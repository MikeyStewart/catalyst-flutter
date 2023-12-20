import 'package:catalyst_flutter/components/countdown.dart';
import 'package:catalyst_flutter/components/eventsection.dart';
import 'package:catalyst_flutter/components/map.dart';
import 'package:flutter/material.dart';

import '../data/event.dart';

class HomePage extends StatelessWidget {
  final List<Event> events;

  HomePage({required this.events});

  @override
  Widget build(BuildContext context) {
    return ListView(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      children: [
        CountDown(),
        EventSection(events: this.events),
        Map(),
      ],
    );
  }
}
