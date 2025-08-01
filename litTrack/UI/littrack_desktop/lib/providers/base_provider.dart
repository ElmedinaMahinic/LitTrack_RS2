import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:littrack_desktop/providers/auth_provider.dart';
import 'package:littrack_desktop/models/search_result.dart';

abstract class BaseProvider<T> with ChangeNotifier {
  static String? baseUrl;
  String _endpoint = "";

  BaseProvider(String endpoint) {
    _endpoint = endpoint;
    baseUrl = const String.fromEnvironment(
      "baseUrl",
      defaultValue: "http://localhost:5175/api/",
    );
  }

  Future<SearchResult<T>> get({
  dynamic filter,
  int? page,
  int? pageSize,
  String? orderBy,
  String? sortDirection,
  bool? isDeleted,
}) async {
  var url = "$baseUrl$_endpoint";

  Map<String, dynamic> queryParams = {};

  if (filter != null) {
    queryParams.addAll(filter);
  }

  if (page != null) {
    queryParams['page'] = page;
  }
  if (pageSize != null) {
    queryParams['pageSize'] = pageSize;
  }
  if (orderBy != null) {
    queryParams['orderBy'] = orderBy;
  }
  if (sortDirection != null) {
    queryParams['sortDirection'] = sortDirection;
  }
  if (isDeleted != null) {
    queryParams['isDeleted'] = isDeleted;
  }

  if (queryParams.isNotEmpty) {
    var queryString = getQueryString(queryParams);
    url = "$url?$queryString";
  }

  var uri = Uri.parse(url);
  var headers = createHeaders();

  var response = await http.get(uri, headers: headers);

  if (isValidResponse(response)) {
    var data = jsonDecode(response.body);
    var result = SearchResult<T>();

    result.count = data['count'];
    for (var item in data['resultList']) {
      result.resultList.add(fromJson(item));
    }

    return result;
  } else {
    throw Exception("Unknown error");
  }
}

  Future<T> getById(int id) async {
    var url = "$baseUrl$_endpoint/$id";
    var uri = Uri.parse(url);
    var headers = createHeaders();
    var response = await http.get(uri, headers: headers);

    if (isValidResponse(response)) {
      var data = jsonDecode(response.body);
      return fromJson(data);
    } else {
      throw Exception("Unknown error");
    }
  }

  Future<T> insert(dynamic request) async {
    var url = "$baseUrl$_endpoint";
    var uri = Uri.parse(url);
    var headers = createHeaders();

    var jsonRequest = jsonEncode(request);
    var response = await http.post(uri, headers: headers, body: jsonRequest);

    if (isValidResponse(response)) {
      var data = jsonDecode(response.body);
      return fromJson(data);
    } else {
      throw Exception("Unknown error");
    }
  }

  Future<T> update(int id, [dynamic request]) async {
    var url = "$baseUrl$_endpoint/$id";
    var uri = Uri.parse(url);
    var headers = createHeaders();

    var jsonRequest = jsonEncode(request);
    var response = await http.put(uri, headers: headers, body: jsonRequest);

    if (isValidResponse(response)) {
      var data = jsonDecode(response.body);
      return fromJson(data);
    } else {
      throw Exception("Unknown error");
    }
  }

  Future delete(int id) async {
    var url = "$baseUrl$_endpoint/$id";
    var uri = Uri.parse(url);
    var headers = createHeaders();

    var response = await http.delete(uri, headers: headers);

    isValidResponse(response);
  }

  T fromJson(data) {
    throw Exception("Method not implemented");
  }

  bool isValidResponse(Response response) {
    if (response.statusCode < 299) {
      return true;
    } else if (response.statusCode == 401) {
      throw UserException("Unauthorized");
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
        if (e is UserException) {
          throw e;
        }
        throw UserException("Greška u obradi odgovora sa servera.");
      }
    }
  }

   Map<String, String> createHeaders() {
    String username = AuthProvider.username ?? "";
    String password = AuthProvider.password ?? "";

    String basicAuth =
        "Basic ${base64Encode(utf8.encode('$username:$password'))}";

    var headers = {
      "Content-Type": "application/json",
      "Authorization": basicAuth
    };

    return headers;
  }

  String getQueryString(Map params,
      {String prefix = '&', bool inRecursion = false}) {
    String query = '';
    params.forEach((key, value) {
      if (inRecursion) {
        if (key is int) {
          key = '[$key]';
        } else if (value is List || value is Map) {
          key = '.$key';
        } else {
          key = '.$key';
        }
      }
      if (value is String || value is int || value is double || value is bool) {
        var encoded = value;
        if (value is String) {
          encoded = Uri.encodeComponent(value);
        }
        query += '$prefix$key=$encoded';
      } else if (value is DateTime) {
        query += '$prefix$key=${(value as DateTime).toIso8601String()}';
      } else if (value is List || value is Map) {
        if (value is List) value = value.asMap();
        value.forEach((k, v) {
          query +=
              getQueryString({k: v}, prefix: '$prefix$key', inRecursion: true);
        });
      }
    });
    return query;
  }


}


class UserException implements Exception {
  final String message;

  UserException(this.message);

  @override
  String toString() => message;
}

