import 'package:littrack_desktop/models/obavijest.dart';
import 'package:littrack_desktop/providers/base_provider.dart';

class ObavijestProvider extends BaseProvider<Obavijest> {
  ObavijestProvider() : super("Obavijest");

  @override
  Obavijest fromJson(data) {
    return Obavijest.fromJson(data);
  }
}