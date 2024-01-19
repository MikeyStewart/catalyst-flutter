import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'dart:ui';

class MapPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: Text(
              'Need to find your way?',
              style: TextStyle(fontSize: 18.0),
            ),
          ),
          OpenContainer(
              closedElevation: 0.0,
              tappable: false,
              closedShape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(32.0)),
              ),
              closedBuilder: (BuildContext context, VoidCallback callback) {
                return CollapsedMap(
                  onView: callback,
                );
              },
              openBuilder: (BuildContext context, VoidCallback callback) {
                return Container(); //ExpandedMap(onClose: callback);
              })
        ],
      ),
    );
  }
}

class CollapsedMap extends StatelessWidget {
  final VoidCallback onView;

  CollapsedMap({required this.onView});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Stack(children: [
          AspectRatio(
            aspectRatio: 16 / 9,
            child: Image.asset(
              'assets/KB-Map-23.jpg',
              fit: BoxFit.cover,
            ),
          ),
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
            child: Container(
              color: Colors.transparent,
            ),
          ),
          Positioned.fill(
            child: Center(
              child: FilledButton.tonal(
                onPressed: () {
                  onView();
                },
                child: Text('View map'),
              ),
            ),
          ),
        ]);
      },
    );
  }
}

class ExpandedMap extends StatelessWidget {
  ExpandedMap();

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Container(
        color: Colors.black,
        child: InteractiveViewer(
          minScale: 1,
          maxScale: 5,
          child: Image(
            image: AssetImage('assets/Kiwiburn-2024-Town-Map.png'),
            width: double.infinity,
            height: double.infinity,
          ),
        ),
      ),
      Positioned(
          bottom: 32.0,
          left: 0,
          right: 0,
          child: Center(
            child: FloatingActionButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Icon(Icons.close),
              backgroundColor: Theme.of(context).colorScheme.primary,
              foregroundColor: Theme.of(context).colorScheme.onPrimary,
            ),
          ))
    ]);
  }
}
