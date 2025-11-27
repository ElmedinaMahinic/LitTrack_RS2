import 'package:littrack_mobile/models/narudzba.dart';
import 'package:littrack_mobile/providers/base_provider.dart';
import 'package:http/http.dart' as http;

class NarudzbaProvider extends BaseProvider<Narudzba> {
  NarudzbaProvider() : super("Narudzba");

  @override
  Narudzba fromJson(data) {
    return Narudzba.fromJson(data);
  }

  Future<void> zavrsi(int narudzbaId) async {
    var url = "${BaseProvider.baseUrl}Narudzba/$narudzbaId/zavrsi";
    var uri = Uri.parse(url);
    var headers = createHeaders();

    try {
      var response = await http.put(uri, headers: headers);

      if (!isValidResponse(response)) {
        throw UserException("Greška prilikom završetka narudžbe.");
      }
    } catch (e) {
      if (e is UserException) {
        rethrow;
      }
      throw UserException(
        "Greška prilikom završetka narudžbe: ${e.toString()}",
      );
    }
  }

  Future<void> ponisti(int narudzbaId) async {
    var url = "${BaseProvider.baseUrl}Narudzba/$narudzbaId/ponisti";
    var uri = Uri.parse(url);
    var headers = createHeaders();

    try {
      var response = await http.put(uri, headers: headers);

      if (!isValidResponse(response)) {
        throw UserException("Greška prilikom poništavanja narudžbe.");
      }
    } catch (e) {
      if (e is UserException) {
        rethrow;
      }
      throw UserException(
        "Greška prilikom poništavanja narudžbe: ${e.toString()}",
      );
    }
  }
}
