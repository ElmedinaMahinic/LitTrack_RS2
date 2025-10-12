import 'package:json_annotation/json_annotation.dart';

part 'preporuka.g.dart';

@JsonSerializable()
class Preporuka {
  int? preporukaId;
  int korisnikId;
  int knjigaId;
  DateTime datumPreporuke;
  String? nazivKnjige;
  String? autorNaziv;
  double? cijena;
  String? slika;

  Preporuka(
    this.preporukaId,
    this.korisnikId,
    this.knjigaId,
    this.datumPreporuke,
    this.nazivKnjige,
    this.autorNaziv,
    this.cijena,
    this.slika,
  );

  factory Preporuka.fromJson(Map<String, dynamic> json) =>
      _$PreporukaFromJson(json);

  Map<String, dynamic> toJson() => _$PreporukaToJson(this);
}
