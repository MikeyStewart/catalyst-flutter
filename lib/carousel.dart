import 'package:flutter/material.dart';

class Carousel extends StatelessWidget {
  Carousel(this.title);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          child: Text(
            title,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
        ),
        SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              CarouselCard('1'),
              CarouselCard('1'),
              CarouselCard('1'),
              CarouselCard('1'),
            ],
          ),
        ),
      ],
    );
  }
}

class CarouselCard extends StatelessWidget {
  CarouselCard(this.body);

  final String body;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        width: 300,
        height: 200,
        child: Text(body),
      ),
    );
  }
}