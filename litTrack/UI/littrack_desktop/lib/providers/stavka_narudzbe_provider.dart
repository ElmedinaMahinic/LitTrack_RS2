import 'package:littrack_desktop/models/stavka_narudzbe.dart';
import 'package:littrack_desktop/providers/base_provider.dart';

class StavkaNarudzbeProvider extends BaseProvider<StavkaNarudzbe> {
  StavkaNarudzbeProvider() : super("StavkaNarudzbe");

  @override
  StavkaNarudzbe fromJson(data) {
    return StavkaNarudzbe.fromJson(data);
  }
}