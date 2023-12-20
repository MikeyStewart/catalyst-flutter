import 'package:animations/animations.dart';
import 'package:catalyst_flutter/components/carousel.dart';
import 'package:catalyst_flutter/screens/eventslist.dart';
import 'package:flutter/material.dart';
import 'dart:ui';

import 'package:flutter/rendering.dart';

import '../data/event.dart';

class EventSection extends StatelessWidget {
  final List<Event> events;

  EventSection({required this.events});

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
                  child: CategoryCard(category: 'All events', events: events),
                ),
              ),
              Expanded(
                child: AspectRatio(
                  aspectRatio: 2 / 1,
                  child: CategoryCard(category: 'Saved events', events: events),
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
  final List<Event> events;
  final String category;

  CategoryCard({required this.category, required this.events});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => EventsList(List.empty())),
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
