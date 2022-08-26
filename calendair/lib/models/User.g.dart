// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'User.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserDataAdapter extends TypeAdapter<UserData> {
  @override
  final int typeId = 0;

  @override
  UserData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserData(
      UID: fields[0] as String,
      city: fields[1] as String?,
      fullName: fields[2] as String,
      streetAddress: fields[3] as String?,
      phoneNumber: fields[4] as String?,
      occupation: (fields[5] as List?)?.cast<String>(),
      description: fields[6] as String?,
      rate: fields[7] as double?,
      reviewsNumber: fields[8] as int?,
      recommendationNumber: fields[9] as int?,
      profilePicture: fields[10] as String?,
      primaryOccupation: fields[11] as String?,
      favorites: (fields[12] as List?)?.cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, UserData obj) {
    writer
      ..writeByte(13)
      ..writeByte(0)
      ..write(obj.UID)
      ..writeByte(1)
      ..write(obj.city)
      ..writeByte(2)
      ..write(obj.fullName)
      ..writeByte(3)
      ..write(obj.streetAddress)
      ..writeByte(4)
      ..write(obj.phoneNumber)
      ..writeByte(5)
      ..write(obj.occupation)
      ..writeByte(6)
      ..write(obj.description)
      ..writeByte(7)
      ..write(obj.rate)
      ..writeByte(8)
      ..write(obj.reviewsNumber)
      ..writeByte(9)
      ..write(obj.recommendationNumber)
      ..writeByte(10)
      ..write(obj.profilePicture)
      ..writeByte(11)
      ..write(obj.primaryOccupation)
      ..writeByte(12)
      ..write(obj.favorites);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
