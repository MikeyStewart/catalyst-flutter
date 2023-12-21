import 'package:animations/animations.dart';
import 'package:catalyst_flutter/components/eventcard.dart';
import 'package:catalyst_flutter/data/event.dart';
import 'package:catalyst_flutter/screens/eventpage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../main.dart';

class EventsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    List<Event> events = appState.events;
    List<DateTime> dates = [];
    DateFormat prettyDateFormat = DateFormat('E dd MMM');

    events.forEach((event) {
      event.dates.forEach((date) {
        if (!dates.contains(date)) {
          dates.add(date);
        }
      });
    });
    dates.sort();

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
              ListView.separated(
                separatorBuilder: (BuildContext context, int index) {
                  return Column(
                    children: [
                      SizedBox(height: 8.0),
                      Divider(),
                      SizedBox(height: 8.0),
                    ],
                  );
                },
                padding: const EdgeInsets.all(16),
                itemCount:
                    events.where((event) => event.dates.contains(date)).length,
                itemBuilder: (context, index) {
                  Event event = events
                      .where((event) => event.dates.contains(date))
                      .toList()[index];
                  return EventCard(event);
                },
              ),
          ]),
        ));
  }
}
