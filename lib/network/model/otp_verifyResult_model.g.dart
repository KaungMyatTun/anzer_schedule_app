// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'otp_verifyResult_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OTPVerifyResultModel _$OTPVerifyResultModelFromJson(Map<String, dynamic> json) {
  return OTPVerifyResultModel(
    responseCode: json['response_code'] as int,
    responseMessage: json['response_message'] as String,
  );
}

Map<String, dynamic> _$OTPVerifyResultModelToJson(
        OTPVerifyResultModel instance) =>
    <String, dynamic>{
      'response_code': instance.responseCode,
      'response_message': instance.responseMessage,
    };
