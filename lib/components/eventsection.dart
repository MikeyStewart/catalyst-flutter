import 'package:animations/animations.dart';
import 'package:catalyst_flutter/components/carousel.dart';
import 'package:catalyst_flutter/screens/eventlistpage.dart';
import 'package:flutter/material.dart';
import 'dart:ui';

import 'package:flutter/rendering.dart';

import '../data/event.dart';

class EventSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
          left: 32.0, right: 32.0, top: 32.0, bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: Text(
              'Explore events!',
              style: TextStyle(fontSize: 18.0),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: AspectRatio(
                  aspectRatio: 2 / 1,
                  child: EventSectionCard(
                    title: 'All events',
                    icon: Icons.list,
                    filter: (event) {
                      return true;
                    },
                  ),
                ),
              ),
              SizedBox(width: 16.0),
              Expanded(
                child: AspectRatio(
                  aspectRatio: 2 / 1,
                  child: EventSectionCard(
                    title: 'Saved events',
                    icon: Icons.favorite,
                    filter: (event) {
                      return event.saved;
                    },
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class EventSectionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool Function(Event) filter;

  EventSectionCard(
      {required this.icon, required this.title, required this.filter});

  @override
  Widget build(BuildContext context) {
    return FilledButton.tonal(
        clipBehavior: Clip.hardEdge,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    EventListPage(filter: FilterInfo(title, filter))),
          );
        },
        child: LayoutBuilder(builder: (context, constraints) {
          return Stack(clipBehavior: Clip.none, children: [
            Positioned(
              right: -(constraints.maxHeight / 2),
              bottom: -(constraints.maxHeight / 8),
              child: Icon(
                icon,
                size: constraints.maxHeight,
                color: Theme.of(context).colorScheme.primary.withOpacity(0.08),
              ),
            ),
            Center(
                child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                title,
                textAlign: TextAlign.center,
              ),
            )),
          ]);
        }),
        style: ButtonStyle(
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.0)))));
  }
}
