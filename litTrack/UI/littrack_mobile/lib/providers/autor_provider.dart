import 'package:littrack_mobile/models/autor.dart';
import 'package:littrack_mobile/providers/base_provider.dart';

class AutorProvider extends BaseProvider<Autor> {
  AutorProvider() : super("Autor");

  @override
  Autor fromJson(data) {
    return Autor.fromJson(data);
  }
}