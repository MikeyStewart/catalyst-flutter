import 'package:catalyst_flutter/components/eventcard.dart';
import 'package:catalyst_flutter/data/event.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../data/EventService.dart';

Future<List<dynamic>> fetchData() async {
  final EventService _eventService = EventService();

  final events = await _eventService.getAllEvents();
  final dates = await _eventService.getAllDates();

  return [events, dates];
}

class EventListPage extends StatefulWidget {
  @override
  _EventListPageState createState() => _EventListPageState();
}

class _EventListPageState extends State<EventListPage> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
      future: fetchData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
              body: Center(
                  child: SizedBox(
                      child: CircularProgressIndicator(),
                      height: 24.0,
                      width: 24.0)));
        } else if (snapshot.hasError) {
          return Scaffold(
              body: Center(child: Text('Error: ${snapshot.error}')));
        } else {
          List<dynamic> data = snapshot.data as List<dynamic>;
          List<Event> events = data[0] as List<Event>;
          List<DateTime> dates = data[1] as List<DateTime>;
          DateFormat prettyDateFormat = DateFormat('E dd MMM');

          return DefaultTabController(
              length: dates.length,
              child: Scaffold(
                appBar: AppBar(
                  centerTitle: true,
                  title: Text('Events'),
                  bottom: TabBar(isScrollable: true, tabs: <Widget>[
                    for (DateTime date in dates)
                      Tab(
                        text: prettyDateFormat.format(date),
                      ),
                  ]),
                  leading: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(Icons.arrow_back),
                  ),
                ),
                body: TabBarView(children: <Widget>[
                  for (DateTime date in dates)
                    ListView.builder(
                      itemCount:
                          events.where((event) => event.date == date).length,
                      itemBuilder: (context, index) {
                        Event event = events
                            .where((event) => event.date == date)
                            .toList()[index];
                        return EventCard(event);
                      },
                    ),
                ]),
              ));
        }
      },
    );
  }
}
