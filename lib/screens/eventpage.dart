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
          floatingActionButton: FloatingActionButton.extended(
            backgroundColor: Theme.of(context).colorScheme.primary,
            onPressed: () {
              if (event.saved) {
                eventProvider.unsaveEvent(event);
              } else {
                eventProvider.saveEvent(event);
              }
            },
            label: Text(
              event.saved ? 'Saved' : 'Save',
              style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
            ),
            icon: Icon(event.saved ? Icons.favorite : Icons.favorite_outline,
                color: Theme.of(context).colorScheme.onPrimary),
          ),
          body: CustomScrollView(
            physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics()),
            slivers: <Widget>[
              SliverAppBar(
                stretch: true,
                onStretchTrigger: () {
                  // Function callback for stretch
                  return Future<void>.value();
                },
                expandedHeight: 200.0,
                flexibleSpace: FlexibleSpaceBar(
                  stretchModes: const <StretchMode>[
                    // StretchMode.fadeTitle,
                  ],
                  centerTitle: false,
                  expandedTitleScale: 1.5,
                  title: Padding(
                    padding: const EdgeInsets.only(right: 48.0),
                    child: Text(event.name,
                        style: Theme.of(context).textTheme.labelLarge!),
                  ),
                ),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.share),
                    tooltip: 'Share event',
                    onPressed: () {
                      Share.share(event.shareMessage);
                    },
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ],
              ),
              SliverList(
                delegate: SliverChildListDelegate([
                  Details(event: event),
                  Description(event: event),
                  Categories(event: event),
                ]),
              ),
            ],
          ),
        );
      },
    );
  }
}

class Details extends StatelessWidget {
  final Event event;

  Details({required this.event});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        children: [
          Row(
            children: [
              Icon(Icons.access_time_filled_rounded),
              SizedBox(width: 8.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Date & Time',
                        style: Theme.of(context).textTheme.labelSmall!.apply(
                            color: Theme.of(context)
                                .colorScheme
                                .onSurfaceVariant)),
                    Text(
                      event.prettyDate + ', ' + event.prettyFullTime,
                      style: Theme.of(context).textTheme.labelLarge!.apply(
                          color:
                              Theme.of(context).colorScheme.onSurfaceVariant),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 8.0),
              IconButton(
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
                  icon: Icon(
                    Icons.add_circle_outline_outlined,
                    color: Theme.of(context).colorScheme.primary,
                  ))
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
                        style: Theme.of(context).textTheme.labelSmall!.apply(
                            color: Theme.of(context)
                                .colorScheme
                                .onSurfaceVariant)),
                    Text(
                      event.location,
                      style: Theme.of(context).textTheme.labelLarge!.apply(
                          color:
                              Theme.of(context).colorScheme.onSurfaceVariant),
                      maxLines: 5,
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (event.adultWarnings.any((element) => element.isNotEmpty))
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: Row(
                children: [
                  Icon(Icons.warning_rounded),
                  SizedBox(width: 8.0),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('18+ Warnings',
                          style: Theme.of(context).textTheme.labelSmall!.apply(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurfaceVariant)),
                      Text(
                        event.adultWarnings.join(', '),
                        style: Theme.of(context).textTheme.labelLarge!.apply(
                            color:
                                Theme.of(context).colorScheme.onSurfaceVariant),
                      ),
                    ],
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class Description extends StatelessWidget {
  final Event event;

  Description({required this.event});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(left: 32.0, right: 32.0, bottom: 32.0),
        child: Text(event.description));
  }
}

class Categories extends StatelessWidget {
  final Event event;

  Categories({required this.event});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(left: 32.0, right: 32.0, bottom: 32.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (Category category in event.categories)
              CategoryItem(category: category)
          ],
        ));
  }
}

class CategoryItem extends StatelessWidget {
  final Category category;

  CategoryItem({required this.category});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(category.icon),
        SizedBox(width: 4.0),
        Text(
          category.displayName,
          style: Theme.of(context)
              .textTheme
              .labelLarge!
              .apply(color: Theme.of(context).colorScheme.onSurfaceVariant),
        ),
      ],
    );
  }
}
