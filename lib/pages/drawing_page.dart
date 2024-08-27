import 'package:flutter/material.dart';
import 'package:hello_mnist/dl_model/classifier.dart';

class DrawPage extends StatefulWidget {
  const DrawPage({super.key});

  @override
  State<DrawPage> createState() => _DrawPageState();
}

class _DrawPageState extends State<DrawPage> {
  int digit = -1;
  Classifier classifier = Classifier();
  List<Offset> points = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pink,
        title: Text("Best digit recognizer in the world"),
      ),
      backgroundColor: Colors.grey[200],
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          points.clear();
          digit = -1;
        },
        backgroundColor: Colors.black,
        shape: CircleBorder(),
        child: Icon(
          Icons.close,
          color: Colors.white,
        ),
      ),
      body: Center(
        child: Column(
          children: [
            Text(
              "Draw digit inside the box",
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(
              height: 40,
            ),
            Container(
              height: 300,
              width: 300,
              child: GestureDetector(
                onPanUpdate: (DragUpdateDetails details) {
                  Offset localPosition = details.localPosition;
                  setState(() {
                    if (localPosition.dx >= 0 &&
                        localPosition.dx <= 300 &&
                        localPosition.dy >= 0 &&
                        localPosition.dy <= 300) {
                      points.add(localPosition);
                    }

                    // print(points);
                  });
                },
                onPanEnd: (DragEndDetails details) async {
                  points.add(Offset(-1, -1));
                  digit = await classifier.classifyDrawing(points);
                  setState(() {});
                },
                child: CustomPaint(
                  painter: Painter(points: points),
                ),
              ),
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.black, width: 2.0)),
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

class Painter extends CustomPainter {
  final List<Offset> points;

  Painter({required this.points});

  final Paint paintDetails = Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = 4.0
    ..color = Colors.black;

  @override
  void paint(Canvas canvas, Size size) {
    for (int i = 0; i < points.length - 1; i++) {
      if (points[i].dx != -1 && points[i + 1].dx != -1) {
        canvas.drawLine(points[i], points[i + 1], paintDetails);
      }
    }
  }

  @override
  bool shouldRepaint(Painter oldDelegate) {
    return true;
  }
}
