import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:littrack_mobile/models/narudzba.dart';
import 'package:littrack_mobile/providers/narudzba_provider.dart';
import 'package:littrack_mobile/providers/auth_provider.dart';
import 'package:littrack_mobile/providers/utils.dart';
import 'package:littrack_mobile/screens/narudzbe_details_screen.dart';
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

  DateTime? _datumOd;
  DateTime? _datumDo;

  DateTime? _tempDatumOd;
  DateTime? _tempDatumDo;

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
      if (_datumOd != null)
        'DatumNarudzbeGTE': DateFormat('yyyy-MM-dd').format(_datumOd!),
      if (_datumDo != null)
        'DatumNarudzbeLTE': DateFormat('yyyy-MM-dd').format(_datumDo!),
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
      if (mounted) setState(() => _loading = false);
    }
  }

  void _clearSearch() {
    setState(() {
      selectedDisplayState = "Sve narudžbe";
      _datumOd = null;
      _datumDo = null;
      _currentPage = 1;
    });

    _fetchNarudzbe(page: 1);
  }

  Future<void> _showDateFilterDialog() async {
    _tempDatumOd = _tempDatumOd ?? _datumOd;
    _tempDatumDo = _tempDatumDo ?? _datumDo;

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color.fromARGB(255, 226, 236, 231),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          "Filter po datumu",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        content: StatefulBuilder(
          builder: (context, localSetState) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("OD:",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _tempDatumOd != null
                          ? DateFormat('dd.MM.yyyy').format(_tempDatumOd!)
                          : "Nije odabrano",
                      style: const TextStyle(fontSize: 16),
                    ),
                    IconButton(
                      icon: const Icon(Icons.calendar_today),
                      onPressed: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: _tempDatumOd ?? DateTime.now(),
                          firstDate: DateTime(2020),
                          lastDate: _tempDatumDo ?? DateTime.now(),
                        );

                        if (picked != null) {
                          localSetState(() {
                            _tempDatumOd = picked;

                            if (_tempDatumDo != null &&
                                _tempDatumDo!.isBefore(_tempDatumOd!)) {
                              _tempDatumDo = null;
                            }
                          });
                        }
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Text("DO:",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _tempDatumDo != null
                          ? DateFormat('dd.MM.yyyy').format(_tempDatumDo!)
                          : "Nije odabrano",
                      style: const TextStyle(fontSize: 16),
                    ),
                    IconButton(
                      icon: const Icon(Icons.calendar_today),
                      onPressed: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate:
                              _tempDatumDo ?? _tempDatumOd ?? DateTime.now(),
                          firstDate: _tempDatumOd ?? DateTime(2020),
                          lastDate: DateTime.now(),
                        );

                        if (picked != null) {
                          localSetState(() {
                            _tempDatumDo = picked;
                          });
                        }
                      },
                    ),
                  ],
                ),
              ],
            );
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(
              "Zatvori",
              style: TextStyle(color: Color(0xFF3C6E71)),
            ),
          ),
          ElevatedButton.icon(
            onPressed: () {
              setState(() {
                _datumOd = _tempDatumOd;
                _datumDo = _tempDatumDo;
                _currentPage = 1;
              });

              Navigator.of(context).pop();
              _fetchNarudzbe(page: 1);
            },
            icon: const Icon(Icons.check, color: Colors.white),
            label:
                const Text("Primijeni", style: TextStyle(color: Colors.white)),
            style: ButtonStyle(
              backgroundColor:
                  MaterialStateProperty.all(const Color(0xFF3C6E71)),
              shape: MaterialStateProperty.all(
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
              ),
              shadowColor:
                  MaterialStateProperty.all(Colors.black.withOpacity(0.3)),
              elevation: MaterialStateProperty.all(6),
            ),
          ),
        ],
      ),
    );
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
            const SizedBox(height: 12),
            _buildHeader(),
            if (_showSve) ...[
              const SizedBox(height: 12),
              _buildSearchFilters(),
            ],
            const SizedBox(height: 24),
            if (_loading)
              const Center(child: CircularProgressIndicator())
            else if (_narudzbe.isEmpty)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Icon(Icons.shopping_bag,
                          color: Color(0xFF3C6E71), size: 50),
                      SizedBox(height: 10),
                      Text(
                        "Nemate nijednu narudžbu.",
                        style:
                            TextStyle(fontSize: 16, color: Color(0xFF3C6E71)),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
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

  Widget _buildToggleButtons() {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: () {
              setState(() {
                _showSve = false;
                selectedDisplayState = "Sve narudžbe";
                _datumOd = null;
                _datumDo = null;
              });
              _fetchNarudzbe(page: 1);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: !_showSve ? Colors.pinkAccent : Colors.grey[300],
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
              backgroundColor: _showSve ? Colors.pinkAccent : Colors.grey[300],
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
    );
  }

  Widget _buildSearchFilters() {
    return Row(
      children: [
        Expanded(
          child: DropdownButtonFormField<String>(
            value: selectedDisplayState,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 10,
              ),
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
        ),
        const SizedBox(width: 10),
        GestureDetector(
          onTap: _showDateFilterDialog,
          child: const Icon(
            Icons.date_range,
            size: 30,
            color: Color(0xFF3C6E71),
          ),
        ),
        const SizedBox(width: 12),
        GestureDetector(
          onTap: _clearSearch,
          child: const Icon(
            Icons.clear,
            color: Colors.grey,
            size: 28,
          ),
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return Container(
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
                color: Colors.white, fontSize: 19, fontWeight: FontWeight.w600),
          ),
          Icon(Icons.shopping_bag_outlined, color: Colors.white, size: 28),
        ],
      ),
    );
  }

  Widget _buildGrid() {
    return Column(
      children: _narudzbe
          .map((n) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: _buildNarudzbaCard(n),
              ))
          .toList(),
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
      onTap: () async {
        final refresh = await Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => NarudzbeDetailsScreen(narudzba: n)),
        );

        if (!mounted) return;
        if (refresh == true) _fetchNarudzbe(page: _currentPage);
      },
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
                    style: const TextStyle(fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const Divider(),
            Text("Broj stavki: ${n.brojStavki ?? 0}"),
            Text("Ukupan iznos: ${n.ukupnaCijena.toStringAsFixed(2)} KM"),
            Text(
              "Datum: ${DateFormat('dd.MM.yyyy').format(n.datumNarudzbe.toLocal())}",
            ),
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
            onPressed: _currentPage > 1
                ? () => _fetchNarudzbe(page: _currentPage - 1)
                : null,
            child: const Text("Prethodna"),
          ),
          const SizedBox(width: 20),
          Text("Stranica $_currentPage / $totalPages"),
          const SizedBox(width: 20),
          ElevatedButton(
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
