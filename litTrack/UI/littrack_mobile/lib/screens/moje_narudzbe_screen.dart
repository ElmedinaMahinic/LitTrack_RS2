import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:littrack_mobile/models/narudzba.dart';
import 'package:littrack_mobile/providers/narudzba_provider.dart';
import 'package:littrack_mobile/providers/auth_provider.dart';
import 'package:littrack_mobile/providers/utils.dart';
import 'package:provider/provider.dart';

class MojeNarudzbeScreen extends StatefulWidget {
  const MojeNarudzbeScreen({super.key});

  @override
  State<MojeNarudzbeScreen> createState() => _MojeNarudzbeScreenState();
}

class _MojeNarudzbeScreenState extends State<MojeNarudzbeScreen> {
  late NarudzbaProvider _provider;
  List<Narudzba> _narudzbe = [];
  bool _loading = true;
  bool _showSve = false;

  int _currentPage = 1;
  final int _pageSize = 10;
  int _totalCount = 0;

  final Map<String, String?> stateDisplayToValue = {
    "Sve narudžbe": null,
    'Kreirane narudžbe': 'kreirana',
    'Narudžbe u toku': 'uToku',
    'Preuzete narudžbe': 'preuzeta',
    'Poništene narudžbe': 'ponistena',
    'Završene narudžbe': 'zavrsena',
  };

  String? selectedDisplayState = "Sve narudžbe";
  List<String> get availableDisplayStates => stateDisplayToValue.keys.toList();

  @override
  void initState() {
    super.initState();
    _provider = context.read<NarudzbaProvider>();
    _fetchNarudzbe(page: 1);
  }

  Future<void> _fetchNarudzbe({int page = 1}) async {
    setState(() => _loading = true);

    final filter = <String, dynamic>{
      'page': page,
      'pageSize': _pageSize,
      'KorisnikId': AuthProvider.korisnikId,
      if (!_showSve) 'StateMachine': ['kreirana', 'uToku', 'preuzeta'],
      if (_showSve && selectedDisplayState != "Sve narudžbe")
        'StateMachine': stateDisplayToValue[selectedDisplayState],
    };

    try {
      final result = await _provider.get(filter: filter);

      if (!mounted) return;
      setState(() {
        _narudzbe = result.resultList;
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
            _buildHeader(),
            const SizedBox(height: 12),
            _buildSearchBox(),
            const SizedBox(height: 24),
            if (_loading)
              const Center(child: CircularProgressIndicator())
            else if (_narudzbe.isEmpty)
              const Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.shopping_bag,
                      color: Color(0xFF3C6E71),
                      size: 50,
                    ),
                    SizedBox(height: 10),
                    Padding(
                      padding: EdgeInsets.all(20),
                      child: Text(
                        "Nemate nijednu narudžbu.",
                        style: TextStyle(
                          fontSize: 16,
                          color: Color(0xFF3C6E71),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              )
            else ...[
              _buildGrid(),
              const SizedBox(height: 20),
              if (_totalCount > _pageSize) _buildPaging(),
            ],
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
            "Moje narudžbe",
            style: TextStyle(
              color: Colors.white,
              fontSize: 19,
              fontWeight: FontWeight.w600,
            ),
          ),
          Icon(Icons.shopping_bag_outlined, color: Colors.white, size: 28),
        ],
      ),
    );
  }

  Widget _buildSearchBox() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    _showSve = false;
                    selectedDisplayState = "Sve narudžbe";
                  });
                  _fetchNarudzbe(page: 1);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      !_showSve ? Colors.pinkAccent : Colors.grey[300],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  elevation: !_showSve ? 8 : 3,
                  shadowColor: Colors.black.withOpacity(0.3),
                ),
                child: Text(
                  "Aktivne",
                  style: TextStyle(
                    color: !_showSve ? Colors.white : Colors.grey[700],
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    _showSve = true;
                  });
                  _fetchNarudzbe(page: 1);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      _showSve ? Colors.pinkAccent : Colors.grey[300],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  elevation: _showSve ? 8 : 3,
                  shadowColor: Colors.black.withOpacity(0.3),
                ),
                child: Text(
                  "Sve",
                  style: TextStyle(
                    color: _showSve ? Colors.white : Colors.grey[700],
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
        if (_showSve) ...[
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            value: selectedDisplayState,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              filled: true,
              fillColor: Colors.white,
            ),
            items: availableDisplayStates.map((display) {
              return DropdownMenuItem<String>(
                value: display,
                child: Text(display),
              );
            }).toList(),
            onChanged: (newValue) {
              setState(() {
                selectedDisplayState = newValue;
              });
              _fetchNarudzbe(page: 1);
            },
          ),
        ],
      ],
    );
  }

  Widget _buildGrid() {
    return Column(
      children: _narudzbe.map((n) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: _buildNarudzbaCard(n),
        );
      }).toList(),
    );
  }

  Widget _buildNarudzbaCard(Narudzba n) {
    Icon getStateIcon(String? state) {
      switch (state) {
        case 'preuzeta':
          return const Icon(Icons.checklist, color: Colors.blueGrey);
        case 'zavrsena':
          return const Icon(Icons.check_circle, color: Colors.green);
        case 'uToku':
          return const Icon(Icons.local_shipping, color: Colors.orange);
        case 'ponistena':
          return const Icon(Icons.cancel, color: Colors.red);
        default:
          return const Icon(Icons.shopping_cart, color: Colors.grey);
      }
    }

    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () {},
      child: Container(
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
                getStateIcon(n.stateMachine),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    n.sifra,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const Divider(),
            Text("Broj stavki: ${n.brojStavki ?? 0}"),
            Text("Ukupan iznos: ${n.ukupnaCijena.toStringAsFixed(2)} KM"),
            Text(
                "Datum: ${DateFormat('dd.MM.yyyy').format(n.datumNarudzbe.toLocal())}"),
          ],
        ),
      ),
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
                ? () => _fetchNarudzbe(page: _currentPage - 1)
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
                ? () => _fetchNarudzbe(page: _currentPage + 1)
                : null,
            child: const Text("Sljedeća"),
          ),
        ],
      ),
    );
  }
}
