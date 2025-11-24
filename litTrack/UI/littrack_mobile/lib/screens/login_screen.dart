import 'package:flutter/material.dart';
import 'package:littrack_mobile/providers/auth_provider.dart';
import 'package:littrack_mobile/providers/korisnik_provider.dart';
import 'package:littrack_mobile/providers/utils.dart';
import 'package:littrack_mobile/screens/registracija_screen_1.dart';
import 'package:littrack_mobile/layouts/master_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isHidden = true;

  @override
  void initState() {
    super.initState();
    AuthProvider.isSignedIn = false;
  }

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      try {
        final korisnikProvider = KorisnikProvider();
        final korisnik = await korisnikProvider.login(
          _usernameController.text,
          _passwordController.text,
        );

        if (!mounted) return;

        if (korisnik.jeAktivan == false) {
          await showCustomDialog(
            context: context,
            title: "Račun deaktiviran",
            message: "Vaš korisnički račun je deaktiviran!",
            icon: Icons.block,
            iconColor: Colors.red,
            buttonColor: const Color(0xFF43675E),
          );
          return;
        }

        AuthProvider.isSignedIn = true;

        if (AuthProvider.uloge != null &&
            AuthProvider.uloge!.contains("Korisnik")) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => const MasterScreen(),
            ),
          );
        } else {
          if (!mounted) return;
          await showCustomDialog(
            context: context,
            title: "Pristup odbijen",
            message: "Nemate pristup ovom interfejsu.",
            icon: Icons.lock_outline,
            iconColor: Colors.red,
            buttonColor: const Color(0xFF43675E),
          );
        }
      } catch (e) {
        if (!mounted) return;
        await showCustomDialog(
          context: context,
          title: "Greška",
          message: e.toString(),
          icon: Icons.error_outline,
          iconColor: Colors.red,
          buttonColor: const Color(0xFF43675E),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xFFF6F4F3),
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            child: Image.asset("assets/images/login_top.png", width: 150),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: Image.asset("assets/images/login_bottom.png", width: 150),
          ),
          Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset("assets/images/logo.png",
                          width: 45, height: 45),
                      const SizedBox(width: 10),
                      const Text(
                        "LitTrack",
                        style: TextStyle(
                          fontSize: 29,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 25),
                  Image.asset("assets/images/login_middle_mobile.png",
                      width: 220),
                  const SizedBox(height: 25),
                  Form(
                    key: _formKey,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: Column(
                        children: [
                          ConstrainedBox(
                            constraints: BoxConstraints(
                              minHeight: screenHeight * 0.03,
                            ),
                            child: TextFormField(
                              controller: _usernameController,
                              decoration: InputDecoration(
                                isDense: true,
                                hintText: "Korisničko ime",
                                filled: true,
                                fillColor: const Color(0xFFB2D9CF),
                                prefixIcon: const Icon(Icons.person, size: 20),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return "Unesite korisničko ime";
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(height: 16),
                          ConstrainedBox(
                            constraints: BoxConstraints(
                              minHeight: screenHeight * 0.03,
                            ),
                            child: TextFormField(
                              controller: _passwordController,
                              obscureText: _isHidden,
                              decoration: InputDecoration(
                                isDense: true,
                                hintText: "Lozinka",
                                filled: true,
                                fillColor: const Color(0xFFB2D9CF),
                                prefixIcon: const Icon(Icons.lock, size: 20),
                                suffixIcon: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _isHidden = !_isHidden;
                                    });
                                  },
                                  child: Icon(
                                    _isHidden
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                  ),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return "Unesite lozinku";
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(height: 24),
                          SizedBox(
                            width: double.infinity,
                            height: 45,
                            child: ElevatedButton(
                              onPressed: _login,
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.resolveWith<Color>(
                                        (states) {
                                  if (states.contains(MaterialState.pressed)) {
                                    return const Color(0xFF33585B);
                                  }
                                  return const Color(0xFF43675E);
                                }),
                                foregroundColor:
                                    MaterialStateProperty.all(Colors.white),
                                shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                                shadowColor: MaterialStateProperty.all(
                                    Colors.black.withOpacity(0.3)),
                                elevation: MaterialStateProperty.all(6),
                              ),
                              child: const Text(
                                "PRIJAVA",
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 15),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                "Nemate račun? ",
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.black87,
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const RegistracijaScreen1(),
                                    ),
                                  );
                                },
                                child: const Text(
                                  "Registrujte se!",
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Color(0xFF3C6E71),
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
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
