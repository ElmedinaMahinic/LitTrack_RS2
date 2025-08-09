// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'arhiva.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Arhiva _$ArhivaFromJson(Map<String, dynamic> json) => Arhiva(
      (json['arhivaId'] as num?)?.toInt(),
      (json['korisnikId'] as num).toInt(),
      (json['knjigaId'] as num).toInt(),
      DateTime.parse(json['datumDodavanja'] as String),
      json['nazivKnjige'] as String?,
      json['autorNaziv'] as String?,
      (json['cijena'] as num?)?.toDouble(),
      json['slika'] as String?,
    );

Map<String, dynamic> _$ArhivaToJson(Arhiva instance) => <String, dynamic>{
      'arhivaId': instance.arhivaId,
      'korisnikId': instance.korisnikId,
      'knjigaId': instance.knjigaId,
      'datumDodavanja': instance.datumDodavanja.toIso8601String(),
      'nazivKnjige': instance.nazivKnjige,
      'autorNaziv': instance.autorNaziv,
      'cijena': instance.cijena,
      'slika': instance.slika,
    };
