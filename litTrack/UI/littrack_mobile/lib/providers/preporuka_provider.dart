import 'package:littrack_mobile/models/preporuka.dart';
import 'package:littrack_mobile/providers/base_provider.dart';
import 'package:littrack_mobile/models/search_result.dart';
import 'package:littrack_mobile/models/preporucena_knjiga.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PreporukaProvider extends BaseProvider<Preporuka> {
  PreporukaProvider() : super("Preporuka");

  @override
  Preporuka fromJson(data) {
    return Preporuka.fromJson(data);
  }

  Future<SearchResult<PreporucenaKnjiga>> getPreporuceneKnjige({
    int? page,
    int? pageSize,
    String? orderBy,
    String? sortDirection,
    bool? isDeleted,
  }) async {
    var url = "${BaseProvider.baseUrl}Preporuka/PreporuceneKnjige";

    Map<String, dynamic> queryParams = {};

    if (page != null) queryParams['page'] = page;
    if (pageSize != null) queryParams['pageSize'] = pageSize;
    if (orderBy != null) queryParams['orderBy'] = orderBy;
    if (sortDirection != null) queryParams['sortDirection'] = sortDirection;
    if (isDeleted != null) queryParams['isDeleted'] = isDeleted;

    if (queryParams.isNotEmpty) {
      var queryString = getQueryString(queryParams);
      url = "$url?$queryString";
    }

    var uri = Uri.parse(url);
    var headers = createHeaders();

    var response = await http.get(uri, headers: headers);

    if (isValidResponse(response)) {
      var data = jsonDecode(response.body);

      var result = SearchResult<PreporucenaKnjiga>();
      result.count = data['count'];

      for (var item in data['resultList']) {
        result.resultList.add(PreporucenaKnjiga.fromJson(item));
      }

      return result;
    } else {
      throw Exception("Greška prilikom dohvatanja preporučenih knjiga.");
    }
  }
}
