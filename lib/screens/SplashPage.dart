import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

import '../data/EventService.dart';
import '../data/category.dart';
import '../data/event.dart';
import '../main.dart';

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  final EventService _eventService = EventService();

  @override
  void initState() {
    super.initState();
    initializeData();
  }

  Future<void> initializeData() async {
    // Parse CSV file and initialize your data
    final eventsJson = await rootBundle.loadString('assets/events.json');
    final List<dynamic> eventListJson = jsonDecode(eventsJson);

    final List<DateTime> dates = [];

    eventListJson.forEach((json) {
      (json['Dates'] as String)
          .split(',')
          .where((element) => element.isNotEmpty)
          .map(
              (unparsedDate) => DateFormat('EEEE d MMMM y').parse(unparsedDate))
          .forEach((date) {
        if (!dates.contains(date)) {
          dates.add(date);
        }

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
                json['Location - Artwork'], json['Location - Other'])));
      });
    });

    // Sort dates and add to DB
    dates.sort();
    dates.forEach((date) {
      print('Date stored: ' + date.toString());
      _eventService.addDate(date);
    });

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => MyHomePage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(color: Colors.deepOrange);
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
