import 'dart:convert';

import 'package:catalyst_flutter/screens/categorylist.dart';
import 'package:catalyst_flutter/screens/eventslist.dart';
import 'package:catalyst_flutter/screens/guidingprinciples.dart';
import 'package:catalyst_flutter/screens/map.dart';
import 'package:catalyst_flutter/screens/themecamps.dart';
import 'package:flutter/material.dart';
import 'data/event.dart';

void main() {
  runApp(const CatalystApp());
}

class CatalystApp extends StatelessWidget {
  const CatalystApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange),
        cardTheme: CardTheme(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(16)))),
        useMaterial3: true,
      ),
      home: LoadAssets(),
    );
  }
}

class LoadAssets extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
        future: loadEvents(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError || snapshot.data == null) {
            return Text("Error: ${snapshot.error}");
          } else {
            final List<dynamic> eventListJson = jsonDecode(snapshot.data!);
            final List<Event> events =
                eventListJson.map((json) => Event.fromJson(json)).toList();

            return NavigationContainer(events: events);
          }
        });
  }
}

class NavigationContainer extends StatefulWidget {
  final List<Event> events;

  NavigationContainer({required this.events});

  @override
  State<NavigationContainer> createState() => _NavigationContainerState();
}

class _NavigationContainerState extends State<NavigationContainer> {
  static final GlobalKey<ScaffoldState> scaffoldKey =
      GlobalKey<ScaffoldState>();

  int selectedPageIndex = 0;

  static void openDrawer() {
    scaffoldKey.currentState!.openDrawer();
  }

  static void closeDrawer() {
    scaffoldKey.currentState!.closeDrawer();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> screens = <Widget>[
      EventsList(openDrawer, widget.events),
      EventsList(openDrawer, widget.events),
      EventsList(openDrawer, widget.events),
      ThemeCamps(openDrawer),
      CategoryList(openDrawer),
      Map(openDrawer),
      GuidingPrinciples(openDrawer),
    ];

    return Scaffold(
        key: scaffoldKey,
        drawer: NavigationDrawer(
          onDestinationSelected: (int index) {
            setState(() {
              selectedPageIndex = index;
            });
            closeDrawer();
          },
          selectedIndex: selectedPageIndex,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(28, 16, 16, 0),
                child: Image(
                  width: 64,
                  height: 64,
                  image: AssetImage('assets/catalyst_logo.png'),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(28, 16, 16, 16),
              child: Text(
                'Catalyst: \nKiwiburn Guide',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(28, 0, 16, 32),
              child: Text(
                'What will spark your fire?',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
            NavigationDrawerDestination(
                icon: Icon(Icons.list), label: Text('All events')),
            NavigationDrawerDestination(
                icon: Icon(Icons.favorite), label: Text('Saved')),
            NavigationDrawerDestination(
                icon: Icon(Icons.access_time), label: Text('On now')),
            const Padding(
              padding: EdgeInsets.fromLTRB(28, 16, 28, 10),
              child: Divider(),
            ),
            NavigationDrawerDestination(
                icon: Icon(Icons.festival_outlined),
                label: Text('Theme camps')),
            NavigationDrawerDestination(
              icon: Icon(Icons.category),
              label: Text('Categories'),
            ),
            NavigationDrawerDestination(
              icon: Icon(Icons.map_outlined),
              label: Text('Map'),
            ),
            NavigationDrawerDestination(
              icon: Icon(Icons.accessibility_new),
              label: Text('Guiding principles'),
            ),
          ],
        ),
        body: screens[selectedPageIndex]);
  }
}

// filter by on now (highlight 'on now' in event list), saved, categories
