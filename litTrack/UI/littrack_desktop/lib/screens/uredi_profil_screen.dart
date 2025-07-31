import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:provider/provider.dart';
import 'package:littrack_desktop/layouts/master_screen.dart';
import 'package:littrack_desktop/providers/korisnik_provider.dart';
import 'package:littrack_desktop/providers/auth_provider.dart';
import 'package:littrack_desktop/providers/utils.dart';
import 'package:littrack_desktop/main.dart';

class UrediKorisnikProfilScreen extends StatefulWidget {
  const UrediKorisnikProfilScreen({super.key});

  @override
  State<UrediKorisnikProfilScreen> createState() =>
      _UrediKorisnikProfilScreenState();
}

class _UrediKorisnikProfilScreenState extends State<UrediKorisnikProfilScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  late KorisnikProvider _provider;
  bool _promijeniLozinku = false;
  bool _isOldPasswordHidden = true;
  bool _isNewPasswordHidden = true;
  bool _isConfirmPasswordHidden = true;

  Map<String, dynamic> _initialValue = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _provider = context.read<KorisnikProvider>();
    _loadKorisnik();
  }

  Future<void> _loadKorisnik() async {
    try {
      final korisnik = await _provider.getById(AuthProvider.korisnikId!);
      _initialValue = {
        'ime': korisnik.ime ?? '',
        'prezime': korisnik.prezime ?? '',
        'email': korisnik.email ?? '',
        'telefon': korisnik.telefon ?? '',
        'jeAktivan': korisnik.jeAktivan ?? true,
        'promijeniLozinku': false,
      };
    } catch (e) {
      await showCustomDialog(
        context: context,
        title: 'Greška',
        message: 'Neuspješno učitavanje podataka o korisniku.',
        icon: Icons.error,
        iconColor: Colors.red,
      );
      Navigator.pop(context);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreen(
      title: "Uredi profil",
      child: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildForm(),
                const SizedBox(height: 30),
                _buildActionButtons(),
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

  Widget _buildForm() {
    return Padding(
      padding: const EdgeInsets.all(25),
      child: FormBuilder(
        key: _formKey,
        initialValue: _initialValue,
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
                        r'^[A-ZČĆŽĐŠ][a-zA-ZčćžđšČĆŽĐŠ\s]*$',
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
                        r'^[A-ZČĆŽĐŠ][a-zA-ZčćžđšČĆŽĐŠ\s]*$',
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
                          errorText: 'Neispravan format emaila.'),
                      FormBuilderValidators.maxLength(100,
                          errorText: 'Maksimalno 100 karaktera.'),
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
                        r'^\+\d{7,15}$',
                        errorText:
                            'Telefon mora početi sa + i imati 7-15 cifara.',
                      ),
                      FormBuilderValidators.maxLength(20,
                          errorText: 'Maksimalno 20 karaktera.'),
                    ]),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            FormBuilderCheckbox(
              name: 'promijeniLozinku',
              title: const Text('Promijeni lozinku',
                  style: TextStyle(fontSize: 16)),
              onChanged: (val) {
                setState(() {
                  _promijeniLozinku = val ?? false;
                });
              },
            ),
            if (_promijeniLozinku) ...[
              const SizedBox(height: 15),
              Row(
                children: [
                  Expanded(
                    child: FormBuilderTextField(
                      name: 'staraLozinka',
                      obscureText: _isOldPasswordHidden,
                      decoration: _decoration('Stara lozinka', '').copyWith(
                        suffixIcon: IconButton(
                          icon: Icon(_isOldPasswordHidden
                              ? Icons.visibility_off
                              : Icons.visibility),
                          onPressed: () {
                            setState(() {
                              _isOldPasswordHidden = !_isOldPasswordHidden;
                            });
                          },
                        ),
                      ),
                      validator: FormBuilderValidators.required(
                          errorText: 'Stara lozinka je obavezna.'),
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: FormBuilderTextField(
                      name: 'lozinka',
                      obscureText: _isNewPasswordHidden,
                      decoration: _decoration('Nova lozinka', '').copyWith(
                        suffixIcon: IconButton(
                          icon: Icon(_isNewPasswordHidden
                              ? Icons.visibility_off
                              : Icons.visibility),
                          onPressed: () {
                            setState(() {
                              _isNewPasswordHidden = !_isNewPasswordHidden;
                            });
                          },
                        ),
                      ),
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(
                            errorText: 'Nova lozinka je obavezna.'),
                        FormBuilderValidators.minLength(6,
                            errorText: 'Najmanje 6 karaktera.'),
                      ]),
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: FormBuilderTextField(
                      name: 'lozinkaPotvrda',
                      obscureText: _isConfirmPasswordHidden,
                      decoration: _decoration('Potvrda lozinke', '').copyWith(
                        suffixIcon: IconButton(
                          icon: Icon(_isConfirmPasswordHidden
                              ? Icons.visibility_off
                              : Icons.visibility),
                          onPressed: () {
                            setState(() {
                              _isConfirmPasswordHidden =
                                  !_isConfirmPasswordHidden;
                            });
                          },
                        ),
                      ),
                      validator: (val) {
                        final lozinka =
                            _formKey.currentState?.fields['lozinka']?.value;
                        if (val == null || val.isEmpty) {
                          return 'Potvrda je obavezna.';
                        }
                        if (val != lozinka) {
                          return 'Lozinke se ne podudaraju.';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
            ]
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: Row(
        children: [
          SizedBox(
            width: 220,
            height: 45,
            child: ElevatedButton(
              onPressed: () {
                showConfirmDialog(
                  context: context,
                  title: "Deaktivacija profila",
                  message:
                      "Da li ste sigurni da želite deaktivirati svoj profil?",
                  icon: Icons.warning,
                  iconColor: Colors.red,
                  onConfirm: () async {
                    try {
                      await _provider.deaktiviraj(AuthProvider.korisnikId!);

                      await showCustomDialog(
                        context: context,
                        title: "Uspjeh",
                        message: "Profil je uspješno deaktiviran.",
                        icon: Icons.check_circle,
                        iconColor: Colors.green,
                      );

                      AuthProvider.username = null;
                      AuthProvider.password = null;
                      AuthProvider.korisnikId = null;
                      AuthProvider.ime = null;
                      AuthProvider.prezime = null;
                      AuthProvider.email = null;
                      AuthProvider.telefon = null;
                      AuthProvider.uloge = null;
                      AuthProvider.isSignedIn = false;

                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) => const MyApp()),
                      );
                    } catch (e) {
                      showCustomDialog(
                        context: context,
                        title: "Greška",
                        message: e.toString(),
                        icon: Icons.error,
                        iconColor: Colors.red,
                      );
                    }
                  },
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF3C6E71),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                "Deaktiviraj profil",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600),
              ),
            ),
          ),
          const Spacer(),
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
                  title: "Uređivanje profila",
                  message: "Da li ste sigurni da želite sačuvati izmjene?",
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

    final formValues = Map<String, dynamic>.from(_formKey.currentState!.value);
    final request = {
      'ime': formValues['ime'],
      'prezime': formValues['prezime'],
      'email': formValues['email'],
      'telefon': formValues['telefon'],
    };

    if (_promijeniLozinku) {
      request['staraLozinka'] = formValues['staraLozinka'];
      request['lozinka'] = formValues['lozinka'];
      request['lozinkaPotvrda'] = formValues['lozinkaPotvrda'];
    }

    try {
      await _provider.update(AuthProvider.korisnikId!, request);

      if (_promijeniLozinku &&
          formValues['lozinka'] != null &&
          formValues['lozinka'] != '') {
        AuthProvider.password = formValues['lozinka'];
      }

      await showCustomDialog(
        context: context,
        title: "Uspjeh",
        message: "Profil uspješno ažuriran.",
        icon: Icons.check_circle,
        iconColor: Colors.green,
      );

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
