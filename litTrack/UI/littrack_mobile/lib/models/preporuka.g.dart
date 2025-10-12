// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'preporuka.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Preporuka _$PreporukaFromJson(Map<String, dynamic> json) => Preporuka(
      (json['preporukaId'] as num?)?.toInt(),
      (json['korisnikId'] as num).toInt(),
      (json['knjigaId'] as num).toInt(),
      DateTime.parse(json['datumPreporuke'] as String),
      json['nazivKnjige'] as String?,
      json['autorNaziv'] as String?,
      (json['cijena'] as num?)?.toDouble(),
      json['slika'] as String?,
    );

Map<String, dynamic> _$PreporukaToJson(Preporuka instance) => <String, dynamic>{
      'preporukaId': instance.preporukaId,
      'korisnikId': instance.korisnikId,
      'knjigaId': instance.knjigaId,
      'datumPreporuke': instance.datumPreporuke.toIso8601String(),
      'nazivKnjige': instance.nazivKnjige,
      'autorNaziv': instance.autorNaziv,
      'cijena': instance.cijena,
      'slika': instance.slika,
    };
