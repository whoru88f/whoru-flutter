import 'package:hive/hive.dart';

part 'favorites.g.dart'; // Generated file will have this name

final String tableFavoritess = 'favorite_question';

class FavoritesFields {
  static final List<String> values = [
    /// Add all fields
    id, questionName, answer, roleName, time, isSelected
  ];

  static final String id = '_id';
  static final String questionName = 'questionName';
  static final String answer = 'answer';
  static final String roleName = 'roleName';
  static final String time = 'time';
  static final String isSelected = 'isSelected';
}

@HiveType(typeId: 4)
class Favorites extends HiveObject {
  @HiveField(0)
  final String? id;
  @HiveField(1)
  final String? questionName;
  @HiveField(2)
  final String? answer;
  @HiveField(3)
  final String? roleName;
  @HiveField(4)
  final int? isSelected;
  @HiveField(5)
  final DateTime createdTime;

  Favorites({
    this.id,
    required this.questionName,
    required this.answer,
    required this.roleName,
    required this.isSelected,
    required this.createdTime,
  });

  Favorites copy({
    String? id,
    String? questionName,
    String? answer,
    String? roleName,
    int? isSelected,
    DateTime? createdTime,
  }) =>
      Favorites(
        id: id ?? this.id,
        questionName: questionName ?? this.questionName,
        answer: answer ?? this.answer,
        roleName: roleName ?? this.roleName,
        isSelected: isSelected ?? this.isSelected,
        createdTime: createdTime ?? this.createdTime,
      );

  static Favorites fromJson(Map<String, Object?> json) => Favorites(
        id: json[FavoritesFields.id] as String?,
        questionName: json[FavoritesFields.questionName] as String,
        answer: json[FavoritesFields.answer] as String,
        roleName: json[FavoritesFields.roleName] as String,
        isSelected: json[FavoritesFields.isSelected] as int,
        createdTime: DateTime.parse(json[FavoritesFields.time] as String),
      );

  Map<String, Object?> toJson() => {
        FavoritesFields.id: id,
        FavoritesFields.questionName: questionName,
        FavoritesFields.answer: answer,
        FavoritesFields.roleName: roleName,
        FavoritesFields.isSelected: isSelected,
        FavoritesFields.time: createdTime.toIso8601String(),
      };
}
