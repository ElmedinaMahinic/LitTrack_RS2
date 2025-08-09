import 'package:littrack_desktop/models/preporuka.dart';
import 'package:littrack_desktop/providers/base_provider.dart';

class PreporukaProvider extends BaseProvider<Preporuka> {
  PreporukaProvider() : super("Preporuka");

  @override
  Preporuka fromJson(data) {
    return Preporuka.fromJson(data);
  }
}