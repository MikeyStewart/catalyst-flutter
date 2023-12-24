import 'package:catalyst_flutter/data/event.dart';
import 'package:intl/intl.dart';

import 'EventRepository.dart';

class EventService {
  final EventRepository _repository = EventRepository();

  Future<void> addEvent(Event event) async {
    await _repository.addEvent(event.toMap());
  }

  Future<List<Event>> getAllEvents() async {
    final List<dynamic> eventListJson = await _repository.getAllEvents();
    final List<Event> events =
        eventListJson.map((json) => Event.fromMap(json)).toList();
    return events;
  }

  Future<List<DateTime>> getAllDates() async {
    final List<String> dateList = await _repository.getAllDates();
    final List<DateTime> dates = dateList
        .map((date) => DateTime.parse(date))
        .toList();
    return dates;
  }

// Add logic here that converts initial json to events

// Add other methods for business logic
}
