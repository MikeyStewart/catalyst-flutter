import 'package:catalyst_flutter/data/category.dart';
import 'package:catalyst_flutter/data/event.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:add_2_calendar/add_2_calendar.dart' as Calendar;

import '../data/EventProvider.dart';

class EventPage extends StatelessWidget {
  final String id;

  EventPage({required this.id});

  @override
  Widget build(BuildContext context) {
    return Consumer<EventDataProvider>(
      builder: (BuildContext context, EventDataProvider eventProvider,
          Widget? child) {
        Event event =
            eventProvider.events.firstWhere((event) => event.id == id);
        return Scaffold(
          body: SafeArea(
            child: Stack(children: [
              SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 32.0),
                        child: Text(
                          event.name,
                          style: Theme.of(context).textTheme.titleLarge!.apply(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurfaceVariant),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(height: 16.0),
                      Text(
                        event.prettyTime,
                        style: Theme.of(context).textTheme.labelLarge!.apply(
                            color:
                                Theme.of(context).colorScheme.onSurfaceVariant),
                      ),
                      SizedBox(height: 16.0),
                      Text(
                        'at ' + event.location,
                        style: Theme.of(context).textTheme.labelLarge!.apply(
                            color:
                                Theme.of(context).colorScheme.onSurfaceVariant),
                      ),
                      SizedBox(height: 32.0),
                      Text(event.description),
                      SizedBox(height: 16.0),
                      Text(
                        event.categories.map((e) => e.displayName).join(', '),
                        style: TextStyle(
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                      if (event.adultWarnings.isNotEmpty) Text('R18'),
                      SizedBox(height: 32.0),
                      FractionallySizedBox(
                        widthFactor: 0.8,
                        child: FilledButton.tonalIcon(
                          onPressed: () {
                            Share.share(event.shareMessage);
                          },
                          label: Text('Share'),
                          icon: Icon(Icons.share),
                        ),
                      ),
                      FractionallySizedBox(
                        widthFactor: 0.8,
                        child: FilledButton.tonalIcon(
                          onPressed: () {
                            final Calendar.Event calendarEvent = Calendar.Event(
                              title: event.name,
                              description: event.description,
                              location: event.location,
                              startDate: DateTime(
                                event.date.year,
                                event.date.month,
                                event.date.day,
                                event.startTime?.hour ?? 0,
                                event.startTime?.minute ?? 0,
                              ),
                              endDate: DateTime(
                                event.date.year,
                                event.date.month,
                                event.date.day,
                                event.endTime?.hour ?? 0,
                                event.endTime?.minute ?? 0,
                              ),
                              iosParams: Calendar.IOSParams(
                                reminder: Duration(minutes: 15),
                              ),
                            );

                            Calendar.Add2Calendar.addEvent2Cal(calendarEvent);
                          },
                          label: Text('Add to calendar'),
                          icon: Icon(Icons.calendar_month_rounded),
                        ),
                      ),
                      FractionallySizedBox(
                        widthFactor: 0.8,
                        child: FilledButton.icon(
                          onPressed: () {
                            if (event.saved) {
                              eventProvider.unsaveEvent(event);
                            } else {
                              eventProvider.saveEvent(event);
                            }
                          },
                          label: Text(event.saved ? 'Saved' : 'Save'),
                          icon: Icon(event.saved
                              ? Icons.favorite
                              : Icons.favorite_outline),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(Icons.arrow_back),
                ),
              ),
            ]),
          ),
        );
      },
    );
  }
}
