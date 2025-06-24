// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'guest.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class GuestAdapter extends TypeAdapter<Guest> {
  @override
  final int typeId = 0;

  @override
  Guest read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Guest(
      name: fields[0] as String,
      purpose: fields[1] as String,
      phone: fields[2] as String,
      origin: fields[3] as String,
      timestamp: fields[4] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, Guest obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.purpose)
      ..writeByte(2)
      ..write(obj.phone)
      ..writeByte(3)
      ..write(obj.origin)
      ..writeByte(4)
      ..write(obj.timestamp);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GuestAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
