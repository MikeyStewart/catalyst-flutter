import 'dart:io';

import 'package:catalyst_flutter/components/map.dart';
import 'package:catalyst_flutter/screens/SplashPage.dart';
import 'package:flutter/material.dart';
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
        home: SplashPage(),
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

class MyAppState extends ChangeNotifier {
  final LocalStorage storage = LocalStorage();

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
