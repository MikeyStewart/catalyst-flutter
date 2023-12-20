import 'package:animations/animations.dart';
import 'package:catalyst_flutter/components/carousel.dart';
import 'package:catalyst_flutter/screens/eventslist.dart';
import 'package:flutter/material.dart';
import 'dart:ui';

import 'package:flutter/rendering.dart';

import '../data/event.dart';

class EventSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(32.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: AspectRatio(
                  aspectRatio: 2 / 1,
                  child: CategoryCard(category: 'All events'),
                ),
              ),
              Expanded(
                child: AspectRatio(
                  aspectRatio: 2 / 1,
                  child: CategoryCard(category: 'Saved events'),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class CategoryCard extends StatelessWidget {
  final String category;

  CategoryCard({required this.category});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => EventsPage()),
        );
      },
      child: Card(
        child: Center(
            child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            category,
            textAlign: TextAlign.center,
          ),
        )),
      ),
    );
  }
}
