// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'zanr.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Zanr _$ZanrFromJson(Map<String, dynamic> json) => Zanr(
      (json['zanrId'] as num?)?.toInt(),
      json['naziv'] as String,
      json['opis'] as String?,
      json['slika'] as String?,
    );

Map<String, dynamic> _$ZanrToJson(Zanr instance) => <String, dynamic>{
      'zanrId': instance.zanrId,
      'naziv': instance.naziv,
      'opis': instance.opis,
      'slika': instance.slika,
    };
