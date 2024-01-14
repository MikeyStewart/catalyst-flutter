import 'package:catalyst_flutter/data/category.dart';
import 'package:catalyst_flutter/data/event.dart';
import 'package:catalyst_flutter/screens/eventpage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/EventProvider.dart';

class EventCard extends StatelessWidget {
  final Event event;

  EventCard({required this.event});

  @override
  Widget build(BuildContext context) {
    final eventProvider = context.read<EventDataProvider>();

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EventPage(id: event.id),
          ),
        );
      },
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16.0, top: 16.0, bottom: 16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  flex: 1,
                  child: Column(
                    children: [
                      Text(
                        event.prettyTime,
                        style: Theme.of(context).textTheme.labelLarge!.apply(
                            color:
                                Theme.of(context).colorScheme.onSurfaceVariant),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 8,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0, right: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      event.name,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium!
                                          .apply(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onSurfaceVariant),
                                    ),
                                    SizedBox(height: 8.0),
                                    Text(
                                      'at ' + event.location,
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelLarge!
                                          .apply(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onSurfaceVariant),
                                    ),
                                  ]),
                            ),
                            SizedBox(width: 8.0),
                            Align(
                              alignment: Alignment.topRight,
                              child: IconButton(
                                  onPressed: () {
                                    if (event.saved) {
                                      eventProvider.unsaveEvent(event);
                                    } else {
                                      eventProvider.saveEvent(event);
                                    }
                                  },
                                  color: Theme.of(context).colorScheme.primary,
                                  icon: Icon(event.saved
                                      ? Icons.favorite
                                      : Icons.favorite_outline)),
                            )
                          ],
                        ),
                        SizedBox(height: 8.0),
                        Text(
                          event.description,
                          maxLines: 5,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 8.0),
                        Text(
                          event.categories.map((e) => e.displayName).join(', '),
                          style: TextStyle(
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                        if (event.adultWarnings.any((element) => element.isNotEmpty))
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text('18+'),
                          )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Divider(
              thickness: 1.0,
              height: 1.0,
            ),
          )
        ],
      ),
    );
  }
}
