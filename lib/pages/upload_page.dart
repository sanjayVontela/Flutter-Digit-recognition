import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class UploadImage extends StatefulWidget {
  const UploadImage({super.key});

  @override
  State<UploadImage> createState() => _UploadImageState();
}

class _UploadImageState extends State<UploadImage> {
  final ImagePicker picker = ImagePicker();
  var image;
  var digit = -1;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pink,
        title: Text("Best digit recognizer in the world"),
      ),
      backgroundColor: Colors.grey[200],
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          image = await picker.pickImage(source: ImageSource.gallery);
          digit = 1;
          print(image.path);
          setState(() {});
        },
        backgroundColor: Colors.black,
        shape: CircleBorder(),
        child: Icon(
          Icons.camera_alt_outlined,
          color: Colors.white,
        ),
      ),
      body: Center(
        child: Column(
          children: [
            SizedBox(
              height: 40,
            ),
            Text(
              "Image will be shown below",
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              height: 300,
              width: 300,
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.black),
                  image: DecorationImage(
                      image: digit == -1
                          ? AssetImage("assets/white.jpg")
                          : FileImage(File(image.path)))),
            ),
            SizedBox(
              height: 45,
            ),
            Text(
              "Current Prediction",
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 40,
            ),
            Text(
              digit == -1 ? "" : "$digit",
              style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
            )
          ],
        ),
      ),
    );
  }
}
