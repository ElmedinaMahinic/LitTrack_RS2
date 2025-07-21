import 'package:json_annotation/json_annotation.dart';

part 'ciljna_grupa.g.dart';

@JsonSerializable()
class CiljnaGrupa {
  int? ciljnaGrupaId;
  String naziv;

  CiljnaGrupa(this.ciljnaGrupaId, this.naziv);

  factory CiljnaGrupa.fromJson(Map<String, dynamic> json) =>
      _$CiljnaGrupaFromJson(json);

  Map<String, dynamic> toJson() => _$CiljnaGrupaToJson(this);

  
}