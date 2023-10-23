import 'package:animations/animations.dart';
import 'package:catalyst_flutter/categorylist.dart';
import 'package:catalyst_flutter/eventslist.dart';
import 'package:catalyst_flutter/map.dart';
import 'package:catalyst_flutter/themecamplist.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange),
        cardTheme: CardTheme(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(16)))),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  static final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  int selectedPageIndex = 0;

  static void openDrawer() {
    scaffoldKey.currentState!.openDrawer();
  }

  static void closeDrawer() {
    scaffoldKey.currentState!.closeDrawer();
  }

  List<Widget> screens = <Widget>[
    EventsList(openDrawer),
    EventsList(openDrawer),
    EventsList(openDrawer),
    ThemeCampsList(openDrawer),
    CategoryList(openDrawer),
  ];

  @override
  Widget build(BuildContext context) {
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
            Padding(
              padding: const EdgeInsets.fromLTRB(28, 16, 16, 32),
              child: Text(
                'Catalyst: Kiwiburn Guide',
                style: Theme.of(context).textTheme.titleSmall,
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
            const Padding(
              padding: EdgeInsets.fromLTRB(28, 16, 28, 10),
              child: Divider(),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(28, 16, 16, 16),
              child: Text(
                'Map',
                style: Theme.of(context).textTheme.titleSmall,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: OpenContainer(
                transitionType: ContainerTransitionType.fadeThrough,
                closedColor: Theme.of(context).cardColor,
                closedElevation: 0.0,
                openElevation: 4.0,
                transitionDuration: Duration(milliseconds: 300),
                openBuilder: (BuildContext context, VoidCallback _) => Map(),
                closedBuilder: (BuildContext _, VoidCallback openContainer) {
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image(
                      image: AssetImage('assets/KB-Map-23.jpg'),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
        body: screens[selectedPageIndex]);
  }
}

// filter by on now (highlight 'on now' in event list), saved, categories
