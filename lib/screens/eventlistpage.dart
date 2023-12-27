import 'package:catalyst_flutter/components/eventcard.dart';
import 'package:catalyst_flutter/data/EventProvider.dart';
import 'package:catalyst_flutter/data/event.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class EventListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    DateFormat prettyDateFormat = DateFormat('E dd MMM');

    return Consumer<EventDataProvider>(
        builder: (context, eventProvider, child) {
      return DefaultTabController(
          length: eventProvider.dates.length,
          child: Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: Text('Events'),
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
                  itemCount: eventProvider.events
                      .where((event) => event.date == date)
                      .length,
                  itemBuilder: (context, index) {
                    return EventCard(event: eventProvider.events
                        .where((event) => event.date == date)
                        .toList()[index]);
                  },
                ),
            ]),
          ));
    });
  }
}
