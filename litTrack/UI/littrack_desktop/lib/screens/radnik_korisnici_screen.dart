import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:littrack_desktop/models/korisnik.dart';
import 'package:littrack_desktop/models/uloga.dart';
import 'package:littrack_desktop/providers/korisnik_provider.dart';
import 'package:littrack_desktop/providers/uloga_provider.dart';
import 'package:littrack_desktop/providers/utils.dart';
import 'package:littrack_desktop/layouts/master_screen.dart';
import 'package:littrack_desktop/screens/korisnici_details_screen.dart';
import 'package:advanced_datatable/datatable.dart';
import 'package:advanced_datatable/advanced_datatable_source.dart';

class RadnikKorisniciScreen extends StatefulWidget {
  const RadnikKorisniciScreen({super.key});

  @override
  State<RadnikKorisniciScreen> createState() => _RadnikKorisniciScreenState();
}

class _RadnikKorisniciScreenState extends State<RadnikKorisniciScreen> {
  final TextEditingController _korisnickoImeController =
      TextEditingController();
  Uloga? _selectedUloga;

  late KorisnikProvider _korisnikProvider;
  late UlogaProvider _ulogaProvider;
  late KorisnikDataSource _dataSource;

  List<Uloga> _ulogeList = [];

  @override
  void initState() {
    super.initState();
    _korisnikProvider = context.read<KorisnikProvider>();
    _ulogaProvider = context.read<UlogaProvider>();

    _dataSource = KorisnikDataSource(
      provider: _korisnikProvider,
      context: context,
    );

    _loadUloge();
    _dataSource.loadInitial();
  }

  Future<void> _loadUloge() async {
    final result = await _ulogaProvider.get();
    if (!mounted) return;
    setState(() {
      _ulogeList = result.resultList;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreen(
      title: "Korisnici",
      child: Column(
        children: [
          _buildSearchSection(),
          const SizedBox(height: 15),
          _buildTable(),
        ],
      ),
    );
  }

  Widget _buildSearchSection() {
    return Padding(
      padding: const EdgeInsets.all(25),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: TextField(
              controller: _korisnickoImeController,
              decoration: InputDecoration(
                labelText: 'Korisničko ime',
                hintText: 'Unesite korisničko ime',
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                filled: true,
                fillColor: Colors.white,
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
              ),
              onChanged: (value) {
                _dataSource.filterServerSide(value, _selectedUloga?.ulogaId);
              },
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            flex: 2,
            child: DropdownButtonFormField<Uloga>(
              decoration: InputDecoration(
                hintText: 'Uloga',
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                filled: true,
                fillColor: Colors.white,
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
              ),
              initialValue: _selectedUloga,
              items: _ulogeList
                  .map((uloga) =>
                      DropdownMenuItem(value: uloga, child: Text(uloga.naziv)))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _selectedUloga = value;
                });
                _dataSource.filterServerSide(
                    _korisnickoImeController.text, _selectedUloga?.ulogaId);
              },
            ),
          ),
          const SizedBox(width: 20),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _korisnickoImeController.clear();
                _selectedUloga = null;
              });
              _dataSource.filterServerSide('', null);
            },
            style: ButtonStyle(
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
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 16)),
              shape: WidgetStateProperty.all(RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              )),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.clear, color: Colors.white),
                SizedBox(width: 8),
                Text("Očisti filtere", style: TextStyle(color: Colors.white)),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Tooltip(
            message: 'Filtrirajte korisnike po korisničkom imenu i/ili ulozi.',
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
    );
  }

  Widget _buildTable() {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: DataTableTheme(
        data: DataTableThemeData(
          headingRowColor: WidgetStateProperty.all(
            const Color.fromARGB(255, 213, 224, 219),
          ),
          headingTextStyle: const TextStyle(
            color: Color(0xFF3C6E71),
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
          dataTextStyle: const TextStyle(fontSize: 15),
        ),
        child: AdvancedPaginatedDataTable(
          showCheckboxColumn: false,
          addEmptyRows: false,
          source: _dataSource,
          rowsPerPage: _dataSource.pageSize,
          showFirstLastButtons: true,
          columns: const [
            DataColumn(label: Text("ULOGE")),
            DataColumn(label: Text("KORISNIČKO IME")),
            DataColumn(label: Text("EMAIL")),
            DataColumn(label: Text("OPCIJE")),
          ],
        ),
      ),
    );
  }
}

class KorisnikDataSource extends AdvancedDataTableSource<Korisnik> {
  final KorisnikProvider provider;
  final BuildContext context;

  List<Korisnik> data = [];
  int page = 1;
  final int pageSize = 10;
  int count = 0;
  String korisnickoImeFilter = '';
  int? ulogaIdFilter;

  KorisnikDataSource({
    required this.provider,
    required this.context,
  });

  Future<void> loadInitial() async {
    if (!context.mounted) return;
    try {
      await reset(targetPage: page);
    } catch (e) {
      if (!context.mounted) return;
      showCustomDialog(
        context: context,
        title: 'Greška',
        message: e.toString(),
        icon: Icons.error,
      );
    }
  }

  void filterServerSide(String ime, int? ulogaId) async {
    korisnickoImeFilter = ime;
    ulogaIdFilter = ulogaId;
    await reset(targetPage: 1);
  }

  Future<void> reset({int? targetPage}) async {
    final newPage = targetPage ?? page;
    final filter = {
      'KorisnickoIme': korisnickoImeFilter,
      if (ulogaIdFilter != null) 'UlogaId': ulogaIdFilter,
    };

    try {
      var result =
          await provider.get(filter: filter, page: newPage, pageSize: pageSize);
      var newData = result.resultList;
      var newCount = result.count;

      if (newData.isEmpty && newPage > 1) {
        final fallbackPage = newPage - 1;
        final fallbackResult = await provider.get(
          filter: filter,
          page: fallbackPage,
          pageSize: pageSize,
        );
        newData = fallbackResult.resultList;
        newCount = fallbackResult.count;
        page = fallbackPage;
      } else {
        page = newPage;
      }

      data = newData;
      count = newCount;

      setNextView(startIndex: (page - 1) * pageSize);
      await Future.delayed(const Duration(milliseconds: 100));
      notifyListeners();
    } catch (e) {
      if (!context.mounted) return;
      showCustomDialog(
        context: context,
        title: 'Greška',
        message: e.toString(),
        icon: Icons.error,
      );
    }
  }

  @override
  Future<RemoteDataSourceDetails<Korisnik>> getNextPage(
      NextPageRequest pageRequest) async {
    page = (pageRequest.offset ~/ pageSize) + 1;

    final filter = {
      'KorisnickoIme': korisnickoImeFilter,
      if (ulogaIdFilter != null) 'UlogaId': ulogaIdFilter,
    };

    try {
      final result =
          await provider.get(filter: filter, page: page, pageSize: pageSize);
      data = result.resultList;
      count = result.count;
      return RemoteDataSourceDetails(count, data);
    } catch (e) {
      if (!context.mounted) {
        return RemoteDataSourceDetails(0, []);
      }
      showCustomDialog(
        context: context,
        title: 'Greška',
        message: e.toString(),
        icon: Icons.error,
      );
      return RemoteDataSourceDetails(0, []);
    }
  }

  @override
  DataRow? getRow(int index) {
    if (index >= data.length) return null;
    final item = data[index];

    final ulogeText = item.uloge?.join(', ') ?? '';

    return DataRow(
      color: WidgetStateProperty.all(Colors.white),
      onSelectChanged: (selected) async {
        final result = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => KorisniciDetailsScreen(korisnik: item),
          ),
        );
        if (result == true) await reset();
      },
      cells: [
        DataCell(
          Tooltip(
            message: "Klikni za prikaz detalja",
            child: Container(
              constraints: const BoxConstraints(maxWidth: 150),
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text(ulogeText,
                  softWrap: true, overflow: TextOverflow.ellipsis),
            ),
          ),
        ),
        DataCell(
          Tooltip(
            message: "Klikni za prikaz detalja",
            child: Container(
              constraints: const BoxConstraints(maxWidth: 150),
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text(item.korisnickoIme ?? '',
                  softWrap: true, overflow: TextOverflow.ellipsis),
            ),
          ),
        ),
        DataCell(
          Tooltip(
            message: "Klikni za prikaz detalja",
            child: Container(
              constraints: const BoxConstraints(maxWidth: 200),
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text(item.email ?? '',
                  softWrap: true, overflow: TextOverflow.ellipsis),
            ),
          ),
        ),
        DataCell(Row(
          children: [
            ElevatedButton(
              onPressed: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        KorisniciDetailsScreen(korisnik: item),
                  ),
                );
                if (result == true) await reset();
              },
              style: ButtonStyle(
                backgroundColor:
                    WidgetStateProperty.resolveWith<Color>((states) {
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
                    const EdgeInsets.symmetric(horizontal: 13, vertical: 9)),
                shape: WidgetStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.info_outline, color: Colors.white, size: 20),
                  SizedBox(width: 6),
                  Text("Detalji", style: TextStyle(color: Colors.white)),
                ],
              ),
            ),
          ],
        )),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => count;

  @override
  int get selectedRowCount => 0;
}
