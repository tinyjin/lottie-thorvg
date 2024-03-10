import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:lottie_thorvg/thorvg.dart' as TVG;
import 'package:lottie_thorvg/utils.dart';

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
    this.animate = false,
    this.repeat = false,
    this.reverse = false,
  }) : super(key: key);

  static Lottie asset(
    String name, {
    Key? key,
    required int width,
    required int height,
    bool? animate,
    bool? repeat,
    bool? reverse,
  }) {
    return Lottie(
      key: key,
      data: parseAsset(name),
      width: width,
      height: height,
      animate: animate ?? false,
      repeat: repeat ?? false,
      reverse: reverse ?? false,
    );
  }

  static Lottie file(
    Object /*io.File|html.File*/ file, {
    Key? key,
    required int width,
    required int height,
    bool? animate,
    bool? repeat,
    bool? reverse,
  }) {
    // todo: parse file
    return Lottie(
      key: key,
      data: parseFile(),
      width: width,
      height: height,
      animate: animate ?? false,
      repeat: repeat ?? false,
      reverse: reverse ?? false,
    );
  }

  static Lottie memory(
    Uint8List bytes, {
    Key? key,
    required int width,
    required int height,
    bool? animate,
    bool? repeat,
    bool? reverse,
  }) {
    // todo: parse memory
    return Lottie(
      key: key,
      data: parseMemory(),
      width: width,
      height: height,
      animate: animate ?? false,
      repeat: repeat ?? false,
      reverse: reverse ?? false,
    );
  }

  static Lottie network(
    String src, {
    Key? key,
    required int width,
    required int height,
    bool? animate,
    bool? repeat,
    bool? reverse,
  }) {
    return Lottie(
      key: key,
      data: parseSrc(src),
      width: width,
      height: height,
      animate: animate ?? false,
      repeat: repeat ?? false,
      reverse: reverse ?? false,
    );
  }

  @override
  State createState() => _State();
}

class _State extends State<Lottie> {
  late TVG.Thorvg tvg;
  ui.Image? img;
  int? _frameCallbackId;
  bool _needRepaint = false;

  @override
  void initState() {
    super.initState();
    load();
  }

  @override
  void dispose() {
    _unscheduleTick();
    super.dispose();
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

    final buffer = tvg.animLoop();

    if (buffer == null) {
      return;
    }

    final image = await decodeImage(buffer, widget.width, widget.height);

    setState(() {
      _needRepaint = true;
      img = image;
    });
  }

  void load() async {
    final data = await widget.data;
    tvg = TVG.Thorvg();
    tvg.load(data, widget.width, widget.height);
    _scheduleTick();
  }

  Widget _buildWidget() {
    if (img == null) {
      return const Center(child: Text('loading'));
    }

    return CustomPaint(
      painter: TVGCanvas(image: img!, needRepaint: _needRepaint),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width.toDouble(),
      height: widget.height.toDouble(),
      child: _buildWidget(),
    );
  }
}

class TVGCanvas extends CustomPainter {
  TVGCanvas({
    required this.image,
    required this.needRepaint,
  });

  ui.Image image;
  bool needRepaint;
  final Paint _paint = Paint();

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawImage(
      image,
      Offset.zero,
      _paint,
    );
  }

  @override
  bool shouldRepaint(TVGCanvas oldDelegate) {
    return image != oldDelegate.image;
  }
}
