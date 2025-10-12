// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'moja_listum.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MojaListum _$MojaListumFromJson(Map<String, dynamic> json) => MojaListum(
      (json['mojaListaId'] as num?)?.toInt(),
      (json['korisnikId'] as num).toInt(),
      (json['knjigaId'] as num).toInt(),
      json['jeProcitana'] as bool,
      DateTime.parse(json['datumDodavanja'] as String),
      json['nazivKnjige'] as String?,
      json['autorNaziv'] as String?,
      (json['cijena'] as num?)?.toDouble(),
      json['slika'] as String?,
    );

Map<String, dynamic> _$MojaListumToJson(MojaListum instance) =>
    <String, dynamic>{
      'mojaListaId': instance.mojaListaId,
      'korisnikId': instance.korisnikId,
      'knjigaId': instance.knjigaId,
      'jeProcitana': instance.jeProcitana,
      'datumDodavanja': instance.datumDodavanja.toIso8601String(),
      'nazivKnjige': instance.nazivKnjige,
      'autorNaziv': instance.autorNaziv,
      'cijena': instance.cijena,
      'slika': instance.slika,
    };
