import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:littrack_mobile/models/licna_preporuka.dart';
import 'package:littrack_mobile/providers/licna_preporuka_provider.dart';
import 'package:littrack_mobile/providers/auth_provider.dart';
import 'package:littrack_mobile/providers/utils.dart';
import 'package:provider/provider.dart';

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
  final int _pageSize = 6;
  int _totalCount = 0;

  @override
  void initState() {
    super.initState();
    _provider = context.read<LicnaPreporukaProvider>();
    _fetchPreporuke(page: 1);
  }

  Future<void> _fetchPreporuke({int page = 1}) async {
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
      setState(() {
        _preporuke = result.resultList;
        _totalCount = result.count;
        _currentPage = page;
      });
    } catch (e) {
      showCustomDialog(
        context: context,
        title: 'Greška',
        message: e.toString(),
        icon: Icons.error,
        iconColor: Colors.red,
      );
    } finally {
      setState(() => _loading = false);
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
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Text(
                  "Nema dostupnih preporuka.",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black54,
                  ),
                  textAlign: TextAlign.center,
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
            ),
            child: Text(
              "Poslane",
              style: TextStyle(
                color: _prikaziPoslane ? Colors.white : Colors.black,
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
            ),
            child: Text(
              "Primljene",
              style: TextStyle(
                color: !_prikaziPoslane ? Colors.white : Colors.black,
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
      onTap: () {
        // TODO: Navigacija na details screen
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.25),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                if (!preporuka.jePogledana)
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
            child: const Text("Prethodna"),
          ),
          const SizedBox(width: 20),
          Text("Stranica $_currentPage / $totalPages"),
          const SizedBox(width: 20),
          ElevatedButton(
            onPressed: _currentPage < totalPages
                ? () => _fetchPreporuke(page: _currentPage + 1)
                : null,
            child: const Text("Sljedeća"),
          ),
        ],
      ),
    );
  }
}
