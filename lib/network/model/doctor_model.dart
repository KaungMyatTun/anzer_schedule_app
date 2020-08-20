import 'package:json_annotation/json_annotation.dart';

part 'doctor_model.g.dart';

@JsonSerializable()
class DoctorModel {
  @JsonKey(name: "DocCode")
  final String docCode;
  @JsonKey(name: "DocName")
  final String docName;
  @JsonKey(name: "DocService")
  final String docService;

  DoctorModel({this.docCode, this.docName, this.docService});

  factory DoctorModel.fromJson(Map<String, dynamic> json) =>
      _$DoctorModelFromJson(json);

  Map<String, dynamic> toJson() => _$DoctorModelToJson(this);
}
