// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_info_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ApiInfoModelAdapter extends TypeAdapter<ApiInfoModel> {
  @override
  final int typeId = 1;

  @override
  ApiInfoModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ApiInfoModel(
      fields[0] as String,
      fields[1] as String,
      fields[2] as int,
      fields[3] as int,
      fields[4] as int,
    )
      ..isApiWorking = fields[5] as bool?
      ..lastStatusCode = fields[6] as int?
      ..lastRetryCount = fields[7] as int?;
  }

  @override
  void write(BinaryWriter writer, ApiInfoModel obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.url)
      ..writeByte(1)
      ..write(obj.method)
      ..writeByte(2)
      ..write(obj.responseStatus)
      ..writeByte(3)
      ..write(obj.retryCount)
      ..writeByte(4)
      ..write(obj.periodSeconds)
      ..writeByte(5)
      ..write(obj.isApiWorking)
      ..writeByte(6)
      ..write(obj.lastStatusCode)
      ..writeByte(7)
      ..write(obj.lastRetryCount);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ApiInfoModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
