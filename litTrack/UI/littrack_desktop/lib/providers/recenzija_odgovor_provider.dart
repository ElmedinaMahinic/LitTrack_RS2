import 'package:littrack_desktop/models/recenzija_odgovor.dart';
import 'package:littrack_desktop/providers/base_provider.dart';

class RecenzijaOdgovorProvider extends BaseProvider<RecenzijaOdgovor> {
  RecenzijaOdgovorProvider() : super("RecenzijaOdgovor");

  @override
  RecenzijaOdgovor fromJson(data) {
    return RecenzijaOdgovor.fromJson(data);
  }
}