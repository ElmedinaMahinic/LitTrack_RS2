import 'package:flutter/material.dart';
import 'package:littrack_mobile/models/knjiga.dart';
import 'package:littrack_mobile/providers/utils.dart';
import 'package:littrack_mobile/providers/auth_provider.dart';
import 'package:littrack_mobile/providers/preporuka_cart_provider.dart';
import 'package:littrack_mobile/providers/moja_listum_provider.dart';
import 'package:provider/provider.dart';

class KnjigaDetailsScreen extends StatefulWidget {
  final Knjiga knjiga;

  const KnjigaDetailsScreen({super.key, required this.knjiga});

  @override
  State<KnjigaDetailsScreen> createState() => _KnjigaDetailsScreenState();
}

class _KnjigaDetailsScreenState extends State<KnjigaDetailsScreen> {
  late String naziv;
  late String autor;
  late String opis;
  late int godina;
  late List<String> ciljneGrupe;
  late List<String> zanrovi;
  String? slika;

  late MojaListumProvider _mojaListumProvider;
  PreporukaCartProvider? _preporukaProvider;

  bool _isLoadingProcitano = false;
  bool _jeProcitana = false;
  bool _isInPreporuka = false;

  @override
  void initState() {
    super.initState();
    naziv = widget.knjiga.naziv;
    autor = widget.knjiga.autorNaziv ?? "/";
    opis = widget.knjiga.opis;
    godina = widget.knjiga.godinaIzdavanja;
    ciljneGrupe = widget.knjiga.ciljneGrupe;
    zanrovi = widget.knjiga.zanrovi;
    slika = widget.knjiga.slika;

    _mojaListumProvider = context.read<MojaListumProvider>();

    _preporukaProvider = AuthProvider.korisnikId == null
        ? null
        : PreporukaCartProvider(AuthProvider.korisnikId!);

    _provjeriProcitano();
    _provjeriPreporuka();
  }

  Future<void> _provjeriProcitano() async {
    if (!mounted) return;
    setState(() => _isLoadingProcitano = true);

    try {
      final rezultat = await _mojaListumProvider.get(filter: {
        "KorisnikId": AuthProvider.korisnikId,
        "KnjigaId": widget.knjiga.knjigaId,
        "JeProcitana": true,
      });

      if (!mounted) return;
      setState(() => _jeProcitana = rezultat.resultList.isNotEmpty);
    } catch (_) {
      if (!mounted) return;
      setState(() => _jeProcitana = false);
    } finally {
      if (mounted) setState(() => _isLoadingProcitano = false);
    }
  }

  Future<void> _provjeriPreporuka() async {
    if (_preporukaProvider == null) return;
    final inList =
        await _preporukaProvider!.isInPreporuka(widget.knjiga.knjigaId!);
    if (!mounted) return;
    setState(() => _isInPreporuka = inList);
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
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back,
                      color: Colors.black, size: 35),
                  onPressed: () => Navigator.pop(context, true),
                ),
                Row(
                  children: [
                    Image.asset("assets/images/logo.png",
                        height: 45, width: 45),
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
                  icon: const Icon(Icons.shopping_cart,
                      color: Colors.black, size: 35),
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
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _buildHeaderInfo(),
                  const SizedBox(height: 24),
                  _buildTags(),
                  const SizedBox(height: 20),
                  _buildDescriptionContainer(),
                  const SizedBox(height: 20),
                  _buildButtonZaListu(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderInfo() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildImage(slika),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                naziv,
                style:
                    const TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 6),
              Text(
                autor,
                style: const TextStyle(fontSize: 17.5, color: Colors.black87),
              ),
              const SizedBox(height: 4),
              Text(
                "$godina.",
                style: const TextStyle(fontSize: 15, color: Colors.black54),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTags() {
    return Column(
      children: [
        Wrap(
          alignment: WrapAlignment.center,
          spacing: 8,
          runSpacing: 8,
          children: ciljneGrupe
              .map(
                (g) => Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 13, vertical: 7),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 6,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Text(
                    g,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF3C6E71),
                    ),
                  ),
                ),
              )
              .toList(),
        ),
        const SizedBox(height: 18),
        Wrap(
          alignment: WrapAlignment.center,
          children: [
            Text(
              zanrovi.join(",  "),
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Color(0xFF3C6E71),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDescriptionContainer() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 6),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "O knjizi:",
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            opis,
            style: const TextStyle(fontSize: 14, color: Colors.black87),
          ),
        ],
      ),
    );
  }

  Widget _buildButtonZaListu() {
    final dugmeDisable =
        _isLoadingProcitano || _preporukaProvider == null || _isInPreporuka;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: SizedBox(
        width: 220,
        height: 48,
        child: ElevatedButton(
          onPressed: dugmeDisable
              ? null
              : () async {
                  if (!_jeProcitana) {
                    await showCustomDialog(
                      context: context,
                      title: "Greška",
                      message:
                          "Knjiga mora biti pročitana prije dodavanja u listu za ličnu preporuku.",
                      icon: Icons.error,
                      iconColor: Colors.red,
                    );
                    return;
                  }

                  try {
                    await _preporukaProvider!.addToPreporukaList(widget.knjiga);
                    if (!mounted) return;

                    setState(() => _isInPreporuka = true);

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        backgroundColor: Color(0xFFD5E0DB),
                        duration: Duration(seconds: 2),
                        content: Center(
                          child: Text(
                            "Knjiga dodana u listu za ličnu preporuku.",
                            style: TextStyle(color: Color(0xFF3C6E71)),
                          ),
                        ),
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
                },
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.resolveWith<Color>(
              (states) {
                if (dugmeDisable) {
                  return Colors.grey;
                }
                if (states.contains(MaterialState.pressed)) {
                  return const Color(0xFF33585B);
                }
                return const Color(0xFF3C6E71);
              },
            ),
            shape: MaterialStateProperty.all(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
            ),
            shadowColor:
                MaterialStateProperty.all(Colors.black.withOpacity(0.15)),
            elevation: MaterialStateProperty.all(6),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                _isInPreporuka ? "Već u" : "Dodaj u",
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 8),
              const Icon(Icons.mail, color: Colors.white, size: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImage(String? slikaBase64) {
    if (slikaBase64 == null || slikaBase64.isEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.asset(
          "assets/images/placeholder.png",
          height: 160,
          width: 130,
          fit: BoxFit.cover,
        ),
      );
    }

    try {
      return ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: SizedBox(
          height: 160,
          width: 130,
          child: imageFromString(slikaBase64),
        ),
      );
    } catch (_) {
      return const Icon(Icons.broken_image, size: 100);
    }
  }
}
