// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'knjiga_favorit.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

KnjigaFavorit _$KnjigaFavoritFromJson(Map<String, dynamic> json) =>
    KnjigaFavorit(
      knjigaId: (json['knjigaId'] as num).toInt(),
      nazivKnjige: json['nazivKnjige'] as String?,
      autorNaziv: json['autorNaziv'] as String?,
      slika: json['slika'] as String?,
      brojArhiviranja: (json['brojArhiviranja'] as num).toInt(),
    );

Map<String, dynamic> _$KnjigaFavoritToJson(KnjigaFavorit instance) =>
    <String, dynamic>{
      'knjigaId': instance.knjigaId,
      'nazivKnjige': instance.nazivKnjige,
      'autorNaziv': instance.autorNaziv,
      'slika': instance.slika,
      'brojArhiviranja': instance.brojArhiviranja,
    };
