import 'package:littrack_desktop/models/arhiva.dart';
import 'package:littrack_desktop/providers/base_provider.dart';
import 'package:http/http.dart' as http;

class ArhivaProvider extends BaseProvider<Arhiva> {
  ArhivaProvider() : super("Arhiva");

  @override
  Arhiva fromJson(data) {
    return Arhiva.fromJson(data);
  }

  Future<String> getNajdrazaKnjigaNaziv() async {
  var url = "${BaseProvider.baseUrl}Arhiva/NajdrazaKnjiga";
  var uri = Uri.parse(url);
  var headers = createHeaders();

  try {
    var response = await http.get(uri, headers: headers);

    if (!isValidResponse(response)) {
      throw UserException("Greška prilikom dohvatanja najdraže knjige.");
    }

    return response.body;
  } catch (e) {
    if (e is UserException) {
      rethrow;
    }
    throw UserException("Greška prilikom dohvatanja najdraže knjige: ${e.toString()}");
  }
}

}