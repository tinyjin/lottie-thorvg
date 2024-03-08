import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

Future<String> parseSrc(String src) async {
  if (src.startsWith('http')) {
    final url = Uri.parse(src);
    final http.Response response = await http.get(url);
    final String json = response.body;
    return json;
  }

  return src;
}

Future<String> parseAsset(String name) async {
  final String json = await rootBundle.loadString(name);
  return json;
}

Future<String> parseFile() async {
  // TODO: implements
  return "";
}

Future<String> parseMemory() async {
  // TODO: implements
  return "";
}

Future<ui.Image> decodeImage(Uint8List buffer, int width, int height) async {
  final Completer<ui.Image> completer = Completer();

  ui.decodeImageFromPixels(buffer, width, height, ui.PixelFormat.rgba8888,
      allowUpscaling: false,
      targetWidth: width,
      targetHeight: height, (result) {
    completer.complete(result);
  });

  return completer.future;
}
