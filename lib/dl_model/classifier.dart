import 'dart:io' as io;
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:tflite_flutter/tflite_flutter.dart';

class Classifier {
  Classifier();

  classifyImage(var image) async {
    var _file = io.File(image.path);
    img.Image? imageTemp = img.decodeImage(_file.readAsBytesSync());
    img.Image resizedImg = img.copyResize(imageTemp!, height: 28, width: 28);
    var imgBytes = resizedImg.getBytes();
    var imgAsList = imgBytes.buffer.asUint8List();

    return getPred(imgAsList);
  }

  classifyDrawing(List<Offset> points) async {
    final picture = toPicture(points);
    final image = await picture.toImage(28, 28);
    ByteData? imgBytes = await image.toByteData(); // Nullable ByteData

    if (imgBytes == null) {
      // Handle the error or return a default value
      throw Exception('Failed to get image bytes');
    }

    var imgAsList = imgBytes.buffer.asUint8List();
    return getPred(imgAsList);
  }

  Future<int> getPred(Uint8List imgAsList) async {
    List resultBytes = List.filled(28 * 28, 0.0);

    int index = 0;
    print(imgAsList.lengthInBytes);
    for (int i = 0; i < imgAsList.lengthInBytes; i += 4) {
      final r = imgAsList[i];
      final g = imgAsList[i + 1];
      final b = imgAsList[i + 2];
      resultBytes[index] = ((r + g + b) / 3.0) / 255.0;
      index++;
    }

    var input = resultBytes.reshape([1, 28, 28, 1]);
    var output = List.filled(1 * 64, 0.0).reshape([1, 64]);

    InterpreterOptions interpreterOptions = InterpreterOptions();

    try {
      Interpreter interpreter = await Interpreter.fromAsset("mode.tflite",
          options: interpreterOptions);
      interpreter.run(input, output);
    } catch (e) {
      print(e);
      print("error Loading model");
    }

    double heighestProb = 0;
    int digitPred = -1;

    for (int i = 0; i < output[0].length; i++) {
      if (output[0][i] > heighestProb) {
        heighestProb = output[0][i];
        digitPred = i;
      }
    }

    return digitPred;
  }
}

ui.Picture toPicture(List<Offset> points) {
  final _whitePaint = Paint()
    ..strokeCap = ui.StrokeCap.round
    ..strokeWidth = 16.0
    ..color = Colors.white;

  final _bgPaint = Paint()..color = Colors.black;
  final _canvasCullRect = Rect.fromPoints(Offset(0, 0), Offset(28.0, 28.0));
  final recorder = ui.PictureRecorder();
  final canvas = Canvas(recorder, _canvasCullRect)..scale(28 / 300);
  canvas.drawRect(Rect.fromLTWH(0, 0, 28, 28), _bgPaint);
  for (int i = 0; i < points.length - 1; i++) {
    if (points[i].dx != -1 && points[i + 1].dx != -1) {
      canvas.drawLine(points[i], points[i + 1], _whitePaint);
    }
  }
  return recorder.endRecording();
}
