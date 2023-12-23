import 'package:catalyst_flutter/data/category.dart';
import 'package:catalyst_flutter/data/event.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:add_2_calendar/add_2_calendar.dart' as Calendar;

class EventPage extends StatelessWidget {
  EventPage(this.event);

  final Event event;

  @override
  Widget build(BuildContext context) {
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
                          color:
                              Theme.of(context).colorScheme.onSurfaceVariant),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(height: 16.0),
                  Text(
                    event.prettyTime,
                    style: Theme.of(context).textTheme.labelLarge!.apply(
                        color: Theme.of(context).colorScheme.onSurfaceVariant),
                  ),
                  SizedBox(height: 16.0),
                  Text(
                    'at ' + event.location,
                    style: Theme.of(context).textTheme.labelLarge!.apply(
                        color: Theme.of(context).colorScheme.onSurfaceVariant),
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
                      onPressed: () {},
                      label: Text('Save'),
                      icon: Icon(Icons.favorite_outline),
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
  }
}

// class EventPage extends StatelessWidget {
//   EventPage(this.event);
//
//   final Event event;
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(event.name),
//       ),
//       body: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             mainAxisSize: MainAxisSize.max,
//             children: [
//               Padding(
//                 padding: const EdgeInsets.all(16.0),
//                 child: Row(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     DetailView(event.location, Icons.location_pin),
//                     DetailView(event.prettyTime, Icons.access_time),
//                   ],
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.all(16.0),
//                 child: Text(
//                   event.description,
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.all(16.0),
//                 child: Wrap(
//                   spacing: 8,
//                   children: [
//                     for (Category category in event.categories)
//                       Chip(label: Text(category.displayName)),
//                     for (String adultWarning in event.adultWarnings)
//                       Chip(
//                         label: Text(adultWarning),
//                         backgroundColor:
//                         Theme.of(context).colorScheme.errorContainer,
//                       )
//                   ],
//                 ),
//               ),
//               Spacer(),
//               FilledButton.icon(
//                 style: style,
//                 onPressed: () {},
//                 label: Text('Save'),
//                 icon: Icon(Icons.favorite_outline),
//               ),
//               SizedBox(height: 8),
//               FilledButton.tonalIcon(
//                 style: style,
//                 onPressed: () {},
//                 label: Text('Share'),
//                 icon: Icon(Icons.send),
//               ),
//               SizedBox(height: 8),
//               FilledButton.tonalIcon(
//                 style: style,
//                 onPressed: () {},
//                 label: Text('Add to calendar'),
//                 icon: Icon(Icons.add),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// class DetailView extends StatelessWidget {
//   final String value;
//   final IconData icon;
//
//   DetailView(this.value, this.icon);
//
//   @override
//   Widget build(BuildContext context) {
//     return Expanded(
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             Padding(
//               padding: const EdgeInsets.only(bottom: 8.0),
//               child: Icon(icon),
//             ),
//             Text(
//               value,
//               textAlign: TextAlign.center,
//               style: Theme.of(context)
//                   .textTheme
//                   .labelLarge!
//                   .apply(color: Theme.of(context).colorScheme.onSurfaceVariant),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
