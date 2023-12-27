import 'package:catalyst_flutter/data/category.dart';
import 'package:catalyst_flutter/data/event.dart';
import 'package:catalyst_flutter/screens/eventpage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/EventProvider.dart';
import '../data/EventService.dart';

class EventCard extends StatefulWidget {
  final Event event;

  EventCard({required this.event});

  @override
  _EventCardState createState() => _EventCardState();
}

class _EventCardState extends State<EventCard> {
  @override
  Widget build(BuildContext context) {
    final eventProvider = context.read<EventDataProvider>();

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EventPage(widget.event),
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
                        widget.event.prettyTime,
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
                                      widget.event.name,
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
                                      'at ' + widget.event.location,
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
                                    if (widget.event.saved) {
                                      eventProvider.unsaveEvent(widget.event);
                                    } else {
                                      eventProvider.saveEvent(widget.event);
                                    }
                                    setState(() {});
                                  },
                                  color: Theme.of(context).colorScheme.primary,
                                  icon: Icon(widget.event.saved
                                      ? Icons.favorite
                                      : Icons.favorite_outline)),
                            )
                          ],
                        ),
                        SizedBox(height: 8.0),
                        Text(
                          widget.event.description,
                          maxLines: 5,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 8.0),
                        Text(
                          widget.event.categories
                              .map((e) => e.displayName)
                              .join(', '),
                          style: TextStyle(
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                        if (widget.event.adultWarnings.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text('R18'),
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
