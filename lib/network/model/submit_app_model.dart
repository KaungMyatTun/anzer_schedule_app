import 'package:json_annotation/json_annotation.dart';

part 'submit_app_model.g.dart';

@JsonSerializable()
class SubmitAppModel {
  final String ptCPI;
  final String ptGivenName;
  final String ptSurname;
  final String ptDoB;
  final String ptDoD;
  final String ptAge;
  final String ptSex;
  final String ptMobileNumber;
  final String ptAddress;
  final String specialityName;
  final String specialityCode;
  final String doctorName;
  final String doctorCode;
  final String appdate;
  final String appTime;
  final DateTime requestDTApp;

  SubmitAppModel(
      {this.ptCPI,
      this.ptGivenName,
      this.ptSurname,
      this.ptDoB,
      this.ptDoD,
      this.ptAge,
      this.ptSex,
      this.ptMobileNumber,
      this.ptAddress,
      this.specialityName,
      this.specialityCode,
      this.doctorName,
      this.doctorCode,
      this.appdate,
      this.appTime,
      this.requestDTApp});

  factory SubmitAppModel.fromJson(Map<String, dynamic> json) => _$SubmitAppModelFromJson(json);

  Map<String, dynamic> toJson() => _$SubmitAppModelToJson(this);

}
