import 'DBHelper.dart';

class EventRepository {
  Future<void> addEvent(Map<String, dynamic> event) async {
    await DBHelper.insertEvent(event);
  }

  Future<List<Map<String, dynamic>>> getAllEvents() async {
    return await DBHelper.getAllEvents();
  }

  Future<void> addDate(Map<String, dynamic> date) async {
    await DBHelper.insertEvent(date);
  }

  Future<List<Map<String, dynamic>>> getAllDates() async {
    return await DBHelper.getAllDates();
  }

// Add other methods for updating, deleting, and querying events
}