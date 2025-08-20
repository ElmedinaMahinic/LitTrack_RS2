import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:littrack_desktop/layouts/master_screen.dart';
import 'package:littrack_desktop/models/autor.dart';
import 'package:littrack_desktop/providers/autor_provider.dart';
import 'package:littrack_desktop/providers/utils.dart';
import 'package:provider/provider.dart';

class AdminAutoriDetailsScreen extends StatefulWidget {
  final Autor? autor;

  const AdminAutoriDetailsScreen({super.key, this.autor});

  @override
  State<AdminAutoriDetailsScreen> createState() =>
      _AdminAutoriDetailsScreenState();
}

class _AdminAutoriDetailsScreenState extends State<AdminAutoriDetailsScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  late AutorProvider _provider;
  late Map<String, dynamic> _initialValue;

  @override
  void initState() {
    super.initState();
    _provider = context.read<AutorProvider>();
    _initialValue = {
      "Ime": widget.autor?.ime ?? '',
      "Prezime": widget.autor?.prezime ?? '',
      "Biografija": widget.autor?.biografija ?? '',
    };
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreen(
      title: widget.autor == null ? "Dodaj autora" : "Uredi autora",
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
              name: 'Ime',
              decoration: _inputDecoration("Ime autora", "Unesite ime"),
              validator: FormBuilderValidators.compose([
                FormBuilderValidators.required(errorText: "Ime je obavezno."),
                FormBuilderValidators.minLength(1,
                    errorText: "Ime ne može biti prazno."),
                FormBuilderValidators.maxLength(50,
                    errorText: "Ime može imati najviše 50 karaktera."),
                FormBuilderValidators.match(
                  r'^[A-ZČĆŽĐŠ][a-zA-ZčćžđšČĆŽĐŠ\s]*$',
                  errorText:
                      "Ime mora početi velikim slovom i sadržavati samo slova.",
                ),
              ]),
            ),
            const SizedBox(height: 16),
            FormBuilderTextField(
              name: 'Prezime',
              decoration: _inputDecoration("Prezime autora", "Unesite prezime"),
              validator: FormBuilderValidators.compose([
                FormBuilderValidators.required(
                    errorText: "Prezime je obavezno."),
                FormBuilderValidators.minLength(1,
                    errorText: "Prezime ne može biti prazno."),
                FormBuilderValidators.maxLength(50,
                    errorText: "Prezime može imati najviše 50 karaktera."),
                FormBuilderValidators.match(
                  r'^[A-ZČĆŽĐŠ][a-zA-ZčćžđšČĆŽĐŠ\s]*$',
                  errorText:
                      "Prezime mora početi velikim slovom i sadržavati samo slova.",
                ),
              ]),
            ),
            const SizedBox(height: 16),
            FormBuilderTextField(
              name: 'Biografija',
              maxLines: 6,
              decoration: _inputDecoration("Biografija", "Unesite biografiju"),
              validator: FormBuilderValidators.compose([
                FormBuilderValidators.maxLength(1000,
                    errorText: "Biografija može imati najviše 1000 karaktera."),
              ]),
            ),
          ],
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String label, String hint) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      floatingLabelBehavior: FloatingLabelBehavior.always,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      filled: true,
      fillColor: Colors.white,
    );
  }

  Widget _buildActionButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          SizedBox(
            width: 140,
            height: 45,
            child: ElevatedButton.icon(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back_ios_new,
                  color: Colors.white, size: 18),
              label: const Text(
                "Odustani",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.resolveWith<Color>((states) {
                  if (states.contains(MaterialState.hovered)) {
                    return const Color.fromARGB(255, 150, 150, 150);
                  }
                  return const Color.fromARGB(255, 120, 120, 120);
                }),
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                elevation: MaterialStateProperty.all(4),
                padding: MaterialStateProperty.all(
                  const EdgeInsets.symmetric(horizontal: 16),
                ),
                shadowColor: MaterialStateProperty.all(Colors.black54),
              ),
            ),
          ),
          const SizedBox(width: 20),
          SizedBox(
            width: 140,
            height: 45,
            child: ElevatedButton.icon(
              onPressed: () {
                showConfirmDialog(
                  context: context,
                  title: widget.autor == null
                      ? "Dodavanje autora"
                      : "Uređivanje autora",
                  message: widget.autor == null
                      ? "Da li ste sigurni da želite dodati ovog autora?"
                      : "Da li ste sigurni da želite urediti ovog autora?",
                  icon: widget.autor == null ? Icons.person_add : Icons.edit,
                  iconColor: const Color(0xFF3C6E71),
                  onConfirm: _save,
                );
              },
              icon: const Icon(Icons.check, color: Colors.white, size: 20),
              label: const Text(
                "Sačuvaj",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.resolveWith<Color>((states) {
                  if (states.contains(MaterialState.hovered)) {
                    return const Color(0xFF51968F);
                  }
                  return const Color(0xFF3C6E71);
                }),
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                elevation: MaterialStateProperty.all(4),
                padding: MaterialStateProperty.all(
                  const EdgeInsets.symmetric(horizontal: 16),
                ),
                shadowColor: MaterialStateProperty.all(Colors.black54),
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
      if (widget.autor == null) {
        await _provider.insert(request);
        await showCustomDialog(
          context: context,
          title: "Uspjeh",
          message: "Autor je uspješno dodan.",
          icon: Icons.check_circle,
          iconColor: Colors.green,
        );
      } else {
        await _provider.update(widget.autor!.autorId!, request);
        await showCustomDialog(
          context: context,
          title: "Uspjeh",
          message: "Autor je uspješno uređen.",
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
