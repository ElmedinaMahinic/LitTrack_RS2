import 'package:littrack_mobile/models/moja_listum.dart';
import 'package:littrack_mobile/providers/base_provider.dart';

class MojaListumProvider extends BaseProvider<MojaListum> {
  MojaListumProvider() : super("MojaListum");

  @override
  MojaListum fromJson(data) {
    return MojaListum.fromJson(data);
  }
}