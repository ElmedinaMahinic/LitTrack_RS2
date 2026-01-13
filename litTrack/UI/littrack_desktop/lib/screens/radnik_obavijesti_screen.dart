import 'package:flutter/material.dart';
import 'package:littrack_desktop/layouts/master_screen.dart';
import 'package:littrack_desktop/models/obavijest.dart';
import 'package:littrack_desktop/providers/obavijest_provider.dart';
import 'package:littrack_desktop/providers/auth_provider.dart';
import 'package:littrack_desktop/providers/utils.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:littrack_desktop/screens/radnik_obavijesti_details.dart';

class RadnikObavijestiScreen extends StatefulWidget {
  const RadnikObavijestiScreen({super.key});

  @override
  State<RadnikObavijestiScreen> createState() => _RadnikObavijestiScreenState();
}

class _RadnikObavijestiScreenState extends State<RadnikObavijestiScreen> {
  final TextEditingController _naslovController = TextEditingController();
  late ObavijestProvider _provider;

  List<Obavijest> _obavijesti = [];
  bool _loading = true;
  bool _showHistorija = false;
  bool _samoStare = false;
  DateTime? _selectedDate;

  int _currentPage = 1;
  final int _pageSize = 8;
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
      if (_naslovController.text.isNotEmpty) 'Naslov': _naslovController.text,
      if (!_showHistorija) 'JePogledana': false,
      if (_showHistorija && _samoStare) 'JePogledana': true,
      if (_selectedDate != null)
        'DatumObavijestiLTE': DateFormat('yyyy-MM-dd').format(_selectedDate!),
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
      if (mounted) setState(() => _loading = false);
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
      _fetchObavijesti(page: 1);
    }
  }

  void _clearFilters() {
    if (!mounted) return;
    setState(() {
      _naslovController.clear();
      _samoStare = false;
      _showHistorija = false;
      _selectedDate = null;
    });
    _fetchObavijesti(page: 1);
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
                ? () => _fetchObavijesti(page: _currentPage - 1)
                : null,
          ),
          Text("Stranica $_currentPage od $totalPages"),
          IconButton(
            icon: const Icon(Icons.chevron_right),
            onPressed: _currentPage < totalPages
                ? () => _fetchObavijesti(page: _currentPage + 1)
                : null,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreen(
      title: _showHistorija ? 'Historija obavijesti' : 'Nove obavijesti',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSearchBar(),
          const SizedBox(height: 10),
          if (_loading)
            const Center(child: CircularProgressIndicator())
          else if (_obavijesti.isEmpty)
            const Padding(
              padding: EdgeInsets.all(25.0),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.notifications_outlined,
                      size: 60,
                      color: Color(0xFF3C6E71),
                    ),
                    SizedBox(height: 16),
                    Text(
                      "Nema dostupnih obavijesti",
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
                _buildObavijestiCards(),
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
                  controller: _naslovController,
                  decoration: InputDecoration(
                    labelText: 'Pretraga po naslovu',
                    hintText: 'Unesite naslov obavijesti',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 12),
                  ),
                  onChanged: (_) => _fetchObavijesti(page: 1),
                ),
              ),
              const SizedBox(width: 15),
              if (_showHistorija)
                ElevatedButton(
                  onPressed: _pickDate,
                  style: _buttonStyle(),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.calendar_today, color: Colors.white),
                      const SizedBox(width: 8),
                      Text(
                        _selectedDate != null
                            ? 'Obavijesti do: ${DateFormat('dd.MM.yyyy').format(_selectedDate!)}'
                            : 'Odaberi datum',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              const SizedBox(width: 10),
              ElevatedButton(
                onPressed: _clearFilters,
                style: _buttonStyle(),
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
                    ? 'Filtrirajte obavijesti po naslovu i/ili do određenog datuma'
                    : 'Filtrirajte obavijesti po naslovu',
                decoration: _tooltipDecoration(),
                textStyle: _tooltipTextStyle(),
                child: const Icon(Icons.info_outline,
                    color: Colors.grey, size: 20),
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
                    _samoStare = false;
                    _selectedDate = null;
                  });
                  _fetchObavijesti(page: 1);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: !_showHistorija
                      ? const Color(0xFF3C6E71)
                      : Colors.grey[400],
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                ),
                child: Text(
                  'Nove obavijesti',
                  style: TextStyle(
                    color: !_showHistorija ? Colors.white : Colors.black87,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _showHistorija = true;
                  });
                  _fetchObavijesti(page: 1);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: _showHistorija
                      ? const Color(0xFF3C6E71)
                      : Colors.grey[400],
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                ),
                child: Text(
                  'Historija obavijesti',
                  style: TextStyle(
                    color: _showHistorija ? Colors.white : Colors.black87,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Tooltip(
                message:
                    'Izaberite da prikažete nove obavijesti ili historiju svih obavijesti',
                decoration: _tooltipDecoration(),
                textStyle: _tooltipTextStyle(),
                child: const Icon(Icons.info_outline,
                    color: Colors.grey, size: 20),
              ),
            ],
          ),
          if (_showHistorija) ...[
            const SizedBox(height: 17),
            Row(
              children: [
                Checkbox(
                  value: _samoStare,
                  onChanged: (val) {
                    setState(() {
                      _samoStare = val ?? false;
                    });
                    _fetchObavijesti(page: 1);
                  },
                ),
                const Text("Samo stare obavijesti"),
              ],
            ),
          ]
        ],
      ),
    );
  }

  Widget _buildObavijestiCards() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Center(
        child: Wrap(
          spacing: 60,
          runSpacing: 30,
          alignment: WrapAlignment.center,
          children: _obavijesti.map((obavijest) {
            return ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: 310,
                maxHeight: 170,
              ),
              child: SizedBox(
                width: 310,
                child: _buildObavijestCard(obavijest),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildObavijestCard(Obavijest obavijest) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      hoverColor: Colors.grey.withAlpha(26),
      onTap: () async {
        final refresh = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RadnikObavijestiDetailsScreen(
              obavijest: obavijest,
            ),
          ),
        );

        if (refresh == true) {
          await _fetchObavijesti(page: _currentPage);
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withAlpha(77),
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
                  message: obavijest.jePogledana
                      ? "Stara obavijest"
                      : "Nova obavijest",
                  child: obavijest.jePogledana
                      ? const Icon(
                          Icons.circle,
                          color: Colors.grey,
                        )
                      : Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          height: 24,
                          decoration: BoxDecoration(
                            color: const Color(0xFF3C6E71).withAlpha(26),
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
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    obavijest.naslov,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
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
            Expanded(
              child: Text(
                obavijest.sadrzaj,
                maxLines: 4,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  ButtonStyle _buttonStyle() {
    return ButtonStyle(
      backgroundColor: WidgetStateProperty.resolveWith<Color>((states) {
        if (states.contains(WidgetState.pressed) ||
            states.contains(WidgetState.selected)) {
          return const Color(0xFF41706A);
        }
        if (states.contains(WidgetState.hovered)) {
          return const Color(0xFF51968F);
        }
        return const Color(0xFF3C6E71);
      }),
      padding: WidgetStateProperty.all(
        const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      ),
      shape: WidgetStateProperty.all(
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  BoxDecoration _tooltipDecoration() {
    return BoxDecoration(
      color: const Color.fromARGB(255, 128, 136, 132),
      borderRadius: BorderRadius.circular(8),
      border: Border.all(
        color: const Color.fromARGB(255, 96, 102, 102),
        width: 1,
      ),
    );
  }

  TextStyle _tooltipTextStyle() {
    return const TextStyle(
      color: Color.fromARGB(255, 246, 246, 246),
      fontSize: 14.5,
    );
  }
}
