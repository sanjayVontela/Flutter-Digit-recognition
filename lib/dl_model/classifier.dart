import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'dart:io' as io;
import 'package:image/image.dart';

class Classifier {
  Classifier();

  classifyImage(PickedFile image) async {
    var file = io.File(image.path);
    image.Image imageTemp = image
  }
}
