import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:littrack_desktop/models/korisnik.dart';
import 'package:littrack_desktop/providers/auth_provider.dart';
import 'package:littrack_desktop/providers/base_provider.dart';

class KorisnikProvider extends BaseProvider<Korisnik> {
  KorisnikProvider() : super("Korisnik");

  @override
  Korisnik fromJson(data) {
    return Korisnik.fromJson(data);
  }

  Future<Korisnik> login(String username, String password) async {
    var url = "${BaseProvider.baseUrl}Korisnik/login";
    var uri = Uri.parse(url);
    var headers = createHeaders();

    // Login payload, jer backend očekuje JSON objekt KorisnikLoginRequest
    var loginRequest = jsonEncode({
      "korisnickoIme": username,
      "lozinka": password,
    });

    http.Response response;
    try {
      response = await http.post(uri, headers: headers, body: loginRequest);
    } on Exception {
      throw UserException("Greška prilikom prijave.");
    }

    if (username.isEmpty || password.isEmpty) {
      throw UserException("Molimo unesite korisničko ime i lozinku.");
    }

    if (response.body.isEmpty) {
      throw UserException("Pogrešno korisničko ime ili lozinka.");
    }

    if (isValidResponse(response)) {
      var data = jsonDecode(response.body);
      var korisnik = fromJson(data);

      // Popuni AuthProvider polja
      AuthProvider.username = korisnik.korisnickoIme;
      AuthProvider.password = password;
      AuthProvider.korisnikId = korisnik.korisnikId;
      AuthProvider.ime = korisnik.ime;
      AuthProvider.prezime = korisnik.prezime;
      AuthProvider.email = korisnik.email;
      AuthProvider.telefon = korisnik.telefon;
      AuthProvider.jeAktivan = korisnik.jeAktivan;
      AuthProvider.datumRegistracije = korisnik.datumRegistracije;
      AuthProvider.uloge = korisnik.uloge;

      if (korisnik.uloge == null ||
          !(korisnik.uloge!.contains("Admin") ||
              korisnik.uloge!.contains("Radnik"))) {
        throw UserException("Pristup dozvoljen samo adminu i radnicima.");
      }

      return korisnik;
    } else {
      throw UserException("Nepoznata greška.");
    }
  }

  Future<void> aktiviraj(int korisnikId) async {
  var url = "${BaseProvider.baseUrl}Korisnik/Aktiviraj/$korisnikId";
  var uri = Uri.parse(url);
  var headers = createHeaders();

  try {
    var response = await http.put(uri, headers: headers);

    if (!isValidResponse(response)) {
      throw UserException("Greška prilikom aktivacije korisnika.");
    }
  } catch (e) {
    if (e is UserException) {
      rethrow; 
    }
    throw UserException("Greška prilikom aktivacije korisnika: ${e.toString()}");
  }
}

Future<void> deaktiviraj(int korisnikId) async {
  var url = "${BaseProvider.baseUrl}Korisnik/Deaktiviraj/$korisnikId";
  var uri = Uri.parse(url);
  var headers = createHeaders();

  try {
    var response = await http.put(uri, headers: headers);

    if (!isValidResponse(response)) {
      throw UserException("Greška prilikom deaktivacije korisnika.");
    }
  } catch (e) {
    if (e is UserException) {
      rethrow;
    }
    throw UserException("Greška prilikom deaktivacije korisnika: ${e.toString()}");
  }
}

}
