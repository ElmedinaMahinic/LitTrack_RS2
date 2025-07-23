import 'package:littrack_desktop/models/knjiga.dart';
import 'package:littrack_desktop/providers/base_provider.dart';

class KnjigaProvider extends BaseProvider<Knjiga> {
  KnjigaProvider() : super("Knjiga");

  @override
  Knjiga fromJson(data) {
    return Knjiga.fromJson(data);
  }
}