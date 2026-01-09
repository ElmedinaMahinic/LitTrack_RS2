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
  State<AdminUlogaDetailsScreen> createState() =>
      _AdminUlogaDetailsScreenState();
}

class _AdminUlogaDetailsScreenState extends State<AdminUlogaDetailsScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  late UlogaProvider _provider;
  late Map<String, dynamic> _initialValue;
  bool _isSaving = false;

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
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                filled: true,
                fillColor: Colors.white,
              ),
              validator: FormBuilderValidators.compose([
                FormBuilderValidators.required(errorText: "Naziv je obavezan."),
                FormBuilderValidators.minLength(1,
                    errorText: "Naziv ne može biti prazan."),
                FormBuilderValidators.maxLength(50,
                    errorText: "Naziv može imati najviše 50 karaktera."),
                FormBuilderValidators.match(
                  RegExp(r'^[A-ZČĆŽĐŠ][a-zA-ZčćžđšČĆŽĐŠ\s]*$'),
                  errorText:
                      "Naziv mora početi velikim slovom i sadržavati samo slova.",
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
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                filled: true,
                fillColor: Colors.white,
              ),
              validator: FormBuilderValidators.compose([
                FormBuilderValidators.maxLength(200,
                    errorText: "Opis može imati najviše 200 karaktera."),
                FormBuilderValidators.minLength(1,
                    errorText: "Opis ne može biti prazan."),
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
                    WidgetStateProperty.resolveWith<Color>((states) {
                  if (states.contains(WidgetState.pressed) ||
                      states.contains(WidgetState.selected)) {
                    return const Color.fromARGB(255, 100, 100, 100);
                  }
                  if (states.contains(WidgetState.hovered)) {
                    return const Color.fromARGB(255, 150, 150, 150);
                  }
                  return const Color.fromARGB(255, 120, 120, 120);
                }),
                shape: WidgetStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                elevation: WidgetStateProperty.all(4),
                padding: WidgetStateProperty.all(
                  const EdgeInsets.symmetric(horizontal: 16),
                ),
                shadowColor: WidgetStateProperty.all(Colors.black54),
              ),
            ),
          ),
          const SizedBox(width: 20),
          SizedBox(
            width: 140,
            height: 45,
            child: ElevatedButton.icon(
              onPressed: _isSaving
                  ? null
                  : () {
                      showConfirmDialog(
                        context: context,
                        title: widget.uloga == null
                            ? "Dodavanje uloge"
                            : "Uređivanje uloge",
                        message: widget.uloga == null
                            ? "Da li ste sigurni da želite dodati ovu ulogu?"
                            : "Da li ste sigurni da želite urediti ovu ulogu?",
                        icon: widget.uloga == null
                            ? Icons.verified_user
                            : Icons.edit,
                        iconColor: const Color(0xFF3C6E71),
                        onConfirm: _save,
                      );
                    },
              icon: _isSaving
                  ? const SizedBox.shrink()
                  : const Icon(Icons.check, color: Colors.white, size: 20),
              label: _isSaving
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : const Text(
                      "Sačuvaj",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
              style: ButtonStyle(
                backgroundColor:
                    WidgetStateProperty.resolveWith<Color>((states) {
                  if (states.contains(WidgetState.pressed) ||
                      states.contains(WidgetState.selected)) {
                    return const Color(0xFF41706A);
                  }
                  if (states.contains(WidgetState.hovered)) {
                    return const Color(0xFF51968F);
                  }
                  return const Color(0xFF3C6E71);
                }),
                shape: WidgetStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                elevation: WidgetStateProperty.all(4),
                padding: WidgetStateProperty.all(
                  const EdgeInsets.symmetric(horizontal: 16),
                ),
                shadowColor: WidgetStateProperty.all(Colors.black54),
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

    if (!mounted) return;
    setState(() => _isSaving = true);

    try {
      if (widget.uloga == null) {
        await _provider.insert(request);
        if (!mounted) return;
        await showCustomDialog(
          context: context,
          title: "Uspjeh",
          message: "Uloga je uspješno dodana.",
          icon: Icons.check_circle,
          iconColor: Colors.green,
        );
      } else {
        await _provider.update(widget.uloga!.ulogaId!, request);
        if (!mounted) return;
        await showCustomDialog(
          context: context,
          title: "Uspjeh",
          message: "Uloga je uspješno uređena.",
          icon: Icons.check_circle,
          iconColor: Colors.green,
        );
      }

      if (!mounted) return;
      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;
      await showCustomDialog(
        context: context,
        title: "Greška",
        message: e.toString(),
        icon: Icons.error,
        iconColor: Colors.red,
      );
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }
}
