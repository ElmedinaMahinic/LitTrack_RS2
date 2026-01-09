import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:littrack_desktop/providers/auth_provider.dart';

class ReportProvider with ChangeNotifier {
  static String? baseUrl;
  String _endpoint = "";

  ReportProvider() {
    _endpoint = "Report";
    baseUrl = const String.fromEnvironment(
      "baseUrl",
      defaultValue: "http://localhost:5175/api/",
    );
  }

  Future<List<int>> getRadnikStatistikaPdf({String? stateMachine}) async {
    var url = "$baseUrl$_endpoint/radnik-statistika-pdf";

    if (stateMachine != null && stateMachine.isNotEmpty) {
      url += "?stateMachine=$stateMachine";
    }

    var uri = Uri.parse(url);
    var headers = createHeaders()..addAll({'Accept': 'application/pdf'});

    try {
      var response = await get(uri, headers: headers);

      if (!isValidResponse(response)) {
        throw UserException("Greška pri preuzimanju PDF izvještaja.");
      }

      return response.bodyBytes;
    } catch (e) {
      if (e is UserException) rethrow;
      throw UserException("Greška pri preuzimanju PDF izvještaja: $e");
    }
  }

  Future<List<int>> getAdminStatistikaPdf({String? stateMachine}) async {
    var url = "$baseUrl$_endpoint/admin-statistika-pdf";

    if (stateMachine != null && stateMachine.isNotEmpty) {
      url += "?stateMachine=$stateMachine";
    }

    var uri = Uri.parse(url);
    var headers = createHeaders()..addAll({'Accept': 'application/pdf'});

    try {
      var response = await get(uri, headers: headers);

      if (!isValidResponse(response)) {
        throw UserException("Greška pri preuzimanju PDF izvještaja.");
      }

      return response.bodyBytes;
    } catch (e) {
      if (e is UserException) rethrow;
      throw UserException("Greška pri preuzimanju PDF izvještaja: $e");
    }
  }

  Future<List<int>> getRadnikKreiranPdf({
    required int radnikId,
    required String plainPassword,
  }) async {
    var url =
        "$baseUrl$_endpoint/radnik-kreiran-pdf?radnikId=$radnikId&plainPassword=${Uri.encodeComponent(plainPassword)}";

    var uri = Uri.parse(url);
    var headers = createHeaders()..addAll({'Accept': 'application/pdf'});

    try {
      var response = await get(uri, headers: headers);

      if (!isValidResponse(response)) {
        throw UserException("Greška pri preuzimanju PDF izvještaja.");
      }

      return response.bodyBytes;
    } catch (e) {
      if (e is UserException) rethrow;
      throw UserException("Greška pri preuzimanju PDF izvještaja: $e");
    }
  }

  bool isValidResponse(Response response) {
    if (response.statusCode < 299) {
      return true;
    } else if (response.statusCode == 401) {
      throw UserException("Unauthorized");
    } else if (response.statusCode == 403) {
      throw UserException("Nemate dozvolu za pristup.");
    } else {
      try {
        final errorResponse = jsonDecode(response.body);
        if (errorResponse is Map<String, dynamic> &&
            errorResponse['errors'] != null &&
            errorResponse['errors']['userError'] != null) {
          throw UserException(errorResponse['errors']['userError'].join(', '));
        } else {
          throw UserException("Došlo je do greške, pokušajte ponovo.");
        }
      } catch (e) {
        if (e is UserException) rethrow;
        throw UserException("Greška u obradi odgovora sa servera.");
      }
    }
  }

  Map<String, String> createHeaders() {
    String username = AuthProvider.username ?? "";
    String password = AuthProvider.password ?? "";

    String basicAuth =
        "Basic ${base64Encode(utf8.encode('$username:$password'))}";

    return {
      "Content-Type": "application/json",
      "Authorization": basicAuth,
    };
  }
}

class UserException implements Exception {
  final String message;
  UserException(this.message);

  @override
  String toString() => message;
}
