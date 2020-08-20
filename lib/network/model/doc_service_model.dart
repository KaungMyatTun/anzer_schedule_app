import 'package:json_annotation/json_annotation.dart';

part 'doc_service_model.g.dart';

@JsonSerializable()
class DocServiceModel {
  @JsonKey(name: "ServCode")
  final String servCode;
  @JsonKey(name: "ServDesc")
  final String servDesc;

  DocServiceModel({this.servCode, this.servDesc});

  factory DocServiceModel.fromJson(Map<String, dynamic> json) =>
      _$DocServiceModelFromJson(json);
  Map<String, dynamic> toJson() => _$DocServiceModelToJson(this);
}
