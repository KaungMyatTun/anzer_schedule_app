import 'package:json_annotation/json_annotation.dart';

part 'available_date_time_model.g.dart';

@JsonSerializable()
class AvailableDateAndTimeModel {
  @JsonKey(name: "OPDStartTime")
  final String opdStartTime;
  @JsonKey(name: "OPDEndTime")
  final String opdEndTime;
  @JsonKey(name: "DoctorName")
  final String doctorName;
  @JsonKey(name: "DoctorCode")
  final String doctorCode;
  @JsonKey(name: "SDate")
  final String availableDate;

  AvailableDateAndTimeModel(
      {this.opdStartTime,
      this.opdEndTime,
      this.doctorName,
      this.doctorCode,
      this.availableDate});

  factory AvailableDateAndTimeModel.fromJson(Map<String, dynamic> json) => _$AvailableDateAndTimeModelFromJson(json);
  Map<String, dynamic> toJson() => _$AvailableDateAndTimeModelToJson(this);
}
