// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'verification.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class VerificationAdapter extends TypeAdapter<Verification> {
  @override
  final int typeId = 0;

  @override
  Verification read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Verification(
      id: fields[0] as String,
      employeeName: fields[0] as String,
      companyName: fields[1] as String,
      companyAddress: fields[2] as String,
      respName: fields[3] as String,
      contactNumber: fields[4] as String,
      notes: fields[5] as String,
      visitDate: fields[6] as DateTime,
      photos: (fields[7] as List).cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, Verification obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.employeeName)
      ..writeByte(1)
      ..write(obj.companyName)
      ..writeByte(2)
      ..write(obj.companyAddress)
      ..writeByte(3)
      ..write(obj.respName)
      ..writeByte(4)
      ..write(obj.contactNumber)
      ..writeByte(5)
      ..write(obj.notes)
      ..writeByte(6)
      ..write(obj.visitDate)
      ..writeByte(7)
      ..write(obj.photos);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VerificationAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
