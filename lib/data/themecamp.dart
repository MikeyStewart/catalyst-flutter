import 'package:intl/intl.dart';
import 'package:catalyst_flutter/data/category.dart';

class ThemeCamp {
  final String id;
  final String name;
  final String description;

  ThemeCamp({required this.name, required this.description, required this.id});

  ThemeCamp.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        description = json['description'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
      };
}
