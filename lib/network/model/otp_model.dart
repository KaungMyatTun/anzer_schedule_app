import 'package:json_annotation/json_annotation.dart';

part 'otp_model.g.dart';

@JsonSerializable()
class OTPModel{
  @JsonKey(name: "PhoneNumberByCPI")
  final String phoneNumber;
  @JsonKey(name: "OTPCode")
  final String otpCode;
  @JsonKey(name: "RequestTime")
  final String requestTime;

  OTPModel({this.phoneNumber, this.otpCode, this.requestTime});

  factory OTPModel.fromJson(Map<String, dynamic> json) => _$OTPModelFromJson(json);

  Map<String,dynamic> toJson() => _$OTPModelToJson(this);
}