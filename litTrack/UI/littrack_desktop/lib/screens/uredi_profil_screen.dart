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
  bool _isSaving = false;
  bool _isDeactivating = false;

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
      if (!mounted) return;
      await showCustomDialog(
        context: context,
        title: 'Greška',
        message: 'Neuspješno učitavanje podataka o korisniku.',
        icon: Icons.error,
        iconColor: Colors.red,
      );
      if (!mounted) return;
      Navigator.pop(context);
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
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
                        RegExp(r'^\+\d{7,15}$'),
                        errorText:
                            'Telefon mora početi sa + i imati 7-15 cifara.',
                      ),
                      FormBuilderValidators.maxLength(20,
                          errorText:
                              'Telefon može imati najviše 20 karaktera.'),
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
            child: ElevatedButton.icon(
              onPressed: _isDeactivating
                  ? null
                  : () {
                      showConfirmDialog(
                        context: context,
                        title: "Deaktivacija profila",
                        message:
                            "Da li ste sigurni da želite deaktivirati svoj profil?",
                        icon: Icons.warning,
                        iconColor: Colors.red,
                        onConfirm: _deactivateProfile,
                      );
                    },
              icon: _isDeactivating
                  ? const SizedBox.shrink()
                  : const Icon(Icons.block, color: Colors.white, size: 20),
              label: _isDeactivating
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : const Text(
                      "Deaktiviraj profil",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
              style: _buttonStyle(
                Colors.redAccent,
                Colors.red.shade300,
                selected: Colors.red.shade700,
              ),
            ),
          ),
          const Spacer(),
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
                const Color.fromARGB(255, 100, 100, 100),
                const Color.fromARGB(255, 150, 150, 150),
                selected: const Color.fromARGB(255, 100, 100, 100),
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
                        title: "Uređivanje profila",
                        message:
                            "Da li ste sigurni da želite sačuvati izmjene?",
                        icon: Icons.edit,
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
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
              style: _buttonStyle(
                const Color(0xFF3C6E71),
                const Color(0xFF51968F),
                selected: const Color(0xFF41706A),
              ),
            ),
          ),
        ],
      ),
    );
  }

  ButtonStyle _buttonStyle(Color normal, Color hover, {Color? selected}) {
    return ButtonStyle(
      backgroundColor: WidgetStateProperty.resolveWith<Color>((states) {
        if (states.contains(WidgetState.pressed) ||
            states.contains(WidgetState.selected)) {
          return selected ?? normal;
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

  Future<void> _deactivateProfile() async {
    if (!mounted) return;
    setState(() => _isDeactivating = true);

    try {
      await _provider.deaktiviraj(AuthProvider.korisnikId!);
      if (!mounted) return;

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

      if (!mounted) return;

      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const MyApp()),
        (route) => false,
      );
    } catch (e) {
      if (!mounted) return;
      showCustomDialog(
        context: context,
        title: "Greška",
        message: e.toString(),
        icon: Icons.error,
        iconColor: Colors.red,
      );
    } finally {
      if (mounted) setState(() => _isDeactivating = false);
    }
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

    if (!mounted) return;
    setState(() => _isSaving = true);

    try {
      await _provider.update(AuthProvider.korisnikId!, request);
      if (!mounted) return;

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
      if (mounted) setState(() => _isSaving = false);
    }
  }
}
