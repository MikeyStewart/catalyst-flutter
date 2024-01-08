import 'package:catalyst_flutter/data/EventProvider.dart';
import 'package:catalyst_flutter/screens/MainPage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
        home: MainPage(),
      ),
    );
  }
}
