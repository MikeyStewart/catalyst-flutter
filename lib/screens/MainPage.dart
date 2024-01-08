import 'dart:convert';

import 'package:catalyst_flutter/components/carousel.dart';
import 'package:catalyst_flutter/components/countdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../components/eventsection.dart';
import '../components/map.dart';
import '../data/EventProvider.dart';
import '../data/EventService.dart';
import '../data/category.dart';
import '../data/event.dart';
import '../main.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage>
    with SingleTickerProviderStateMixin {
  final EventService _eventService = EventService();
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;

  @override
  void initState() {
    super.initState();

    // Create an animation controller with a duration
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    );

    // Create an offset animation with a curve
    _offsetAnimation = Tween<Offset>(
      begin: Offset(0.0, 1.0), // Offscreen below the screen
      end: Offset(0.0, 0.0), // Onscreen
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut, // Choose an appropriate curve
    ));
  }

  Future<void> initializeData(Function onComplete) async {
    final eventProvider = context.read<EventDataProvider>();

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

    await Future.delayed(Duration(seconds: 1));

    onComplete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(builder: (context) {
        initializeData(() {
          _controller.forward();
        });

        return Stack(children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: <Color>[Colors.orange, Colors.deepOrange]),
            ),
            child: SafeArea(child: CountDown()),
          ),
          SlideTransition(
            position: _offsetAnimation,
            child: DraggableScrollableSheet(
              initialChildSize: 0.70,
              minChildSize: 0.70,
              builder:
                  (BuildContext context, ScrollController scrollController) {
                return SingleChildScrollView(
                  controller: scrollController,
                  child: BottomSheetContent(),
                );
              },
            ),
          ),
        ]);
      }),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
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

class BottomSheetContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.background,
      child: Column(
        children: [
          EventSection(),
          Carousel('title'),
          Map(),
          SizedBox(height: 180.0),
          Text('Categories carousel'),
          SizedBox(height: 180.0),
          Text('Theme camps carousel'),
          SizedBox(height: 180.0),
          Text('Events on now'),
          SizedBox(height: 180.0),
          Text('About app'),
          SizedBox(height: 180.0),
        ],
      ),
    );
  }
}
