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
      refreshParent: _refreshTable,
    );

    _loadUloge();
    _dataSource.filterServerSide('', null);
  }

  Future<void> _loadUloge() async {
    final result = await _ulogaProvider.get();
    if (!mounted) return;
    setState(() {
      _ulogeList = result.resultList;
    });
  }

  void _refreshTable() {
    _dataSource.filterServerSide(
        _korisnickoImeController.text, _selectedUloga?.ulogaId);
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
              onChanged: (_) => _refreshTable(),
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            flex: 2,
            child: DropdownButtonFormField<Uloga>(
              decoration: InputDecoration(
                labelText: 'Uloga',
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                filled: true,
                fillColor: Colors.white,
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
              ),
              value: _selectedUloga,
              items: _ulogeList
                  .map((uloga) =>
                      DropdownMenuItem(value: uloga, child: Text(uloga.naziv)))
                  .toList(),
              onChanged: (value) {
                setState(() => _selectedUloga = value);
                _refreshTable();
              },
            ),
          ),
          const SizedBox(width: 20),
          ElevatedButton(
            onPressed: () {
              _korisnickoImeController.clear();
              setState(() => _selectedUloga = null);
              _refreshTable();
            },
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
          headingRowColor: MaterialStateProperty.all(
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
          rowsPerPage: 10,
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
  final VoidCallback refreshParent;

  List<Korisnik> data = [];
  int page = 1;
  int pageSize = 10;
  int count = 0;
  String korisnickoImeFilter = '';
  int? ulogaIdFilter;

  KorisnikDataSource({
    required this.provider,
    required this.context,
    required this.refreshParent,
  });

  void filterServerSide(String ime, int? ulogaId) {
    korisnickoImeFilter = ime;
    ulogaIdFilter = ulogaId;
    setNextView();
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
      color: MaterialStateProperty.all(Colors.white),
      onSelectChanged: (selected) async {
        final result = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => KorisniciDetailsScreen(korisnik: item),
          ),
        );
        if (result == true) refreshParent();
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
                if (result == true) refreshParent();
              },
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
                    const EdgeInsets.symmetric(horizontal: 13, vertical: 9)),
                shape: MaterialStateProperty.all(
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
