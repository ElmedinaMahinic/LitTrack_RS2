import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:littrack_desktop/layouts/master_screen.dart';
import 'package:littrack_desktop/models/narudzba.dart';
import 'package:littrack_desktop/providers/narudzba_provider.dart';
import 'package:littrack_desktop/providers/utils.dart';
import 'package:provider/provider.dart';
import 'package:littrack_desktop/screens/radnik_narudzbe_details.dart';

class RadnikNarudzbeScreen extends StatefulWidget {
  const RadnikNarudzbeScreen({super.key});

  @override
  State<RadnikNarudzbeScreen> createState() => _RadnikNarudzbeScreenState();
}

class _RadnikNarudzbeScreenState extends State<RadnikNarudzbeScreen> {
  final TextEditingController _sifraController = TextEditingController();
  DateTime? _selectedDate;
  late NarudzbaProvider _provider;
  List<Narudzba> _narudzbe = [];
  bool _loading = true;
  bool _showHistorija = false;

  int _currentPage = 1;
  final int _pageSize = 8;
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
    if (!mounted) return;
    setState(() => _loading = true);

    final filter = <String, dynamic>{
      'page': page,
      'pageSize': _pageSize,
      if (_sifraController.text.isNotEmpty) 'Sifra': _sifraController.text,
      if (!_showHistorija) 'StateMachine': ['kreirana', 'uToku', 'preuzeta'],
      if (_selectedDate != null) ...{
        'DatumNarudzbeLTE': DateFormat('yyyy-MM-dd').format(_selectedDate!),
      },
      if (_showHistorija && selectedDisplayState != "Sve narudžbe")
        'StateMachine': stateDisplayToValue[selectedDisplayState],
      'orderBy': 'DatumNarudzbe',
      'sortDirection': 'desc',
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

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      if (!mounted) return;
      setState(() => _selectedDate = picked);
      _fetchNarudzbe(page: 1);
    }
  }

  void _clearFilters() {
    if (!mounted) return;
    setState(() {
      _selectedDate = null;
      _sifraController.clear();
      selectedDisplayState = "Sve narudžbe";
    });
    _fetchNarudzbe(page: 1);
  }

  Widget _buildPaginationControls() {
    int totalPages = (_totalCount / _pageSize).ceil();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            icon: const Icon(Icons.chevron_left),
            onPressed: _currentPage > 1
                ? () => _fetchNarudzbe(page: _currentPage - 1)
                : null,
          ),
          Text("Stranica $_currentPage od $totalPages"),
          IconButton(
            icon: const Icon(Icons.chevron_right),
            onPressed: _currentPage < totalPages
                ? () => _fetchNarudzbe(page: _currentPage + 1)
                : null,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreen(
      title: _showHistorija ? 'Historija narudžbi' : 'Narudžbe',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSearchBar(),
          const SizedBox(height: 10),
          if (_loading)
            const Center(child: CircularProgressIndicator())
          else if (_narudzbe.isEmpty)
            const Padding(
              padding: EdgeInsets.all(25.0),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.shopping_cart_outlined,
                      size: 60,
                      color: Color(0xFF3C6E71),
                    ),
                    SizedBox(height: 16),
                    Text(
                      "Nema dostupnih narudžbi",
                      style: TextStyle(
                        fontSize: 18,
                        color: Color(0xFF3C6E71),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            )
          else
            Column(
              children: [
                _buildNarudzbeCards(),
                if (_totalCount > _pageSize) _buildPaginationControls(),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                flex: 3,
                child: TextField(
                  controller: _sifraController,
                  decoration: InputDecoration(
                    labelText: 'Pretraga po šifri',
                    hintText: 'Unesite šifru narudžbe',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 12),
                  ),
                  onChanged: (_) => _fetchNarudzbe(page: 1),
                ),
              ),
              const SizedBox(width: 15),
              if (_showHistorija)
                ElevatedButton(
                  onPressed: _pickDate,
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.resolveWith<Color>((states) {
                      if (states.contains(MaterialState.pressed) ||
                          states.contains(MaterialState.selected)) {
                        return const Color(0xFF41706A);
                      }
                      if (states.contains(MaterialState.hovered)) {
                        return const Color(0xFF51968F);
                      }
                      return const Color(0xFF3C6E71);
                    }),
                    padding: MaterialStateProperty.all(
                        const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 16)),
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    )),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.calendar_today, color: Colors.white),
                      const SizedBox(width: 8),
                      Text(
                        _selectedDate != null
                            ? 'Narudžbe do: ${DateFormat('dd.MM.yyyy').format(_selectedDate!)}'
                            : 'Odaberi datum',
                        style: const TextStyle(
                            color: Colors.white, fontWeight: FontWeight.w600),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              const SizedBox(width: 10),
              ElevatedButton(
                onPressed: _clearFilters,
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.resolveWith<Color>((states) {
                    if (states.contains(MaterialState.pressed) ||
                        states.contains(MaterialState.selected)) {
                      return const Color(0xFF41706A);
                    }
                    if (states.contains(MaterialState.hovered)) {
                      return const Color(0xFF51968F);
                    }
                    return const Color(0xFF3C6E71);
                  }),
                  padding: MaterialStateProperty.all(
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 16)),
                  shape: MaterialStateProperty.all(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  )),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.clear, color: Colors.white),
                    SizedBox(width: 8),
                    Text("Očisti filter",
                        style: TextStyle(color: Colors.white)),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Tooltip(
                message: _showHistorija
                    ? 'Filtrirajte narudžbe po šifri i/ili do određenog datuma'
                    : 'Filtrirajte narudžbe po šifri',
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 128, 136, 132),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: const Color.fromARGB(255, 96, 102, 102),
                    width: 1,
                  ),
                ),
                textStyle: const TextStyle(
                  color: Color.fromARGB(255, 246, 246, 246),
                  fontSize: 14.5,
                ),
                child: const Icon(
                  Icons.info_outline,
                  color: Colors.grey,
                  size: 20,
                ),
              ),
            ],
          ),
          const SizedBox(height: 17),
          Row(
            children: [
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _showHistorija = false;
                    selectedDisplayState = "Sve narudžbe";
                    _selectedDate = null;
                  });
                  _fetchNarudzbe(page: 1);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: !_showHistorija
                      ? const Color(0xFF3C6E71)
                      : Colors.grey[400],
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  elevation: 0,
                ),
                child: Text(
                  'Aktivne narudžbe',
                  style: TextStyle(
                    color: !_showHistorija ? Colors.white : Colors.black87,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _showHistorija = true;
                  });
                  _fetchNarudzbe(page: 1);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: _showHistorija
                      ? const Color(0xFF3C6E71)
                      : Colors.grey[400],
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  elevation: 0,
                ),
                child: Text(
                  'Historija narudžbi',
                  style: TextStyle(
                    color: _showHistorija ? Colors.white : Colors.black87,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Tooltip(
                message:
                    'Izaberite da prikažete aktivne narudžbe ili historiju svih narudžbi',
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 128, 136, 132),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: const Color.fromARGB(255, 96, 102, 102),
                    width: 1,
                  ),
                ),
                textStyle: const TextStyle(
                  color: Color.fromARGB(255, 246, 246, 246),
                  fontSize: 14.5,
                ),
                child: const Icon(
                  Icons.info_outline,
                  color: Colors.grey,
                  size: 20,
                ),
              ),
            ],
          ),
          if (_showHistorija) ...[
            const SizedBox(height: 17),
            Row(
              children: [
                Flexible(
                  fit: FlexFit.loose,
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 250),
                    child: DropdownButtonFormField<String>(
                      value: selectedDisplayState,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 14),
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
                  ),
                ),
                const SizedBox(width: 12),
                Tooltip(
                  message: 'Filtrirajte narudžbe po statusu',
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 128, 136, 132),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: const Color.fromARGB(255, 96, 102, 102),
                      width: 1,
                    ),
                  ),
                  textStyle: const TextStyle(
                    color: Color.fromARGB(255, 246, 246, 246),
                    fontSize: 14.5,
                  ),
                  child: const Icon(
                    Icons.info_outline,
                    color: Colors.grey,
                    size: 20,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildNarudzbeCards() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Center(
        child: Wrap(
          spacing: 60,
          runSpacing: 30,
          alignment: WrapAlignment.center,
          children: _narudzbe.map((narudzba) {
            return ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: 310,
                maxHeight: 165,
              ),
              child: SizedBox(
                width: 310,
                child: _buildNarudzbaCard(narudzba),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildNarudzbaCard(Narudzba narudzba) {
    Icon getStateIcon(String? stateMachine) {
      switch (stateMachine) {
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
      hoverColor: Colors.grey.withOpacity(0.1),
      onTap: () async {
        final refresh = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                RadnikNarudzbeDetailsScreen(narudzba: narudzba),
          ),
        );

        if (refresh == true) {
          _fetchNarudzbe(page: _currentPage);
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
                Tooltip(
                  message: narudzba.stateMachine ?? 'Nepoznato stanje',
                  child: getStateIcon(narudzba.stateMachine),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    "Narudžba: ${narudzba.sifra}",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const Divider(),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  _buildLabelValue("Kupac", narudzba.imePrezime),
                  const SizedBox(height: 4),
                  _buildLabelValue(
                    "Detalji",
                    "${narudzba.brojStavki ?? 0} ${_getStavkeTekst(narudzba.brojStavki ?? 0)}, "
                        "${narudzba.ukupanBrojKnjiga ?? 0} ${_getKnjigaTekst(narudzba.ukupanBrojKnjiga ?? 0)}",
                  ),
                  const SizedBox(height: 4),
                  _buildLabelValue("Ukupan iznos",
                      "${narudzba.ukupnaCijena.toStringAsFixed(2)} KM"),
                  const SizedBox(height: 4),
                  _buildLabelValue(
                    "Datum",
                    DateFormat('dd.MM.yyyy')
                        .format(narudzba.datumNarudzbe.toLocal()),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLabelValue(String label, String? value) {
    return Text.rich(
      TextSpan(
        text: "$label: ",
        style: const TextStyle(fontWeight: FontWeight.w500),
        children: [
          TextSpan(
            text: value ?? '',
            style: const TextStyle(fontWeight: FontWeight.normal),
          ),
        ],
      ),
      overflow: TextOverflow.ellipsis,
    );
  }

  String _getKnjigaTekst(int broj) {
    if (broj == 1) return "knjiga";
    if (broj >= 2 && broj <= 4) return "knjige";
    return "knjiga";
  }

  String _getStavkeTekst(int broj) {
    if (broj == 1) return "stavka";
    if (broj >= 2 && broj <= 4) return "stavke";
    return "stavki";
  }
}
