import 'package:json_annotation/json_annotation.dart';

part 'knjiga_favorit.g.dart';

@JsonSerializable()
class KnjigaFavorit {
  int knjigaId;
  String? nazivKnjige;
  String? autorNaziv;
  String? slika;
  int brojArhiviranja;

  KnjigaFavorit({
    required this.knjigaId,
    this.nazivKnjige,
    this.autorNaziv,
    this.slika,
    required this.brojArhiviranja,
  });

  factory KnjigaFavorit.fromJson(Map<String, dynamic> json) =>
      _$KnjigaFavoritFromJson(json);

  Map<String, dynamic> toJson() => _$KnjigaFavoritToJson(this);
}
