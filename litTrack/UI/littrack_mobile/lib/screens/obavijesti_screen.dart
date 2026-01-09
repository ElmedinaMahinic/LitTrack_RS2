import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:littrack_mobile/models/obavijest.dart';
import 'package:littrack_mobile/providers/obavijest_provider.dart';
import 'package:littrack_mobile/screens/obavijesti_details_screen.dart';
import 'package:littrack_mobile/providers/auth_provider.dart';
import 'package:littrack_mobile/providers/utils.dart';
import 'package:provider/provider.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

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

  final TextEditingController _searchController = TextEditingController();

  DateTime? _datumOd;
  DateTime? _datumDo;

  DateTime? _tempDatumOd;
  DateTime? _tempDatumDo;

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
      if (_searchController.text.isNotEmpty) 'Naslov': _searchController.text,
      if (_datumOd != null)
        'DatumObavijestiGTE': DateFormat('yyyy-MM-dd').format(_datumOd!),
      if (_datumDo != null)
        'DatumObavijestiLTE': DateFormat('yyyy-MM-dd').format(_datumDo!),
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

  Future<void> _deleteObavijest(Obavijest obavijest) async {
    try {
      await _provider.delete(obavijest.obavijestId!);

      if (!mounted) return;
      await showCustomDialog(
        context: context,
        title: "Uspješno",
        message: "Obavijest je obrisana.",
        icon: Icons.check_circle,
        iconColor: Colors.green,
      );

      if (!mounted) return;
      _fetchObavijesti(page: _currentPage);
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

  void _clearSearch() {
    _searchController.clear();
    _datumOd = null;
    _datumDo = null;
    _currentPage = 1;
    _fetchObavijesti(page: 1);
  }

  Future<void> _showDateFilterDialog() async {
    _tempDatumOd = _tempDatumOd ?? _datumOd;
    _tempDatumDo = _tempDatumDo ?? _datumDo;

    await showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setLocalState) {
            return AlertDialog(
              backgroundColor: const Color.fromARGB(255, 226, 236, 231),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              title: const Text(
                "Filter po datumu",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              content: Column(
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
                            setLocalState(() {
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
                            setLocalState(() {
                              _tempDatumDo = picked;
                            });
                          }
                        },
                      ),
                    ],
                  ),
                ],
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
                    _fetchObavijesti(page: 1);
                  },
                  icon: const Icon(Icons.check, color: Colors.white),
                  label: const Text("Primijeni",
                      style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF3C6E71),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    shadowColor: Colors.black.withAlpha(77),
                    elevation: 6,
                  ),
                ),
              ],
            );
          },
        );
      },
    );
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
            const SizedBox(height: 14),
            _buildSearchBox(),
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

  Widget _buildSearchBox() {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: "Pretraži...",
              hintStyle: const TextStyle(color: Colors.grey),
              prefixIcon: const Icon(Icons.search, color: Colors.grey),
              suffixIcon: IconButton(
                icon: const Icon(Icons.clear, color: Colors.grey),
                onPressed: _clearSearch,
              ),
              filled: true,
              fillColor: Colors.white,
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.grey, width: 1.2),
                borderRadius: BorderRadius.circular(16),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.grey, width: 1.5),
                borderRadius: BorderRadius.circular(16),
              ),
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
            ),
            style: const TextStyle(color: Colors.grey),
            onChanged: (value) {
              _currentPage = 1;
              _fetchObavijesti();
            },
          ),
        ),
        const SizedBox(width: 10),
        GestureDetector(
          onTap: _showDateFilterDialog,
          child: const Icon(Icons.date_range, color: Colors.grey, size: 28),
        ),
      ],
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
              shadowColor: Colors.black.withAlpha(77),
              backgroundColor:
                  _prikaziSve ? const Color(0xFFD55B91) : Colors.grey[300],
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
              shadowColor: Colors.black.withAlpha(77),
              backgroundColor:
                  !_prikaziSve ? const Color(0xFFD55B91) : Colors.grey[300],
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
            color: Colors.black.withAlpha(51),
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
    return Slidable(
      key: ValueKey(obavijest.obavijestId),
      endActionPane: ActionPane(
        motion: const BehindMotion(),
        children: [
          SlidableAction(
            backgroundColor: Colors.black,
            icon: Icons.delete,
            label: "Obriši",
            onPressed: (_) {
              showConfirmDialog(
                context: context,
                title: "Brisanje obavijesti",
                message: "Da li ste sigurni da želite obrisati obavijest?",
                icon: Icons.delete,
                iconColor: Colors.red,
                onConfirm: () => _deleteObavijest(obavijest),
              );
            },
          ),
        ],
      ),
      child: InkWell(
        onTap: () async {
          final refresh = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  ObavijestiDetailsScreen(obavijest: obavijest),
            ),
          );

          if (!mounted) return;

          if (refresh == true) {
            _fetchObavijesti(page: _currentPage);
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
                color: Colors.grey.withAlpha(51),
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
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 2),
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
              shadowColor: Colors.black.withAlpha(77),
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
              shadowColor: Colors.black.withAlpha(77),
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
