import 'dart:convert';

import 'package:catalyst_flutter/screens/eventlistpage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../data/EventProvider.dart';
import '../data/EventService.dart';
import '../data/category.dart';
import '../data/event.dart';

class MainPage extends StatelessWidget {
  final EventService _eventService = EventService();

  Future<void> initializeData(BuildContext context) async {
    final eventProvider = context.read<EventDataProvider>();

    await eventProvider.loadDataFromDatabase();

    // Only save events to DB if there are none already
    if (eventProvider.events.isNotEmpty) return;

    // Parse CSV file and initialize your data
    final eventsJson = await rootBundle.loadString('assets/events.json');
    final List<dynamic> eventListJson = jsonDecode(eventsJson);

    eventListJson.forEach((json) {
      (json['Dates'] as String)
          .split(',')
          .where((element) => element.isNotEmpty)
          .map(
              (unparsedDate) => DateFormat('EEEE d MMMM y').parse(unparsedDate))
          .forEach((date) {
        _eventService.addEvent(Event(
            id: Uuid().v4(),
            name: json['Event Name'],
            description: json['Description'],
            categories: (json['Event Types'] as String)
                .split(',')
                .where((element) => element.isNotEmpty)
                .map((element) => getCategoryFromName(element))
                .toList(),
            date: date,
            adultWarnings: (json['Adults Only - Warnings'] as String)
                .split(',')
                .where((element) => element.isNotEmpty)
                .toList(),
            startTime: _parseTime(json['Start Time']),
            endTime: _parseTime(json['End Time']),
            location: _getLocation(json['Location - Theme Camp'],
                json['Location - Artwork'], json['Location - Other']),
            saved: false)); // No event will be saved initially
      });
    });

    eventProvider.loadDataFromDatabase();

    await Future.delayed(Duration(seconds: 3));
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: initializeData(context),
      builder: (context, AsyncSnapshot<void> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            return EventListPage();
          default:
            return Container(
              color: Theme.of(context).colorScheme.primary,
            );
        }
      },
    );
  }
}

DateTime? _parseTime(String unparsedTime) {
  if (unparsedTime.isEmpty) {
    return null;
  } else {
    int hours = int.parse(unparsedTime.substring(0, 2));
    int mins = int.parse(unparsedTime.substring(3, 5));
    // Ignore Date properties
    return DateTime(1970, 1, 1, hours, mins);
  }
}

String _getLocation(String themeCamp, String artwork, String elsewhere) {
  if (themeCamp.isNotEmpty) {
    return themeCamp.substring(0, themeCamp.length - 6);
  } else if (artwork.isNotEmpty) {
    return artwork;
  } else if (elsewhere.isNotEmpty) {
    return elsewhere;
  } else {
    return 'unknown';
  }
}
