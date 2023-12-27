import 'package:catalyst_flutter/components/eventcard.dart';
import 'package:catalyst_flutter/data/EventProvider.dart';
import 'package:catalyst_flutter/data/event.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class EventListPage extends StatelessWidget {
  final ListFilter filter;

  const EventListPage({super.key, required this.filter});

  @override
  Widget build(BuildContext context) {
    DateFormat prettyDateFormat = DateFormat('E dd MMM');

    return Consumer<EventDataProvider>(
        builder: (context, eventProvider, child) {
      // List<Event> events = switch(filter) {
      //   ListFilter.All => eventProvider.events,
      //   ListFilter.Saved => eventProvider.savedEvents,
      // };
      List<Event> events = eventProvider.events;
      String title = switch (filter) {
        ListFilter.All => 'Events',
        ListFilter.Saved => 'Saved',
      };

      return DefaultTabController(
          length: eventProvider.dates.length,
          child: Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: Text(title),
              bottom: TabBar(isScrollable: true, tabs: <Widget>[
                for (DateTime date in eventProvider.dates)
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
              for (DateTime date in eventProvider.dates)
                ListView.builder(
                  itemCount: events
                      .where((event) => event.date == date)
                      .where((event) =>
                          filter == ListFilter.Saved ? event.saved : true)
                      .length,
                  itemBuilder: (context, index) {
                    return EventCard(
                        event: events
                            .where((event) => event.date == date)
                            .where((event) =>
                                filter == ListFilter.Saved ? event.saved : true)
                            .toList()[index]);
                  },
                ),
            ]),
          ));
    });
  }
}

enum ListFilter {
  All,
  Saved,
}
