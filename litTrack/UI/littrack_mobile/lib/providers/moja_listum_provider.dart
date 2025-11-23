import 'package:littrack_mobile/models/moja_listum.dart';
import 'package:littrack_mobile/providers/base_provider.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class MojaListumProvider extends BaseProvider<MojaListum> {
  MojaListumProvider() : super("MojaListum");

  @override
  MojaListum fromJson(data) {
    return MojaListum.fromJson(data);
  }

  Future<void> oznaciKaoProcitanu(int mojaListaId) async {
    var url =
        "${BaseProvider.baseUrl}MojaListum/OznaciKaoProcitanu/$mojaListaId";
    var uri = Uri.parse(url);
    var headers = createHeaders();

    try {
      var response = await http.put(uri, headers: headers);

      if (!isValidResponse(response)) {
        throw UserException(
            "Greška prilikom označavanja knjige kao pročitane.");
      }
    } catch (e) {
      if (e is UserException) {
        rethrow;
      }
      throw UserException(
          "Greška prilikom označavanja knjige: ${e.toString()}");
    }
  }

  Future<int> getBrojRazlicitihZanrova(int korisnikId) async {
    var url = "${BaseProvider.baseUrl}MojaListum/BrojZanrova/$korisnikId";
    var uri = Uri.parse(url);
    var headers = createHeaders();

    try {
      var response = await http.get(uri, headers: headers);

      if (!isValidResponse(response)) {
        throw UserException("Greška prilikom dohvatanja broja žanrova.");
      }

      return jsonDecode(response.body) as int;
    } catch (e) {
      if (e is UserException) rethrow;
      throw UserException(
          "Greška prilikom dohvatanja broja žanrova: ${e.toString()}");
    }
  }

  Future<int> getBrojRazlicitihAutora(int korisnikId) async {
    var url = "${BaseProvider.baseUrl}MojaListum/BrojAutora/$korisnikId";
    var uri = Uri.parse(url);
    var headers = createHeaders();

    try {
      var response = await http.get(uri, headers: headers);

      if (!isValidResponse(response)) {
        throw UserException("Greška prilikom dohvatanja broja autora.");
      }

      return jsonDecode(response.body) as int;
    } catch (e) {
      if (e is UserException) rethrow;
      throw UserException(
          "Greška prilikom dohvatanja broja autora: ${e.toString()}");
    }
  }
}
