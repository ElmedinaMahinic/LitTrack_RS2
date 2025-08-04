import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:littrack_desktop/main.dart';
import 'package:littrack_desktop/providers/auth_provider.dart';
import 'package:littrack_desktop/models/korisnik.dart';
import 'package:littrack_desktop/models/uloga.dart';
import 'package:littrack_desktop/providers/korisnik_provider.dart';
import 'package:littrack_desktop/providers/uloga_provider.dart';
import 'package:littrack_desktop/providers/utils.dart';
import 'package:littrack_desktop/layouts/master_screen.dart';
import 'package:littrack_desktop/screens/korisnici_details_screen.dart';
import 'package:littrack_desktop/screens/admin_dodaj_radnika_screen.dart';
import 'package:advanced_datatable/datatable.dart';
import 'package:advanced_datatable/advanced_datatable_source.dart';

class AdminKorisniciScreen extends StatefulWidget {
  const AdminKorisniciScreen({super.key});

  @override
  State<AdminKorisniciScreen> createState() => _AdminKorisniciScreenState();
}

class _AdminKorisniciScreenState extends State<AdminKorisniciScreen> {
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
          const SizedBox(width: 15),
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
          const SizedBox(width: 15),
          ElevatedButton(
            onPressed: () {
              _korisnickoImeController.clear();
              setState(() => _selectedUloga = null);
              _refreshTable();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF3C6E71),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            ),
            child: const Text("Očisti filtere",
                style: TextStyle(color: Colors.white)),
          ),
          const SizedBox(width: 15),
          ElevatedButton(
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AdminDodajRadnikaScreen(),
                ),
              );
              if (result == true) {
                _refreshTable();
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF3C6E71),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            ),
            child: const Text("Dodaj radnika",
                style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget _buildTable() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: DataTableTheme(
        data: DataTableThemeData(
          headingRowColor: MaterialStateProperty.all(const Color(0xFF3C6E71)),
          headingTextStyle:
              const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        child: AdvancedPaginatedDataTable(
          showCheckboxColumn: false,
          addEmptyRows: false,
          source: _dataSource,
          rowsPerPage: 10,
          columns: const [
            DataColumn(label: Text("Uloge")),
            DataColumn(label: Text("Korisničko ime")),
            DataColumn(label: Text("Email")),
            DataColumn(label: Text("Opcije")),
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
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(ulogeText),
            ),
          ),
        ),
        DataCell(
          Tooltip(
            message: "Klikni za prikaz detalja",
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(item.korisnickoIme ?? ''),
            ),
          ),
        ),
        DataCell(
          Tooltip(
            message: "Klikni za prikaz detalja",
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(item.email ?? ''),
            ),
          ),
        ),
        DataCell(Row(
          children: [
            ElevatedButton(
              onPressed: () {
                showConfirmDialog(
                  context: context,
                  title: item.jeAktivan == true ? "Deaktivacija" : "Aktivacija",
                  message:
                      "Da li ste sigurni da želite ${item.jeAktivan == true ? 'deaktivirati' : 'aktivirati'} korisnika?",
                  icon: Icons.warning,
                  iconColor: Colors.red,
                  onConfirm: () async {
                    try {
                      if (item.jeAktivan == true) {
                        await provider.deaktiviraj(item.korisnikId!);

                        if (item.korisnikId == AuthProvider.korisnikId) {
                          AuthProvider.username = null;
                          AuthProvider.password = null;
                          AuthProvider.korisnikId = null;
                          AuthProvider.ime = null;
                          AuthProvider.prezime = null;
                          AuthProvider.email = null;
                          AuthProvider.telefon = null;
                          AuthProvider.uloge = null;
                          AuthProvider.isSignedIn = false;

                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                                builder: (context) => const MyApp()),
                          );
                          return;
                        }
                      } else {
                        await provider.aktiviraj(item.korisnikId!);
                      }

                      showCustomDialog(
                        context: context,
                        title: "Uspjeh",
                        message:
                            "Korisnik je uspješno ${item.jeAktivan == true ? 'deaktiviran' : 'aktiviran'}.",
                        icon: Icons.check_circle,
                        iconColor: Colors.green,
                      );

                      refreshParent();
                    } catch (e) {
                      showCustomDialog(
                        context: context,
                        title: "Greška",
                        message: e.toString(),
                        icon: Icons.error,
                        iconColor: Colors.red,
                      );
                    }
                  },
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF3C6E71),
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              ),
              child: Text(
                item.jeAktivan == true ? "Deaktiviraj" : "Aktiviraj",
                style: const TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(width: 8),
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
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF3C6E71),
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              ),
              child:
                  const Text("Detalji", style: TextStyle(color: Colors.white)),
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
