import 'package:json_annotation/json_annotation.dart';

part 'moja_listum.g.dart';

@JsonSerializable()
class MojaListum {
  int? mojaListaId;
  int korisnikId;
  int knjigaId;
  bool jeProcitana;
  DateTime datumDodavanja;
  String? nazivKnjige;
  String? autorNaziv;
  double? cijena;
  String? slika;

  MojaListum(
    this.mojaListaId,
    this.korisnikId,
    this.knjigaId,
    this.jeProcitana,
    this.datumDodavanja,
    this.nazivKnjige,
    this.autorNaziv,
    this.cijena,
    this.slika,
  );

  factory MojaListum.fromJson(Map<String, dynamic> json) => _$MojaListumFromJson(json);

  Map<String, dynamic> toJson() => _$MojaListumToJson(this);
}