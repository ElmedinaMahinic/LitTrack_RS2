import 'package:littrack_mobile/models/recenzija.dart';
import 'package:littrack_mobile/providers/base_provider.dart';
import 'package:http/http.dart' as http;

class RecenzijaProvider extends BaseProvider<Recenzija> {
  RecenzijaProvider() : super("Recenzija");

  @override
  Recenzija fromJson(data) {
    return Recenzija.fromJson(data);
  }

  Future<void> toggleLike(int recenzijaId, int korisnikId) async {
    var url =
        "${BaseProvider.baseUrl}Recenzija/ToggleLike/$recenzijaId/$korisnikId";
    var uri = Uri.parse(url);
    var headers = createHeaders();

    try {
      var response = await http.put(uri, headers: headers);

      if (!isValidResponse(response)) {
        throw UserException("Greška prilikom lajkovanja recenzije.");
      }
    } catch (e) {
      if (e is UserException) rethrow;
      throw UserException(
          "Greška prilikom lajkovanja recenzije: ${e.toString()}");
    }
  }

  Future<void> toggleDislike(int recenzijaId, int korisnikId) async {
    var url =
        "${BaseProvider.baseUrl}Recenzija/ToggleDislike/$recenzijaId/$korisnikId";
    var uri = Uri.parse(url);
    var headers = createHeaders();

    try {
      var response = await http.put(uri, headers: headers);

      if (!isValidResponse(response)) {
        throw UserException("Greška prilikom dislajkovanja recenzije.");
      }
    } catch (e) {
      if (e is UserException) rethrow;
      throw UserException(
          "Greška prilikom dislajkovanja recenzije: ${e.toString()}");
    }
  }
}
