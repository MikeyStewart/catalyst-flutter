import 'package:flutter/material.dart';

class GuidingPrinciples extends StatelessWidget {
  Function() _openDrawer;

  GuidingPrinciples(this._openDrawer);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Guiding Principles'),
        leading: IconButton(
          onPressed: _openDrawer,
          icon: Icon(Icons.menu),
        ),
      ),
      body: Center(child: Text('TODO'))
    );
  }
}
