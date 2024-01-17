import 'dart:math';

import 'package:catalyst_flutter/components/countdown.dart';
import 'package:catalyst_flutter/components/eventcard.dart';
import 'package:catalyst_flutter/components/mapPage.dart';
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
  Set<String> selectedCampFilters = <String>{};
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
                          selectedCampFilters: selectedCampFilters,
                          selectedCategoryFilters: selectedCategoryFilters,
                          updateMainFilters: (mainFilters) {
                            setState(() {
                              selectedMainFilters = mainFilters;
                            });
                          },
                          updateCampFilters: (campFilters) {
                            setState(() {
                              selectedCampFilters = selectedCampFilters;
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
                          .filter(selectedMainFilters, selectedCampFilters,
                              selectedCategoryFilters)
                          .length)
                      .toString() +
                  ')'),
              icon: Icon(Icons.filter_list),
              backgroundColor: Theme.of(context).colorScheme.primary,
              foregroundColor: Theme.of(context).colorScheme.onPrimary,
            ),
            bottomNavigationBar: CountDown(),
            body: TabBarView(children: <Widget>[
              for (DateTime date in eventProvider.dates)
                (events
                        .where((event) => event.date == date)
                        .toList()
                        .filter(selectedMainFilters, selectedCampFilters,
                            selectedCategoryFilters)
                        .isEmpty)
                    ? EmptyView()
                    : ListView.builder(
                        itemCount: events
                            .where((event) => event.date == date)
                            .toList()
                            .filter(selectedMainFilters, selectedCampFilters,
                                selectedCategoryFilters)
                            .length,
                        itemBuilder: (context, index) {
                          return EventCard(
                              event: events
                                  .where((event) => event.date == date)
                                  .toList()
                                  .filter(
                                      selectedMainFilters,
                                      selectedCampFilters,
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
  final Set<String> selectedCampFilters;
  final Function(Set<String>) updateMainFilters;
  final Function(Set<String>) updateCampFilters;
  final Function(Set<Category>) updateCategoryFilters;

  FilterSheet({
    required this.selectedMainFilters,
    required this.selectedCategoryFilters,
    required this.updateMainFilters,
    required this.updateCategoryFilters,
    required this.selectedCampFilters,
    required this.updateCampFilters,
  });

  @override
  State<FilterSheet> createState() => _FilterSheetState();
}

class _FilterSheetState extends State<FilterSheet> {
  late Set<String> selectedMainFilters;
  late Set<Category> selectedCategoryFilters;
  late Set<String> selectedCampFilters;

  Set<String> mainFilters = <String>{'All events', 'Saved'};

  @override
  void initState() {
    super.initState();

    selectedMainFilters = widget.selectedMainFilters;
    selectedCategoryFilters = widget.selectedCategoryFilters;
    selectedCampFilters = widget.selectedCampFilters;
  }

  @override
  Widget build(BuildContext context) {
    final eventProvider = context.read<EventDataProvider>();
    Map<String, List<String>> campFilters =
        groupByStartingLetter(eventProvider.camps.map((e) => e.name).toList());

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
                        selectedCampFilters.clear();
                      } else {
                        selectedMainFilters.remove('All events');
                      }
                    } else {
                      if (filter != 'All events') {
                        selectedMainFilters.remove(filter);
                        if (selectedCampFilters.isEmpty &&
                            selectedCategoryFilters.isEmpty &&
                            selectedMainFilters.isEmpty) {
                          selectedMainFilters.add('All events');
                        }
                      }
                    }
                    setState(() {
                      widget.updateMainFilters(selectedMainFilters);
                      widget.updateCampFilters(selectedCampFilters);
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
              for (Category category
                  in Category.values.where((e) => e != Category.unknown))
                FilterChip(
                  label: IntrinsicWidth(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(category.icon),
                        SizedBox(width: 4.0),
                        Expanded(
                            child: Text(category.displayName,
                                overflow: TextOverflow.ellipsis)),
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
                          selectedCampFilters.isEmpty &&
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
          SizedBox(height: 16.0),
          Text('Theme Camps'),
          SizedBox(height: 16.0),
          for (MapEntry<String, List<String>> letterGroup
              in campFilters.entries)
            CampsByLetter(
                camps: letterGroup,
                selectedCamps: selectedCampFilters,
                onSelected: (bool selected, String campName) {
                  if (selected) {
                    selectedCampFilters.add(campName);
                    selectedMainFilters.remove('All events');
                  } else {
                    selectedCampFilters.remove(campName);
                    if (selectedCategoryFilters.isEmpty &&
                        selectedCampFilters.isEmpty &&
                        selectedMainFilters.isEmpty) {
                      selectedMainFilters.add('All events');
                    }
                  }
                  setState(() {
                    widget.updateMainFilters(selectedMainFilters);
                    widget.updateCampFilters(selectedCampFilters);
                  });
                }),
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

Map<String, List<String>> groupByStartingLetter(List<String> words) {
  // Create a map to store the grouped words
  Map<String, List<String>> groupedWords = {};

  // Iterate through each word
  for (String word in words) {
    // Get the starting letter of the word
    String startingLetter = word[0].toLowerCase();

    // Check if the starting letter is already a key in the map
    if (!groupedWords.containsKey(startingLetter)) {
      // If not, create a new entry with an empty list
      groupedWords[startingLetter] = [];
    }

    // Add the word to the list corresponding to its starting letter
    groupedWords[startingLetter]!.add(word);
  }

  return groupedWords;
}

class CampsByLetter extends StatelessWidget {
  final MapEntry<String, List<String>> camps;
  final Set<String> selectedCamps;
  final Function(bool, String) onSelected;

  const CampsByLetter(
      {super.key,
      required this.camps,
      required this.onSelected,
      required this.selectedCamps});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 14.0),
          child: Text(
            camps.key.toUpperCase(),
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(
          width: 12.0,
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Wrap(
                spacing: 8.0, // gap between adjacent chips
                runSpacing: 0.0, // gap between lines
                children: <Widget>[
                  for (String campName in camps.value)
                    FilterChip(
                      label: Text(campName, overflow: TextOverflow.ellipsis),
                      clipBehavior: Clip.hardEdge,
                      showCheckmark: true,
                      selected: selectedCamps.contains(campName),
                      onSelected: (bool selected) {
                        if (selected) {
                          selectedCamps.add(campName);
                        } else {
                          selectedCamps.remove(campName);
                        }
                        onSelected(selected, campName);
                      },
                    )
                ],
              ),
              SizedBox(
                height: 16.0,
              )
            ],
          ),
        ),
      ],
    );
  }
}
