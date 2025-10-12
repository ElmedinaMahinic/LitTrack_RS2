import 'package:littrack_mobile/models/arhiva.dart';
import 'package:littrack_mobile/providers/base_provider.dart';

class ArhivaProvider extends BaseProvider<Arhiva> {
  ArhivaProvider() : super("Arhiva");

  @override
  Arhiva fromJson(data) {
    return Arhiva.fromJson(data);
  }
}
