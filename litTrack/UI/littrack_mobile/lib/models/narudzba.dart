import 'package:json_annotation/json_annotation.dart';

part 'narudzba.g.dart';

@JsonSerializable()
class Narudzba {
  int? narudzbaId;
  String sifra;
  DateTime datumNarudzbe;
  double ukupnaCijena;
  String? stateMachine;
  String? adresa;
  int korisnikId;
  int nacinPlacanjaId;
  String? imePrezime;
  String? nacinPlacanja;
  int? brojStavki;
  int? ukupanBrojKnjiga;

  Narudzba(
    this.narudzbaId,
    this.sifra,
    this.datumNarudzbe,
    this.ukupnaCijena,
    this.stateMachine,
    this.adresa,
    this.korisnikId,
    this.nacinPlacanjaId,
    this.imePrezime,
    this.nacinPlacanja,
    this.brojStavki,
    this.ukupanBrojKnjiga,
  );

  factory Narudzba.fromJson(Map<String, dynamic> json) =>
      _$NarudzbaFromJson(json);

  Map<String, dynamic> toJson() => _$NarudzbaToJson(this);
}
