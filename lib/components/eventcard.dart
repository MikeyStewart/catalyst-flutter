import 'package:flutter/material.dart';
import 'package:catalyst_flutter/data/event.dart';
import 'package:catalyst_flutter/data/category.dart';
import 'package:intl/intl.dart';

class EventCard extends StatelessWidget {
  EventCard(this.event);

  final Event event;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(bottom: 4),
                        child: Icon(Icons.location_pin),
                      ),
                      Text(
                        event.location,
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
                  Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, 0, 4, 0),
                        child: Icon(Icons.access_time),
                      ),
                      Text(
                        event.prettyTime,
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
              IconButton(
                onPressed: () {},
                icon: Icon(Icons.favorite_outline),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              event.name,
              style: Theme.of(context).textTheme.titleMedium!.apply(
                  color: Theme.of(context).colorScheme.onSurfaceVariant),
            ),
          ),
          Text(
            event.description,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Wrap(
              spacing: 8,
              children: [
                for (Category category in event.categories)
                  Chip(label: Text(category.displayName)),
                if (event.adultWarnings.isNotEmpty)
                  Chip(
                    label: Text('R18'),
                    backgroundColor:
                        Theme.of(context).colorScheme.errorContainer,
                  )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
