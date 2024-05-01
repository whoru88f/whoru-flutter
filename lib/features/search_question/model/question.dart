import 'package:chatapp/database/recent_history/recent_question.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';

part 'question.g.dart'; // Generated file will have this name

@HiveType(typeId: 3)
class Question extends HiveObject {
  @HiveField(0)
  final String? id;
  @HiveField(1)
  final String userRoleIds;
  @HiveField(2)
  final String? questionName;
  @HiveField(3)
  final DateTime createdTime;

  Question({
    this.id,
    required this.userRoleIds,
    required this.questionName,
    required this.createdTime,
  });

  Question copy({
    String? id,
    String? userRoleIds,
    String? questionName,
    DateTime? createdTime,
  }) =>
      Question(
        id: id ?? this.id,
        userRoleIds: userRoleIds ?? this.userRoleIds,
        questionName: questionName ?? this.questionName,
        createdTime: createdTime ?? this.createdTime,
      );

  static Question fromJson(Map<String, Object?> json) {
    print("id ${json[RecentQuestionFields.id]}");
    print("questionName ${json[RecentQuestionFields.questionName]}");
    print("time ${json[RecentQuestionFields.time]}");
    return Question(
      id: json[RecentQuestionFields.id] as String? ?? Uuid().v4(),
      userRoleIds: json[RecentQuestionFields.userRoleIds] as String,
      questionName: json[RecentQuestionFields.questionName] as String,
      createdTime: DateTime.parse(json[RecentQuestionFields.time] as String),
    );
  }

  Map<String, Object?> toJson() => {
        RecentQuestionFields.id: id,
        RecentQuestionFields.userRoleIds: userRoleIds,
        RecentQuestionFields.questionName: questionName,
        RecentQuestionFields.time: createdTime.toIso8601String(),
      };
}
