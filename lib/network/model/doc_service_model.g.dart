// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'doc_service_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DocServiceModel _$DocServiceModelFromJson(Map<String, dynamic> json) {
  return DocServiceModel(
    servCode: json['ServCode'] as String,
    servDesc: json['ServDesc'] as String,
  );
}

Map<String, dynamic> _$DocServiceModelToJson(DocServiceModel instance) =>
    <String, dynamic>{
      'ServCode': instance.servCode,
      'ServDesc': instance.servDesc,
    };
