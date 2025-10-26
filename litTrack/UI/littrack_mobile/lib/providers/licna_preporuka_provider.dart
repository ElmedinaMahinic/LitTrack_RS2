import 'package:littrack_mobile/models/licna_preporuka.dart';
import 'package:littrack_mobile/providers/base_provider.dart';
import 'package:http/http.dart' as http;

class LicnaPreporukaProvider extends BaseProvider<LicnaPreporuka> {
  LicnaPreporukaProvider() : super("LicnaPreporuka");

  @override
  LicnaPreporuka fromJson(data) {
    return LicnaPreporuka.fromJson(data);
  }

  Future<void> oznaciKaoPogledanu(int licnaPreporukaId) async {
    var url =
        "${BaseProvider.baseUrl}LicnaPreporuka/OznaciKaoPogledanu/$licnaPreporukaId";
    var uri = Uri.parse(url);
    var headers = createHeaders();

    try {
      var response = await http.put(uri, headers: headers);

      if (!isValidResponse(response)) {
        throw UserException(
            "Greška prilikom označavanja preporuke kao pogledane.");
      }
    } catch (e) {
      if (e is UserException) {
        rethrow;
      }
      throw UserException(
          "Greška prilikom označavanja preporuke: ${e.toString()}");
    }
  }
}
