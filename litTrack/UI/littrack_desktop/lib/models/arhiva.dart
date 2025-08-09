import 'package:json_annotation/json_annotation.dart';

part 'arhiva.g.dart';

@JsonSerializable()
class Arhiva {
  int? arhivaId;
  int korisnikId;
  int knjigaId;
  DateTime datumDodavanja;
  String? nazivKnjige;
  String? autorNaziv;
  double? cijena;
  String? slika;

  Arhiva(
    this.arhivaId,
    this.korisnikId,
    this.knjigaId,
    this.datumDodavanja,
    this.nazivKnjige,
    this.autorNaziv,
    this.cijena,
    this.slika,
  );

  factory Arhiva.fromJson(Map<String, dynamic> json) => _$ArhivaFromJson(json);

  Map<String, dynamic> toJson() => _$ArhivaToJson(this);
}