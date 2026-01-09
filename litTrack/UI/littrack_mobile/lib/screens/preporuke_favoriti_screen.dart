import 'package:flutter/material.dart';
import 'package:littrack_mobile/models/knjiga_favorit.dart';
import 'package:littrack_mobile/models/preporucena_knjiga.dart';
import 'package:littrack_mobile/providers/arhiva_provider.dart';
import 'package:littrack_mobile/providers/preporuka_provider.dart';
import 'package:littrack_mobile/providers/knjiga_provider.dart';
import 'package:littrack_mobile/providers/utils.dart';
import 'package:littrack_mobile/screens/knjiga_details_screen.dart';
import 'package:provider/provider.dart';

class PreporukeFavoritiScreen extends StatefulWidget {
  const PreporukeFavoritiScreen({super.key});

  @override
  State<PreporukeFavoritiScreen> createState() =>
      _PreporukeFavoritiScreenState();
}

class _PreporukeFavoritiScreenState extends State<PreporukeFavoritiScreen> {
  late ArhivaProvider _arhivaProvider;
  late PreporukaProvider _preporukaProvider;
  late KnjigaProvider _knjigaProvider;

  bool _loading = true;
  bool _prikaziPreporuke = true;

  int _currentPage = 1;
  final int _pageSize = 10;
  int _totalCount = 0;

  List<Object> _knjige = [];

  @override
  void initState() {
    super.initState();
    _arhivaProvider = context.read<ArhivaProvider>();
    _preporukaProvider = context.read<PreporukaProvider>();
    _knjigaProvider = context.read<KnjigaProvider>();
    _fetchKnjige(page: 1);
  }

  Future<void> _fetchKnjige({int page = 1}) async {
    setState(() => _loading = true);

    try {
      if (_prikaziPreporuke) {
        final result = await _preporukaProvider.getPreporuceneKnjige(
          page: page,
          pageSize: _pageSize,
          sortDirection: "desc",
        );

        if (!mounted) return;

        setState(() {
          _knjige = result.resultList.cast<PreporucenaKnjiga>();
          _totalCount = result.count;
        });
      } else {
        final result = await _arhivaProvider.getKnjigeFavoriti(
          page: page,
          pageSize: _pageSize,
          sortDirection: "desc",
        );

        if (!mounted) return;

        setState(() {
          _knjige = result.resultList.cast<KnjigaFavorit>();
          _totalCount = result.count;
        });
      }

      if (mounted) {
        setState(() => _currentPage = page);
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
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildToggleButtons(),
            const SizedBox(height: 17),
            _buildHeader(),
            const SizedBox(height: 24),
            if (_loading)
              const Center(child: CircularProgressIndicator())
            else if (_knjige.isEmpty)
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.menu_book_outlined,
                        color: Color(0xFF3C6E71), size: 50),
                    const SizedBox(height: 12),
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Text(
                        _prikaziPreporuke
                            ? "Trenutno nema preporuka."
                            : "Trenutno nema favorita.",
                        style: const TextStyle(
                          fontSize: 17,
                          color: Color(0xFF3C6E71),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              )
            else ...[
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _knjige.length,
                itemBuilder: (context, index) {
                  return _buildKnjigaCard(_knjige[index], index);
                },
              ),
              if (_totalCount > _pageSize) _buildPaging(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildToggleButtons() {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: () {
              if (!_prikaziPreporuke) {
                setState(() => _prikaziPreporuke = true);
                _fetchKnjige(page: 1);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: _prikaziPreporuke
                  ? const Color(0xFFD55B91)
                  : Colors.grey[300],
              elevation: _prikaziPreporuke ? 8 : 3,
              shadowColor: Colors.black.withAlpha(77),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
            child: Text(
              "Preporuke",
              style: TextStyle(
                color: _prikaziPreporuke ? Colors.white : Colors.grey[700],
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: ElevatedButton(
            onPressed: () {
              if (_prikaziPreporuke) {
                setState(() => _prikaziPreporuke = false);
                _fetchKnjige(page: 1);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: !_prikaziPreporuke
                  ? const Color(0xFFD55B91)
                  : Colors.grey[300],
              elevation: !_prikaziPreporuke ? 8 : 3,
              shadowColor: Colors.black.withAlpha(77),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
            child: Text(
              "Favoriti",
              style: TextStyle(
                color: !_prikaziPreporuke ? Colors.white : Colors.grey[700],
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
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
            color: Colors.black.withAlpha(51),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            _prikaziPreporuke ? "Preporuke čitatelja" : "Najdraže knjige",
            style: const TextStyle(
              color: Colors.white,
              fontSize: 19,
              fontWeight: FontWeight.w600,
            ),
          ),
          const Icon(Icons.favorite_border, color: Colors.white, size: 28),
        ],
      ),
    );
  }

  Widget _buildKnjigaCard(Object knjiga, int index) {
    final bool jePreporuka = knjiga is PreporucenaKnjiga;
    final String naziv = jePreporuka
        ? knjiga.nazivKnjige ?? "-"
        : (knjiga as KnjigaFavorit).nazivKnjige ?? "-";

    final String autor = jePreporuka
        ? knjiga.autorNaziv ?? "-"
        : (knjiga as KnjigaFavorit).autorNaziv ?? "-";

    final String? slika =
        jePreporuka ? knjiga.slika : (knjiga as KnjigaFavorit).slika;

    final String dodatniText = jePreporuka
        ? "Broj preporuka: ${knjiga.brojPreporuka}"
        : "Broj arhiviranja: ${(knjiga as KnjigaFavorit).brojArhiviranja}";

    final int knjigaId =
        jePreporuka ? knjiga.knjigaId : (knjiga as KnjigaFavorit).knjigaId;

    return GestureDetector(
      onTap: () async {
        try {
          final knjigaDetalji = await _knjigaProvider.getById(knjigaId);

          if (!mounted) return;

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => KnjigaDetailsScreen(knjiga: knjigaDetalji),
            ),
          );
        } catch (e) {
          if (!mounted) return;
          showCustomDialog(
            context: context,
            title: 'Greška',
            message: 'Ne mogu učitati detalje knjige: $e',
            icon: Icons.error,
            iconColor: Colors.red,
          );
        }
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(51),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Center(
              child: Text(
                "${index + 1}.",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Color(0xFF3C6E71),
                ),
              ),
            ),
            const SizedBox(width: 12),
            _buildImage(slika),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    naziv,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    autor,
                    style: const TextStyle(
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    dodatniText,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImage(String? slikaBase64) {
    if (slikaBase64 == null || slikaBase64.isEmpty) {
      return Image.asset(
        "assets/images/placeholder.png",
        width: 85,
        height: 120,
        fit: BoxFit.cover,
      );
    }

    try {
      return ClipRRect(
        borderRadius: BorderRadius.circular(6),
        child: SizedBox(
          width: 85,
          height: 120,
          child: imageFromString(slikaBase64),
        ),
      );
    } catch (_) {
      return const Icon(Icons.broken_image, size: 50);
    }
  }

  Widget _buildPaging() {
    int totalPages = (_totalCount / _pageSize).ceil();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Opacity(
            opacity: 0.3,
            child: ElevatedButton(
              onPressed: _currentPage > 1
                  ? () => _fetchKnjige(page: _currentPage - 1)
                  : null,
              style: ElevatedButton.styleFrom(
                elevation: 6,
                shadowColor: Colors.black.withAlpha(38),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text("Prethodna"),
            ),
          ),
          const SizedBox(width: 20),
          Text("Stranica $_currentPage / $totalPages"),
          const SizedBox(width: 20),
          Opacity(
            opacity: 0.3,
            child: ElevatedButton(
              onPressed: _currentPage < totalPages
                  ? () => _fetchKnjige(page: _currentPage + 1)
                  : null,
              style: ElevatedButton.styleFrom(
                elevation: 6,
                shadowColor: Colors.black.withAlpha(38),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text("Sljedeća"),
            ),
          ),
        ],
      ),
    );
  }
}
