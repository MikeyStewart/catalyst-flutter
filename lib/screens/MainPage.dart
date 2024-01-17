import 'dart:convert';
import 'dart:math';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:catalyst_flutter/data/themecamp.dart';
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
    if (eventProvider.events.isEmpty) {
      final eventsJson = await rootBundle.loadString('assets/events24.json');
      final List<dynamic> eventListJson = jsonDecode(eventsJson);
      eventListJson.forEach((json) {
        (json['Dates'] as String)
            .split(',')
            .where((element) => element.isNotEmpty)
            .map((unparsedDate) =>
                DateFormat('EEEE d MMMM y').parse(unparsedDate))
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
    }

    if (eventProvider.camps.isEmpty) {
      final campsJson = await rootBundle.loadString('assets/fake_camps.json');
      final List<dynamic> campListJson = jsonDecode(campsJson);
      campListJson.forEach((json) {
        _eventService.addCamp(ThemeCamp(
            id: Uuid().v4(),
            name: json['name'],
            description: json['description']));
      });
    }

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
            return SplashPage();
        }
      },
    );
  }
}

class SplashPage extends StatelessWidget {
  const SplashPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    double imageSize = min(screenWidth, screenHeight);

    const Color lightOrangeFaded = Color(0xCCFF9800);
    const Color darkOrangeFaded = Color(0xCCFF5722);

    return Material(
      child: Stack(children: [
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: <Color>[Colors.orange, Colors.deepOrange]),
          ),
        ),
        Positioned(
            left: -(imageSize / 6),
            bottom: -(imageSize / 6),
            child: SizedBox(
                width: imageSize,
                child: ColorFiltered(
                  colorFilter: ColorFilter.mode(
                    Colors.transparent.withAlpha(200),
                    BlendMode
                        .srcATop, // Choose a blend mode that suits your needs
                  ),
                  child: Image.asset(
                    'assets/catalyst_logo_black.png',
                  ),
                ))),
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: <Color>[lightOrangeFaded, darkOrangeFaded]),
          ),
        ),
        Align(
            alignment: Alignment.topCenter,
            child: FractionallySizedBox(
                heightFactor: 0.66,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Catalyst',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 40,
                          color: Colors.white),
                    ),
                    SizedBox(height: 32.0),
                    AnimatedTextKit(
                      totalRepeatCount: 1,
                      pause: Duration(milliseconds: 1000),
                      animatedTexts: [
                        TyperAnimatedText(
                          'Loading events...',
                          textStyle: TextStyle(color: Colors.white),
                          speed: Duration(milliseconds: 200),
                        ),
                      ],
                    ),
                  ],
                ))),
      ]),
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
    return themeCamp.substring(0, themeCamp.length - 6).trim();
  } else if (artwork.isNotEmpty) {
    return artwork;
  } else if (elsewhere.isNotEmpty) {
    return elsewhere;
  } else {
    return 'unknown';
  }
}
