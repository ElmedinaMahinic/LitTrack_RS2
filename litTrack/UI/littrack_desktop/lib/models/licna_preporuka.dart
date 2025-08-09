import 'package:json_annotation/json_annotation.dart';

part 'licna_preporuka.g.dart';

@JsonSerializable()
class LicnaPreporuka {
  int? licnaPreporukaId;
  int korisnikPosiljalacId;
  int korisnikPrimalacId;
  DateTime datumPreporuke;
  String? naslov;
  String? poruka;
  bool jePogledana;
  String? posiljalacKorisnickoIme;
  String? primalacKorisnickoIme;
  List<String> knjige;

  LicnaPreporuka(
    this.licnaPreporukaId,
    this.korisnikPosiljalacId,
    this.korisnikPrimalacId,
    this.datumPreporuke,
    this.naslov,
    this.poruka,
    this.jePogledana,
    this.posiljalacKorisnickoIme,
    this.primalacKorisnickoIme,
    this.knjige,
  );

  factory LicnaPreporuka.fromJson(Map<String, dynamic> json) => _$LicnaPreporukaFromJson(json);

  Map<String, dynamic> toJson() => _$LicnaPreporukaToJson(this);
}