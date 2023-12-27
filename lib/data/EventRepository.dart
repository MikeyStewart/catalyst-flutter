import 'DBHelper.dart';

class EventRepository {
  Future<void> addEvent(Map<String, dynamic> event) async {
    await DBHelper.insertEvent(event);
  }

  Future<List<Map<String, dynamic>>> getAllEvents() async {
    return await DBHelper.getAllEvents();
  }

  Future<List<String>> getAllDates() async {
    return await DBHelper.getUniqueDates();
  }

  Future<void> updateEvent(Map<String, dynamic> event) async {
    await DBHelper.updateEvent(event);
  }
}