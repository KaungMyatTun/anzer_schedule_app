import 'package:json_annotation/json_annotation.dart';

part 'pt_info.g.dart';

@JsonSerializable()
class PtInfo {
  @JsonKey(name: "CPerCPI")
  final String ptCpi;
  @JsonKey(name: "CPerGiven")
  final String ptGivenName;
  @JsonKey(name: "CPerSurname")
  final String ptSurname;
  @JsonKey(name: "CPerDoB")
  final String ptDob;
  @JsonKey(name: "CPerDoD")
  final String ptDod;
  @JsonKey(name: "CPerAge")
  final int ptAge;
  @JsonKey(name: "CPerSex")
  final String ptSex;
  @JsonKey(name: "CPerCPhone")
  final String ptMobilePhone;
  @JsonKey(name: "CPerAddr1")
  final String ptAddress;

  PtInfo(
      {this.ptCpi,
      this.ptGivenName,
      this.ptSurname,
      this.ptDob,
      this.ptDod,
      this.ptAge,
      this.ptSex,
      this.ptMobilePhone,
      this.ptAddress});

  factory PtInfo.fromJson(Map<String, dynamic> json) => _$PtInfoFromJson(json);

  Map<String, dynamic> toJson() => _$PtInfoToJson(this);
}
