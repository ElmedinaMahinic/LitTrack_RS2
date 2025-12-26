import 'package:littrack_mobile/models/knjiga.dart';
import 'package:littrack_mobile/providers/base_provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class KnjigaProvider extends BaseProvider<Knjiga> {
  KnjigaProvider() : super("Knjiga");

  @override
  Knjiga fromJson(data) {
    return Knjiga.fromJson(data);
  }

  Future<List<Knjiga>> getRecommendedBooks(int knjigaId) async {
    var url = "${BaseProvider.baseUrl}Knjiga/$knjigaId/recommended";
    var uri = Uri.parse(url);
    var headers = createHeaders();

    try {
      var response = await http.get(uri, headers: headers);

      if (response.body.isEmpty || response.body == 'null') {
        return [];
      }

      if (!isValidResponse(response)) {
        throw UserException("Greška prilikom dohvatanja preporučenih knjiga.");
      }

      var data = jsonDecode(response.body);

      if (data is List) {
        return data.map((item) => Knjiga.fromJson(item)).toList();
      } else {
        throw UserException("Greška u formatu podataka.");
      }
    } catch (e) {
      if (e is UserException) rethrow;
      throw UserException(
          "Greška prilikom dohvatanja preporučenih knjiga: ${e.toString()}");
    }
  }
}
