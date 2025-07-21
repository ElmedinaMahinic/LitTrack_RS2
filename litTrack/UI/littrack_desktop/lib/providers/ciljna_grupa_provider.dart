import 'package:littrack_desktop/models/ciljna_grupa.dart';
import 'package:littrack_desktop/providers/base_provider.dart';

class CiljnaGrupaProvider extends BaseProvider<CiljnaGrupa> {
  CiljnaGrupaProvider() : super("CiljnaGrupa");

  @override
  CiljnaGrupa fromJson(data) {
    return CiljnaGrupa.fromJson(data);
  }
}