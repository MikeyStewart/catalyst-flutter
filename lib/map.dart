import 'package:flutter/material.dart';

class Map extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Map'),
      ),
      body: Container(
        color: Colors.black,
        child: InteractiveViewer(
          minScale: 1,
          maxScale: 5,
          child: Image(
            image: AssetImage('assets/KB-Map-23.jpg'),
            width: double.infinity,
            height: double.infinity,
          ),
        ),
      ),
    );
  }
}
