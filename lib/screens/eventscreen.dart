import 'package:catalyst_flutter/data/category.dart';
import 'package:catalyst_flutter/data/event.dart';
import 'package:flutter/material.dart';

class EventScreen extends StatelessWidget {
  EventScreen(this.event);

  final Event event;

  @override
  Widget build(BuildContext context) {
    ButtonStyle style = FilledButton.styleFrom(
      minimumSize: Size(double.infinity, 64),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
    );
    return Scaffold(
      appBar: AppBar(
        title: Text(event.name),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.max,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    DetailView(event.location, Icons.location_pin),
                    DetailView(event.prettyTime, Icons.access_time),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  event.description,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Wrap(
                  spacing: 8,
                  children: [
                    for (Category category in event.categories)
                      Chip(label: Text(category.displayName)),
                    for (String adultWarning in event.adultWarnings)
                      Chip(
                        label: Text(adultWarning),
                        backgroundColor:
                            Theme.of(context).colorScheme.errorContainer,
                      )
                  ],
                ),
              ),
              Spacer(),
              FilledButton.icon(
                style: style,
                onPressed: () {},
                label: Text('Save'),
                icon: Icon(Icons.favorite_outline),
              ),
              SizedBox(height: 8),
              FilledButton.tonalIcon(
                style: style,
                onPressed: () {},
                label: Text('Share'),
                icon: Icon(Icons.send),
              ),
              SizedBox(height: 8),
              FilledButton.tonalIcon(
                style: style,
                onPressed: () {},
                label: Text('Add to calendar'),
                icon: Icon(Icons.add),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DetailView extends StatelessWidget {
  final String value;
  final IconData icon;

  DetailView(this.value, this.icon);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Icon(icon),
            ),
            Text(
              value,
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .labelLarge!
                  .apply(color: Theme.of(context).colorScheme.onSurfaceVariant),
            ),
          ],
        ),
      ),
    );
  }
}
