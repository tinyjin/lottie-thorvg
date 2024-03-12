import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:lottie_thorvg/src/thorvg.dart' as TVG;
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
  TVG.Thorvg? tvg;
  ui.Image? img;
  int? _frameCallbackId;
  bool _needRepaint = false;

  String data = "";
  int width = 0;
  int height = 0;

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

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _reload();
    });
  }

  @override
  void dispose() {
    super.dispose();
    
    _unscheduleTick();
    tvg!.delete();
  }

  void _setDefaultSize() {
    final info = jsonDecode(data);

    setState(() {
      width = info['w'];
      height = info['h'];
    });
  }

  void _reload() async {
    // When changed size on hot-reload
    if (width != widget.width || height != widget.height) {
      _unscheduleTick();

      if (widget.width == 0 || widget.height == 0) {
        _setDefaultSize();
      } else {
        setState(() {
          width = widget.width;
          height = widget.height;
        });
      }

      tvg!.load(
          data, width, height, widget.animate, widget.repeat, widget.reverse);

      _scheduleTick();
      return;
    }

    // FIXME: this async calling isn't necessary when data isn't changed
    data = await widget.data;
    _unscheduleTick();

    if (widget.width == 0 || widget.height == 0) {
      _setDefaultSize();
    }

    tvg!.load(
        data, width, height, widget.animate, widget.repeat, widget.reverse);

    _scheduleTick();
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

    final image = await decodeImage(buffer, width, height);

    setState(() {
      _needRepaint = true;
      img = image;
    });
  }

  void _load() async {
    data = await widget.data;

    if (widget.width == 0 || widget.height == 0) {
      _setDefaultSize();
    } else {
      setState(() {
        width = widget.width;
        height = widget.height;
      });
    }

    tvg = TVG.Thorvg();
    tvg!.load(
        data, width, height, widget.animate, widget.repeat, widget.reverse);
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
      width: width.toDouble(),
      height: height.toDouble(),
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
