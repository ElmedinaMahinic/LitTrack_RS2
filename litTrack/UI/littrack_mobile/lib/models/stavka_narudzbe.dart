import 'package:json_annotation/json_annotation.dart';

part 'stavka_narudzbe.g.dart';

@JsonSerializable()
class StavkaNarudzbe {
  int? stavkaNarudzbeId;
  int narudzbaId;
  int knjigaId;
  int kolicina;
  double cijena;
  String? nazivKnjige;
  String? slika;

  StavkaNarudzbe(
    this.stavkaNarudzbeId,
    this.narudzbaId,
    this.knjigaId,
    this.kolicina,
    this.cijena,
    this.nazivKnjige,
    this.slika,
  );

  factory StavkaNarudzbe.fromJson(Map<String, dynamic> json) =>
      _$StavkaNarudzbeFromJson(json);

  Map<String, dynamic> toJson() => _$StavkaNarudzbeToJson(this);
}
