import 'package:json_annotation/json_annotation.dart';

part 'otp_verifyResult_model.g.dart';

@JsonSerializable()
class OTPVerifyResultModel{
  @JsonKey(name: "response_code")
  final int responseCode;
  @JsonKey(name: "response_message")
  final String responseMessage;

  OTPVerifyResultModel({this.responseCode, this.responseMessage});

  factory OTPVerifyResultModel.fromJson(Map<String, dynamic> json) => _$OTPVerifyResultModelFromJson(json);

  Map<String,dynamic> toJson() => _$OTPVerifyResultModelToJson(this);
}