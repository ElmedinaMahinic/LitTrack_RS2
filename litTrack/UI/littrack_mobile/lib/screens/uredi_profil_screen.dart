import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:provider/provider.dart';
import 'package:littrack_mobile/providers/korisnik_provider.dart';
import 'package:littrack_mobile/providers/auth_provider.dart';
import 'package:littrack_mobile/providers/utils.dart';
import 'package:littrack_mobile/main.dart';

class UrediProfilScreen extends StatefulWidget {
  const UrediProfilScreen({super.key});

  @override
  State<UrediProfilScreen> createState() => _UrediProfilScreenState();
}

class _UrediProfilScreenState extends State<UrediProfilScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  late KorisnikProvider _provider;
  bool _isLoading = true;
  bool _promijeniLozinku = false;
  bool _isOldPasswordHidden = true;
  bool _isNewPasswordHidden = true;
  bool _isConfirmPasswordHidden = true;

  Map<String, dynamic> _initialValue = {};

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
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F4F3),
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        centerTitle: false,
        toolbarHeight: kToolbarHeight + 25,
        backgroundColor: const Color(0xFFF6F4F3),
        title: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(top: 6.0, left: 8, right: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Colors.black,
                    size: 35,
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
                Row(
                  children: [
                    Image.asset(
                      "assets/images/logo.png",
                      height: 45,
                      width: 45,
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      "LitTrack",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                        fontSize: 28,
                      ),
                    ),
                  ],
                ),
                IconButton(
                  icon: const Icon(
                    Icons.shopping_cart,
                    color: Colors.black,
                    size: 35,
                  ),
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      _buildHeader(),
                      const SizedBox(height: 28),
                      _buildForm(),
                      const SizedBox(height: 28),
                      _buildActionButtons(),
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  InputDecoration _decoration(String label, String hint) {
    return InputDecoration(
      isDense: true,
      contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
      labelText: label,
      hintText: hint,
      floatingLabelBehavior: FloatingLabelBehavior.always,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      filled: true,
      fillColor: Colors.white,
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 22, horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF3C6E71),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: const Center(
        child: Text(
          "Uredi korisnički profil",
          style: TextStyle(
            color: Colors.white,
            fontSize: 19,
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _buildForm() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: FormBuilder(
        key: _formKey,
        initialValue: _initialValue,
        child: Column(
          children: [
            FormBuilderTextField(
              name: 'ime',
              decoration: _decoration('Ime', 'Unesite ime'),
              validator: FormBuilderValidators.compose([
                FormBuilderValidators.required(errorText: "Ime je obavezno."),
                FormBuilderValidators.maxLength(50,
                    errorText: "Maksimalno 50 karaktera."),
                FormBuilderValidators.match(
                  r'^[A-ZČĆŽĐŠ][a-zA-ZčćžđšČĆŽĐŠ\s]*$',
                  errorText:
                      "Ime mora početi velikim slovom i sadržavati samo slova.",
                ),
              ]),
            ),
            const SizedBox(height: 15),
            FormBuilderTextField(
              name: 'prezime',
              decoration: _decoration('Prezime', 'Unesite prezime'),
              validator: FormBuilderValidators.compose([
                FormBuilderValidators.required(
                    errorText: "Prezime je obavezno."),
                FormBuilderValidators.maxLength(50,
                    errorText: "Maksimalno 50 karaktera."),
                FormBuilderValidators.match(
                  r'^[A-ZČĆŽĐŠ][a-zA-ZčćžđšČĆŽĐŠ\s]*$',
                  errorText:
                      "Prezime mora početi velikim slovom i sadržavati samo slova.",
                ),
              ]),
            ),
            const SizedBox(height: 15),
            FormBuilderTextField(
              name: 'email',
              decoration: _decoration('Email', 'Unesite email'),
              validator: FormBuilderValidators.compose([
                FormBuilderValidators.required(errorText: "Email je obavezan."),
                FormBuilderValidators.email(
                    errorText: 'Neispravan format emaila.'),
                FormBuilderValidators.maxLength(100,
                    errorText: 'Maksimalno 100 karaktera.'),
              ]),
            ),
            const SizedBox(height: 15),
            FormBuilderTextField(
              name: 'telefon',
              decoration:
                  _decoration('Telefon', 'Unesite telefon (npr. +387...)'),
              validator: FormBuilderValidators.compose([
                FormBuilderValidators.required(
                    errorText: "Telefon je obavezan."),
                FormBuilderValidators.match(
                  r'^\+\d{7,15}$',
                  errorText: 'Telefon mora početi sa + i imati 7-15 cifara.',
                ),
              ]),
            ),
            const SizedBox(height: 15),
            FormBuilderCheckbox(
              name: 'promijeniLozinku',
              title: const Text(
                'Promijeni lozinku',
                style: TextStyle(fontSize: 15),
              ),
              onChanged: (val) {
                setState(() {
                  _promijeniLozinku = val ?? false;
                });
              },
            ),
            if (_promijeniLozinku) ...[
              const SizedBox(height: 15),
              FormBuilderTextField(
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
              const SizedBox(height: 15),
              FormBuilderTextField(
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
              const SizedBox(height: 15),
              FormBuilderTextField(
                name: 'lozinkaPotvrda',
                obscureText: _isConfirmPasswordHidden,
                decoration: _decoration('Potvrda lozinke', '').copyWith(
                  suffixIcon: IconButton(
                    icon: Icon(_isConfirmPasswordHidden
                        ? Icons.visibility_off
                        : Icons.visibility),
                    onPressed: () {
                      setState(() {
                        _isConfirmPasswordHidden = !_isConfirmPasswordHidden;
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
            ]
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    final buttonStyle = ButtonStyle(
      backgroundColor: MaterialStateProperty.resolveWith<Color>((states) {
        if (states.contains(MaterialState.pressed)) {
          return const Color(0xFF33585B);
        }
        return const Color(0xFF3C6E71);
      }),
      shape: MaterialStateProperty.all(
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
      ),
      shadowColor: MaterialStateProperty.all(Colors.black.withOpacity(0.15)),
      elevation: MaterialStateProperty.all(6),
    );

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 220,
            height: 48,
            child: ElevatedButton.icon(
              onPressed: () {
                showConfirmDialog(
                  context: context,
                  title: "Uređivanje profila",
                  message: "Da li ste sigurni da želite sačuvati izmjene?",
                  icon: Icons.edit,
                  iconColor: const Color(0xFF3C6E71),
                  onConfirm: _save,
                );
              },
              icon: const Icon(Icons.check, color: Colors.white),
              label: const Text(
                "Sačuvaj",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: buttonStyle,
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: 220,
            height: 48,
            child: ElevatedButton.icon(
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

                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) => const MyApp()),
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
                    }
                  },
                );
              },
              icon: const Icon(Icons.block, color: Colors.white),
              label: const Text(
                "Deaktiviraj profil",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: buttonStyle,
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

      if (!mounted) return;

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
    }
  }
}
