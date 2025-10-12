// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'narudzba.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Narudzba _$NarudzbaFromJson(Map<String, dynamic> json) => Narudzba(
      (json['narudzbaId'] as num?)?.toInt(),
      json['sifra'] as String,
      DateTime.parse(json['datumNarudzbe'] as String),
      (json['ukupnaCijena'] as num).toDouble(),
      json['stateMachine'] as String?,
      (json['korisnikId'] as num).toInt(),
      (json['nacinPlacanjaId'] as num).toInt(),
      json['imePrezime'] as String?,
      json['nacinPlacanja'] as String?,
      (json['brojStavki'] as num?)?.toInt(),
      (json['ukupanBrojKnjiga'] as num?)?.toInt(),
    );

Map<String, dynamic> _$NarudzbaToJson(Narudzba instance) => <String, dynamic>{
      'narudzbaId': instance.narudzbaId,
      'sifra': instance.sifra,
      'datumNarudzbe': instance.datumNarudzbe.toIso8601String(),
      'ukupnaCijena': instance.ukupnaCijena,
      'stateMachine': instance.stateMachine,
      'korisnikId': instance.korisnikId,
      'nacinPlacanjaId': instance.nacinPlacanjaId,
      'imePrezime': instance.imePrezime,
      'nacinPlacanja': instance.nacinPlacanja,
      'brojStavki': instance.brojStavki,
      'ukupanBrojKnjiga': instance.ukupanBrojKnjiga,
    };
