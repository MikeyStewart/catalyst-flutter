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

  Future<void> addDate(DateTime date) async {
    await _repository
        .addDate({'date': DateFormat('EEEE d MMMM y').format(date)});
  }

  Future<List<DateTime>> getAllDates() async {
    final List<dynamic> dateListJson = await _repository.getAllDates();
    final List<DateTime> dates = dateListJson
        .map((json) => DateFormat('EEEE d MMMM y').parse(json))
        .toList();
    return dates;
  }

// Add logic here that converts initial json to events
// Add other methods for business logic
}
