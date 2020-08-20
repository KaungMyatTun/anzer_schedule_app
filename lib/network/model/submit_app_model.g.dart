// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'submit_app_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SubmitAppModel _$SubmitAppModelFromJson(Map<String, dynamic> json) {
  return SubmitAppModel(
    ptCPI: json['ptCPI'] as String,
    ptGivenName: json['ptGivenName'] as String,
    ptSurname: json['ptSurname'] as String,
    ptDoB: json['ptDoB'] as String,
    ptDoD: json['ptDoD'] as String,
    ptAge: json['ptAge'] as String,
    ptSex: json['ptSex'] as String,
    ptMobileNumber: json['ptMobileNumber'] as String,
    ptAddress: json['ptAddress'] as String,
    specialityName: json['specialityName'] as String,
    specialityCode: json['specialityCode'] as String,
    doctorName: json['doctorName'] as String,
    doctorCode: json['doctorCode'] as String,
    appdate: json['appdate'] as String,
    appTime: json['appTime'] as String,
    requestDTApp: json['requestDTApp'] == null
        ? null
        : DateTime.parse(json['requestDTApp'] as String),
  );
}

Map<String, dynamic> _$SubmitAppModelToJson(SubmitAppModel instance) =>
    <String, dynamic>{
      'ptCPI': instance.ptCPI,
      'ptGivenName': instance.ptGivenName,
      'ptSurname': instance.ptSurname,
      'ptDoB': instance.ptDoB,
      'ptDoD': instance.ptDoD,
      'ptAge': instance.ptAge,
      'ptSex': instance.ptSex,
      'ptMobileNumber': instance.ptMobileNumber,
      'ptAddress': instance.ptAddress,
      'specialityName': instance.specialityName,
      'specialityCode': instance.specialityCode,
      'doctorName': instance.doctorName,
      'doctorCode': instance.doctorCode,
      'appdate': instance.appdate,
      'appTime': instance.appTime,
      'requestDTApp': instance.requestDTApp?.toIso8601String(),
    };
