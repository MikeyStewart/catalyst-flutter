import 'package:flutter/material.dart';

class Map extends StatelessWidget {
  Function() _openDrawer;

  Map(this._openDrawer);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Map'),
        leading: IconButton(
          onPressed: _openDrawer,
          icon: Icon(Icons.menu),
        ),
      ),
      body: Container(
        color: Theme.of(context).colorScheme.surfaceVariant,
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
