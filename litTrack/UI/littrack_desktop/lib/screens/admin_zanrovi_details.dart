import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:littrack_desktop/layouts/master_screen.dart';
import 'package:littrack_desktop/models/zanr.dart';
import 'package:littrack_desktop/providers/utils.dart';
import 'package:littrack_desktop/providers/zanr_provider.dart';
import 'package:provider/provider.dart';

class AdminZanrDetailsScreen extends StatefulWidget {
  final Zanr? zanr;

  const AdminZanrDetailsScreen({super.key, this.zanr});

  @override
  State<AdminZanrDetailsScreen> createState() => _AdminZanrDetailsScreenState();
}

class _AdminZanrDetailsScreenState extends State<AdminZanrDetailsScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  late ZanrProvider _provider;
  late Map<String, dynamic> _initialValue;
  bool _isSaving = false;

  File? _image;
  String? _base64Image;

  @override
  void initState() {
    super.initState();
    _provider = context.read<ZanrProvider>();
    _base64Image = widget.zanr?.slika;

    _initialValue = {
      "Naziv": widget.zanr?.naziv ?? '',
      "Opis": widget.zanr?.opis ?? '',
    };
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreen(
      title: widget.zanr == null ? "Dodaj žanr" : "Uredi žanr",
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FormBuilderTextField(
              name: 'Naziv',
              decoration: InputDecoration(
                labelText: 'Naziv žanra',
                hintText: 'Unesite naziv žanra',
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
              maxLines: 3,
              decoration: InputDecoration(
                labelText: 'Opis žanra',
                hintText: 'Unesite opis žanra',
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
            const SizedBox(height: 20),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: FormBuilderField(
                      name: "Slika",
                      builder: (field) {
                        return InputDecorator(
                          decoration: InputDecoration(
                            labelText: "Dodajte sliku",
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            border: const OutlineInputBorder(),
                            filled: true,
                            fillColor: Colors.white,
                            errorText: field.errorText,
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 12, horizontal: 12),
                          ),
                          child: ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: const Icon(Icons.image),
                            title: const Text("Izaberite sliku"),
                            trailing: const Icon(Icons.file_upload),
                            onTap: _getImage,
                          ),
                        );
                      },
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Center(
                    child: SizedBox(
                      width: 150,
                      height: 170,
                      child: _base64Image != null
                          ? Image.memory(
                              base64Decode(_base64Image!),
                              fit: BoxFit.cover,
                            )
                          : Image.asset(
                              'assets/images/placeholder.png',
                              fit: BoxFit.cover,
                            ),
                    ),
                  ),
                ),
              ],
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
                        title: widget.zanr == null
                            ? "Dodavanje žanra"
                            : "Uređivanje žanra",
                        message: widget.zanr == null
                            ? "Da li ste sigurni da želite dodati ovaj žanr?"
                            : "Da li ste sigurni da želite urediti ovaj žanr?",
                        icon: widget.zanr == null
                            ? Icons.library_add
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

    final requestData = {
      "Naziv": request["Naziv"],
      "Opis": request["Opis"],
      "Slika": _base64Image,
    };

    if (!mounted) return;
    setState(() => _isSaving = true);

    try {
      if (widget.zanr == null) {
        await _provider.insert(requestData);
        if (!mounted) return;
        await showCustomDialog(
          context: context,
          title: "Uspjeh",
          message: "Žanr je uspješno dodan.",
          icon: Icons.check_circle,
          iconColor: Colors.green,
        );
      } else {
        await _provider.update(widget.zanr!.zanrId!, requestData);
        if (!mounted) return;
        await showCustomDialog(
          context: context,
          title: "Uspjeh",
          message: "Žanr je uspješno ažuriran.",
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

  void _getImage() async {
    var result = await FilePicker.platform.pickFiles(type: FileType.image);

    if (result != null && result.files.single.path != null) {
      _image = File(result.files.single.path!);
      setState(() {
        _base64Image = base64Encode(_image!.readAsBytesSync());
      });
    }
  }
}
