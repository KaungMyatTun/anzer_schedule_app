// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'doctor_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DoctorModel _$DoctorModelFromJson(Map<String, dynamic> json) {
  return DoctorModel(
    docCode: json['DocCode'] as String,
    docName: json['DocName'] as String,
    docService: json['DocService'] as String,
  );
}

Map<String, dynamic> _$DoctorModelToJson(DoctorModel instance) =>
    <String, dynamic>{
      'DocCode': instance.docCode,
      'DocName': instance.docName,
      'DocService': instance.docService,
    };
