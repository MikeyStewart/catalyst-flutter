import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'dart:ui';

class SpiritualSection extends StatelessWidget {
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
              'Need to find your way, spiritually?',
              style: TextStyle(fontSize: 18.0),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: AspectRatio(
                  aspectRatio: 1 / 1,
                  child: CategoryCard(category: 'Spiritual events'),
                ),
              ),
              Expanded(
                child: AspectRatio(
                  aspectRatio: 1 / 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: CategoryCard(category: 'Health & Wellness'),
                      ),
                      Expanded(
                        child: CategoryCard(category: 'Workshop events'),
                      ),
                    ],
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}

class CategoryCard extends StatelessWidget {
  final String category;

  CategoryCard({required this.category});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Center(
          child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          category,
          textAlign: TextAlign.center,
        ),
      )),
    );
  }
}
