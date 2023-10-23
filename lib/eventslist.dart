import 'package:catalyst_flutter/eventscreen.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:catalyst_flutter/data/event.dart';
import 'package:catalyst_flutter/eventcard.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:animations/animations.dart';

Future<String> loadEvents() async {
  return await rootBundle.loadString('assets/events.json');
}

class EventsList extends StatelessWidget {
  Function() _openDrawer;

  EventsList(this._openDrawer);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
        future: loadEvents(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError || snapshot.data == null) {
            return Text("Error: ${snapshot.error}");
          } else {
            final List<dynamic> eventListJson = jsonDecode(snapshot.data!);
            final List<Event> events =
            eventListJson.map((json) => Event.fromJson(json)).toList();

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
                        itemCount: events
                            .where((event) => event.dates.contains(date))
                            .length,
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
        });
  }
}