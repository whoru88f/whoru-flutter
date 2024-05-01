// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'prompt.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PromptAdapter extends TypeAdapter<Prompt> {
  @override
  final int typeId = 2;

  @override
  Prompt read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Prompt(
      id: fields[0] as String?,
      userRoleIds: fields[1] as String,
      promptName: fields[2] as String?,
      createdTime: fields[3] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, Prompt obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.userRoleIds)
      ..writeByte(2)
      ..write(obj.promptName)
      ..writeByte(3)
      ..write(obj.createdTime);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PromptAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
