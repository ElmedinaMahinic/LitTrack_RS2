import 'package:json_annotation/json_annotation.dart';

part 'autor.g.dart';

@JsonSerializable()
class Autor {
  int? autorId;
  String ime;
  String prezime;
  String? biografija;

  Autor(this.autorId, this.ime, this.prezime, this.biografija);

  factory Autor.fromJson(Map<String, dynamic> json) => _$AutorFromJson(json);

  Map<String, dynamic> toJson() => _$AutorToJson(this);
}
