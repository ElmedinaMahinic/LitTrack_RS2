import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:littrack_desktop/layouts/master_screen.dart';
import 'package:littrack_desktop/models/ciljna_grupa.dart';
import 'package:littrack_desktop/providers/ciljna_grupa_provider.dart';
import 'package:littrack_desktop/providers/utils.dart';
import 'package:provider/provider.dart';

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
  late CiljnaGrupaProvider _provider;
  late Map<String, dynamic> _initialValue;

  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _provider = context.read<CiljnaGrupaProvider>();
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
            FormBuilderValidators.minLength(1,
                errorText: "Naziv ne može biti prazan."),
            FormBuilderValidators.maxLength(50,
                errorText: "Naziv može imati najviše 50 karaktera."),
            FormBuilderValidators.match(
              r'^[A-ZČĆŽĐŠ][a-zA-ZčćžđšČĆŽĐŠ\s]*$',
              errorText:
                  "Naziv mora početi velikim slovom i sadržavati samo slova.",
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
                  if (states.contains(MaterialState.pressed) ||
                      states.contains(MaterialState.selected)) {
                    return const Color.fromARGB(255, 100, 100, 100);
                  }
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
              onPressed: _isSaving
                  ? null
                  : () {
                      showConfirmDialog(
                        context: context,
                        title: widget.ciljnaGrupa == null
                            ? "Dodavanje ciljne grupe"
                            : "Uređivanje ciljne grupe",
                        message: widget.ciljnaGrupa == null
                            ? "Da li ste sigurni da želite dodati ovu ciljnu grupu?"
                            : "Da li ste sigurni da želite urediti ovu ciljnu grupu?",
                        icon: widget.ciljnaGrupa == null
                            ? Icons.group_add
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
                    MaterialStateProperty.resolveWith<Color>((states) {
                  if (states.contains(MaterialState.pressed) ||
                      states.contains(MaterialState.selected)) {
                    return const Color(0xFF41706A);
                  }
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

    if (mounted) {
      setState(() => _isSaving = true);
    }

    try {
      if (widget.ciljnaGrupa == null) {
        await _provider.insert(request);
        if (!mounted) return;
        await showCustomDialog(
          context: context,
          title: "Uspjeh",
          message: "Ciljna grupa je uspješno dodana.",
          icon: Icons.check_circle,
          iconColor: Colors.green,
        );
      } else {
        await _provider.update(
          widget.ciljnaGrupa!.ciljnaGrupaId!,
          request,
        );
        if (!mounted) return;
        await showCustomDialog(
          context: context,
          title: "Uspjeh",
          message: "Ciljna grupa je uspješno uređena.",
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
