import 'package:flutter/material.dart';
import 'package:littrack_mobile/providers/auth_provider.dart';
import 'package:littrack_mobile/providers/korisnik_provider.dart';
import 'package:littrack_mobile/providers/licna_preporuka_provider.dart';
import 'package:littrack_mobile/providers/preporuka_cart_provider.dart';
import 'package:littrack_mobile/providers/utils.dart';
import 'package:littrack_mobile/layouts/master_screen.dart';
import 'package:provider/provider.dart';

class PreporukaPorukaScreen extends StatefulWidget {
  final int usernameId;
  const PreporukaPorukaScreen({super.key, required this.usernameId});

  @override
  State<PreporukaPorukaScreen> createState() => _PreporukaPorukaScreenState();
}

class _PreporukaPorukaScreenState extends State<PreporukaPorukaScreen> {
  final TextEditingController _naslovController = TextEditingController();
  final TextEditingController _porukaController = TextEditingController();

  late LicnaPreporukaProvider _licnaPreporukaProvider;
  late KorisnikProvider _korisnikProvider;
  PreporukaCartProvider? _cartProvider;

  List<int> _knjigeIds = [];
  String? _korisnickoIme;
  bool _isLoading = true;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _licnaPreporukaProvider = context.read<LicnaPreporukaProvider>();
    _korisnikProvider = context.read<KorisnikProvider>();

    if (AuthProvider.korisnikId != null) {
      _cartProvider = PreporukaCartProvider(AuthProvider.korisnikId!);
      _loadData();
    }
  }

  Future<void> _loadData() async {
    try {
      final korisnik = await _korisnikProvider.getById(widget.usernameId);
      if (!mounted) return;
      setState(() {
        _korisnickoIme = korisnik.korisnickoIme ?? "Nepoznat korisnik";
      });

      if (_cartProvider != null) {
        final lista = await _cartProvider!.getPreporukaList();
        final ids = lista.values.map<int>((e) => e['id'] as int).toList();
        if (!mounted) return;
        setState(() {
          _knjigeIds = ids;
        });
      }
    } catch (e) {
      if (!mounted) return;
      await showCustomDialog(
        context: context,
        title: "Greška",
        message: "Došlo je do greške pri učitavanju podataka.",
        icon: Icons.error,
        iconColor: Colors.red,
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _save() async {
    if (_isSaving) return;

    final naslov = _naslovController.text.trim();
    final poruka = _porukaController.text.trim();

    if (naslov.isEmpty || poruka.isEmpty) {
      await showCustomDialog(
        context: context,
        title: "Greška",
        message: "Molimo unesite i naslov i poruku.",
        icon: Icons.error,
        iconColor: Colors.red,
      );
      return;
    }

    if (naslov.length > 100) {
      await showCustomDialog(
        context: context,
        title: "Greška",
        message: "Naslov može imati najviše 100 karaktera.",
        icon: Icons.error,
        iconColor: Colors.red,
      );
      return;
    }

    if (poruka.length > 1000) {
      await showCustomDialog(
        context: context,
        title: "Greška",
        message: "Poruka može imati najviše 1000 karaktera.",
        icon: Icons.error,
        iconColor: Colors.red,
      );
      return;
    }

    if (_knjigeIds.isEmpty) {
      await showCustomDialog(
        context: context,
        title: "Greška",
        message: "Morate dodati barem jednu knjigu u preporuku.",
        icon: Icons.error,
        iconColor: Colors.red,
      );
      return;
    }

    final request = {
      "korisnikPosiljalacId": AuthProvider.korisnikId,
      "korisnikPrimalacId": widget.usernameId,
      "naslov": naslov,
      "poruka": poruka,
      "knjige": _knjigeIds,
    };

    if (mounted) {
      setState(() => _isSaving = true);
    }

    try {
      await _licnaPreporukaProvider.insert(request);
      if (!mounted) return;

      await showCustomDialog(
        context: context,
        title: "Uspjeh",
        message: "Uspješna preporuka za korisnika ${_korisnickoIme ?? ''}.",
        icon: Icons.check_circle,
        iconColor: Colors.green,
      );
      if (!mounted) return;

      await _cartProvider?.clearPreporukaList();
      if (!mounted) return;

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const MasterScreen()),
        (route) => false,
      );
    } catch (e) {
      if (!mounted) return;
      await showCustomDialog(
        context: context,
        title: "Greška",
        message: "Došlo je do greške pri slanju preporuke.",
        icon: Icons.error,
        iconColor: Colors.red,
      );
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
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
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      _buildHeader(),
                      const SizedBox(height: 40),
                      _buildSection(),
                      const SizedBox(height: 40),
                      _buildPreporuciButton(),
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
            color: Colors.black.withOpacity(0.15),
            blurRadius: 6,
            offset: const Offset(0, 3),
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
          Icon(Icons.message, color: Colors.white, size: 28),
        ],
      ),
    );
  }

  Widget _buildSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Unesite naslov",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _naslovController,
          decoration: InputDecoration(
            hintText: "Naslov...",
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            contentPadding:
                const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
          ),
        ),
        const SizedBox(height: 25),
        const Text(
          "Unesite poruku",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _porukaController,
          maxLines: 5,
          decoration: InputDecoration(
            hintText: "Poruka...",
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            contentPadding:
                const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
          ),
        ),
      ],
    );
  }

  Widget _buildPreporuciButton() {
    return SizedBox(
      width: 220,
      height: 48,
      child: ElevatedButton(
        onPressed: _isSaving ? null : _save,
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.resolveWith<Color>((states) {
            if (_isSaving) return Colors.grey;
            if (states.contains(MaterialState.pressed)) {
              return const Color(0xFF33585B);
            }
            return const Color(0xFF3C6E71);
          }),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
          ),
          shadowColor:
              MaterialStateProperty.all(Colors.black.withOpacity(0.15)),
          elevation: MaterialStateProperty.all(6),
        ),
        child: _isSaving
            ? const SizedBox(
                height: 22,
                width: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2.4,
                  color: Colors.white,
                ),
              )
            : const Text(
                "Preporuči",
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
