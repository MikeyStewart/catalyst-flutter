import 'DBHelper.dart';

class EventRepository {
  Future<void> addEvent(Map<String, dynamic> event) async {
    await DBHelper.insertEvent(event);
  }

  Future<void> addCamp(Map<String, dynamic> camp) async {
    await DBHelper.insertCamp(camp);
  }

  Future<List<Map<String, dynamic>>> getAllEvents() async {
    return await DBHelper.getAllEvents();
  }

  Future<List<Map<String, dynamic>>> getAllCamps() async {
    return await DBHelper.getAllCamps();
  }

  Future<List<String>> getAllDates() async {
    return await DBHelper.getUniqueDates();
  }

  Future<void> updateEvent(Map<String, dynamic> event) async {
    await DBHelper.updateEvent(event);
  }
}