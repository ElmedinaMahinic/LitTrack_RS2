import 'package:littrack_desktop/models/autor.dart';
import 'package:littrack_desktop/providers/base_provider.dart';

class AutorProvider extends BaseProvider<Autor> {
  AutorProvider() : super("Autor");

  @override
  Autor fromJson(data) {
    return Autor.fromJson(data);
  }
}