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
              Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(32.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 56.0),
                            Text(
                              event.name,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge!
                                  .apply(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurfaceVariant),
                            ),
                            SizedBox(height: 32.0),
                            Row(
                              children: [
                                Icon(Icons.access_time_filled_rounded),
                                SizedBox(width: 8.0),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('Date & Time',
                                          style: Theme.of(context)
                                              .textTheme
                                              .labelSmall!
                                              .apply(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .onSurfaceVariant)),
                                      Text(
                                        event.prettyDate +
                                            ', ' +
                                            event.prettyFullTime,
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelLarge!
                                            .apply(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .onSurfaceVariant),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 16.0),
                            Row(
                              children: [
                                Icon(Icons.location_pin),
                                SizedBox(width: 8.0),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('Location',
                                          style: Theme.of(context)
                                              .textTheme
                                              .labelSmall!
                                              .apply(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .onSurfaceVariant)),
                                      Text(
                                        event.location,
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelLarge!
                                            .apply(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .onSurfaceVariant),
                                        maxLines: 5,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            if (event.adultWarnings
                                .any((element) => element.isNotEmpty))
                              Column(
                                children: [
                                  SizedBox(height: 16.0),
                                  Expanded(
                                    child: Row(
                                      children: [
                                        Icon(Icons.warning_rounded),
                                        SizedBox(width: 8.0),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text('18+ Warnings',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .labelSmall!
                                                    .apply(
                                                        color: Theme.of(context)
                                                            .colorScheme
                                                            .onSurfaceVariant)),
                                            Text(
                                              event.adultWarnings.join(', '),
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .labelLarge!
                                                  .apply(
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .onSurfaceVariant),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            SizedBox(height: 32.0),
                            Text(event.description),
                            SizedBox(height: 16.0),
                            Wrap(
                              spacing: 8.0, // gap between adjacent chips
                              runSpacing: 4.0, // gap between lines
                              children: <Widget>[
                                for (Category category in event.categories)
                                  Chip(
                                    // backgroundColor: Theme.of(context).colorScheme.tertiaryContainer,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(25),
                                      side:
                                          const BorderSide(color: Colors.transparent),
                                    ),
                                    label: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(category.icon),
                                        SizedBox(width: 4.0),
                                        Text(category.displayName),
                                      ],
                                    ),
                                  )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 32.0, right: 32.0, bottom: 32.0),
                      child: Column(
                        children: [
                          FractionallySizedBox(
                            widthFactor: 1,
                            child: FilledButton.tonalIcon(
                              onPressed: () {
                                Share.share(event.shareMessage);
                              },
                              label: Text('Share'),
                              icon: Icon(Icons.share),
                            ),
                          ),
                          FractionallySizedBox(
                            widthFactor: 1,
                            child: FilledButton.tonalIcon(
                              onPressed: () {
                                final Calendar.Event calendarEvent =
                                    Calendar.Event(
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

                                Calendar.Add2Calendar.addEvent2Cal(
                                    calendarEvent);
                              },
                              label: Text('Add to calendar'),
                              icon: Icon(Icons.calendar_month_rounded),
                            ),
                          ),
                          FractionallySizedBox(
                            widthFactor: 1,
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
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.background,
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                  child: IconButton(
                    color: Theme.of(context).colorScheme.primary,
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(Icons.arrow_back),
                  ),
                ),
              ),
            ]),
          ),
        );
      },
    );
  }
}
