import 'package:intl/intl.dart';
import 'package:catalyst_flutter/data/category.dart';

class Event {
  final String name;
  final String description;
  final List<Category> categories;
  final List<DateTime>
      dates; // Comma separated with format "Saturday 28 January 2023"
  final List<String> adultWarnings;
  final DateTime? startTime;
  final DateTime? endTime;
  final String location;

  Event(this.name, this.description, this.categories, this.dates,
      this.adultWarnings, this.startTime, this.endTime, this.location);

  Event.fromJson(Map<String, dynamic> json)
      : name = json['Event Name'],
        description = json['Description'],
        categories = (json['Event Types'] as String)
            .split(',')
            .where((element) => element.isNotEmpty)
            .map((element) => getCategoryFromName(element))
            .toList(),
        dates = (json['Dates'] as String)
            .split(',')
            .where((element) => element.isNotEmpty)
            .map((unparsedDate) =>
                DateFormat('EEEE d MMMM y').parse(unparsedDate))
            .toList(),
        adultWarnings = (json['Adults Only - Warnings'] as String)
            .split(',')
            .where((element) => element.isNotEmpty)
            .toList(),
        startTime = _parseTime(json['Start Time']),
        endTime = _parseTime(json['End Time']),
        location = _getLocation(json['Location - Theme Camp'],
            json['Location - Artwork'], json['Location - Other']);

  Map<String, dynamic> toJson() => {
        'Event Name': name,
        'Description': description,
        'Event Types': categories,
        'Dates': dates,
        'Start Time': dates,
        'End Time': dates,
        'Adults Only - Warnings': adultWarnings,
      };
}

DateTime? _parseTime(String unparsedTime) {
  if (unparsedTime.isEmpty) {
    return null;
  } else {
    int hours = int.parse(unparsedTime.substring(0, 2));
    int mins = int.parse(unparsedTime.substring(3, 5));
    // Ignore Date properties
    return DateTime(1970, 1, 1, hours, mins);
  }
}

String _getLocation(String themeCamp, String artwork, String elsewhere) {
  if (themeCamp.isNotEmpty) {
    return themeCamp.substring(0, themeCamp.length - 6);
  } else if (artwork.isNotEmpty) {
    return artwork;
  } else if (elsewhere.isNotEmpty) {
    return elsewhere;
  } else {
    return 'unknown';
  }
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
        prettyDateFormat.format(dates.first);
  }
}
