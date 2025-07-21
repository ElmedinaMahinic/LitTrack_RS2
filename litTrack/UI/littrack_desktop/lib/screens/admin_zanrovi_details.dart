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

class AdminZanrDetailsScreen extends StatefulWidget {
  final Zanr? zanr;

  const AdminZanrDetailsScreen({super.key, this.zanr});

  @override
  State<AdminZanrDetailsScreen> createState() => _AdminZanrDetailsScreenState();
}

class _AdminZanrDetailsScreenState extends State<AdminZanrDetailsScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  late final ZanrProvider _provider;
  late Map<String, dynamic> _initialValue;

  File? _image;
  String? _base64Image;

  @override
  void initState() {
    super.initState();
    _provider = ZanrProvider();
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
              maxLines: 3,
              decoration: InputDecoration(
                labelText: 'Opis žanra',
                hintText: 'Unesite opis žanra',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                filled: true,
                fillColor: Colors.white,
              ),
              validator: FormBuilderValidators.compose([
                FormBuilderValidators.maxLength(200, errorText: "Opis može imati najviše 200 karaktera."),
                FormBuilderValidators.minLength(1, errorText: "Opis ne može biti prazan."),
              ]),
            ),
            const SizedBox(height: 20),
            FormBuilderField(
              name: "Slika",
              builder: (field) {
                return InputDecorator(
                  decoration: InputDecoration(
                    labelText: "Dodaj sliku",
                    border: const OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.white,
                    errorText: field.errorText,
                  ),
                  child: ListTile(
                    leading: const Icon(Icons.image),
                    title: const Text("Dodaj sliku"),
                    trailing: const Icon(Icons.file_upload),
                    onTap: _getImage,
                  ),
                );
              },
            ),
            const SizedBox(height: 15),
            Row(
              children: [
                SizedBox(
                  width: 200,
                  height: 195,
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

    final requestData = {
      "Naziv": request["Naziv"],
      "Opis": request["Opis"],
      "Slika": _base64Image,
    };

    try {
      if (widget.zanr == null) {
        await _provider.insert(requestData);
        await showCustomDialog(
          context: context,
          title: "Uspjeh",
          message: "Žanr je uspješno dodan.",
          icon: Icons.check_circle,
          iconColor: Colors.green,
        );
      } else {
        await _provider.update(widget.zanr!.zanrId!, requestData);
        await showCustomDialog(
          context: context,
          title: "Uspjeh",
          message: "Žanr je uspješno ažuriran.",
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

