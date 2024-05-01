// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'favorites.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FavoritesAdapter extends TypeAdapter<Favorites> {
  @override
  final int typeId = 4;

  @override
  Favorites read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Favorites(
      id: fields[0] as String?,
      questionName: fields[1] as String?,
      answer: fields[2] as String?,
      roleName: fields[3] as String?,
      isSelected: fields[4] as int?,
      createdTime: fields[5] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, Favorites obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.questionName)
      ..writeByte(2)
      ..write(obj.answer)
      ..writeByte(3)
      ..write(obj.roleName)
      ..writeByte(4)
      ..write(obj.isSelected)
      ..writeByte(5)
      ..write(obj.createdTime);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FavoritesAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
