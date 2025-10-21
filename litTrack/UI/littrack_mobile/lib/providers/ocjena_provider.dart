import 'package:littrack_mobile/models/ocjena.dart';
import 'package:littrack_mobile/providers/base_provider.dart';
import 'package:http/http.dart' as http;

class OcjenaProvider extends BaseProvider<Ocjena> {
  OcjenaProvider() : super("Ocjena");

  @override
  Ocjena fromJson(data) {
    return Ocjena.fromJson(data);
  }

  Future<double> getProsjekOcjena(int knjigaId) async {
    var url = "${BaseProvider.baseUrl}Ocjena/Prosjek/$knjigaId";
    var uri = Uri.parse(url);
    var headers = createHeaders();

    try {
      var response = await http.get(uri, headers: headers);

      if (!isValidResponse(response)) {
        throw UserException("Greška prilikom dohvatanja prosjeka ocjena.");
      }

      return double.parse(response.body);
    } catch (e) {
      if (e is UserException) {
        rethrow;
      }
      throw UserException(
          "Greška prilikom dohvatanja prosjeka ocjena: ${e.toString()}");
    }
  }
}
