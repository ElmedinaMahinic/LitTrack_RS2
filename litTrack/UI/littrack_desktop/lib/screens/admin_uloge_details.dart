import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:littrack_desktop/layouts/master_screen.dart';
import 'package:littrack_desktop/models/uloga.dart';
import 'package:littrack_desktop/providers/uloga_provider.dart';
import 'package:littrack_desktop/providers/utils.dart';
import 'package:provider/provider.dart';

class AdminUlogaDetailsScreen extends StatefulWidget {
  final Uloga? uloga;

  const AdminUlogaDetailsScreen({super.key, this.uloga});

  @override
  State<AdminUlogaDetailsScreen> createState() => _AdminUlogaDetailsScreenState();
}

class _AdminUlogaDetailsScreenState extends State<AdminUlogaDetailsScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  late UlogaProvider _provider;
  late Map<String, dynamic> _initialValue;

  @override
  void initState() {
    super.initState();
    _provider = context.read<UlogaProvider>(); 
    _initialValue = {
      "Naziv": widget.uloga?.naziv ?? '',
      "Opis": widget.uloga?.opis ?? '',
    };
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreen(
      title: widget.uloga == null ? "Dodaj ulogu" : "Uredi ulogu",
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
        child: Column(
          children: [
            FormBuilderTextField(
              name: 'Naziv',
              decoration: InputDecoration(
                labelText: 'Naziv uloge',
                hintText: 'Unesite naziv uloge',
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
            const SizedBox(height: 20),
            FormBuilderTextField(
              name: 'Opis',
              maxLines: 5,
              decoration: InputDecoration(
                labelText: 'Opis uloge',
                hintText: 'Unesite opis uloge',
                floatingLabelBehavior: FloatingLabelBehavior.always,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                filled: true,
                fillColor: Colors.white,
              ),
              validator: FormBuilderValidators.compose([
                FormBuilderValidators.maxLength(200, errorText: "Opis može imati najviše 200 karaktera."),
                FormBuilderValidators.minLength(1, errorText: "Opis ne može biti prazan."),
              ]),
            ),
          ],
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
              onPressed: () {
                showConfirmDialog(
                  context: context,
                  title: widget.uloga == null
                      ? "Dodavanje uloge"
                      : "Uređivanje uloge",
                  message: widget.uloga == null
                      ? "Da li ste sigurni da želite dodati ovu ulogu?"
                      : "Da li ste sigurni da želite urediti ovu ulogu?",
                  icon: Icons.warning,
                  iconColor: Colors.red,
                  onConfirm: _save,
                );
              },
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
      if (widget.uloga == null) {
        await _provider.insert(request);
        await showCustomDialog(
          context: context,
          title: "Uspjeh",
          message: "Uloga je uspješno dodana.",
          icon: Icons.check_circle,
          iconColor: Colors.green,
        );
      } else {
        await _provider.update(widget.uloga!.ulogaId!, request);
        await showCustomDialog(
          context: context,
          title: "Uspjeh",
          message: "Uloga je uspješno uređena.",
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
