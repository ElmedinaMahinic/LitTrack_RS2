import 'package:flutter/material.dart';
import 'package:littrack_mobile/providers/korisnik_provider.dart';
import 'package:littrack_mobile/providers/utils.dart';
import 'package:provider/provider.dart';
import 'package:littrack_mobile/screens/preporuka_poruka_screen.dart';

class PreporukaUserScreen extends StatefulWidget {
  const PreporukaUserScreen({super.key});

  @override
  State<PreporukaUserScreen> createState() => _PreporukaUserScreenState();
}

class _PreporukaUserScreenState extends State<PreporukaUserScreen> {
  final TextEditingController _usernameController = TextEditingController();
  late KorisnikProvider _provider;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _provider = context.read<KorisnikProvider>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F4F3),
      appBar: AppBar(
        elevation: 0,
        shadowColor: Colors.transparent,
        automaticallyImplyLeading: false,
        centerTitle: false,
        toolbarHeight: kToolbarHeight + 15,
        backgroundColor: const Color(0xFFF6F4F3),
        surfaceTintColor: Colors.transparent,
        forceMaterialTransparency: false,
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
                    size: 30,
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
                Row(
                  children: [
                    Image.asset(
                      "assets/images/logo.png",
                      height: 40,
                      width: 40,
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      "LitTrack",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                        fontSize: 26,
                      ),
                    ),
                  ],
                ),
                IconButton(
                  icon: const Icon(
                    Icons.shopping_cart,
                    color: Colors.black,
                    size: 30,
                  ),
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _buildHeader(),
                const SizedBox(height: 100),
                _buildSection(),
                const SizedBox(height: 40),
                _buildDaljeButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 22, horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.pink,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Lična preporuka",
            style: TextStyle(
              color: Colors.white,
              fontSize: 19,
              fontWeight: FontWeight.w600,
            ),
          ),
          Icon(Icons.person, color: Colors.white, size: 28),
        ],
      ),
    );
  }

  Widget _buildSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Odaberi korisnika",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _usernameController,
          decoration: InputDecoration(
            isDense: true,
            contentPadding:
                const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
            labelText: "Korisničko ime",
            hintText: "Unesite korisničko ime...",
            floatingLabelBehavior: FloatingLabelBehavior.always,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            filled: true,
            fillColor: Colors.grey[200],
            prefixIcon: const Icon(Icons.search),
          ),
        ),
      ],
    );
  }

  Widget _buildDaljeButton() {
    return SizedBox(
      width: 220,
      height: 48,
      child: ElevatedButton(
        onPressed: _isLoading
            ? null
            : () async {
                String username = _usernameController.text.trim();

                if (username.isEmpty) {
                  if (!mounted) return;
                  await showCustomDialog(
                    context: context,
                    title: "Greška",
                    message: "Molimo unesite korisničko ime.",
                    icon: Icons.error,
                    iconColor: Colors.red,
                  );
                  return;
                }

                setState(() {
                  _isLoading = true;
                });

                int usernameId = 0;

                try {
                  usernameId =
                      await _provider.getKorisnikIdByUsername(username);
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
                  if (mounted) {
                    setState(() {
                      _isLoading = false;
                    });
                  }
                  return;
                }

                if (usernameId == 0) {
                  if (!mounted) return;
                  await showCustomDialog(
                    context: context,
                    title: "Greška",
                    message:
                        "Uneseno korisničko ime ne postoji ili nije validan korisnik.",
                    icon: Icons.error,
                    iconColor: Colors.red,
                  );
                  if (mounted) {
                    setState(() {
                      _isLoading = false;
                    });
                  }
                  return;
                }

                if (!mounted) return;
                setState(() {
                  _isLoading = false;
                });

                if (!mounted) return;
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        PreporukaPorukaScreen(usernameId: usernameId),
                  ),
                );
              },
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.resolveWith<Color>((states) {
            if (_isLoading) return Colors.grey;

            if (states.contains(MaterialState.pressed)) {
              return const Color(0xFF33585B);
            }
            return const Color(0xFF3C6E71);
          }),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
          ),
          shadowColor:
              MaterialStateProperty.all(Colors.black.withOpacity(0.3)),
          elevation: MaterialStateProperty.all(6),
        ),
        child: _isLoading
            ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  color: Colors.white,
                ),
              )
            : const Text(
                "Dalje",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
      ),
    );
  }
}
