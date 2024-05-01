import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';

part 'prompt.g.dart'; // Generated file will have this name

final String tablePrompt = 'prompts';

class PromptFields {
  static final List<String> values = [
    /// Add all fields
    id, userRoleIds, promptName, time
  ];

  static final String id = '_id';
  static final String promptName = 'promptName';
  static final String time = 'time';
  static final String userRoleIds = 'userRoleIds';
}

@HiveType(typeId: 2)
class Prompt extends HiveObject {
  @HiveField(0)
  final String? id;
  @HiveField(1)
  final String userRoleIds;
  @HiveField(2)
  final String? promptName;
  @HiveField(3)
  final DateTime createdTime;

  Prompt({
    this.id,
    required this.userRoleIds,
    required this.promptName,
    required this.createdTime,
  });

  Prompt copy({
    String? id,
    String? userRoleIds,
    String? promptName,
    DateTime? createdTime,
  }) =>
      Prompt(
        id: id ?? this.id,
        userRoleIds: userRoleIds ?? this.userRoleIds,
        promptName: promptName ?? this.promptName,
        createdTime: createdTime ?? this.createdTime,
      );

  static Prompt fromJson(Map<String, Object?> json) {
    print("id ${json[PromptFields.id]}");
    print("promptName ${json[PromptFields.promptName]}");
    print("time ${json[PromptFields.time]}");
    return Prompt(
      id: json[PromptFields.id] as String? ?? Uuid().v4(),
      userRoleIds: json[PromptFields.userRoleIds] as String,
      promptName: json[PromptFields.promptName] as String,
      createdTime: DateTime.parse(json[PromptFields.time] as String),
    );
  }

  Map<String, Object?> toJson() => {
        PromptFields.id: id,
        PromptFields.userRoleIds: userRoleIds,
        PromptFields.promptName: promptName,
        PromptFields.time: createdTime.toIso8601String(),
      };
}
