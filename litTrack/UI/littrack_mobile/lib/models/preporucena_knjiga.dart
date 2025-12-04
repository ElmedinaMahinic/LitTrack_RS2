import 'package:json_annotation/json_annotation.dart';

part 'preporucena_knjiga.g.dart';

@JsonSerializable()
class PreporucenaKnjiga {
  int knjigaId;
  String? nazivKnjige;
  String? autorNaziv;
  String? slika;
  int brojPreporuka;

  PreporucenaKnjiga({
    required this.knjigaId,
    this.nazivKnjige,
    this.autorNaziv,
    this.slika,
    required this.brojPreporuka,
  });

  factory PreporucenaKnjiga.fromJson(Map<String, dynamic> json) =>
      _$PreporucenaKnjigaFromJson(json);

  Map<String, dynamic> toJson() => _$PreporucenaKnjigaToJson(this);
}
