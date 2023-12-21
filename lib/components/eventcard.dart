import 'package:catalyst_flutter/data/category.dart';
import 'package:catalyst_flutter/data/event.dart';
import 'package:catalyst_flutter/screens/eventpage.dart';
import 'package:flutter/material.dart';

class EventCard extends StatelessWidget {
  EventCard(this.event);

  final Event event;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EventPage(event),
          ),
        );
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 1,
            child: Column(
              children: [
                Text(
                  event.prettyTime,
                  style: Theme.of(context).textTheme.labelLarge!.apply(
                      color: Theme.of(context).colorScheme.onSurfaceVariant),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          Expanded(
            flex: 8,
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    event.name,
                    style: Theme.of(context).textTheme.titleMedium!.apply(
                        color: Theme.of(context).colorScheme.onSurfaceVariant),
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    'at ' + event.location,
                    style: Theme.of(context).textTheme.labelLarge!.apply(
                        color: Theme.of(context).colorScheme.onSurfaceVariant),
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
                  if (event.adultWarnings.isNotEmpty) Text('R18')
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
