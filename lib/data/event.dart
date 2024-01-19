import 'package:catalyst_flutter/data/category.dart';
import 'package:catalyst_flutter/data/themecamp.dart';
import 'package:intl/intl.dart';

class Event {
  final String id;
  final String name;
  final String description;
  final List<Category> categories;
  final DateTime date;
  final List<String> adultWarnings;
  final DateTime? startTime;
  final DateTime? endTime;
  final String location;
  final bool saved;

  Event(
      {required this.id,
      required this.name,
      required this.description,
      required this.categories,
      required this.date,
      required this.adultWarnings,
      required this.startTime,
      required this.endTime,
      required this.location,
      required this.saved});

  factory Event.fromMap(Map<String, dynamic> map) {
    return Event(
      id: map['id'],
      name: map['name'],
      description: map['description'],
      categories: (map['categories'] as String)
          .split(',')
          .map((e) => getCategoryFromName(e))
          .toList(),
      date: DateTime.parse(map['date']),
      adultWarnings: (map['adultWarnings'] as String).split(',').toList(),
      startTime:
          map['startTime'] != null ? DateTime.parse(map['startTime']) : null,
      endTime: map['endTime'] != null ? DateTime.parse(map['endTime']) : null,
      location: map['location'],
      saved: map['saved'] == 1,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'categories':
          categories.map((category) => category.displayName).toList().join(','),
      'date': date.toIso8601String(),
      'adultWarnings': adultWarnings.join(','),
      'startTime': startTime?.toIso8601String(),
      'endTime': endTime?.toIso8601String(),
      'location': location,
      'saved': saved ? 1 : 0,
    };
  }
}

extension EventExtension on Event {
  String get prettyTime {
    DateFormat timeFormat = DateFormat("jm");
    String start = '';
    String end = '';
    if (startTime != null) {
      start = timeFormat.format(startTime!);
      start = start.replaceAll(RegExp(r'\s+'), '\n');
    }
    if (startTime == null && endTime == null) {
      start = 'All\nday';
    }

    return start;
  }

  String get prettyFullTime {
    DateFormat timeFormat = DateFormat("jm");
    String start = '';
    String end = '';
    if (startTime != null) {
      start = timeFormat.format(startTime!);
    }
    if (endTime != null) {
      start += ' - ';
      end = timeFormat.format(endTime!);
    }
    if (startTime == null && endTime == null) {
      start = 'All day';
    }

    return start + end;
  }

  String get prettyDate {
    DateFormat prettyDateFormat = DateFormat('E dd MMM');
    return prettyDateFormat.format(date);
  }

  String get shareMessage {
    DateFormat prettyDateFormat = DateFormat('E dd MMM');
    return 'Chirp chirp! A little birdie informed me about ' +
        name +
        ' happening at ' +
        location +
        ' at ' +
        prettyTime +
        ' on ' +
        prettyDateFormat.format(date) +
        '\n\n' +
        description;
  }
}

extension EventListExtension<T> on List<Event> {
  List<Event> filter(Set<String> selectedMainFilters,
      Set<String> selectedCampFilters, Set<Category> selectedCategoryFilters) {
    print(selectedCampFilters);

    return this
        .where((event) =>
            selectedMainFilters.contains('Saved') ? event.saved : true)
        .where((event) => selectedMainFilters.contains('Roaming')
            ? event.location.contains('Roaming')
            : true)
        .where((event) => selectedCategoryFilters.isNotEmpty
            ? event.categories
                .any((category) => selectedCategoryFilters.contains(category))
            : true)
        .where((event) => selectedCampFilters.isNotEmpty
            ? selectedCampFilters.contains(event.location)
            : true)
        .toList();
  }
}
