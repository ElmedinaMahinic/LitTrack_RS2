import 'package:littrack_desktop/models/licna_preporuka.dart';
import 'package:littrack_desktop/providers/base_provider.dart';

class LicnaPreporukaProvider extends BaseProvider<LicnaPreporuka> {
  LicnaPreporukaProvider() : super("LicnaPreporuka");

  @override
  LicnaPreporuka fromJson(data) {
    return LicnaPreporuka.fromJson(data);
  }
}