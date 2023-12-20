import 'dart:convert';
import 'dart:io';

import 'package:catalyst_flutter/components/map.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

import 'components/countdown.dart';
import 'components/eventsection.dart';
import 'data/event.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'Catalyst',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
        ),
        home: MyHomePage(),
      ),
    );
  }
}

class LocalStorage {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/saved.txt');
  }

  Future<List<String>> readSaved() async {
    try {
      final file = await _localFile;
      final contents = await file.readAsString();
      return contents.split(',');
    } catch (e) {
      return List.empty();
    }
  }

  Future<File> writeSaved(List<String> data) async {
    final file = await _localFile;
    return file.writeAsString(data.join(','));
  }
}

class LocalEvents {
  Future<List<Event>> readEvents() async {
    final eventsJson = await rootBundle.loadString('assets/events.json');
    final List<dynamic> eventListJson = jsonDecode(eventsJson);
    final List<Event> events =
        eventListJson.map((json) => Event.fromJson(json)).toList();

    return events;
  }
}

class MyAppState extends ChangeNotifier {
  final LocalStorage storage = LocalStorage();
  final LocalEvents localEvents = LocalEvents();

  var events = <Event>[];
  var saved = <String>[];

  void setEvents(List<Event> allEvents) {
    events = allEvents;
    notifyListeners();
  }

  void setSaved(List<String> initialSaved) {
    saved = initialSaved;
    notifyListeners();
  }

  void toggleSaved(String item) {
    if (saved.contains(item)) {
      saved.remove(item);
    } else {
      saved.add(item);
    }
    storage.writeSaved(saved);
    notifyListeners();
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    appState.storage.readSaved().then((value) => appState.setSaved(value));
    appState.localEvents.readEvents().then((value) => appState.setEvents(value));

    return LayoutBuilder(builder: (context, constraints) {
      return Scaffold(
        body: ListView(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          children: [
            CountDown(),
            EventSection(),
            Map(),
          ],
        ),
      );
    });
  }
}
