import 'package:catalyst_flutter/data/event.dart';
import 'package:catalyst_flutter/data/themecamp.dart';
import 'package:flutter/foundation.dart';

import 'EventService.dart';

class EventDataProvider with ChangeNotifier {
  final EventService _eventService = EventService();
  List<Event> _events = [];
  List<ThemeCamp> _camps = [];
  List<DateTime> _dates = [];

  List<Event> get events => _events;
  List<ThemeCamp> get camps => _camps;
  List<DateTime> get dates => _dates;

  Future<void> loadDataFromDatabase() async {
    // Fetch events from the database and update the state
    _events = await _eventService.getAllEvents();
    _camps = await _eventService.getAllCamps();
    _dates = await _eventService.getAllDates();
    notifyListeners();
  }

  Future<void> saveEvent(Event event) async {
    // Update the event in the database
    Event updatedEvent = await _eventService.saveEvent(event);
    // Update the state and notify listeners
    _updateEventInList(updatedEvent);
  }

  Future<void> unsaveEvent(Event event) async {
    // Update the event in the database
    Event updatedEvent = await _eventService.unsaveEvent(event);
    // Update the state and notify listeners
    _updateEventInList(updatedEvent);
  }

  void _updateEventInList(Event updatedEvent) {
    final index = _events.indexWhere((event) => event.id == updatedEvent.id);
    print('index: ' + index.toString());
    if (index != -1) {
      _events[index] = updatedEvent;
    }
    notifyListeners();
  }
}