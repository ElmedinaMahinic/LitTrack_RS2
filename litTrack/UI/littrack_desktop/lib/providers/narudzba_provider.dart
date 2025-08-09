import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:littrack_desktop/models/narudzba.dart';
import 'package:littrack_desktop/providers/base_provider.dart';

class NarudzbaProvider extends BaseProvider<Narudzba> {
  NarudzbaProvider() : super("Narudzba");

  @override
  Narudzba fromJson(data) {
    return Narudzba.fromJson(data);
  }

  Future<List<int>> getBrojNarudzbiPoMjesecima({String? stateFilter}) async {
    var url = "${BaseProvider.baseUrl}Narudzba/BrojNarudzbiPoMjesecima";

    if (stateFilter != null && stateFilter.isNotEmpty) {
      url += "?stateFilter=$stateFilter";
    }

    var uri = Uri.parse(url);
    var headers = createHeaders();

    try {
      var response = await http.get(uri, headers: headers);

      if (!isValidResponse(response)) {
        throw UserException("Greška prilikom dohvatanja broja narudžbi.");
      }

      return List<int>.from(jsonDecode(response.body));
    } catch (e) {
      if (e is UserException) {
        rethrow;
      }
      throw UserException("Greška prilikom dohvatanja broja narudžbi: ${e.toString()}");
    }
  }
}