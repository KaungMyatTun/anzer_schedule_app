// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pt_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PtInfo _$PtInfoFromJson(Map<String, dynamic> json) {
  return PtInfo(
    ptCpi: json['CPerCPI'] as String,
    ptGivenName: json['CPerGiven'] as String,
    ptSurname: json['CPerSurname'] as String,
    ptDob: json['CPerDoB'] as String,
    ptDod: json['CPerDoD'] as String,
    ptAge: json['CPerAge'] as int,
    ptSex: json['CPerSex'] as String,
    ptMobilePhone: json['CPerCPhone'] as String,
    ptAddress: json['CPerAddr1'] as String,
  );
}

Map<String, dynamic> _$PtInfoToJson(PtInfo instance) => <String, dynamic>{
      'CPerCPI': instance.ptCpi,
      'CPerGiven': instance.ptGivenName,
      'CPerSurname': instance.ptSurname,
      'CPerDoB': instance.ptDob,
      'CPerDoD': instance.ptDod,
      'CPerAge': instance.ptAge,
      'CPerSex': instance.ptSex,
      'CPerCPhone': instance.ptMobilePhone,
      'CPerAddr1': instance.ptAddress,
    };
