import 'package:catalyst_flutter/screens/eventscreen.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:catalyst_flutter/data/event.dart';
import 'package:catalyst_flutter/components/eventcard.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:animations/animations.dart';

Future<String> loadEvents() async {
  return await rootBundle.loadString('assets/events.json');
}

class EventsList extends StatelessWidget {
  Function() _openDrawer;
  List<Event> events;

  EventsList(this._openDrawer, this.events);

  @override
  Widget build(BuildContext context) {
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
            title: Text('All events'),
            bottom: TabBar(isScrollable: true, tabs: <Widget>[
              for (DateTime date in dates)
                Tab(
                  text: prettyDateFormat.format(date),
                ),
            ]),
            leading: IconButton(
              onPressed: _openDrawer,
              icon: Icon(Icons.menu),
            ),
          ),
          body: TabBarView(children: <Widget>[
            for (DateTime date in dates)
              ListView.separated(
                separatorBuilder: (BuildContext context, int index) {
                  return SizedBox(height: 16);
                },
                padding: const EdgeInsets.all(16),
                itemCount:
                    events.where((event) => event.dates.contains(date)).length,
                itemBuilder: (context, index) {
                  Event event = events
                      .where((event) => event.dates.contains(date))
                      .toList()[index];
                  return OpenContainer(
                    transitionType: ContainerTransitionType.fadeThrough,
                    closedColor: Theme.of(context).cardColor,
                    closedElevation: 0.0,
                    openElevation: 4.0,
                    transitionDuration: Duration(milliseconds: 500),
                    openBuilder: (BuildContext context, VoidCallback _) =>
                        EventScreen(event),
                    closedBuilder:
                        (BuildContext _, VoidCallback openContainer) {
                      return EventCard(event);
                    },
                  );
                },
              ),
          ]),
        ));
  }
}
