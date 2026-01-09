import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:provider/provider.dart';
import 'package:littrack_desktop/layouts/master_screen.dart';
import 'package:littrack_desktop/providers/korisnik_provider.dart';
import 'package:littrack_desktop/providers/uloga_provider.dart';
import 'package:littrack_desktop/providers/report_provider.dart';
import 'package:littrack_desktop/providers/utils.dart';
import 'package:littrack_desktop/models/korisnik.dart';
import 'package:file_selector/file_selector.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';

class AdminDodajRadnikaScreen extends StatefulWidget {
  const AdminDodajRadnikaScreen({super.key});

  @override
  State<AdminDodajRadnikaScreen> createState() =>
      _AdminDodajRadnikaScreenState();
}

class _AdminDodajRadnikaScreenState extends State<AdminDodajRadnikaScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  late KorisnikProvider _korisnikProvider;
  late UlogaProvider _ulogaProvider;
  late ReportProvider _reportProvider;
  int? _radnikUlogaId;
  String? _generisanaLozinka;
  final TextEditingController _lozinkaController = TextEditingController();
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _korisnikProvider = context.read<KorisnikProvider>();
    _ulogaProvider = context.read<UlogaProvider>();
    _reportProvider = context.read<ReportProvider>();
    _loadRadnikUloga();
  }

  Future<void> _loadRadnikUloga() async {
    try {
      final result = await _ulogaProvider.get();
      final radnikUloga =
          result.resultList.firstWhere((x) => x.naziv == "Radnik");
      if (!mounted) return;
      setState(() {
        _radnikUlogaId = radnikUloga.ulogaId;
      });
    } catch (e) {
      if (!mounted) return;
      await showCustomDialog(
        context: context,
        title: 'Greška',
        message: 'Neuspješno učitavanje uloge Radnik.',
        icon: Icons.error,
        iconColor: Colors.red,
      );
      if (!mounted) return;
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreen(
      title: "Dodaj radnika",
      child: _radnikUlogaId == null
          ? const Center(child: CircularProgressIndicator())
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildForm(),
                const SizedBox(height: 30),
                _buildActionButtons(context),
              ],
            ),
    );
  }

  InputDecoration _decoration(String label, String hint) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      floatingLabelBehavior: FloatingLabelBehavior.always,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      filled: true,
      fillColor: Colors.white,
    );
  }

  String generateRandomPassword(int length) {
    const chars =
        'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
    return List.generate(
        length, (index) => chars[Random().nextInt(chars.length)]).join();
  }

  Widget _buildForm() {
    return Padding(
      padding: const EdgeInsets.all(25),
      child: FormBuilder(
        key: _formKey,
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: FormBuilderTextField(
                    name: 'ime',
                    decoration: _decoration('Ime', 'Unesite ime'),
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(
                          errorText: "Ime je obavezno."),
                      FormBuilderValidators.minLength(1,
                          errorText: "Ime ne može biti prazno."),
                      FormBuilderValidators.maxLength(50,
                          errorText: "Ime može imati najviše 50 karaktera."),
                      FormBuilderValidators.match(
                        RegExp(r'^[A-ZČĆŽĐŠ][a-zA-ZčćžđšČĆŽĐŠ\s]*$'),
                        errorText:
                            "Ime mora početi velikim slovom i sadržavati samo slova.",
                      ),
                    ]),
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: FormBuilderTextField(
                    name: 'prezime',
                    decoration: _decoration('Prezime', 'Unesite prezime'),
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(
                          errorText: "Prezime je obavezno."),
                      FormBuilderValidators.minLength(1,
                          errorText: "Prezime ne može biti prazno."),
                      FormBuilderValidators.maxLength(50,
                          errorText:
                              "Prezime može imati najviše 50 karaktera."),
                      FormBuilderValidators.match(
                        RegExp(r'^[A-ZČĆŽĐŠ][a-zA-ZčćžđšČĆŽĐŠ\s]*$'),
                        errorText:
                            "Prezime mora početi velikim slovom i sadržavati samo slova.",
                      ),
                    ]),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            Row(
              children: [
                Expanded(
                  child: FormBuilderTextField(
                    name: 'email',
                    decoration: _decoration('Email', 'Unesite email'),
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(
                          errorText: "Email je obavezan."),
                      FormBuilderValidators.email(
                          errorText: 'Neispravan email.'),
                      FormBuilderValidators.maxLength(100,
                          errorText: "Email može imati najviše 100 karaktera."),
                    ]),
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: FormBuilderTextField(
                    name: 'telefon',
                    decoration: _decoration(
                        'Telefon', 'Unesite telefon (npr. +387...)'),
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(
                          errorText: "Telefon je obavezan."),
                      FormBuilderValidators.match(
                        RegExp(r'^\+\d{7,15}$'),
                        errorText:
                            'Telefon mora početi sa + i imati 7-15 cifara.',
                      ),
                      FormBuilderValidators.maxLength(20,
                          errorText:
                              "Telefon može imati najviše 20 karaktera."),
                    ]),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            FormBuilderTextField(
              name: 'korisnickoIme',
              inputFormatters: [
                FilteringTextInputFormatter.deny(RegExp(r'\s')),
              ],
              decoration:
                  _decoration('Korisničko ime', 'Unesite korisničko ime'),
              validator: FormBuilderValidators.compose([
                FormBuilderValidators.required(
                    errorText: "Korisničko ime je obavezno."),
                FormBuilderValidators.minLength(4,
                    errorText: "Minimalno 4 karaktera."),
                FormBuilderValidators.maxLength(30,
                    errorText: "Maksimalno 30 karaktera."),
                (val) {
                  if (val != null && val.contains(' ')) {
                    return 'Korisničko ime ne smije sadržavati razmake.';
                  }

                  return null;
                },
              ]),
            ),
            const SizedBox(height: 15),
            TextFormField(
              enabled: false,
              initialValue: "Radnik",
              style: const TextStyle(color: Colors.grey),
              decoration: _decoration("Uloga", "").copyWith(
                labelStyle: const TextStyle(color: Colors.grey),
                hintStyle: const TextStyle(color: Colors.grey),
                disabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey.shade600),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 15),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    enabled: false,
                    controller: _lozinkaController,
                    style: const TextStyle(color: Colors.grey),
                    decoration:
                        _decoration("Lozinka", "Generiši lozinku").copyWith(
                      labelStyle: const TextStyle(color: Colors.grey),
                      hintStyle: const TextStyle(color: Colors.grey),
                      disabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey.shade600),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.refresh),
                  tooltip: "Generiši lozinku",
                  onPressed: () {
                    final novaLozinka = generateRandomPassword(10);
                    setState(() {
                      _generisanaLozinka = novaLozinka;
                      _lozinkaController.text = "Lozinka uspješno generisana!";
                    });
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
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
              style: _buttonStyle(
                const Color.fromARGB(255, 120, 120, 120),
                const Color.fromARGB(255, 150, 150, 150),
                const Color.fromARGB(255, 100, 100, 100),
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
                        title: "Dodavanje radnika",
                        message: "Da li ste sigurni da želite dodati radnika?",
                        icon: Icons.person_add,
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
              style: _buttonStyle(
                const Color(0xFF3C6E71),
                const Color(0xFF51968F),
                const Color(0xFF41706A),
              ),
            ),
          ),
        ],
      ),
    );
  }

  ButtonStyle _buttonStyle(Color normal, Color hover, Color selected) {
    return ButtonStyle(
      backgroundColor: WidgetStateProperty.resolveWith<Color>((states) {
        if (states.contains(WidgetState.pressed) ||
            states.contains(WidgetState.selected)) {
          return selected;
        }
        if (states.contains(WidgetState.hovered)) return hover;
        return normal;
      }),
      shape: WidgetStateProperty.all(
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      elevation: WidgetStateProperty.all(4),
      padding: WidgetStateProperty.all(
        const EdgeInsets.symmetric(horizontal: 16),
      ),
      shadowColor: WidgetStateProperty.all(Colors.black54),
    );
  }

  Future<void> _save() async {
    final isValid = _formKey.currentState?.saveAndValidate() ?? false;
    if (!isValid) return;

    if (_generisanaLozinka == null || _generisanaLozinka!.isEmpty) {
      await showCustomDialog(
        context: context,
        title: "Greška",
        message: "Molimo prvo generišite lozinku.",
        icon: Icons.error,
        iconColor: Colors.red,
      );
      return;
    }

    if (!mounted) return;

    setState(() => _isSaving = true);

    try {
      final formValues =
          Map<String, dynamic>.from(_formKey.currentState!.value);

      final request = {
        'ime': formValues['ime'],
        'prezime': formValues['prezime'],
        'korisnickoIme': formValues['korisnickoIme'],
        'email': formValues['email'],
        'telefon': formValues['telefon'],
        'lozinka': _generisanaLozinka!,
        'lozinkaPotvrda': _generisanaLozinka!,
        'uloge': [_radnikUlogaId],
      };

      final Korisnik noviRadnik = await _korisnikProvider.insert(request);
      final int radnikId = noviRadnik.korisnikId ?? 0;
      if (!mounted) return;

      await showCustomDialog(
        context: context,
        title: "Uspjeh",
        message: "Radnik je uspješno dodan.",
        icon: Icons.check_circle,
        iconColor: Colors.green,
      );

      if (!mounted) return;

      await showConfirmDialog(
        context: context,
        title: "Generisanje PDF-a",
        message: "Želite li generisati PDF sa podacima o radniku?",
        icon: Icons.picture_as_pdf,
        iconColor: Colors.redAccent,
        onConfirm: () async {
          await createPdfFile({
            'id': radnikId,
            'lozinka': _generisanaLozinka!,
          });
        },
      );
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
      if (mounted) setState(() => _isSaving = false);
    }
  }

  Future<void> createPdfFile(Map<String, dynamic> radnikData) async {
    try {
      final bytes = await _reportProvider.getRadnikKreiranPdf(
        radnikId: radnikData['id'] ?? 0,
        plainPassword: radnikData['lozinka'] ?? '',
      );

      if (bytes.isEmpty) return;

      final name =
          'Radnik_${radnikData['id']}_${DateFormat('ddMMyyyy_HHmm').format(DateTime.now().toLocal())}.pdf';

      final location = await getSaveLocation(
        suggestedName: name,
        acceptedTypeGroups: [
          const XTypeGroup(label: 'PDF', extensions: ['pdf']),
        ],
      );

      if (location == null) return;

      final pdfBytes = Uint8List.fromList(bytes);

      final file = XFile.fromData(
        pdfBytes,
        name: name,
        mimeType: 'application/pdf',
      );

      await file.saveTo(location.path);

      if (!mounted) return;

      await showCustomDialog(
        context: context,
        title: "Uspjeh",
        message:
            "PDF izvještaj je uspješno sačuvan.\nLokacija: ${location.path}",
        icon: Icons.check_circle_outline,
        iconColor: Colors.green,
      );

      if (!mounted) return;
      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;
      await showCustomDialog(
        context: context,
        title: "Greška",
        message: "Došlo je do greške pri generisanju PDF-a:\n$e",
        icon: Icons.error,
        iconColor: Colors.red,
      );
    }
  }
}
