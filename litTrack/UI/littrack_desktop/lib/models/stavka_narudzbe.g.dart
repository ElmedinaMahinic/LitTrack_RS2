// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stavka_narudzbe.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StavkaNarudzbe _$StavkaNarudzbeFromJson(Map<String, dynamic> json) =>
    StavkaNarudzbe(
      (json['stavkaNarudzbeId'] as num?)?.toInt(),
      (json['narudzbaId'] as num).toInt(),
      (json['knjigaId'] as num).toInt(),
      (json['kolicina'] as num).toInt(),
      (json['cijena'] as num).toDouble(),
      json['nazivKnjige'] as String?,
      json['slika'] as String?,
    );

Map<String, dynamic> _$StavkaNarudzbeToJson(StavkaNarudzbe instance) =>
    <String, dynamic>{
      'stavkaNarudzbeId': instance.stavkaNarudzbeId,
      'narudzbaId': instance.narudzbaId,
      'knjigaId': instance.knjigaId,
      'kolicina': instance.kolicina,
      'cijena': instance.cijena,
      'nazivKnjige': instance.nazivKnjige,
      'slika': instance.slika,
    };
