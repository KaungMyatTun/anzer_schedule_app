// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'otp_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OTPModel _$OTPModelFromJson(Map<String, dynamic> json) {
  return OTPModel(
    phoneNumber: json['PhoneNumberByCPI'] as String,
    otpCode: json['OTPCode'] as String,
    requestTime: json['RequestTime'] as String,
  );
}

Map<String, dynamic> _$OTPModelToJson(OTPModel instance) => <String, dynamic>{
      'PhoneNumberByCPI': instance.phoneNumber,
      'OTPCode': instance.otpCode,
      'RequestTime': instance.requestTime,
    };
