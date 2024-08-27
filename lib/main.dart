import 'package:flutter/material.dart';
import 'package:hello_mnist/pages/upload_page.dart';
import 'package:hello_mnist/pages/drawing_page.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Home(),
    );
  }
}


class Home extends StatefulWidget {
  const Home({super.key});


  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int current_index =0;
  List tabs = const [
    UploadImage(),
    DrawPage()
  ];
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: tabs[current_index],
      bottomNavigationBar: BottomNavigationBar(items: [
        BottomNavigationBarItem(icon: Icon(Icons.image),label: "Image"),
        BottomNavigationBarItem(icon: Icon(Icons.album),label: "Draw")
      ],
        selectedItemColor: Colors.pink,
        unselectedItemColor: Colors.grey[800],
        currentIndex: current_index,
        onTap: (index){
        setState(() {
          current_index = index;
        });
        },
      ),
    );
  }
}
