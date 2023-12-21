import 'package:flutter/material.dart';
import 'package:catalyst_flutter/data/event.dart';
import 'package:catalyst_flutter/data/category.dart';
import 'package:intl/intl.dart';

class EventCard extends StatelessWidget {
  EventCard(this.event);

  final Event event;

  @override
  Widget build(BuildContext context) {
    return Row(
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
        // Column(
        //   crossAxisAlignment: CrossAxisAlignment.start,
        //   mainAxisSize: MainAxisSize.min,
        //   children: [
        //     Padding(
        //       padding: const EdgeInsets.symmetric(vertical: 8.0),
        //       child: Text(
        //         event.name,
        //         style: Theme.of(context).textTheme.titleMedium!.apply(
        //             color: Theme.of(context).colorScheme.onSurfaceVariant),
        //       ),
        //     ),
        //     Text(
        //       event.location,
        //       style: Theme.of(context).textTheme.labelLarge!.apply(
        //           color: Theme.of(context).colorScheme.onSurfaceVariant),
        //     ),
        //     Text(
        //       event.description,
        //       maxLines: 3,
        //       overflow: TextOverflow.ellipsis,
        //     ),
        //     Padding(
        //       padding: const EdgeInsets.only(top: 8.0),
        //       child: Wrap(
        //         spacing: 8,
        //         children: [
        //           for (Category category in event.categories)
        //             Chip(label: Text(category.displayName)),
        //           if (event.adultWarnings.isNotEmpty)
        //             Chip(
        //               label: Text('R18'),
        //               backgroundColor:
        //                   Theme.of(context).colorScheme.errorContainer,
        //             )
        //         ],
        //       ),
        //     ),
        //   ],
        // ),
      ],
    );
  }
}

// class EventCard extends StatelessWidget {
//   EventCard(this.event);
//
//   final Event event;
//
//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       children: [
//         Text(
//           event.prettyTime,
//           style: Theme.of(context)
//               .textTheme
//               .labelLarge!
//               .apply(color: Theme.of(context).colorScheme.onSurfaceVariant),
//         ),
//         Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Padding(
//               padding: const EdgeInsets.symmetric(vertical: 8.0),
//               child: Text(
//                 event.name,
//                 style: Theme.of(context).textTheme.titleMedium!.apply(
//                     color: Theme.of(context).colorScheme.onSurfaceVariant),
//               ),
//             ),
//             Text(
//               event.location,
//               style: Theme.of(context).textTheme.labelLarge!.apply(
//                   color: Theme.of(context).colorScheme.onSurfaceVariant),
//             ),
//             Text(
//               event.description,
//               maxLines: 3,
//               overflow: TextOverflow.ellipsis,
//             ),
//             Padding(
//               padding: const EdgeInsets.only(top: 8.0),
//               child: Wrap(
//                 spacing: 8,
//                 children: [
//                   for (Category category in event.categories)
//                     Chip(label: Text(category.displayName)),
//                   if (event.adultWarnings.isNotEmpty)
//                     Chip(
//                       label: Text('R18'),
//                       backgroundColor:
//                       Theme.of(context).colorScheme.errorContainer,
//                     )
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ],
//     );
//   }
// }
