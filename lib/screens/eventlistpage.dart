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
              title: Text('Events'),
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
                  (selectedCategoryFilters.length +
                          selectedMainFilters
                              .where((filter) => filter != 'All events')
                              .length)
                      .toString() +
                  ')'),
              icon: Icon(Icons.filter_list),
            ),
            body: TabBarView(children: <Widget>[
              for (DateTime date in eventProvider.dates)
                ListView.builder(
                  itemCount: events
                      .where((event) => event.date == date)
                      .where((event) => selectedMainFilters.contains('Saved')
                          ? event.saved
                          : true)
                      .where((event) => selectedCategoryFilters.isNotEmpty
                          ? event.categories.any((category) =>
                              selectedCategoryFilters.contains(category))
                          : true)
                      .length,
                  itemBuilder: (context, index) {
                    return EventCard(
                        event: events
                            .where((event) => event.date == date)
                            .where((event) =>
                                selectedMainFilters.contains('Saved')
                                    ? event.saved
                                    : true)
                            .where((event) => selectedCategoryFilters.isNotEmpty
                                ? event.categories.any((category) =>
                                    selectedCategoryFilters.contains(category))
                                : true)
                            .toList()[index]);
                  },
                ),
            ]),
          ));
    });
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
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('Filter',
                style: Theme.of(context).textTheme.headlineSmall),
          ),
          SizedBox(height: 16.0),
          Wrap(
            spacing: 8.0, // gap between adjacent chips
            runSpacing: 4.0, // gap between lines
            children: <Widget>[
              for (String filter in mainFilters)
                FilterChip(
                  label: Text(filter),
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
                  label: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(category.icon),
                      SizedBox(width: 4.0),
                      Text(category.displayName),
                    ],
                  ),
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
