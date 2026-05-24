import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      home: Scaffold(
        appBar: AppBar(
          title: Text("Image Gallery"),
        ),

        body: Column(
  mainAxisAlignment: MainAxisAlignment.center,
  children: [

    Text(
      "Welcome to Flutter",
      style: TextStyle(
        fontSize: 26,
        fontWeight: FontWeight.bold,
      ),
    ),

    SizedBox(height: 20),

    Container(
      height: 150,
      width: 150,

      decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.circular(20),
      ),

      child: Center(
        child: Text(
          "Container",
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
          ),
        ),
      ),
    ),
  ],
),
      ),
    );
  }
}