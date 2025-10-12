// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'licna_preporuka.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LicnaPreporuka _$LicnaPreporukaFromJson(Map<String, dynamic> json) =>
    LicnaPreporuka(
      (json['licnaPreporukaId'] as num?)?.toInt(),
      (json['korisnikPosiljalacId'] as num).toInt(),
      (json['korisnikPrimalacId'] as num).toInt(),
      DateTime.parse(json['datumPreporuke'] as String),
      json['naslov'] as String?,
      json['poruka'] as String?,
      json['jePogledana'] as bool,
      json['posiljalacKorisnickoIme'] as String?,
      json['primalacKorisnickoIme'] as String?,
      (json['knjige'] as List<dynamic>).map((e) => e as String).toList(),
    );

Map<String, dynamic> _$LicnaPreporukaToJson(LicnaPreporuka instance) =>
    <String, dynamic>{
      'licnaPreporukaId': instance.licnaPreporukaId,
      'korisnikPosiljalacId': instance.korisnikPosiljalacId,
      'korisnikPrimalacId': instance.korisnikPrimalacId,
      'datumPreporuke': instance.datumPreporuke.toIso8601String(),
      'naslov': instance.naslov,
      'poruka': instance.poruka,
      'jePogledana': instance.jePogledana,
      'posiljalacKorisnickoIme': instance.posiljalacKorisnickoIme,
      'primalacKorisnickoIme': instance.primalacKorisnickoIme,
      'knjige': instance.knjige,
    };
