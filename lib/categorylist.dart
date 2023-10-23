import 'package:catalyst_flutter/data/category.dart';
import 'package:flutter/material.dart';

class CategoryList extends StatelessWidget {
  Function() _openDrawer;

  CategoryList(this._openDrawer);

  @override
  Widget build(BuildContext context) {
    List<Category> categories = Category.values.sublist(0, Category.values.length - 1);

    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('Categories'),
          leading: IconButton(
            onPressed: _openDrawer,
            icon: Icon(Icons.menu),
          ),
        ),
        body: SafeArea(
          child: GridView.count(
            crossAxisCount: 2,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
            childAspectRatio: 1.5,
            padding: EdgeInsets.all(16),
            children: [
              for (Category category in categories)
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(category.displayName),
                  ),
                )
            ],
          ),
        ));
  }
}
