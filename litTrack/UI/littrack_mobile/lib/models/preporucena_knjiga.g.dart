// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'preporucena_knjiga.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PreporucenaKnjiga _$PreporucenaKnjigaFromJson(Map<String, dynamic> json) =>
    PreporucenaKnjiga(
      knjigaId: (json['knjigaId'] as num).toInt(),
      nazivKnjige: json['nazivKnjige'] as String?,
      autorNaziv: json['autorNaziv'] as String?,
      slika: json['slika'] as String?,
      brojPreporuka: (json['brojPreporuka'] as num).toInt(),
    );

Map<String, dynamic> _$PreporucenaKnjigaToJson(PreporucenaKnjiga instance) =>
    <String, dynamic>{
      'knjigaId': instance.knjigaId,
      'nazivKnjige': instance.nazivKnjige,
      'autorNaziv': instance.autorNaziv,
      'slika': instance.slika,
      'brojPreporuka': instance.brojPreporuka,
    };
