import 'package:littrack_mobile/models/recenzija_odgovor.dart';
import 'package:littrack_mobile/providers/base_provider.dart';
import 'package:http/http.dart' as http;

class RecenzijaOdgovorProvider extends BaseProvider<RecenzijaOdgovor> {
  RecenzijaOdgovorProvider() : super("RecenzijaOdgovor");

  @override
  RecenzijaOdgovor fromJson(data) {
    return RecenzijaOdgovor.fromJson(data);
  }

  Future<void> toggleLike(int recenzijaOdgovorId, int korisnikId) async {
    var url =
        "${BaseProvider.baseUrl}RecenzijaOdgovor/ToggleLike/$recenzijaOdgovorId/$korisnikId";
    var uri = Uri.parse(url);
    var headers = createHeaders();

    try {
      var response = await http.put(uri, headers: headers);

      if (!isValidResponse(response)) {
        throw UserException(
            "Greška prilikom lajkovanja odgovora na recenziju.");
      }
    } catch (e) {
      if (e is UserException) rethrow;
      throw UserException(
          "Greška prilikom lajkovanja odgovora na recenziju: ${e.toString()}");
    }
  }

  Future<void> toggleDislike(int recenzijaOdgovorId, int korisnikId) async {
    var url =
        "${BaseProvider.baseUrl}RecenzijaOdgovor/ToggleDislike/$recenzijaOdgovorId/$korisnikId";
    var uri = Uri.parse(url);
    var headers = createHeaders();

    try {
      var response = await http.put(uri, headers: headers);

      if (!isValidResponse(response)) {
        throw UserException(
            "Greška prilikom dislajkovanja odgovora na recenziju.");
      }
    } catch (e) {
      if (e is UserException) rethrow;
      throw UserException(
          "Greška prilikom dislajkovanja odgovora na recenziju: ${e.toString()}");
    }
  }
}
