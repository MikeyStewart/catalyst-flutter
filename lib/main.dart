
//
// class LoadAssets extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder<String>(
//         future: loadEvents(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(
//               child: CircularProgressIndicator(),
//             );
//           } else if (snapshot.hasError || snapshot.data == null) {
//             return Text("Error: ${snapshot.error}");
//           } else {
//             final List<dynamic> eventListJson = jsonDecode(snapshot.data!);
//             final List<Event> events =
//                 eventListJson.map((json) => Event.fromJson(json)).toList();
//
//             return Container();
//           }
//         });
//   }
// }
//

import 'dart:io';

import 'package:catalyst_flutter/components/map.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

import 'components/countdown.dart';
import 'components/eventsection.dart';

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

class MyAppState extends ChangeNotifier {
  var list = List.generate(20, (index) => 'Item $index');
  final LocalStorage storage = LocalStorage();
  var favorites = <String>[];

  void setFavorites(List<String> initialFavorites) {
    favorites = initialFavorites;
    notifyListeners();
  }

  void toggleFavorite(String item) {
    if (favorites.contains(item)) {
      favorites.remove(item);
    } else {
      favorites.add(item);
    }
    storage.writeSaved(favorites);
    notifyListeners();
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    appState.storage.readSaved().then((value) => appState.setFavorites(value));

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