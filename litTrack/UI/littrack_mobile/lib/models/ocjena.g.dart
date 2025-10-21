// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ocjena.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Ocjena _$OcjenaFromJson(Map<String, dynamic> json) => Ocjena(
      (json['ocjenaId'] as num?)?.toInt(),
      (json['knjigaId'] as num).toInt(),
      (json['korisnikId'] as num).toInt(),
      (json['vrijednost'] as num).toInt(),
      DateTime.parse(json['datumOcjenjivanja'] as String),
    );

Map<String, dynamic> _$OcjenaToJson(Ocjena instance) => <String, dynamic>{
      'ocjenaId': instance.ocjenaId,
      'knjigaId': instance.knjigaId,
      'korisnikId': instance.korisnikId,
      'vrijednost': instance.vrijednost,
      'datumOcjenjivanja': instance.datumOcjenjivanja.toIso8601String(),
    };
