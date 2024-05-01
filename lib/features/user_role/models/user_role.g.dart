// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_role.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserRoleAdapter extends TypeAdapter<UserRole> {
  @override
  final int typeId = 0;

  @override
  UserRole read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserRole(
      id: fields[0] as String?,
      userRoleId: fields[1] as String,
      roleName: fields[2] as String?,
      isExample: fields[3] as int?,
      createdTime: fields[4] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, UserRole obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.userRoleId)
      ..writeByte(2)
      ..write(obj.roleName)
      ..writeByte(3)
      ..write(obj.isExample)
      ..writeByte(4)
      ..write(obj.createdTime);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserRoleAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
