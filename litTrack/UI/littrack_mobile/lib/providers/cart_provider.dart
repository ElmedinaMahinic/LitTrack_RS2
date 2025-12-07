import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:littrack_mobile/models/knjiga.dart';

class CartProvider with ChangeNotifier {
  final int? userId;
  static const String _cartKeyPrefix = 'cart_';

  CartProvider(this.userId);

  Map<String, dynamic> _knjigaToMap(Knjiga knjiga) {
    return {
      'id': knjiga.knjigaId,
      'naziv': knjiga.naziv,
      'opis': knjiga.opis,
      'cijena': knjiga.cijena,
      'autorId': knjiga.autorId,
      'autorNaziv': knjiga.autorNaziv,
      'slika': knjiga.slika,
      'zanrovi': knjiga.zanrovi,
      'ciljneGrupe': knjiga.ciljneGrupe,
    };
  }

  Future<void> addToCart(Knjiga knjiga, int quantity) async {
    final prefs = await SharedPreferences.getInstance();
    final cartKey = '$_cartKeyPrefix$userId';
    Map<String, dynamic> cart = {};

    if (prefs.containsKey(cartKey)) {
      final String cartData = prefs.getString(cartKey)!;
      try {
        cart = Map<String, dynamic>.from(json.decode(cartData));
      } catch (_) {}
    }

    String knjigaId = knjiga.knjigaId.toString();

    if (cart.containsKey(knjigaId)) {
      if (cart[knjigaId]['kolicina'] != null) {
        cart[knjigaId]['kolicina'] += quantity;
      } else {
        cart[knjigaId]['kolicina'] = quantity;
      }
    } else {
      cart[knjigaId] = {
        ..._knjigaToMap(knjiga),
        'kolicina': quantity,
      };
    }

    await prefs.setString(cartKey, json.encode(cart));
    notifyListeners();
  }

  Future<Map<String, dynamic>> getCart() async {
    final prefs = await SharedPreferences.getInstance();
    final cartKey = '$_cartKeyPrefix$userId';
    if (prefs.containsKey(cartKey)) {
      final String cartData = prefs.getString(cartKey)!;
      try {
        return Map<String, dynamic>.from(json.decode(cartData));
      } catch (_) {}
    }
    return {};
  }

  Future<void> updateCart(int knjigaId, int quantity) async {
    final prefs = await SharedPreferences.getInstance();
    final cartKey = '$_cartKeyPrefix$userId';
    Map<String, dynamic> cart = await getCart();

    if (cart.containsKey(knjigaId.toString())) {
      cart[knjigaId.toString()]['kolicina'] = quantity;
    }

    await prefs.setString(cartKey, json.encode(cart));
    notifyListeners();
  }

  Future<void> deleteFromCart(int knjigaId) async {
    final prefs = await SharedPreferences.getInstance();
    final cartKey = '$_cartKeyPrefix$userId';
    Map<String, dynamic> cart = await getCart();

    if (cart.containsKey(knjigaId.toString())) {
      cart.remove(knjigaId.toString());
    }

    await prefs.setString(cartKey, json.encode(cart));
    notifyListeners();
  }

  Future<void> clearCart() async {
    final prefs = await SharedPreferences.getInstance();
    final cartKey = '$_cartKeyPrefix$userId';
    await prefs.remove(cartKey);
    notifyListeners();
  }

  double izracunajUkupnuCijenu(Map<String, dynamic> cartItems) {
    double total = 0.0;
    for (var item in cartItems.entries) {
      total += (item.value['cijena'] as num) * (item.value['kolicina'] as int);
    }
    return total;
  }
}
