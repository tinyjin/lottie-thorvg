import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:lottie_thorvg/src/thorvg.dart' as module;
import 'package:lottie_thorvg/src/utils.dart';

class Lottie extends StatefulWidget {
  final Future<String> data;
  final int width;
  final int height;

  final bool animate;
  final bool repeat;
  final bool reverse;

  const Lottie({
    Key? key,
    required this.data,
    required this.width,
    required this.height,
    required this.animate,
    required this.repeat,
    required this.reverse,
  }) : super(key: key);

  static Lottie asset(
    String name, {
    Key? key,
    int? width,
    int? height,
    bool? animate,
    bool? repeat,
    bool? reverse,
  }) {
    return Lottie(
      key: key,
      data: parseAsset(name),
      width: width ?? 0,
      height: height ?? 0,
      animate: animate ?? true,
      repeat: repeat ?? true,
      reverse: reverse ?? false,
    );
  }

  static Lottie file(
    Object /*io.File|html.File*/ file, {
    Key? key,
    int? width,
    int? height,
    bool? animate,
    bool? repeat,
    bool? reverse,
  }) {
    // todo: parse file
    return Lottie(
      key: key,
      data: parseFile(),
      width: width ?? 0,
      height: height ?? 0,
      animate: animate ?? true,
      repeat: repeat ?? true,
      reverse: reverse ?? false,
    );
  }

  static Lottie memory(
    Uint8List bytes, {
    Key? key,
    int? width,
    int? height,
    bool? animate,
    bool? repeat,
    bool? reverse,
  }) {
    // todo: parse memory
    return Lottie(
      key: key,
      data: parseMemory(),
      width: width ?? 0,
      height: height ?? 0,
      animate: animate ?? true,
      repeat: repeat ?? true,
      reverse: reverse ?? false,
    );
  }

  static Lottie network(
    String src, {
    Key? key,
    int? width,
    int? height,
    bool? animate,
    bool? repeat,
    bool? reverse,
  }) {
    return Lottie(
      key: key,
      data: parseSrc(src),
      width: width ?? 0,
      height: height ?? 0,
      animate: animate ?? true,
      repeat: repeat ?? true,
      reverse: reverse ?? false,
    );
  }

  @override
  State createState() => _State();
}

class _State extends State<Lottie> {
  module.Thorvg? tvg;
  ui.Image? img;
  int? _frameCallbackId;

  String data = "";

  // Canvas size
  int width = 0;
  int height = 0;

  // Original size (lottie)
  int lottieWidth = 0;
  int lottieHeight = 0;

  // Render size (calculated)
  int get renderWidth => lottieWidth > width ? width : lottieWidth;
  int get renderHeight => lottieHeight > height ? height : lottieHeight;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void reassemble() {
    super.reassemble();

    if (tvg == null) {
      return;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _unscheduleTick();

      data = await widget.data;
      _updateLottieSize();
      _updateCanvasSize();
      _loadTVG();

      _scheduleTick();
    });
  }

  @override
  void dispose() {
    super.dispose();

    _unscheduleTick();
    tvg!.delete();
  }

  void _updateLottieSize() {
    final info = jsonDecode(data);

    setState(() {
      lottieWidth = info['w'];
      lottieHeight = info['h'];
    });
  }

  void _updateCanvasSize() {
    if (widget.width == 0 || widget.height == 0) {
      setState(() {
        width = lottieWidth;
        height = lottieHeight;
      });
      return;
    }

    setState(() {
      width = widget.width;
      height = widget.height;
    });
  }

  void _loadTVG() {
    tvg!.load(data, renderWidth, renderHeight, widget.animate, widget.repeat,
        widget.reverse);
  }

  void _scheduleTick() {
    _frameCallbackId = SchedulerBinding.instance.scheduleFrameCallback(_tick);
  }

  void _unscheduleTick() {
    if (_frameCallbackId == null) {
      return;
    }

    SchedulerBinding.instance.cancelFrameCallbackWithId(_frameCallbackId!);
    _frameCallbackId = null;
  }

  void _tick(Duration timestamp) async {
    _scheduleTick();

    final buffer = tvg!.animLoop();
    if (buffer == null) {
      return;
    }

    final image = await decodeImage(buffer, renderWidth, renderHeight);
    setState(() {
      img = image;
    });
  }

  void _load() async {
    data = await widget.data;
    _updateLottieSize();
    _updateCanvasSize();

    tvg ??= module.Thorvg();
    _loadTVG();

    _scheduleTick();
  }

  @override
  Widget build(BuildContext context) {
    if (img == null) {
      return Container();
    }

    return Container(
      width: width.toDouble(),
      height: height.toDouble(),
      clipBehavior: Clip.hardEdge,
      decoration: const BoxDecoration(color: Colors.transparent),
      child: CustomPaint(
        painter: TVGCanvas(
            width: width.toDouble(),
            height: height.toDouble(),
            lottieWidth: lottieWidth.toDouble(),
            lottieHeight: lottieHeight.toDouble(),
            renderWidth: renderWidth.toDouble(),
            renderHeight: renderHeight.toDouble(),
            image: img!),
      ),
    );
  }
}

class TVGCanvas extends CustomPainter {
  TVGCanvas(
      {required this.image,
      required this.width,
      required this.height,
      required this.lottieWidth,
      required this.lottieHeight,
      required this.renderWidth,
      required this.renderHeight});

  double width;
  double height;

  double lottieWidth;
  double lottieHeight;

  double renderWidth;
  double renderHeight;

  ui.Image image;

  @override
  void paint(Canvas canvas, Size size) {
    final left = renderWidth > width ? 0.0 : (width - renderWidth) / 2;
    final top = renderHeight > height ? 0.0 : (height - renderHeight) / 2;

    paintImage(
      canvas: canvas,
      rect: Rect.fromLTWH(left, top, renderWidth, renderHeight),
      image: image,
      fit: BoxFit.none, //NOTE: Should make it a param
      filterQuality: FilterQuality.high, //NOTE: Should make it a param
      alignment: Alignment.center, //NOTE: Should make it a param
    );
  }

  @override
  bool shouldRepaint(TVGCanvas oldDelegate) {
    return image != oldDelegate.image;
  }
}
