import 'package:littrack_desktop/models/moja_listum.dart';
import 'package:littrack_desktop/providers/base_provider.dart';

class MojaListumProvider extends BaseProvider<MojaListum> {
  MojaListumProvider() : super("MojaListum");

  @override
  MojaListum fromJson(data) {
    return MojaListum.fromJson(data);
  }
}