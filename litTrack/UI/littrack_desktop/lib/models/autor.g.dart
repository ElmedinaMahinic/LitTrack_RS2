// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'autor.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Autor _$AutorFromJson(Map<String, dynamic> json) => Autor(
      (json['autorId'] as num?)?.toInt(),
      json['ime'] as String,
      json['prezime'] as String,
      json['biografija'] as String?,
    );

Map<String, dynamic> _$AutorToJson(Autor instance) => <String, dynamic>{
      'autorId': instance.autorId,
      'ime': instance.ime,
      'prezime': instance.prezime,
      'biografija': instance.biografija,
    };
