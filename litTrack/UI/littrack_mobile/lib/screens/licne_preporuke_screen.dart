import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:littrack_mobile/models/licna_preporuka.dart';
import 'package:littrack_mobile/providers/licna_preporuka_provider.dart';
import 'package:littrack_mobile/providers/auth_provider.dart';
import 'package:littrack_mobile/providers/utils.dart';
import 'package:provider/provider.dart';
import 'package:littrack_mobile/screens/licne_preporuke_details_screen.dart';

class LicnePreporukeScreen extends StatefulWidget {
  const LicnePreporukeScreen({super.key});

  @override
  State<LicnePreporukeScreen> createState() => _LicnePreporukeScreenState();
}

class _LicnePreporukeScreenState extends State<LicnePreporukeScreen> {
  late LicnaPreporukaProvider _provider;
  List<LicnaPreporuka> _preporuke = [];

  bool _loading = true;
  bool _prikaziPoslane = false;

  int _currentPage = 1;
  final int _pageSize = 10;
  int _totalCount = 0;

  @override
  void initState() {
    super.initState();
    _provider = context.read<LicnaPreporukaProvider>();
    _fetchPreporuke(page: 1);
  }

  Future<void> _fetchPreporuke({int page = 1}) async {
    if (!mounted) return;
    setState(() => _loading = true);

    final filter = <String, dynamic>{
      'page': page,
      'pageSize': _pageSize,
      if (_prikaziPoslane)
        'KorisnikPosiljalacId': AuthProvider.korisnikId
      else
        'KorisnikPrimalacId': AuthProvider.korisnikId,
      'orderBy': 'DatumPreporuke',
      'sortDirection': 'desc',
    };

    try {
      final result = await _provider.get(filter: filter);
      if (!mounted) return;
      setState(() {
        _preporuke = result.resultList;
        _totalCount = result.count;
        _currentPage = page;
      });
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
        setState(() => _loading = false);
      }
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
            else if (_preporuke.isEmpty)
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.mail,
                      color: Color(0xFF3C6E71),
                      size: 50,
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Text(
                        _prikaziPoslane
                            ? "Nemate poslanih preporuka."
                            : "Nemate primljenih preporuka.",
                        style: const TextStyle(
                          fontSize: 16,
                          color: Color(0xFF3C6E71),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              )
            else
              Column(
                children: [
                  _buildList(),
                  if (_totalCount > _pageSize) _buildPaging(),
                ],
              ),
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
              setState(() => _prikaziPoslane = true);
              _fetchPreporuke(page: 1);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  _prikaziPoslane ? Colors.pinkAccent : Colors.grey[300],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              padding: const EdgeInsets.symmetric(vertical: 12),
              elevation: _prikaziPoslane ? 8 : 3,
              shadowColor: Colors.black.withOpacity(0.3),
            ),
            child: Text(
              "Poslane",
              style: TextStyle(
                color: _prikaziPoslane ? Colors.white : Colors.grey[700],
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: ElevatedButton(
            onPressed: () {
              setState(() => _prikaziPoslane = false);
              _fetchPreporuke(page: 1);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  !_prikaziPoslane ? Colors.pinkAccent : Colors.grey[300],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              padding: const EdgeInsets.symmetric(vertical: 12),
              elevation: !_prikaziPoslane ? 8 : 3,
              shadowColor: Colors.black.withOpacity(0.3),
            ),
            child: Text(
              "Primljene",
              style: TextStyle(
                color: !_prikaziPoslane ? Colors.white : Colors.grey[700],
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
            "Lične preporuke",
            style: TextStyle(
              color: Colors.white,
              fontSize: 19,
              fontWeight: FontWeight.w600,
            ),
          ),
          Icon(Icons.mail_outline, color: Colors.white, size: 28),
        ],
      ),
    );
  }

  Widget _buildPreporukaCard(LicnaPreporuka preporuka) {
    return InkWell(
      onTap: () async {
        final refresh = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                LicnePreporukeDetailsScreen(licnaPreporuka: preporuka),
          ),
        );
        if (!mounted) return;

        if (refresh == true) {
          _fetchPreporuke(page: _currentPage);
        }
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                if (!_prikaziPoslane && !preporuka.jePogledana)
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: const Color(0xFF3C6E71).withOpacity(0.1),
                      border: Border.all(
                        color: const Color(0xFF3C6E71),
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      "NOVO",
                      style: TextStyle(
                        color: Color(0xFF3C6E71),
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    preporuka.naslov ?? '',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              DateFormat('dd.MM.yyyy')
                  .format(preporuka.datumPreporuke.toLocal()),
              style: const TextStyle(
                fontSize: 13,
                color: Colors.grey,
              ),
            ),
            const Divider(),
            Text(
              "Od: ${preporuka.posiljalacKorisnickoIme}",
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 4),
            Text(
              preporuka.poruka ?? '',
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildList() {
    return Column(
      children: _preporuke.map((e) => _buildPreporukaCard(e)).toList(),
    );
  }

  Widget _buildPaging() {
    int totalPages = (_totalCount / _pageSize).ceil();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: _currentPage > 1
                ? () => _fetchPreporuke(page: _currentPage - 1)
                : null,
            style: ElevatedButton.styleFrom(
              elevation: 6,
              shadowColor: Colors.black.withOpacity(0.3),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text("Prethodna"),
          ),
          const SizedBox(width: 20),
          Text("Stranica $_currentPage / $totalPages"),
          const SizedBox(width: 20),
          ElevatedButton(
            onPressed: _currentPage < totalPages
                ? () => _fetchPreporuke(page: _currentPage + 1)
                : null,
            style: ElevatedButton.styleFrom(
              elevation: 6,
              shadowColor: Colors.black.withOpacity(0.3),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text("Sljedeća"),
          ),
        ],
      ),
    );
  }
}
