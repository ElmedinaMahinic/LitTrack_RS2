import 'package:json_annotation/json_annotation.dart';

part 'knjiga.g.dart';

@JsonSerializable()
class Knjiga {
  int? knjigaId;
  String naziv;
  String opis;
  int godinaIzdavanja;
  int autorId;
  String? slika;
  double cijena;
  String? autorNaziv;
  List<String> zanrovi;
  List<String> ciljneGrupe;

  Knjiga(
    this.knjigaId,
    this.naziv,
    this.opis,
    this.godinaIzdavanja,
    this.autorId,
    this.slika,
    this.cijena,
    this.autorNaziv,
    this.zanrovi,
    this.ciljneGrupe,
  );

  factory Knjiga.fromJson(Map<String, dynamic> json) => _$KnjigaFromJson(json);

  Map<String, dynamic> toJson() => _$KnjigaToJson(this);
}
