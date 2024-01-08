import 'package:catalyst_flutter/data/category.dart';
import 'package:flutter/material.dart';

import '../screens/eventlistpage.dart';

class Carousel extends StatelessWidget {
  Carousel(this.title);

  final String title;

  @override
  Widget build(BuildContext context) {
    List<Category> filtered = Category.values
        .where((element) => element != Category.unknown)
        .toList();
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Container(
        width: 800, // Set the desired width larger than the parent
        padding: EdgeInsets.symmetric(horizontal: 32.0),
        child: Wrap(
          spacing: 8.0, // gap between adjacent chips
          runSpacing: 4.0, // gap between lines
          children: <Widget>[
            for (Category cat in filtered)
              ActionChip(
                avatar: Icon(cat.icon),
                label: Text(cat.displayName),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => EventListPage(
                                filter: FilterInfo(cat.displayName, (event) {
                              return event.categories.contains(cat);
                            }))),
                  );
                },
              )
          ],
        ),
      ),
    );
  }
}
