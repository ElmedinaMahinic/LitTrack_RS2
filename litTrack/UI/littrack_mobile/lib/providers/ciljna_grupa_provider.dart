import 'package:littrack_mobile/models/ciljna_grupa.dart';
import 'package:littrack_mobile/providers/base_provider.dart';

class CiljnaGrupaProvider extends BaseProvider<CiljnaGrupa> {
  CiljnaGrupaProvider() : super("CiljnaGrupa");

  @override
  CiljnaGrupa fromJson(data) {
    return CiljnaGrupa.fromJson(data);
  }
}