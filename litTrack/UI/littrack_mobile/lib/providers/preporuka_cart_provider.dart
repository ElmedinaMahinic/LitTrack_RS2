import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:littrack_mobile/models/knjiga.dart';

class PreporukaCartProvider with ChangeNotifier {
  final int? userId;
  static const String _cartKeyPrefix = 'preporuka_';

  PreporukaCartProvider(this.userId);

  Map<String, dynamic> _knjigaToMap(Knjiga knjiga) {
    return {
      'id': knjiga.knjigaId,
      'naziv': knjiga.naziv,
      'opis': knjiga.opis,
      'autorId': knjiga.autorId,
      'autorNaziv': knjiga.autorNaziv,
      'slika': knjiga.slika,
      'godinaIzdavanja': knjiga.godinaIzdavanja,
      'cijena': knjiga.cijena,
    };
  }

  Future<void> addToPreporukaList(Knjiga knjiga) async {
    final prefs = await SharedPreferences.getInstance();
    final cartKey = '$_cartKeyPrefix$userId';
    Map<String, dynamic> lista = {};

    if (prefs.containsKey(cartKey)) {
      final String data = prefs.getString(cartKey)!;
      try {
        lista = Map<String, dynamic>.from(json.decode(data));
      } catch (_) {}
    }

    String knjigaId = knjiga.knjigaId.toString();
    if (!lista.containsKey(knjigaId)) {
      lista[knjigaId] = _knjigaToMap(knjiga);
      await prefs.setString(cartKey, json.encode(lista));
      notifyListeners();
    }
  }

  Future<Map<String, dynamic>> getPreporukaList() async {
    final prefs = await SharedPreferences.getInstance();
    final cartKey = '$_cartKeyPrefix$userId';
    if (prefs.containsKey(cartKey)) {
      final String data = prefs.getString(cartKey)!;
      try {
        return Map<String, dynamic>.from(json.decode(data));
      } catch (_) {}
    }
    return {};
  }

  Future<void> removeKnjiga(int knjigaId) async {
    final prefs = await SharedPreferences.getInstance();
    final cartKey = '$_cartKeyPrefix$userId';
    Map<String, dynamic> lista = {};

    if (prefs.containsKey(cartKey)) {
      final String data = prefs.getString(cartKey)!;
      try {
        lista = Map<String, dynamic>.from(json.decode(data));
      } catch (_) {}
    }

    if (lista.containsKey(knjigaId.toString())) {
      lista.remove(knjigaId.toString());
      await prefs.setString(cartKey, json.encode(lista));
      notifyListeners();
    }
  }

  Future<void> clearPreporukaList() async {
    final prefs = await SharedPreferences.getInstance();
    final cartKey = '$_cartKeyPrefix$userId';
    await prefs.remove(cartKey);
    notifyListeners();
  }

  Future<bool> isInPreporuka(int knjigaId) async {
    final lista = await getPreporukaList();
    return lista.containsKey(knjigaId.toString());
  }
}
