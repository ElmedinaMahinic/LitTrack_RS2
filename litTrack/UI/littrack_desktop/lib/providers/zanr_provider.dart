import 'package:littrack_desktop/models/zanr.dart';
import 'package:littrack_desktop/providers/base_provider.dart';

class ZanrProvider extends BaseProvider<Zanr> {
  ZanrProvider() : super("Zanr");

  @override
  Zanr fromJson(data) {
    return Zanr.fromJson(data);
  }
}