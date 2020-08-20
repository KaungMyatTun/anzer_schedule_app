// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'available_date_time_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AvailableDateAndTimeModel _$AvailableDateAndTimeModelFromJson(
    Map<String, dynamic> json) {
  return AvailableDateAndTimeModel(
    opdStartTime: json['OPDStartTime'] as String,
    opdEndTime: json['OPDEndTime'] as String,
    doctorName: json['DoctorName'] as String,
    doctorCode: json['DoctorCode'] as String,
    availableDate: json['SDate'] as String,
  );
}

Map<String, dynamic> _$AvailableDateAndTimeModelToJson(
        AvailableDateAndTimeModel instance) =>
    <String, dynamic>{
      'OPDStartTime': instance.opdStartTime,
      'OPDEndTime': instance.opdEndTime,
      'DoctorName': instance.doctorName,
      'DoctorCode': instance.doctorCode,
      'SDate': instance.availableDate,
    };
