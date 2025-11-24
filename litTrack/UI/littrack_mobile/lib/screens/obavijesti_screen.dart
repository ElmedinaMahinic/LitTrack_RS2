import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:littrack_mobile/models/obavijest.dart';
import 'package:littrack_mobile/providers/obavijest_provider.dart';
import 'package:littrack_mobile/providers/auth_provider.dart';
import 'package:littrack_mobile/providers/utils.dart';
import 'package:provider/provider.dart';

class ObavijestiScreen extends StatefulWidget {
  const ObavijestiScreen({super.key});

  @override
  State<ObavijestiScreen> createState() => _ObavijestiScreenState();
}

class _ObavijestiScreenState extends State<ObavijestiScreen> {
  late ObavijestProvider _provider;
  List<Obavijest> _obavijesti = [];

  bool _loading = true;
  bool _prikaziSve = false;

  int _currentPage = 1;
  final int _pageSize = 10;
  int _totalCount = 0;

  @override
  void initState() {
    super.initState();
    _provider = context.read<ObavijestProvider>();
    _fetchObavijesti(page: 1);
  }

  Future<void> _fetchObavijesti({int page = 1}) async {
    setState(() => _loading = true);

    final filter = <String, dynamic>{
      'page': page,
      'pageSize': _pageSize,
      'KorisnikId': AuthProvider.korisnikId,
      if (!_prikaziSve) 'JePogledana': false,
      'orderBy': 'DatumObavijesti',
      'sortDirection': 'desc',
    };

    try {
      final result = await _provider.get(filter: filter);

      if (!mounted) return;
      setState(() {
        _obavijesti = result.resultList;
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
          children: [
            _buildToggleButtons(),
            const SizedBox(height: 17),
            _buildHeader(),
            const SizedBox(height: 24),
            if (_loading)
              const Center(child: CircularProgressIndicator())
            else if (_obavijesti.isEmpty)
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
                        _prikaziSve
                            ? "Nemate obavijesti."
                            : "Nemate novih obavijesti.",
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
              setState(() => _prikaziSve = true);
              _fetchObavijesti(page: 1);
            },
            style: ElevatedButton.styleFrom(
              elevation: _prikaziSve ? 8 : 3,
              shadowColor: Colors.black.withOpacity(0.3),
              backgroundColor:
                  _prikaziSve ? Colors.pinkAccent : Colors.grey[300],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
            child: Text(
              "Sve",
              style: TextStyle(
                color: _prikaziSve ? Colors.white : Colors.grey[700],
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: ElevatedButton(
            onPressed: () {
              setState(() => _prikaziSve = false);
              _fetchObavijesti(page: 1);
            },
            style: ElevatedButton.styleFrom(
              elevation: !_prikaziSve ? 8 : 3,
              shadowColor: Colors.black.withOpacity(0.3),
              backgroundColor:
                  !_prikaziSve ? Colors.pinkAccent : Colors.grey[300],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
            child: Text(
              "Nove",
              style: TextStyle(
                color: !_prikaziSve ? Colors.white : Colors.grey[700],
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
            "Obavijesti",
            style: TextStyle(
              color: Colors.white,
              fontSize: 19,
              fontWeight: FontWeight.w600,
            ),
          ),
          Icon(Icons.notifications_none, color: Colors.white, size: 28),
        ],
      ),
    );
  }

  Widget _buildObavijestCard(Obavijest obavijest) {
    return InkWell(
      onTap: () {},
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
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
                if (!obavijest.jePogledana)
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
                    obavijest.naslov,
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
                  .format(obavijest.datumObavijesti.toLocal()),
              style: const TextStyle(
                fontSize: 13,
                color: Colors.grey,
              ),
            ),
            const Divider(),
            Text(
              obavijest.sadrzaj,
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
      children: _obavijesti.map((e) => _buildObavijestCard(e)).toList(),
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
            style: ElevatedButton.styleFrom(
              elevation: 6,
              shadowColor: Colors.black.withOpacity(0.3),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: _currentPage > 1
                ? () => _fetchObavijesti(page: _currentPage - 1)
                : null,
            child: const Text("Prethodna"),
          ),
          const SizedBox(width: 20),
          Text("Stranica $_currentPage / $totalPages"),
          const SizedBox(width: 20),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              elevation: 6,
              shadowColor: Colors.black.withOpacity(0.3),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: _currentPage < totalPages
                ? () => _fetchObavijesti(page: _currentPage + 1)
                : null,
            child: const Text("Sljedeća"),
          ),
        ],
      ),
    );
  }
}
