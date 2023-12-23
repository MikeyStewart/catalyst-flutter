import 'package:catalyst_flutter/data/category.dart';
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

  Event(
      {required this.id,
      required this.name,
      required this.description,
      required this.categories,
      required this.date,
      required this.adultWarnings,
      required this.startTime,
      required this.endTime,
      required this.location});

  factory Event.fromMap(Map<String, dynamic> map) {
    return Event(
      id: map['id'],
      name: map['name'],
      description: map['description'],
      categories: (map['categories'] as String)
          .split(',')
          .map((e) => getCategoryFromName(e))
          .toList(),
      date: DateFormat('EEEE d MMMM y').parse(map['date']),
      adultWarnings: (map['adultWarnings'] as String).split(',').toList(),
      startTime:
          map['startTime'] != null ? DateTime.parse(map['startTime']) : null,
      endTime: map['endTime'] != null ? DateTime.parse(map['endTime']) : null,
      location: map['location'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'categories':
          categories.map((category) => category.displayName).toList().join(','),
      'date': DateFormat('EEEE d MMMM y').format(date),
      'adultWarnings': adultWarnings.join(','),
      'startTime': startTime?.toIso8601String(),
      'endTime': endTime?.toIso8601String(),
      'location': location,
    };
  }

// Event.fromJson(Map<String, dynamic> json)
//     : name = json['Event Name'],
//       description = json['Description'],
//       categories = (json['Event Types'] as String)
//           .split(',')
//           .where((element) => element.isNotEmpty)
//           .map((element) => getCategoryFromName(element))
//           .toList(),
//       dates = (json['Dates'] as String)
//           .split(',')
//           .where((element) => element.isNotEmpty)
//           .map((unparsedDate) =>
//               DateFormat('EEEE d MMMM y').parse(unparsedDate))
//           .toList(),
//       adultWarnings = (json['Adults Only - Warnings'] as String)
//           .split(',')
//           .where((element) => element.isNotEmpty)
//           .toList(),
//       startTime = _parseTime(json['Start Time']),
//       endTime = _parseTime(json['End Time']),
//       location = _getLocation(json['Location - Theme Camp'],
//           json['Location - Artwork'], json['Location - Other']);

// Map<String, dynamic> toJson() => {
//       'Event Name': name,
//       'Description': description,
//       'Event Types': categories,
//       'Dates': dates,
//       'Start Time': dates,
//       'End Time': dates,
//       'Adults Only - Warnings': adultWarnings,
//     };
}

extension EventExtension on Event {
  String get prettyTime {
    DateFormat timeFormat = DateFormat("jm");
    String start = '';
    String end = '';
    if (startTime != null) {
      start = timeFormat.format(startTime!);
    }
    // if (endTime != null) {
    //   start += ' - ';
    //   end = timeFormat.format(endTime!);
    // }
    if (startTime == null && endTime == null) {
      start = 'All day';
    }

    return start;
  }

  String get shareMessage {
    DateFormat prettyDateFormat = DateFormat('E dd MMM');
    return 'Check out this event!\n\n' +
        name +
        '\n\n' +
        'It\'s happening at ' +
        location +
        ' at ' +
        prettyTime +
        ' on ' +
        prettyDateFormat.format(date);
  }
}
