import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:catalyst_flutter/data/themecamp.dart';
import 'package:catalyst_flutter/eventslist.dart';
import 'dart:convert';
import 'package:animations/animations.dart';

Future<String> loadThemeCamps() async {
  return await rootBundle.loadString('assets/fake_camps.json');
}

class ThemeCampsList extends StatelessWidget {
  Function() _openDrawer;

  ThemeCampsList(this._openDrawer);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
        future: loadThemeCamps(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError || snapshot.data == null) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else {
            final List<dynamic> themeCampListJson = jsonDecode(snapshot.data!);
            final List<ThemeCamp> themeCamps = themeCampListJson
                .map((json) => ThemeCamp.fromJson(json))
                .toList();
            themeCamps.sort((a, b) => a.name.compareTo(b.name));

            return Scaffold(
              appBar: AppBar(
                centerTitle: true,
                title: Text('Theme camps'),
                leading: IconButton(
                  onPressed: _openDrawer,
                  icon: Icon(Icons.menu),
                ),
              ),
              body: ListView.builder(
                  itemCount: themeCamps.length,
                  itemBuilder: (BuildContext context, int index) {
                    ThemeCamp themeCamp = themeCamps[index];
                    String initials = themeCamp.name
                        .split(' ')
                        .map((word) => word.characters.first)
                        .join();
                    return OpenContainer(
                      transitionType: ContainerTransitionType.fadeThrough,
                      closedColor: Theme.of(context).cardColor,
                      closedElevation: 0.0,
                      openElevation: 4.0,
                      transitionDuration: Duration(milliseconds: 1500),
                      openBuilder: (BuildContext context, VoidCallback _) =>
                          EventsList(() {}),
                      closedBuilder:
                          (BuildContext _, VoidCallback openContainer) {
                        return ListTile(
                          title: Text(themeCamp.name),
                          subtitle: Text(themeCamp.description),
                          leading: CircleAvatar(
                            child: Text(initials),
                          ),
                          trailing: Icon(Icons.chevron_right),
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 16),
                        );
                      },
                    );
                  }),
            );
          }
        });
  }
}
