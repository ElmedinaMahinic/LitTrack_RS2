// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ciljna_grupa.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CiljnaGrupa _$CiljnaGrupaFromJson(Map<String, dynamic> json) => CiljnaGrupa(
      (json['ciljnaGrupaId'] as num?)?.toInt(),
      json['naziv'] as String,
    );

Map<String, dynamic> _$CiljnaGrupaToJson(CiljnaGrupa instance) =>
    <String, dynamic>{
      'ciljnaGrupaId': instance.ciljnaGrupaId,
      'naziv': instance.naziv,
    };
