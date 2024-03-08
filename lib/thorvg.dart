import 'dart:convert';
import 'dart:ffi' as ffi;
import 'dart:ffi';
import 'dart:io';
import 'dart:typed_data';

import 'package:ffi/ffi.dart';

import 'thorvg_flutter_bindings_generated.dart';

double totalFrame = 0;
double currentFrame = 0;
double startTime = DateTime.now().millisecond / 1000;
double speed = 1.0;
bool isPlaying = false;
bool autoPlay = true;

int width = 0;
int height = 0;

const String _libName = 'thorvg';

final DynamicLibrary _dylib = () {
  if (Platform.isIOS) {
    return DynamicLibrary.open('lib$_libName.dylib');
  }
  if (Platform.isAndroid) {
    return DynamicLibrary.open('lib$_libName.so');
  }
  throw UnsupportedError('Unknown platform: ${Platform.operatingSystem}');
}();

final ThorVGFlutterBindings TVG = ThorVGFlutterBindings(_dylib);

Uint8List? animLoop() {
  if (!update()) {
    return null;
  }

  final buffer = render();
  return buffer;
}

bool update() {
  final duration = TVG.duration();
  final currentTime = DateTime.now().millisecondsSinceEpoch / 1000;
  currentFrame = (currentTime - startTime) / duration * totalFrame * speed;

  if (currentFrame >= totalFrame) {
    currentFrame = 0;
    play();
    return true;
  }

  return TVG.frame(currentFrame);
}

Uint8List? render() {
  TVG.resize(width, height);

  // Sometimes it causes delay, call in threading?
  final isUpdated = TVG.update();

  if (!isUpdated) {
    return null;
  }

  final buffer = TVG.render();
  final canvasBuffer = buffer.asTypedList(width * height * 4);

  return canvasBuffer;
}

void play() {
  totalFrame = TVG.totalFrame();
  startTime = DateTime.now().millisecondsSinceEpoch / 1000;
  isPlaying = true;
}

void load(String src, int w, int h) {
  List<int> list = utf8.encode(src);
  Uint8List bytes = Uint8List.fromList(list);

  width = w;
  height = h;

  TVG.create();

  final nativeBytes = bytes.toPointer().cast<Char>();
  final nativeType = 'json'.toPointer().cast<Char>();

  int result = TVG.load(nativeBytes, nativeType, width, height);

  if (result != 1) {
    print('error');
    print((TVG.error() as Pointer<Utf8>).toDartString());
    return;
  }

  render();

  if (autoPlay) {
    play();
  }
}

extension Uint8ListExtension on Uint8List {
  /// Converts a Uint8List to a Pointer<Uint8>.
  Pointer<Uint8> toPointer() {
    final pointer = calloc<Uint8>(length);
    for (var i = 0; i < length; i++) {
      pointer[i] = this[i];
    }
    return pointer;
  }
}

extension StringExtension on String {
  /// Converts a String to a Pointer<Uint8> (assuming ASCII characters).
  Pointer<Uint8> toPointer() {
    final units = utf8.encode(this);
    final pointer = calloc<Uint8>(units.length);
    for (var i = 0; i < units.length; i++) {
      pointer[i] = units[i];
    }
    return pointer;
  }
}
