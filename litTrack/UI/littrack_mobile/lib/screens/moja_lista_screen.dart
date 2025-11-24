import 'package:flutter/material.dart';
import 'package:littrack_mobile/models/moja_listum.dart';
import 'package:littrack_mobile/providers/auth_provider.dart';
import 'package:littrack_mobile/providers/moja_listum_provider.dart';
import 'package:littrack_mobile/providers/ocjena_provider.dart';
import 'package:littrack_mobile/providers/knjiga_provider.dart';
import 'package:littrack_mobile/providers/utils.dart';
import 'package:provider/provider.dart';
import 'package:littrack_mobile/screens/moja_lista_knjige_screen.dart';
import 'package:littrack_mobile/screens/knjiga_details_screen.dart';

class MojaListaScreen extends StatefulWidget {
  const MojaListaScreen({super.key});

  @override
  State<MojaListaScreen> createState() => _MojaListaScreenState();
}

class _MojaListaScreenState extends State<MojaListaScreen> {
  late MojaListumProvider _mojaListaProvider;
  late OcjenaProvider _ocjenaProvider;
  late KnjigaProvider _knjigaProvider;

  List<MojaListum> _procitaneKnjige = [];
  List<MojaListum> _zelimProcitati = [];
  final Map<int, double> _prosjekOcjena = {};

  bool _isLoadingProcitane = false;
  bool _isLoadingNeprocitane = false;

  @override
  void initState() {
    super.initState();
    _mojaListaProvider = context.read<MojaListumProvider>();
    _ocjenaProvider = context.read<OcjenaProvider>();
    _knjigaProvider = context.read<KnjigaProvider>();
    _fetchData();
  }

  Future<void> _fetchData() async {
    _fetchProcitane();
    _fetchNeprocitane();
  }

  Future<void> _fetchProcitane() async {
    if (!mounted) return;
    setState(() => _isLoadingProcitane = true);
    try {
      final filter = <String, dynamic>{
        'KorisnikId': AuthProvider.korisnikId,
        'JeProcitana': true,
        'orderBy': 'DatumDodavanja',
        'sortDirection': 'desc',
        'page': 1,
        'pageSize': 2,
      };

      final result = await _mojaListaProvider.get(filter: filter);
      if (!mounted) return;
      setState(() {
        _procitaneKnjige = result.resultList;
      });

      for (var knjiga in result.resultList) {
        try {
          final prosjek =
              await _ocjenaProvider.getProsjekOcjena(knjiga.knjigaId);
          if (!mounted) return;
          setState(() {
            _prosjekOcjena[knjiga.knjigaId] = prosjek;
          });
        } catch (_) {
          _prosjekOcjena[knjiga.knjigaId] = 0;
        }
      }
    } catch (e) {
      if (!mounted) return;
      showCustomDialog(
        context: context,
        title: 'Greška',
        message: e.toString(),
        icon: Icons.error,
        iconColor: Colors.red,
      );
    } finally {
      if (mounted) {
        setState(() => _isLoadingProcitane = false);
      }
    }
  }

  Future<void> _fetchNeprocitane() async {
    if (!mounted) return;
    setState(() => _isLoadingNeprocitane = true);
    try {
      final filter = <String, dynamic>{
        'KorisnikId': AuthProvider.korisnikId,
        'JeProcitana': false,
        'orderBy': 'DatumDodavanja',
        'sortDirection': 'desc',
        'page': 1,
        'pageSize': 2,
      };

      final result = await _mojaListaProvider.get(filter: filter);
      if (!mounted) return;
      setState(() {
        _zelimProcitati = result.resultList;
      });

      for (var knjiga in result.resultList) {
        try {
          final prosjek =
              await _ocjenaProvider.getProsjekOcjena(knjiga.knjigaId);
          if (!mounted) return;
          setState(() {
            _prosjekOcjena[knjiga.knjigaId] = prosjek;
          });
        } catch (_) {
          _prosjekOcjena[knjiga.knjigaId] = 0;
        }
      }
    } catch (e) {
      if (!mounted) return;
      showCustomDialog(
        context: context,
        title: 'Greška',
        message: e.toString(),
        icon: Icons.error,
        iconColor: Colors.red,
      );
    } finally {
      if (mounted) {
        setState(() => _isLoadingNeprocitane = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildHeader(),
            const SizedBox(height: 20),
            _buildSection("Pročitane knjige", _procitaneKnjige, true,
                _isLoadingProcitane),
            const SizedBox(height: 20),
            _buildSection("Knjige koje želim pročitati", _zelimProcitati, false,
                _isLoadingNeprocitane),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 22, horizontal: 20),
      decoration: BoxDecoration(
        color: const Color(0xFF3C6E71),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Moja lista knjiga",
            style: TextStyle(
              color: Colors.white,
              fontSize: 19,
              fontWeight: FontWeight.w600,
            ),
          ),
          Icon(Icons.library_books, color: Colors.white, size: 28),
        ],
      ),
    );
  }

  Widget _buildSection(
      String title, List<MojaListum> knjige, bool jeProcitana, bool isLoading) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF3C6E71),
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        MojaListaKnjigeScreen(jeProcitana: jeProcitana),
                  ),
                );
              },
              child: const Text(
                "Vidi sve >>",
                style: TextStyle(
                  color: Color(0xFF3C6E71),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (isLoading)
          const Center(child: CircularProgressIndicator())
        else if (knjige.isEmpty)
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.menu_book,
                  color: Color(0xFF3C6E71),
                  size: 50,
                ),
                const SizedBox(height: 10),
                Text(
                  jeProcitana
                      ? "Nemate pročitanih knjiga."
                      : "Nemate knjiga za čitanje.",
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF3C6E71),
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          )
        else
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: knjige.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 0.84,
            ),
            itemBuilder: (context, index) {
              final knjiga = knjige[index];
              final prosjek = _prosjekOcjena[knjiga.knjigaId] ?? 0;

              return GestureDetector(
                onTap: () async {
                  try {
                    final knjigaDetalji =
                        await _knjigaProvider.getById(knjiga.knjigaId);
                    if (!mounted) return;

                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            KnjigaDetailsScreen(knjiga: knjigaDetalji),
                      ),
                    );
                    if (!mounted) return;

                    if (result == true) {
                      _fetchData();
                    }
                  } catch (e) {
                    if (!mounted) return;
                    showCustomDialog(
                      context: context,
                      title: 'Greška',
                      message: e.toString(),
                      icon: Icons.error,
                      iconColor: Colors.red,
                    );
                  }
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12.withOpacity(0.2),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildImage(knjiga.slika),
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 6),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              knjiga.nazivKnjige ?? "",
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 15,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              knjiga.autorNaziv ?? "",
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: Colors.black54,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "${knjiga.cijena} KM",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                  ),
                                ),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.star,
                                      color: Colors.pinkAccent,
                                      size: 18,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      prosjek > 0
                                          ? prosjek.toStringAsFixed(1)
                                          : "-",
                                      style: const TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
      ],
    );
  }

  Widget _buildImage(String? slikaBase64) {
    Widget imageWidget;

    if (slikaBase64 == null || slikaBase64.isEmpty) {
      imageWidget = Image.asset(
        "assets/images/placeholder.png",
        height: 120,
        width: 108,
        fit: BoxFit.cover,
      );
    } else {
      try {
        imageWidget = SizedBox(
          height: 120,
          width: 108,
          child: imageFromString(slikaBase64),
        );
      } catch (_) {
        imageWidget = const Icon(Icons.broken_image, size: 100);
      }
    }

    return Center(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: imageWidget,
      ),
    );
  }
}
