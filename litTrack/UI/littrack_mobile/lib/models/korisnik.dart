import 'package:json_annotation/json_annotation.dart';

part 'korisnik.g.dart';

@JsonSerializable()
class Korisnik {
  int? korisnikId;
  String? ime;
  String? prezime;
  String? korisnickoIme;
  String? email;
  String? telefon;
  bool? jeAktivan;
  DateTime? datumRegistracije;
  List<String>? uloge;

  Korisnik({
    this.korisnikId,
    this.ime,
    this.prezime,
    this.korisnickoIme,
    this.email,
    this.telefon,
    this.jeAktivan,
    this.datumRegistracije,
    this.uloge,
  });

  factory Korisnik.fromJson(Map<String, dynamic> json) =>
      _$KorisnikFromJson(json);
  Map<String, dynamic> toJson() => _$KorisnikToJson(this);
}
