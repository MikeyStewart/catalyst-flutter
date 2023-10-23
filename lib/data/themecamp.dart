import 'package:intl/intl.dart';
import 'package:catalyst_flutter/data/category.dart';

class ThemeCamp {
  final String name;
  final String description;

  ThemeCamp(this.name, this.description);

  ThemeCamp.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        description = json['description'];

  Map<String, dynamic> toJson() => {
        'name': name,
        'description': description,
      };
}
