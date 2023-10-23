import 'package:flutter/material.dart';

enum Category {
  artsCrafts,
  chillOut,
  discussionConversation,
  foodDrink,
  games,
  healthWellness,
  music,
  party,
  performance,
  spiritualHealing,
  talkLecture,
  workshop,
  // Default/error case
  unknown,
}

extension CategoryExtension on Category {
  String get displayName {
    switch (this) {
      case Category.artsCrafts:
        return 'Arts & Crafts';
      case Category.chillOut:
        return 'Chillout';
      case Category.discussionConversation:
        return 'Discussion / Conversation';
      case Category.foodDrink:
        return 'Food & Drink';
      case Category.games:
        return 'Games';
      case Category.healthWellness:
        return 'Health & Wellness';
      case Category.music:
        return 'Music';
      case Category.party:
        return 'Party';
      case Category.performance:
        return 'Performance';
      case Category.spiritualHealing:
        return 'Spiritual & Healing';
      case Category.talkLecture:
        return 'Talk / Lecture';
      case Category.workshop:
        return 'Workshop';
      default:
        return "unknown";
    }
  }

  IconData get icon {
    switch (this) {
      case Category.artsCrafts:
        return Icons.brush_rounded;
      case Category.chillOut:
        return Icons.chair_rounded;
      case Category.discussionConversation:
        return Icons.forum_rounded;
      case Category.foodDrink:
        return Icons.fastfood_rounded;
      case Category.games:
        return Icons.videogame_asset_rounded;
      case Category.healthWellness:
        return Icons.spa_rounded;
      case Category.music:
        return Icons.music_note_rounded;
      case Category.party:
        return Icons.celebration_rounded;
      case Category.performance:
        return Icons.theater_comedy_rounded;
      case Category.spiritualHealing:
        return Icons.self_improvement_rounded;
      case Category.talkLecture:
        return Icons.spatial_audio_off_rounded;
      case Category.workshop:
        return Icons.construction_rounded;
      default:
        return Icons.question_mark_rounded;
    }
  }
}

Category getCategoryFromName(String name) {
  for (Category category in Category.values) {
    if (category.displayName == name) {
      return category;
    }
  }
  return Category.unknown;
}
