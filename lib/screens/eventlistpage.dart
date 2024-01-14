import 'dart:math';

import 'package:catalyst_flutter/components/eventcard.dart';
import 'package:catalyst_flutter/components/map.dart';
import 'package:catalyst_flutter/data/EventProvider.dart';
import 'package:catalyst_flutter/data/category.dart';
import 'package:catalyst_flutter/data/event.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class EventListPage extends StatefulWidget {
  const EventListPage({super.key});

  @override
  State<EventListPage> createState() => _EventListPageState();
}

class _EventListPageState extends State<EventListPage> {
  Set<String> selectedMainFilters = <String>{'All events'};
  Set<Category> selectedCategoryFilters = <Category>{};

  @override
  Widget build(BuildContext context) {
    DateFormat prettyDateFormat = DateFormat('E dd MMM');

    return Consumer<EventDataProvider>(
        builder: (context, eventProvider, child) {
      List<Event> events = eventProvider.events;

      return DefaultTabController(
          length: eventProvider.dates.length,
          child: Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: Text('Event Guide'),
              bottom: TabBar(isScrollable: true, tabs: <Widget>[
                for (DateTime date in eventProvider.dates)
                  Tab(
                    text: prettyDateFormat.format(date),
                  ),
              ]),
              actions: [
                IconButton(
                  icon: Icon(
                    Icons.map_outlined,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ExpandedMap(),
                      ),
                    );
                  },
                )
              ],
            ),
            floatingActionButton: FloatingActionButton.extended(
              onPressed: () {
                showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    isDismissible: true,
                    useSafeArea: true,
                    shape: const RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(16))),
                    builder: (context) => FilterSheet(
                          selectedMainFilters: selectedMainFilters,
                          selectedCategoryFilters: selectedCategoryFilters,
                          updateMainFilters: (mainFilters) {
                            setState(() {
                              selectedMainFilters = mainFilters;
                            });
                          },
                          updateCategoryFilters: (categoryFilters) {
                            setState(() {
                              selectedCategoryFilters = categoryFilters;
                            });
                          },
                        ));
              },
              label: Text('Filter (' +
                  (events
                          .filter(selectedMainFilters, selectedCategoryFilters)
                          .length)
                      .toString() +
                  ')'),
              icon: Icon(Icons.filter_list),
            ),
            body: TabBarView(children: <Widget>[
              for (DateTime date in eventProvider.dates)
                (events
                        .where((event) => event.date == date)
                        .toList()
                        .filter(selectedMainFilters, selectedCategoryFilters)
                        .isEmpty)
                    ? EmptyView()
                    : ListView.builder(
                        itemCount: events
                            .where((event) => event.date == date)
                            .toList()
                            .filter(
                                selectedMainFilters, selectedCategoryFilters)
                            .length,
                        itemBuilder: (context, index) {
                          return EventCard(
                              event: events
                                  .where((event) => event.date == date)
                                  .toList()
                                  .filter(selectedMainFilters,
                                      selectedCategoryFilters)[index]);
                        },
                      ),
            ]),
          ));
    });
  }
}

class EmptyView extends StatelessWidget {
  const EmptyView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    double imageSize = min(screenWidth, screenHeight) / 2.0;

    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
                width: imageSize, child: Image.asset('assets/sleepy_cat.png')),
            Padding(
              padding: const EdgeInsets.all(32.0),
              child: Text(
                'There\'s nothing here... Check out the other days or try adjusting the filters.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleMedium!.apply(
                    color: Theme.of(context).colorScheme.onSurfaceVariant),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class FilterInfo {
  final String name;
  final bool Function(Event) filter;

  FilterInfo(this.name, this.filter);
}

class FilterSheet extends StatefulWidget {
  final Set<String> selectedMainFilters;
  final Set<Category> selectedCategoryFilters;
  final Function(Set<String>) updateMainFilters;
  final Function(Set<Category>) updateCategoryFilters;

  FilterSheet({
    required this.selectedMainFilters,
    required this.selectedCategoryFilters,
    required this.updateMainFilters,
    required this.updateCategoryFilters,
  });

  @override
  State<FilterSheet> createState() => _FilterSheetState();
}

class _FilterSheetState extends State<FilterSheet> {
  late Set<String> selectedMainFilters;
  late Set<Category> selectedCategoryFilters;

  Set<String> mainFilters = <String>{'All events', 'Saved'};

  @override
  void initState() {
    super.initState();

    selectedMainFilters = widget.selectedMainFilters;
    selectedCategoryFilters = widget.selectedCategoryFilters;
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.5,
      minChildSize: 0.5,
      maxChildSize: 1.0,
      expand: false,
      builder: (_, controller) => ListView(
        padding: EdgeInsets.all(16.0),
        controller: controller,
        children: [
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Filter',
                      style: Theme.of(context).textTheme.headlineSmall),
                ),
              ),
              IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(
                    Icons.close,
                    color: Theme.of(context).primaryColor,
                  ))
            ],
          ),
          SizedBox(height: 16.0),
          Wrap(
            spacing: 8.0, // gap between adjacent chips
            runSpacing: 4.0, // gap between lines
            children: <Widget>[
              for (String filter in mainFilters)
                FilterChip(
                  label: (filter == 'Saved')
                      ? Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.favorite),
                            SizedBox(width: 4.0),
                            Text(filter),
                          ],
                        )
                      : Text(filter, overflow: TextOverflow.ellipsis),
                  showCheckmark: true,
                  selected: selectedMainFilters.contains(filter),
                  onSelected: (bool selected) {
                    if (selected) {
                      selectedMainFilters.add(filter);
                      if (filter == 'All events') {
                        selectedMainFilters
                            .removeWhere((filter) => filter != 'All events');
                        selectedCategoryFilters.clear();
                      } else {
                        selectedMainFilters.remove('All events');
                      }
                    } else {
                      if (filter != 'All events') {
                        selectedMainFilters.remove(filter);
                        if (selectedCategoryFilters.isEmpty &&
                            selectedMainFilters.isEmpty) {
                          selectedMainFilters.add('All events');
                        }
                      }
                    }
                    setState(() {
                      widget.updateMainFilters(selectedMainFilters);
                      widget.updateCategoryFilters(selectedCategoryFilters);
                    });
                  },
                )
            ],
          ),
          SizedBox(height: 16.0),
          Divider(
            thickness: 1.0,
            height: 1.0,
          ),
          SizedBox(height: 16.0),
          Text('Categories'),
          SizedBox(height: 16.0),
          Wrap(
            spacing: 8.0, // gap between adjacent chips
            runSpacing: 4.0, // gap between lines
            children: <Widget>[
              for (Category category in Category.values)
                FilterChip(
                  label: IntrinsicWidth(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(category.icon),
                        SizedBox(width: 4.0),
                        Expanded(child: Text(category.displayName, overflow: TextOverflow.ellipsis)),
                      ],
                    ),
                  ),
                  clipBehavior: Clip.hardEdge,
                  showCheckmark: true,
                  selected: selectedCategoryFilters.contains(category),
                  onSelected: (bool selected) {
                    if (selected) {
                      selectedCategoryFilters.add(category);
                      selectedMainFilters.remove('All events');
                    } else {
                      selectedCategoryFilters.remove(category);
                      if (selectedCategoryFilters.isEmpty &&
                          selectedMainFilters.isEmpty) {
                        selectedMainFilters.add('All events');
                      }
                    }
                    setState(() {
                      widget.updateCategoryFilters(selectedCategoryFilters);
                      widget.updateMainFilters(selectedMainFilters);
                    });
                  },
                )
            ],
          ),
          SizedBox(height: 16.0),
          Divider(
            thickness: 1.0,
            height: 1.0,
          ),
        ],
      ),
    );
  }
}
