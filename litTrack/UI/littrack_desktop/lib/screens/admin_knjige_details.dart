import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:littrack_desktop/layouts/master_screen.dart';
import 'package:littrack_desktop/models/knjiga.dart';
import 'package:littrack_desktop/providers/autor_provider.dart';
import 'package:littrack_desktop/providers/zanr_provider.dart';
import 'package:littrack_desktop/providers/ciljna_grupa_provider.dart';
import 'package:littrack_desktop/providers/knjiga_provider.dart';
import 'package:littrack_desktop/providers/utils.dart';
import 'package:provider/provider.dart';

class AdminKnjigeDetailsScreen extends StatefulWidget {
  final Knjiga? knjiga;

  const AdminKnjigeDetailsScreen({super.key, this.knjiga});

  @override
  State<AdminKnjigeDetailsScreen> createState() =>
      _AdminKnjigeDetailsScreenState();
}

class _AdminKnjigeDetailsScreenState extends State<AdminKnjigeDetailsScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  late KnjigaProvider _knjigaProvider;
  late AutorProvider _autorProvider;
  late ZanrProvider _zanrProvider;
  late CiljnaGrupaProvider _ciljnaGrupaProvider;

  List<dynamic> _autori = [];
  List<dynamic> _zanrovi = [];
  List<dynamic> _ciljneGrupe = [];

  File? _image;
  String? _base64Image;

  late Map<String, dynamic> _initialValue;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _knjigaProvider = context.read<KnjigaProvider>();
    _autorProvider = context.read<AutorProvider>();
    _zanrProvider = context.read<ZanrProvider>();
    _ciljnaGrupaProvider = context.read<CiljnaGrupaProvider>();

    _fetchData();
  }

  Future<void> _fetchData() async {
    final autoriResult = await _autorProvider.get();
    final zanroviResult = await _zanrProvider.get();
    final ciljneGrupeResult = await _ciljnaGrupaProvider.get();

    if (!mounted) return;

    List<dynamic> autori = autoriResult.resultList;
    List<dynamic> zanrovi = zanroviResult.resultList;
    List<dynamic> ciljneGrupe = ciljneGrupeResult.resultList;

    Map<String, dynamic> initialData = {
      "Naziv": widget.knjiga?.naziv ?? '',
      "Opis": widget.knjiga?.opis ?? '',
      "GodinaIzdavanja": widget.knjiga?.godinaIzdavanja.toString() ?? '',
      "Cijena": widget.knjiga?.cijena.toString() ?? '',
    };

    if (widget.knjiga != null) {
      try {
        final autor = autori.firstWhere(
          (a) => a.autorId == widget.knjiga!.autorId,
        );
        initialData['AutorId'] = autor.autorId;
      } catch (e) {
        if (!mounted) return;
        await showCustomDialog(
          context: context,
          title: "Greška",
          message: "Autor sa ID ${widget.knjiga!.autorId} nije pronađen.",
          icon: Icons.error,
        );
        return;
      }

      initialData['Zanrovi'] = zanrovi
          .where((z) => widget.knjiga!.zanrovi.contains(z.naziv))
          .map<int>((z) => z.zanrId as int)
          .toList();

      initialData['CiljneGrupe'] = ciljneGrupe
          .where((c) => widget.knjiga!.ciljneGrupe.contains(c.naziv))
          .map<int>((c) => c.ciljnaGrupaId as int)
          .toList();
    }

    if (!mounted) return;

    setState(() {
      _autori = autori;
      _zanrovi = zanrovi;
      _ciljneGrupe = ciljneGrupe;
      _base64Image = widget.knjiga?.slika;
      _initialValue = initialData;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreen(
      title: widget.knjiga == null ? "Dodaj knjigu" : "Uredi knjigu",
      child: (_autori.isEmpty ||
              _zanrovi.isEmpty ||
              _ciljneGrupe.isEmpty ||
              _initialValue.isEmpty)
          ? const Center(child: CircularProgressIndicator())
          : Column(
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
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 1,
                  child: FormBuilderTextField(
                    name: 'Naziv',
                    decoration:
                        _inputDecoration("Naziv knjige", "Unesite naziv"),
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(
                          errorText: "Naziv je obavezan."),
                      FormBuilderValidators.minLength(1,
                          errorText: "Naziv ne može biti prazan."),
                      FormBuilderValidators.maxLength(100,
                          errorText: "Naziv može imati najviše 100 karaktera."),
                      FormBuilderValidators.match(
                        RegExp(r'^[A-ZČĆŽĐŠ][a-zA-ZčćžđšČĆŽĐŠ0-9\s,.\-]*$'),
                        errorText:
                            "Naziv mora početi velikim slovom i može sadržavati slova, brojeve i znakove (, . -).",
                      ),
                    ]),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  flex: 2,
                  child: FormBuilderTextField(
                    name: 'Opis',
                    decoration: _inputDecoration("Opis", "Unesite opis"),
                    maxLines: 6,
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(
                          errorText: "Opis je obavezan."),
                      FormBuilderValidators.minLength(1,
                          errorText: "Opis ne može biti prazan."),
                      FormBuilderValidators.maxLength(1000,
                          errorText: "Opis može imati najviše 1000 karaktera."),
                    ]),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: FormBuilderTextField(
                    name: 'GodinaIzdavanja',
                    decoration:
                        _inputDecoration("Godina izdavanja", "Unesite godinu"),
                    keyboardType: TextInputType.number,
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(
                          errorText: "Godina izdavanja je obavezna."),
                      FormBuilderValidators.integer(
                          errorText: "Unesite validnu godinu."),
                      FormBuilderValidators.min(1450,
                          errorText: "Godina ne može biti manja od 1450."),
                      FormBuilderValidators.max(DateTime.now().year,
                          errorText: "Godina ne može biti u budućnosti."),
                    ]),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: FormBuilderTextField(
                    name: 'Cijena',
                    decoration: _inputDecoration("Cijena", "Unesite cijenu"),
                    keyboardType: TextInputType.number,
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(
                          errorText: "Cijena je obavezna."),
                      FormBuilderValidators.numeric(
                          errorText: "Cijena mora biti broj."),
                      FormBuilderValidators.min(1,
                          errorText: "Minimalna cijena je 1."),
                      FormBuilderValidators.max(1000,
                          errorText: "Maksimalna cijena je 1000."),
                    ]),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            FormBuilderDropdown(
              name: 'AutorId',
              decoration:
                  _inputDecoration("Autor", "Izaberite autora").copyWith(
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                    floatingLabelBehavior: FloatingLabelBehavior.auto,
              ),
              items: _autori
                  .map((a) => DropdownMenuItem(
                        value: a.autorId,
                        child: Text("${a.ime} ${a.prezime}"),
                      ))
                  .toList(),
              validator: FormBuilderValidators.required(
                  errorText: "Autor je obavezan."),
            ),
            const SizedBox(height: 20),
            FormBuilderField<List<int>>(
              name: 'Zanrovi',
              initialValue: _initialValue['Zanrovi'] as List<int>? ?? [],
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Potrebno je odabrati barem jedan žanr.";
                }
                return null;
              },
              builder: (field) {
                return InputDecorator(
                  decoration:
                      _inputDecoration("Žanrovi", "Izaberite žanrove").copyWith(
                    errorText: field.errorText,
                  ),
                  child: Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: _zanrovi.map((z) {
                      final selected = field.value?.contains(z.zanrId) ?? false;
                      return ChoiceChip(
                        label: Text(z.naziv),
                        selected: selected,
                        onSelected: (bool value) {
                          final current = List<int>.from(field.value ?? []);
                          if (value) {
                            current.add(z.zanrId);
                          } else {
                            current.remove(z.zanrId);
                          }
                          field.didChange(current);
                        },
                      );
                    }).toList(),
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
            FormBuilderField<List<int>>(
              name: 'CiljneGrupe',
              initialValue: _initialValue['CiljneGrupe'] as List<int>? ?? [],
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Potrebno je odabrati barem jednu ciljnu grupu.";
                }
                return null;
              },
              builder: (field) {
                return InputDecorator(
                  decoration:
                      _inputDecoration("Ciljne grupe", "Izaberite ciljne grupe")
                          .copyWith(errorText: field.errorText),
                  child: Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: _ciljneGrupe.map((c) {
                      final selected =
                          field.value?.contains(c.ciljnaGrupaId) ?? false;
                      return ChoiceChip(
                        label: Text(c.naziv),
                        selected: selected,
                        onSelected: (bool value) {
                          final current = List<int>.from(field.value ?? []);
                          if (value) {
                            current.add(c.ciljnaGrupaId);
                          } else {
                            current.remove(c.ciljnaGrupaId);
                          }
                          field.didChange(current);
                        },
                      );
                    }).toList(),
                  ),
                );
              },
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
                          ? Image.memory(base64Decode(_base64Image!),
                              fit: BoxFit.cover)
                          : Image.asset('assets/images/placeholder.png',
                              fit: BoxFit.cover),
                    ),
                  ),
                )
              ],
            )
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
          _buildButton(
            "Odustani",
            const Color.fromARGB(255, 120, 120, 120),
            const Color.fromARGB(255, 150, 150, 150),
            const Color.fromARGB(255, 100, 100, 100),
            () => Navigator.pop(context),
          ),
          const SizedBox(width: 20),
          _buildButton(
            "Sačuvaj",
            const Color(0xFF3C6E71),
            const Color(0xFF51968F),
            const Color(0xFF41706A),
            _save,
          ),
        ],
      ),
    );
  }

  Widget _buildButton(String text, Color normal, Color hover, Color selected,
      VoidCallback onPressed) {
    final bool isSaveButton = text == "Sačuvaj";

    IconData? icon;
    if (text == "Sačuvaj") {
      icon = Icons.check;
    } else if (text == "Odustani") {
      icon = Icons.arrow_back_ios_new;
    }

    return SizedBox(
      width: 140,
      height: 45,
      child: ElevatedButton.icon(
        onPressed: (isSaveButton && _isSaving)
            ? null
            : () {
                if (isSaveButton) {
                  showConfirmDialog(
                    context: context,
                    title:
                        widget.knjiga == null ? "Dodaj knjigu" : "Uredi knjigu",
                    message: widget.knjiga == null
                        ? "Da li ste sigurni da želite dodati ovu knjigu?"
                        : "Da li ste sigurni da želite urediti ovu knjigu?",
                    icon: widget.knjiga == null ? Icons.menu_book : Icons.edit,
                    iconColor: const Color(0xFF3C6E71),
                    onConfirm: onPressed,
                  );
                } else {
                  onPressed();
                }
              },
        icon: (isSaveButton && _isSaving)
            ? const SizedBox.shrink()
            : Icon(icon, color: Colors.white, size: 18),
        label: (isSaveButton && _isSaving)
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            : Text(
                text,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.resolveWith<Color>((states) {
            if (states.contains(WidgetState.pressed) ||
                states.contains(WidgetState.selected)) {
              return selected;
            }
            if (states.contains(WidgetState.hovered)) return hover;
            return normal;
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
    );
  }

  Future<void> _save() async {
    final isValid = _formKey.currentState?.saveAndValidate();
    if (isValid != true) return;

    final data = Map<String, dynamic>.from(_formKey.currentState!.value);

    data['GodinaIzdavanja'] = int.tryParse(data['GodinaIzdavanja']);
    data['Cijena'] = double.tryParse(data['Cijena']);
    data['Slika'] = _base64Image;

    if (!mounted) return;

    setState(() => _isSaving = true);

    try {
      if (widget.knjiga == null) {
        await _knjigaProvider.insert(data);
        if (!mounted) return;
        await showCustomDialog(
          context: context,
          title: "Uspjeh",
          message: "Knjiga je uspješno dodana.",
          icon: Icons.check_circle,
          iconColor: Colors.green,
        );
      } else {
        await _knjigaProvider.update(
          widget.knjiga!.knjigaId!,
          data,
        );
        if (!mounted) return;
        await showCustomDialog(
          context: context,
          title: "Uspjeh",
          message: "Knjiga je uspješno uređena.",
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
