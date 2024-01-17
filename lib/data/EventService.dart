import 'package:catalyst_flutter/data/event.dart';
import 'package:catalyst_flutter/data/themecamp.dart';

import 'EventRepository.dart';

class EventService {
  final EventRepository _repository = EventRepository();

  Future<void> addEvent(Event event) async {
    await _repository.addEvent(event.toMap());
  }

  Future<void> addCamp(ThemeCamp camp) async {
    await _repository.addCamp(camp.toJson());
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

  Future<List<ThemeCamp>> getAllCamps() async {
    final List<dynamic> campListJson = await _repository.getAllCamps();
    final List<ThemeCamp> camps =
    campListJson.map((json) => ThemeCamp.fromJson(json)).toList();
    return camps;
  }

  Future<Event> saveEvent(Event event) async {
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
    return updatedEvent;
  }

  Future<Event> unsaveEvent(Event event) async {
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
    return updatedEvent;
  }

// Add logic here that converts initial json to events
}
