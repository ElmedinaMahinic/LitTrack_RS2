import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:littrack_desktop/layouts/master_screen.dart';
import 'package:littrack_desktop/models/ciljna_grupa.dart';
import 'package:littrack_desktop/providers/ciljna_grupa_provider.dart';
import 'package:littrack_desktop/providers/utils.dart';

class AdminCiljnaGrupaDetailsScreen extends StatefulWidget {
  final CiljnaGrupa? ciljnaGrupa;

  const AdminCiljnaGrupaDetailsScreen({super.key, this.ciljnaGrupa});

  @override
  State<AdminCiljnaGrupaDetailsScreen> createState() =>
      _AdminCiljnaGrupaDetailsScreenState();
}

class _AdminCiljnaGrupaDetailsScreenState
    extends State<AdminCiljnaGrupaDetailsScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  late final CiljnaGrupaProvider _provider;
  late Map<String, dynamic> _initialValue;

  @override
  void initState() {
    super.initState();
    _provider = CiljnaGrupaProvider();
    _initialValue = {
      "Naziv": widget.ciljnaGrupa?.naziv ?? '',
    };
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreen(
      title: widget.ciljnaGrupa == null
          ? "Dodaj ciljnu grupu"
          : "Uredi ciljnu grupu",
      child: Column(
        children: [
          _buildForm(),
          const SizedBox(height: 30),
          _buildActionButtons(),
        ],
      ),
    );
  }

  Widget _buildForm() {
    return Padding(
      padding: const EdgeInsets.all(25.0),
      child: FormBuilder(
        key: _formKey,
        initialValue: _initialValue,
        child: FormBuilderTextField(
          name: 'Naziv',
          decoration: InputDecoration(
            labelText: 'Naziv ciljne grupe',
            hintText: 'Unesite naziv ciljne grupe',
            floatingLabelBehavior: FloatingLabelBehavior.always,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            filled: true,
            fillColor: Colors.white,
          ),
          validator: FormBuilderValidators.compose([
            FormBuilderValidators.required(errorText: "Naziv je obavezan."),
            FormBuilderValidators.minLength(1, errorText: "Naziv ne može biti prazan."),
            FormBuilderValidators.maxLength(50, errorText: "Naziv može imati najviše 50 karaktera."),
            FormBuilderValidators.match(
              r'^[A-ZČĆŽĐŠ][a-zA-ZčćžđšČĆŽĐŠ\s]*$',
              errorText: "Naziv mora početi velikim slovom i sadržavati samo slova.",
            ),
          ]),
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          SizedBox(
            width: 120,
            height: 45,
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                "Odustani",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          const SizedBox(width: 20),
          SizedBox(
            width: 120,
            height: 45,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF3C6E71),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: _save,
              child: const Text(
                "Sačuvaj",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _save() async {
    final isValid = _formKey.currentState?.saveAndValidate();
    if (isValid != true) return;

    final request = _formKey.currentState!.value;

    try {
      if (widget.ciljnaGrupa == null) {
        await _provider.insert(request);
        await showCustomDialog(
          context: context,
          title: "Uspjeh",
          message: "Ciljna grupa je uspješno dodana.",
          icon: Icons.check_circle,
          iconColor: Colors.green,
        );
      } else {
        await _provider.update(widget.ciljnaGrupa!.ciljnaGrupaId!, request);
        await showCustomDialog(
          context: context,
          title: "Uspjeh",
          message: "Ciljna grupa je uspješno uređena.",
          icon: Icons.check_circle,
          iconColor: Colors.green,
        );
      }

      Navigator.pop(context, true); 
    } catch (e) {
      await showCustomDialog(
        context: context,
        title: "Greška",
        message: e.toString(),
        icon: Icons.error,
        iconColor: Colors.red,
      );
    }
  }
}
