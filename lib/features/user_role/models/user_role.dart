import 'package:chatapp/database/recent_history/recent_user_role.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'user_role.g.dart'; // Generated file will have this name

class UserRoleFields {
  static final List<String> values = [
    /// Add all fields
    id, userRoleId, roleName, isExample, time
  ];

  static final String id = '_id';
  static final String userRoleId = 'userRoleId';
  static final String roleName = 'roleName';
  static final String time = 'time';
  static final String isExample = 'isExample';
}

@HiveType(typeId: 0)
class UserRole extends HiveObject {
  @HiveField(0)
  final String? id;
  @HiveField(1)
  final String userRoleId;
  @HiveField(2)
  final String? roleName;
  @HiveField(3)
  final int? isExample;
  @HiveField(4)
  final DateTime createdTime;

  UserRole({
    this.id,
    required this.userRoleId,
    required this.roleName,
    required this.isExample,
    required this.createdTime,
  });

  UserRole copy({
    String? id,
    String? userRoleId,
    String? roleName,
    int? isExample,
    DateTime? createdTime,
  }) =>
      UserRole(
        id: id ?? this.id,
        userRoleId: userRoleId ?? this.userRoleId,
        roleName: roleName ?? this.roleName,
        isExample: isExample ?? this.isExample,
        createdTime: createdTime ?? this.createdTime,
      );

  static UserRole fromJson(Map<String, Object?> json) {
    // print("id ${json[RecentUserRoleFields.id]}");
    // print("userRoleId ${json[RecentUserRoleFields.userRoleId]}");
    // print("roleName ${json[RecentUserRoleFields.roleName]}");
    // print("time ${json[RecentUserRoleFields.time]}");
    return UserRole(
      id: json[UserRoleFields.id] as String? ?? Uuid().v4(),
      userRoleId: json[UserRoleFields.userRoleId] as String,
      roleName: json[UserRoleFields.roleName] as String,
      isExample: json[UserRoleFields.isExample] as int,
      createdTime: DateTime.parse(json[UserRoleFields.time] as String),
    );
  }

  static UserRole fromRecentUserRole(RecentUserRole recentUserRole) {
    // print("id ${json[RecentUserRoleFields.id]}");
    // print("userRoleId ${json[RecentUserRoleFields.userRoleId]}");
    // print("roleName ${json[RecentUserRoleFields.roleName]}");
    // print("time ${json[RecentUserRoleFields.time]}");
    return UserRole(
      id: recentUserRole.id,
      userRoleId: recentUserRole.userRoleId,
      roleName: recentUserRole.roleName,
      isExample: recentUserRole.isExample,
      createdTime: recentUserRole.createdTime,
    );
  }

  Map<String, Object?> toJson() => {
        UserRoleFields.id: id,
        UserRoleFields.userRoleId: userRoleId,
        UserRoleFields.roleName: roleName,
        UserRoleFields.isExample: isExample,
        UserRoleFields.time: createdTime.toIso8601String(),
      };
}
