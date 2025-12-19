import 'package:littrack_mobile/models/nacin_placanja.dart';
import 'package:littrack_mobile/providers/base_provider.dart';

class NacinPlacanjaProvider extends BaseProvider<NacinPlacanja> {
  NacinPlacanjaProvider() : super("NacinPlacanja");

  @override
  NacinPlacanja fromJson(data) {
    return NacinPlacanja.fromJson(data);
  }
}
