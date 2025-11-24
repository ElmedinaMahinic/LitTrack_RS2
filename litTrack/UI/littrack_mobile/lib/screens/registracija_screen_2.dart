import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:provider/provider.dart';
import 'package:littrack_mobile/providers/korisnik_provider.dart';
import 'package:littrack_mobile/providers/uloga_provider.dart';
import 'package:littrack_mobile/providers/utils.dart';
import 'package:littrack_mobile/screens/login_screen.dart';

class RegistracijaScreen2 extends StatefulWidget {
  const RegistracijaScreen2({super.key});

  @override
  State<RegistracijaScreen2> createState() => _RegistracijaScreen2State();
}

class _RegistracijaScreen2State extends State<RegistracijaScreen2> {
  final _formKey = GlobalKey<FormBuilderState>();
  late KorisnikProvider _korisnikProvider;
  late UlogaProvider _ulogaProvider;

  int? _korisnikUlogaId;
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _isHidden = true;
  bool _isHiddenConfirm = true;

  @override
  void initState() {
    super.initState();
    _korisnikProvider = context.read<KorisnikProvider>();
    _ulogaProvider = context.read<UlogaProvider>();
    _loadKorisnikUloga();
  }

  Future<void> _loadKorisnikUloga() async {
    try {
      final result = await _ulogaProvider.get();
      final korisnikUloga =
          result.resultList.firstWhere((x) => x.naziv == "Korisnik");
      if (!mounted) return;
      setState(() {
        _korisnikUlogaId = korisnikUloga.ulogaId;
      });
    } catch (e) {
      if (!mounted) return;
      await showCustomDialog(
        context: context,
        title: 'Greška',
        message: 'Neuspješno učitavanje uloge Korisnik.',
        icon: Icons.error,
        iconColor: Colors.red,
      );
      if (!mounted) return;
      Navigator.pop(context);
    }
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F4F3),
      body: SafeArea(
        child: _korisnikUlogaId == null
            ? const Center(child: CircularProgressIndicator())
            : Stack(
                children: [
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Image.asset(
                      'assets/images/login_bottom.png',
                      width: 150,
                    ),
                  ),
                  SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
                    child: FormBuilder(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.arrow_back),
                            onPressed: () => Navigator.pop(context),
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            "Kreirajmo vaš račun!",
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF344743)),
                          ),
                          const SizedBox(height: 20),
                          Center(
                            child: Image.asset(
                              'assets/images/registracija_middle_mobile.png',
                              height: 180,
                            ),
                          ),
                          const SizedBox(height: 17),
                          const Text(
                            "Unesite vaše podatke:",
                            style: TextStyle(fontSize: 17),
                          ),
                          const SizedBox(height: 17),
                          FormBuilderTextField(
                            name: 'ime',
                            decoration: _decoration('Ime', 'Unesite ime'),
                            validator: FormBuilderValidators.compose([
                              FormBuilderValidators.required(
                                  errorText: "Ime je obavezno."),
                              FormBuilderValidators.minLength(1,
                                  errorText: "Ime ne može biti prazno."),
                              FormBuilderValidators.maxLength(50,
                                  errorText:
                                      "Ime može imati najviše 50 karaktera."),
                              FormBuilderValidators.match(
                                r'^[A-ZČĆŽĐŠ][a-zA-ZčćžđšČĆŽĐŠ\s]*$',
                                errorText:
                                    "Ime mora početi velikim slovom i sadržavati samo slova.",
                              ),
                            ]),
                          ),
                          const SizedBox(height: 12),
                          FormBuilderTextField(
                            name: 'prezime',
                            decoration:
                                _decoration('Prezime', 'Unesite prezime'),
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
                          const SizedBox(height: 12),
                          FormBuilderTextField(
                            name: "korisnickoIme",
                            decoration: _decoration(
                                'Korisničko ime', 'Unesite korisničko ime'),
                            validator: FormBuilderValidators.compose([
                              FormBuilderValidators.required(
                                  errorText: "Korisničko ime je obavezno."),
                              FormBuilderValidators.minLength(4,
                                  errorText: "Minimalno 4 karaktera."),
                              FormBuilderValidators.maxLength(30,
                                  errorText: "Maksimalno 30 karaktera."),
                            ]),
                          ),
                          const SizedBox(height: 16),
                          const Divider(thickness: 1, color: Colors.grey),
                          const SizedBox(height: 16),
                          FormBuilderTextField(
                            name: "email",
                            decoration:
                                _decoration('Email', 'Unesite email adresu'),
                            validator: FormBuilderValidators.compose([
                              FormBuilderValidators.required(
                                  errorText: "Email je obavezan."),
                              FormBuilderValidators.email(
                                  errorText: 'Neispravan email.'),
                              FormBuilderValidators.maxLength(100,
                                  errorText:
                                      "Email može imati najviše 100 karaktera."),
                            ]),
                          ),
                          const SizedBox(height: 12),
                          FormBuilderTextField(
                            name: "telefon",
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
                                  errorText:
                                      "Telefon može imati najviše 20 karaktera."),
                            ]),
                          ),
                          const SizedBox(height: 16),
                          const Divider(thickness: 1, color: Colors.grey),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _passwordController,
                            obscureText: _isHidden,
                            decoration: InputDecoration(
                              isDense: true,
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 12, horizontal: 12),
                              labelText: "Lozinka",
                              hintText: "Unesite lozinku",
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              filled: true,
                              fillColor: Colors.white,
                              suffixIcon: IconButton(
                                icon: Icon(_isHidden
                                    ? Icons.visibility_off
                                    : Icons.visibility),
                                onPressed: () {
                                  setState(() {
                                    _isHidden = !_isHidden;
                                  });
                                },
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Unesite lozinku';
                              }
                              if (value.length < 6) {
                                return 'Lozinka mora imati minimalno 6 karaktera';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 12),
                          TextFormField(
                            controller: _confirmPasswordController,
                            obscureText: _isHiddenConfirm,
                            decoration: InputDecoration(
                              isDense: true,
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 12, horizontal: 12),
                              labelText: "Potvrdi lozinku",
                              hintText: "Ponovo unesite lozinku",
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              filled: true,
                              fillColor: Colors.white,
                              suffixIcon: IconButton(
                                icon: Icon(_isHiddenConfirm
                                    ? Icons.visibility_off
                                    : Icons.visibility),
                                onPressed: () {
                                  setState(() {
                                    _isHiddenConfirm = !_isHiddenConfirm;
                                  });
                                },
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Potvrdite lozinku';
                              }
                              if (value != _passwordController.text) {
                                return 'Lozinke se ne podudaraju';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 25),
                          SizedBox(
                            width: double.infinity,
                            height: 45,
                            child: ElevatedButton.icon(
                              onPressed: () {
                                showConfirmDialog(
                                  context: context,
                                  title: "Registracija",
                                  message:
                                      "Da li ste sigurni da želite kreirati račun?",
                                  icon: Icons.person_add,
                                  iconColor: const Color(0xFF3C6E71),
                                  onConfirm: _save,
                                );
                              },
                              icon: const Icon(Icons.check,
                                  color: Colors.white, size: 20),
                              label: const Text(
                                "KREIRAJTE RAČUN",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.resolveWith<Color>(
                                        (states) {
                                  if (states.contains(MaterialState.pressed)) {
                                    return const Color(0xFF2E5A58);
                                  }
                                  return const Color(0xFF3C6E71);
                                }),
                                foregroundColor:
                                    MaterialStateProperty.all(Colors.white),
                                shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                ),
                                elevation: MaterialStateProperty.all(6),
                                shadowColor: MaterialStateProperty.all(
                                    Colors.black.withOpacity(0.3)),
                                padding: MaterialStateProperty.all(
                                  const EdgeInsets.symmetric(horizontal: 16),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 15),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                "Imate račun?",
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(width: 5),
                              GestureDetector(
                                onTap: () {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const LoginScreen(),
                                    ),
                                  );
                                },
                                child: const Text(
                                  "Prijavite se!",
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Color(0xFF43675E),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 60),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Future<void> _save() async {
    final isValid = _formKey.currentState?.saveAndValidate() ?? false;
    if (!isValid) return;

    final formValues = Map<String, dynamic>.from(_formKey.currentState!.value);

    final request = {
      'ime': formValues['ime'],
      'prezime': formValues['prezime'],
      'korisnickoIme': formValues['korisnickoIme'],
      'email': formValues['email'],
      'telefon': formValues['telefon'],
      'lozinka': _passwordController.text,
      'lozinkaPotvrda': _confirmPasswordController.text,
      'uloge': [_korisnikUlogaId],
    };

    try {
      await _korisnikProvider.insert(request);
      if (!mounted) return;

      await showCustomDialog(
        context: context,
        title: "Uspjeh",
        message: "Račun je uspješno kreiran. Prijavite se.",
        icon: Icons.check_circle,
        iconColor: Colors.green,
      );
      if (!mounted) return;

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const LoginScreen(),
        ),
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
    }
  }
}
