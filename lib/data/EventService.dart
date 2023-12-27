import 'package:catalyst_flutter/data/event.dart';

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
    final List<DateTime> dates =
        dateList.map((date) => DateTime.parse(date)).toList();
    return dates;
  }

  Future<void> saveEvent(Event event) async {
    final Event updatedEvent = Event(
        id: event.id,
        name: event.name,
        description: event.description,
        categories: event.categories,
        date: event.date,
        adultWarnings: event.adultWarnings,
        startTime: event.startTime,
        endTime: event.endTime,
        location: event.location,
        saved: true);
    await _repository.updateEvent(updatedEvent.toMap());
  }

  Future<void> unsaveEvent(Event event) async {
    final Event updatedEvent = Event(
        id: event.id,
        name: event.name,
        description: event.description,
        categories: event.categories,
        date: event.date,
        adultWarnings: event.adultWarnings,
        startTime: event.startTime,
        endTime: event.endTime,
        location: event.location,
        saved: false);
    await _repository.updateEvent(updatedEvent.toMap());
  }

// Add logic here that converts initial json to events
}
