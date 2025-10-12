import 'package:json_annotation/json_annotation.dart';

part 'zanr.g.dart';

@JsonSerializable()
class Zanr {
  int? zanrId;
  String naziv;
  String? opis;
  String? slika;

  Zanr(this.zanrId, this.naziv, this.opis, this.slika);

  factory Zanr.fromJson(Map<String, dynamic> json) => _$ZanrFromJson(json);

  Map<String, dynamic> toJson() => _$ZanrToJson(this);
}
