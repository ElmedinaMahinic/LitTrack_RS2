// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'knjiga.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Knjiga _$KnjigaFromJson(Map<String, dynamic> json) => Knjiga(
      (json['knjigaId'] as num?)?.toInt(),
      json['naziv'] as String,
      json['opis'] as String,
      (json['godinaIzdavanja'] as num).toInt(),
      (json['autorId'] as num).toInt(),
      json['slika'] as String?,
      (json['cijena'] as num).toDouble(),
      json['autorNaziv'] as String?,
      (json['zanrovi'] as List<dynamic>).map((e) => e as String).toList(),
      (json['ciljneGrupe'] as List<dynamic>).map((e) => e as String).toList(),
    );

Map<String, dynamic> _$KnjigaToJson(Knjiga instance) => <String, dynamic>{
      'knjigaId': instance.knjigaId,
      'naziv': instance.naziv,
      'opis': instance.opis,
      'godinaIzdavanja': instance.godinaIzdavanja,
      'autorId': instance.autorId,
      'slika': instance.slika,
      'cijena': instance.cijena,
      'autorNaziv': instance.autorNaziv,
      'zanrovi': instance.zanrovi,
      'ciljneGrupe': instance.ciljneGrupe,
    };
