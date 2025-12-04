import 'package:littrack_mobile/models/arhiva.dart';
import 'package:littrack_mobile/providers/base_provider.dart';
import 'package:littrack_mobile/models/search_result.dart';
import 'package:littrack_mobile/models/knjiga_favorit.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ArhivaProvider extends BaseProvider<Arhiva> {
  ArhivaProvider() : super("Arhiva");

  @override
  Arhiva fromJson(data) {
    return Arhiva.fromJson(data);
  }

  Future<SearchResult<KnjigaFavorit>> getKnjigeFavoriti({
    int? page,
    int? pageSize,
    String? orderBy,
    String? sortDirection,
    bool? isDeleted,
  }) async {
    var url = "${BaseProvider.baseUrl}Arhiva/KnjigeFavoriti";

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

      var result = SearchResult<KnjigaFavorit>();
      result.count = data['count'];

      for (var item in data['resultList']) {
        result.resultList.add(KnjigaFavorit.fromJson(item));
      }

      return result;
    } else {
      throw Exception("Greška prilikom dohvatanja knjiga favorita.");
    }
  }
}
