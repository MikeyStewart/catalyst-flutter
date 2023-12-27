import 'dart:io';

import 'package:catalyst_flutter/components/map.dart';
import 'package:catalyst_flutter/data/EventProvider.dart';
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
      create: (context) => EventDataProvider(),
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

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Scaffold(
        body: ListView(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          children: [
            CountDown(),
            EventSection(),
            Map(),
            Text('Categories carousel'),
            Text('Events on now'),
            Text('About app'),
          ],
        ),
      );
    });
  }
}
