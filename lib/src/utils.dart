import 'dart:async';
import 'dart:ui' as ui;
import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';

Future<String> parseSrc(String src) async {
  if (src.startsWith('http')) {
    final url = Uri.parse(src);
    HttpClient httpClient = HttpClient();
    String errorMsg = '';

    try {
      final request = await httpClient.getUrl(url);
      final response = await request.close();

      if (response.statusCode == HttpStatus.ok) {
        return await response.transform(utf8.decoder).join();
      } else {
        errorMsg = 'Failed to load data. Error: ${response.statusCode}';
      }
    } catch (error) {
      errorMsg = 'Failed to load data. Error: $error';
    } finally {
      httpClient.close();
    }

    throw Exception(errorMsg);
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
