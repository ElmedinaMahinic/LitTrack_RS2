import 'package:littrack_desktop/models/recenzija.dart';
import 'package:littrack_desktop/providers/base_provider.dart';

class RecenzijaProvider extends BaseProvider<Recenzija> {
  RecenzijaProvider() : super("Recenzija");

  @override
  Recenzija fromJson(data) {
    return Recenzija.fromJson(data);
  }
}