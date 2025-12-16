import 'package:flutter/material.dart';
import 'package:littrack_mobile/models/knjiga.dart';
import 'package:littrack_mobile/providers/utils.dart';
import 'package:littrack_mobile/providers/auth_provider.dart';
import 'package:littrack_mobile/providers/preporuka_cart_provider.dart';
import 'package:littrack_mobile/providers/preporuka_provider.dart';
import 'package:littrack_mobile/providers/moja_listum_provider.dart';
import 'package:littrack_mobile/providers/arhiva_provider.dart';
import 'package:littrack_mobile/providers/ocjena_provider.dart';
import 'package:littrack_mobile/providers/cart_provider.dart';
import 'package:littrack_mobile/screens/korpa_screen.dart';
import 'package:littrack_mobile/screens/recenzije_screen.dart';
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
  late double cijena;
  late List<String> ciljneGrupe;
  late List<String> zanrovi;
  String? slika;

  late MojaListumProvider _mojaListumProvider;
  late ArhivaProvider _arhivaProvider;
  late OcjenaProvider _ocjenaProvider;
  PreporukaCartProvider? _licnaPreporukaProvider;
  late PreporukaProvider _preporukaProvider;
  CartProvider? _cartProvider;

  bool _isLoadingProcitano = false;
  bool _jeProcitana = false;
  bool _isInPreporuka = false;

  bool _jeArhivirana = false;
  bool _isLoadingArhivirana = false;
  int? _arhivaId;

  bool _isLoadingLista = false;
  bool _jeUListi = false;
  int? _mojaListumId;

  bool _isLoadingProsjek = false;
  double? _prosjekOcjena;

  bool _jeOcjena = false;
  bool _isLoadingOcjena = false;
  int? _ocjenaId;
  int _ocjena = 0;

  bool _jePreporucena = false;
  bool _isLoadingPreporuka = false;

  bool _isLoadingKorpa = false;
  int _kolicina = 1;

  @override
  void initState() {
    super.initState();
    naziv = widget.knjiga.naziv;
    autor = widget.knjiga.autorNaziv ?? "/";
    opis = widget.knjiga.opis;
    godina = widget.knjiga.godinaIzdavanja;
    cijena = widget.knjiga.cijena;
    ciljneGrupe = widget.knjiga.ciljneGrupe;
    zanrovi = widget.knjiga.zanrovi;
    slika = widget.knjiga.slika;

    _mojaListumProvider = context.read<MojaListumProvider>();
    _arhivaProvider = context.read<ArhivaProvider>();
    _ocjenaProvider = context.read<OcjenaProvider>();
    _preporukaProvider = context.read<PreporukaProvider>();

    _licnaPreporukaProvider = AuthProvider.korisnikId == null
        ? null
        : PreporukaCartProvider(AuthProvider.korisnikId!);

    if (AuthProvider.korisnikId != null) {
      _cartProvider = CartProvider(AuthProvider.korisnikId!);
    }

    _provjeriProcitano();
    _provjeriPreporuka();
    _provjeriArhivirano();
    _provjeriListu();
    _provjeriProsjek();
    _provjeriOcjenu();
    _provjeriPreporucena();
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
    if (_licnaPreporukaProvider == null) return;
    final inList =
        await _licnaPreporukaProvider!.isInPreporuka(widget.knjiga.knjigaId!);
    if (!mounted) return;
    setState(() => _isInPreporuka = inList);
  }

  Future<void> _provjeriArhivirano() async {
    if (!mounted) return;
    setState(() => _isLoadingArhivirana = true);

    try {
      final rezultat = await _arhivaProvider.get(filter: {
        "KorisnikId": AuthProvider.korisnikId,
        "KnjigaId": widget.knjiga.knjigaId
      });

      if (!mounted) return;

      if (rezultat.resultList.isNotEmpty) {
        setState(() {
          _jeArhivirana = true;
          _arhivaId = rezultat.resultList.first.arhivaId;
        });
      } else {
        setState(() {
          _jeArhivirana = false;
          _arhivaId = null;
        });
      }
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _jeArhivirana = false;
        _arhivaId = null;
      });
    } finally {
      if (mounted) setState(() => _isLoadingArhivirana = false);
    }
  }

  Future<void> _toggleArhiva() async {
    if (!mounted) return;
    setState(() => _isLoadingArhivirana = true);

    try {
      if (_jeArhivirana) {
        await _arhivaProvider.delete(_arhivaId!);
        if (!mounted) return;
        setState(() {
          _jeArhivirana = false;
          _arhivaId = null;
        });

        showCustomSnackBar(
          context: context,
          message: "Knjiga je uklonjena iz arhive.",
          icon: Icons.delete,
        );
      } else {
        final dto = await _arhivaProvider.insert({
          "korisnikId": AuthProvider.korisnikId,
          "knjigaId": widget.knjiga.knjigaId
        });

        if (!mounted) return;
        setState(() {
          _jeArhivirana = true;
          _arhivaId = dto.arhivaId;
        });

        showCustomSnackBar(
          context: context,
          message: "Knjiga je arhivirana.",
          icon: Icons.check,
        );
      }
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
      if (mounted) setState(() => _isLoadingArhivirana = false);
    }
  }

  Future<void> _provjeriListu() async {
    if (!mounted) return;
    setState(() => _isLoadingLista = true);

    try {
      final rezultat = await _mojaListumProvider.get(filter: {
        "KorisnikId": AuthProvider.korisnikId,
        "KnjigaId": widget.knjiga.knjigaId,
      });

      if (!mounted) return;

      if (rezultat.resultList.isNotEmpty) {
        setState(() {
          _jeUListi = true;
          _mojaListumId = rezultat.resultList.first.mojaListaId;
        });
      } else {
        setState(() {
          _jeUListi = false;
          _mojaListumId = null;
        });
      }
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _jeUListi = false;
        _mojaListumId = null;
      });
    } finally {
      if (mounted) {
        setState(() => _isLoadingLista = false);
      }
    }
  }

  Future<void> _dodajUListu() async {
    if (!mounted) return;
    setState(() => _isLoadingLista = true);

    try {
      final dto = await _mojaListumProvider.insert({
        "korisnikId": AuthProvider.korisnikId,
        "knjigaId": widget.knjiga.knjigaId
      });

      if (!mounted) return;
      setState(() {
        _jeUListi = true;
        _mojaListumId = dto.mojaListaId;
      });

      showCustomSnackBar(
        context: context,
        message: "Knjiga je dodana u listu za čitanje.",
        icon: Icons.check,
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
      if (mounted) setState(() => _isLoadingLista = false);
    }
  }

  void _showListaMenu(BuildContext context, Offset offset) async {
    final selected = await showMenu<String>(
      context: context,
      color: const Color.fromARGB(255, 226, 236, 231),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      position: RelativeRect.fromLTRB(offset.dx, offset.dy, 0, 0),
      items: [
        const PopupMenuItem<String>(
          enabled: false,
          child: Text(
            "Opcije",
            style: TextStyle(
              color: Color(0xFF3C6E71),
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
        ),
        const PopupMenuDivider(),
        if (!_jeProcitana)
          const PopupMenuItem<String>(
            value: "oznaci",
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Označi kao pročitanu",
                  style: TextStyle(color: Color(0xFF3C6E71)),
                ),
                Icon(Icons.check, size: 18, color: Color(0xFF3C6E71)),
              ],
            ),
          ),
        if (!_jeProcitana)
          const PopupMenuItem<String>(
            value: "ukloni",
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Ukloni iz liste",
                  style: TextStyle(color: Color(0xFF3C6E71)),
                ),
                Icon(Icons.delete, size: 18, color: Color(0xFF3C6E71)),
              ],
            ),
          ),
        const PopupMenuDivider(),
        const PopupMenuItem<String>(
          value: "zatvori",
          child: Center(
            child: Text(
              "Zatvori",
              style: TextStyle(
                color: Color(0xFF3C6E71),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
      elevation: 8,
    );

    if (selected == null || selected == "zatvori") return;

    if (selected == "oznaci") {
      try {
        await _mojaListumProvider.oznaciKaoProcitanu(_mojaListumId!);

        if (!mounted) return;
        setState(() => _jeProcitana = true);

        showCustomSnackBar(
          context: context,
          message: "Knjiga je označena kao pročitana.",
          icon: Icons.check,
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

    if (selected == "ukloni") {
      try {
        await _mojaListumProvider.delete(_mojaListumId!);

        if (!mounted) return;
        setState(() {
          _jeUListi = false;
          _mojaListumId = null;
        });

        showCustomSnackBar(
          context: context,
          message: "Knjiga je uklonjena iz liste za čitanje.",
          icon: Icons.delete,
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

  Future<void> _provjeriProsjek() async {
    if (!mounted) return;
    setState(() => _isLoadingProsjek = true);

    try {
      final prosjek =
          await _ocjenaProvider.getProsjekOcjena(widget.knjiga.knjigaId!);

      if (!mounted) return;
      setState(() => _prosjekOcjena = prosjek);
    } catch (_) {
      if (!mounted) return;
      setState(() => _prosjekOcjena = null);
    } finally {
      if (mounted) setState(() => _isLoadingProsjek = false);
    }
  }

  Future<void> _provjeriOcjenu() async {
    if (!mounted) return;
    setState(() {
      _isLoadingOcjena = true;
    });

    try {
      final rezultat = await _ocjenaProvider.get(filter: {
        "KorisnikId": AuthProvider.korisnikId,
        "KnjigaId": widget.knjiga.knjigaId
      });

      if (!mounted) return;

      if (rezultat.resultList.isNotEmpty) {
        final dto = rezultat.resultList.first;
        setState(() {
          _jeOcjena = true;
          _ocjenaId = dto.ocjenaId;
          _ocjena = dto.vrijednost;
        });
      } else {
        setState(() {
          _jeOcjena = false;
          _ocjenaId = null;
          _ocjena = 0;
        });
      }
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _jeOcjena = false;
        _ocjenaId = null;
        _ocjena = 0;
      });
    } finally {
      if (mounted) setState(() => _isLoadingOcjena = false);
    }
  }

  Future<void> _spasiOcjenu(int novaVrijednost) async {
    if (!mounted) return;
    setState(() {
      _isLoadingOcjena = true;
    });

    try {
      if (_jeOcjena) {
        await _ocjenaProvider
            .update(_ocjenaId!, {"vrijednost": novaVrijednost});

        if (!mounted) return;
        setState(() {
          _ocjena = novaVrijednost;
        });

        await _provjeriProsjek();

        if (!mounted) return;

        showCustomSnackBar(
          context: context,
          message: "Ocjena je ažurirana.",
          icon: Icons.check,
        );
      } else {
        final dto = await _ocjenaProvider.insert({
          "korisnikId": AuthProvider.korisnikId,
          "knjigaId": widget.knjiga.knjigaId,
          "vrijednost": novaVrijednost
        });

        if (!mounted) return;
        setState(() {
          _jeOcjena = true;
          _ocjenaId = dto.ocjenaId;
          _ocjena = novaVrijednost;
        });

        await _provjeriProsjek();

        if (!mounted) return;

        showCustomSnackBar(
          context: context,
          message: "Uspješno ste ocijenili knjigu.",
          icon: Icons.check,
        );
      }
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
      if (mounted) setState(() => _isLoadingOcjena = false);
    }
  }

  Future<void> _provjeriPreporucena() async {
    if (!mounted) return;
    setState(() => _isLoadingPreporuka = true);

    try {
      final rezultat = await _preporukaProvider.get(filter: {
        "KorisnikId": AuthProvider.korisnikId,
        "KnjigaId": widget.knjiga.knjigaId,
      });

      if (!mounted) return;

      setState(() {
        _jePreporucena = rezultat.resultList.isNotEmpty;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _jePreporucena = false;
      });
    } finally {
      if (mounted) setState(() => _isLoadingPreporuka = false);
    }
  }

  Future<void> _preporuci() async {
    if (!mounted) return;
    setState(() => _isLoadingPreporuka = true);

    try {
      await _preporukaProvider.insert({
        "korisnikId": AuthProvider.korisnikId,
        "knjigaId": widget.knjiga.knjigaId
      });

      if (!mounted) return;

      setState(() => _jePreporucena = true);

      showCustomSnackBar(
        context: context,
        message: "Knjiga je preporučena.",
        icon: Icons.check,
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
      if (mounted) setState(() => _isLoadingPreporuka = false);
    }
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
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back,
                      color: Colors.black, size: 30),
                  onPressed: () => Navigator.pop(context, true),
                ),
                Row(
                  children: [
                    Image.asset("assets/images/logo.png",
                        height: 40, width: 40),
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
                  icon: const Icon(Icons.shopping_cart,
                      color: Colors.black, size: 30),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const KorpaScreen(),
                      ),
                    );
                  },
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
                  const SizedBox(height: 24),
                  _buildOcjenaRow(),
                  const SizedBox(height: 25),
                  const Divider(thickness: 0.6, color: Colors.grey),
                  const SizedBox(height: 24),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Opcije čitanja",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.black54,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 12,
                    runSpacing: 12,
                    children: [
                      _buildButtonArhiva(),
                      _buildButtonCitanje(),
                    ],
                  ),
                  const SizedBox(height: 26),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Interakcije",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.black54,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildButtonRecenzije(),
                  const SizedBox(height: 25),
                  if (_jeProcitana) ...[
                    _buildOcijeni(),
                    const SizedBox(height: 26),
                  ],
                  const Divider(thickness: 0.6, color: Colors.grey),
                  const SizedBox(height: 25),
                  _buildButtonPreporuka(),
                  const SizedBox(height: 20),
                  _buildButtonZaListu(),
                  const SizedBox(height: 25),
                  const Divider(thickness: 0.6, color: Colors.grey),
                  const SizedBox(height: 25),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Kupovina",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.black54,
                      ),
                    ),
                  ),
                  const SizedBox(height: 17),
                  _buildCijena(),
                  const SizedBox(height: 22),
                  _buildButtonKorpa(),
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
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: ciljneGrupe.map(
                (g) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 13, vertical: 7),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.15),
                            blurRadius: 7,
                            offset: const Offset(0, 4),
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
                  );
                },
              ).toList(),
            ),
          ),
        ),
        const SizedBox(height: 18),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: zanrovi.map(
                (z) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: Text(
                      z,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF3C6E71),
                      ),
                    ),
                  );
                },
              ).toList(),
            ),
          ),
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

  Widget _buildButtonArhiva() {
    final tekst = _jeArhivirana ? "Arhivirana" : "Arhiviraj";

    return SizedBox(
      width: 140,
      height: 45,
      child: ElevatedButton(
        onPressed: _isLoadingArhivirana ? null : _toggleArhiva,
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.resolveWith<Color>((states) {
            if (_isLoadingArhivirana) return Colors.grey;

            if (_jeArhivirana) {
              return const Color(0xFF3C6E71);
            }

            return states.contains(MaterialState.pressed)
                ? const Color(0xFF33585B)
                : const Color(0xFF3C6E71);
          }),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
          ),
          shadowColor: MaterialStateProperty.all(
            Colors.black.withOpacity(_jeArhivirana ? 0.4 : 0.3),
          ),
          elevation: MaterialStateProperty.all(
            _jeArhivirana ? 8 : 6,
          ),
        ),
        child: _isLoadingArhivirana
            ? const SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: Text(
                      tekst,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  if (!_jeArhivirana) ...[
                    const SizedBox(width: 8),
                    const Icon(
                      Icons.archive,
                      color: Colors.white,
                      size: 18,
                    ),
                  ],
                ],
              ),
      ),
    );
  }

  Widget _buildButtonCitanje() {
    final bool isLoading = _isLoadingLista || _isLoadingProcitano;

    String tekst;
    bool prikaziMeni;

    if (!_jeUListi) {
      tekst = "Želim čitati";
      prikaziMeni = false;
    } else if (_jeProcitana) {
      tekst = "Pročitana";
      prikaziMeni = false;
    } else {
      tekst = "Opcije";
      prikaziMeni = true;
    }

    return SizedBox(
      width: 140,
      height: 45,
      child: ElevatedButton(
        onPressed: isLoading
            ? null
            : () async {
                if (!_jeUListi) {
                  await _dodajUListu();
                }
              },
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.resolveWith<Color>((states) {
            if (isLoading) return Colors.grey;

            if (_jeProcitana) {
              return const Color(0xFF3C6E71);
            }

            return states.contains(MaterialState.pressed)
                ? const Color(0xFF33585B)
                : const Color(0xFF3C6E71);
          }),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
          ),
          shadowColor: MaterialStateProperty.all(
            Colors.black.withOpacity(_jeProcitana ? 0.4 : 0.3),
          ),
          elevation: MaterialStateProperty.all(_jeProcitana ? 8 : 6),
        ),
        child: isLoading
            ? const SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: Text(
                      tekst,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  if (prikaziMeni) ...[
                    const SizedBox(width: 8),
                    GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTapDown: (details) {
                        if (!isLoading) {
                          _showListaMenu(context, details.globalPosition);
                        }
                      },
                      child: const Icon(
                        Icons.more_vert,
                        size: 18,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ],
              ),
      ),
    );
  }

  Widget _buildOcjenaRow() {
    if (_isLoadingProsjek || _isLoadingProcitano) {
      return const Center(child: CircularProgressIndicator());
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          children: [
            const Icon(Icons.star, color: Color(0xFFF34FA7), size: 26),
            const SizedBox(width: 6),
            Text(
              (_prosjekOcjena ?? 0) > 0
                  ? _prosjekOcjena!.toStringAsFixed(1)
                  : "-",
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ],
        ),
        if (!_jeProcitana) ...[
          const SizedBox(width: 8),
          GestureDetector(
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  backgroundColor: Color(0xFFD5E0DB),
                  duration: Duration(seconds: 3),
                  content: Center(
                    child: Text(
                      "Možete ocijeniti samo pročitane knjige.",
                      style: TextStyle(color: Color(0xFF3C6E71)),
                    ),
                  ),
                ),
              );
            },
            child: const Icon(Icons.info_outline, size: 18, color: Colors.grey),
          ),
        ],
      ],
    );
  }

  Widget _buildButtonRecenzije() {
    return SizedBox(
      width: 220,
      height: 48,
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => RecenzijeScreen(
                knjigaId: widget.knjiga.knjigaId!,
              ),
            ),
          );
        },
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.resolveWith<Color>(
            (states) {
              if (states.contains(MaterialState.pressed)) {
                return Colors.pink.shade500;
              } else {
                return const Color(0xFFF34FA7);
              }
            },
          ),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
          ),
          shadowColor: MaterialStateProperty.all(Colors.black.withOpacity(0.3)),
          elevation: MaterialStateProperty.all(6),
        ),
        child: const Text(
          "Pročitaj recenzije",
          style: TextStyle(
            fontSize: 16,
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildOcijeni() {
    final naslov = _jeOcjena ? "Moja ocjena" : "Ocijeni knjigu";

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          naslov,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(5, (i) {
            final index = i + 1;
            final isActive = index <= _ocjena;

            return GestureDetector(
              onTap: _isLoadingOcjena
                  ? null
                  : () {
                      _spasiOcjenu(index);
                    },
              child: Icon(
                Icons.star,
                size: 32,
                color: isActive ? const Color(0xFFF34FA7) : Colors.grey,
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildCijena() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text.rich(
        TextSpan(
          children: [
            const TextSpan(
              text: "Cijena: ",
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.normal,
                color: Colors.black,
              ),
            ),
            TextSpan(
              text: "${cijena.toStringAsFixed(2)} KM",
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildButtonPreporuka() {
    final bool mozePreporuciti =
        !_isLoadingProcitano && !_isLoadingPreporuka && !_jePreporucena;
    final bool trebaProcitatiPrvo = !_jeProcitana;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 220,
          height: 48,
          child: ElevatedButton(
            onPressed: (mozePreporuciti && !trebaProcitatiPrvo)
                ? () async {
                    await _preporuci();
                  }
                : null,
            style: ButtonStyle(
              backgroundColor:
                  MaterialStateProperty.resolveWith<Color>((states) {
                if (!mozePreporuciti || trebaProcitatiPrvo) {
                  return Colors.grey;
                }
                if (states.contains(MaterialState.pressed)) {
                  return const Color(0xFF33585B);
                }
                return const Color(0xFF3C6E71);
              }),
              shape: MaterialStateProperty.all(
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
              ),
              shadowColor: MaterialStateProperty.all(
                Colors.black.withOpacity(0.3),
              ),
              elevation: MaterialStateProperty.all(6),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  child: Text(
                    _jePreporucena ? "Preporučena" : "Preporuči svima",
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Icon(
                  _jePreporucena ? Icons.check : Icons.thumb_up,
                  color: Colors.white,
                  size: 18,
                ),
              ],
            ),
          ),
        ),
        if (trebaProcitatiPrvo) ...[
          const SizedBox(width: 8),
          GestureDetector(
            onTap: () {
              showCustomSnackBar(
                context: context,
                message: "Možete preporučiti samo pročitane knjige.",
              );
            },
            child: const Icon(Icons.info_outline, size: 22, color: Colors.grey),
          ),
        ],
      ],
    );
  }

  Widget _buildButtonZaListu() {
    final dugmeDisable = _isLoadingProcitano || _isInPreporuka || !_jeProcitana;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 220,
          height: 48,
          child: ElevatedButton(
            onPressed: dugmeDisable
                ? null
                : () async {
                    try {
                      await _licnaPreporukaProvider!
                          .addToPreporukaList(widget.knjiga);
                      if (!mounted) return;
                      setState(() => _isInPreporuka = true);
                      showCustomSnackBar(
                        context: context,
                        message: "Knjiga je dodana u listu za ličnu preporuku.",
                        icon: Icons.check,
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
              backgroundColor:
                  MaterialStateProperty.resolveWith<Color>((states) {
                if (dugmeDisable) {
                  return Colors.grey;
                }
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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  child: Text(
                    _isInPreporuka ? "Već u" : "Dodaj u",
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(
                  Icons.mail,
                  color: Colors.white,
                  size: 16,
                ),
              ],
            ),
          ),
        ),
        if (!_jeProcitana) ...[
          const SizedBox(width: 8),
          GestureDetector(
            onTap: () {
              showCustomSnackBar(
                context: context,
                message:
                    "U ličnu preporuku možete dodati samo pročitane knjige.",
              );
            },
            child: const Icon(Icons.info_outline, size: 22, color: Colors.grey),
          ),
        ],
      ],
    );
  }

  Widget _buildButtonKorpa() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text(
          "Broj knjiga",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Material(
              color: Colors.transparent,
              shape: const CircleBorder(),
              child: InkWell(
                onTap: _kolicina > 1
                    ? () {
                        setState(() {
                          _kolicina--;
                        });
                      }
                    : null,
                customBorder: const CircleBorder(),
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: _kolicina > 1
                        ? const Color(0xFFF34FA7)
                        : Colors.grey.shade600,
                    shape: BoxShape.circle,
                  ),
                  child:
                      const Icon(Icons.remove, color: Colors.white, size: 20),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Text(
              '$_kolicina',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(width: 16),
            Material(
              color: Colors.transparent,
              shape: const CircleBorder(),
              child: InkWell(
                onTap: _kolicina < 10
                    ? () {
                        setState(() {
                          _kolicina++;
                        });
                      }
                    : null,
                customBorder: const CircleBorder(),
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: _kolicina < 10
                        ? const Color(0xFFF34FA7)
                        : Colors.grey.shade600,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.add, color: Colors.white, size: 20),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 17),
        SizedBox(
          width: 220,
          height: 48,
          child: ElevatedButton(
            onPressed: _isLoadingKorpa
                ? null
                : () async {
                    if (_cartProvider == null) return;

                    if (_kolicina < 1) {
                      showCustomDialog(
                        context: context,
                        title: "Greška",
                        message: "Količina mora biti najmanje 1.",
                        icon: Icons.error,
                      );
                      return;
                    }

                    setState(() {
                      _isLoadingKorpa = true;
                    });

                    try {
                      await _cartProvider!.addToCart(widget.knjiga, _kolicina);

                      if (!mounted) return;

                      showCustomSnackBar(
                        context: context,
                        message: 'Knjiga dodana u korpu.',
                        icon: Icons.check,
                      );

                      setState(() {
                        _kolicina = 1;
                      });
                    } catch (e) {
                      if (!mounted) return;
                      showCustomDialog(
                        context: context,
                        title: "Greška",
                        message: e.toString(),
                        icon: Icons.error,
                      );
                    } finally {
                      if (mounted) {
                        setState(() {
                          _isLoadingKorpa = false;
                        });
                      }
                    }
                  },
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.resolveWith<Color>(
                (states) {
                  if (states.contains(MaterialState.pressed)) {
                    return const Color(0xFF33585B);
                  } else {
                    return const Color(0xFF3C6E71);
                  }
                },
              ),
              shape: MaterialStateProperty.all(
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
              ),
              shadowColor:
                  MaterialStateProperty.all(Colors.black.withOpacity(0.3)),
              elevation: MaterialStateProperty.all(6),
            ),
            child: const Text(
              "Dodaj u korpu",
              style: TextStyle(
                fontSize: 16,
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
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
