import 'package:flutter/material.dart';
import 'package:littrack_desktop/layouts/master_screen.dart';
import 'package:littrack_desktop/models/recenzija.dart';
import 'package:littrack_desktop/models/recenzija_odgovor.dart';
import 'package:littrack_desktop/providers/recenzija_provider.dart';
import 'package:littrack_desktop/providers/recenzija_odgovor_provider.dart';
import 'package:littrack_desktop/providers/utils.dart';
import 'package:advanced_datatable/datatable.dart';
import 'package:advanced_datatable/advanced_datatable_source.dart';
import 'package:littrack_desktop/screens/admin_recenzije_details.dart';

enum PrikazTipa { recenzije, odgovori }

class AdminRecenzijeScreen extends StatefulWidget {
  const AdminRecenzijeScreen({super.key});

  @override
  State<AdminRecenzijeScreen> createState() => _AdminRecenzijeScreenState();
}

class _AdminRecenzijeScreenState extends State<AdminRecenzijeScreen> {
  final TextEditingController _korisnickoImeController =
      TextEditingController();
  final RecenzijaProvider _recenzijaProvider = RecenzijaProvider();
  final RecenzijaOdgovorProvider _recenzijaOdgovorProvider =
      RecenzijaOdgovorProvider();
  late RecenzijaDataSource _dataSource;

  PrikazTipa _prikazTipa = PrikazTipa.recenzije;

  @override
  void initState() {
    super.initState();
    _dataSource = RecenzijaDataSource(
      recenzijaProvider: _recenzijaProvider,
      odgovorProvider: _recenzijaOdgovorProvider,
      context: context,
      refreshParent: _refreshTable,
    );
    _dataSource.filterServerSide('', _prikazTipa);
  }

  void _refreshTable() {
    setState(() {
      _dataSource.filterServerSide(_korisnickoImeController.text, _prikazTipa);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreen(
      title: "Recenzije",
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
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                flex: 3,
                child: TextField(
                  controller: _korisnickoImeController,
                  decoration: InputDecoration(
                    labelText: 'Korisničko ime',
                    hintText: 'Unesite korisničko ime',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 12),
                  ),
                  onChanged: (value) {
                    _dataSource.filterServerSide(value, _prikazTipa);
                  },
                ),
              ),
              const SizedBox(width: 15),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF3C6E71),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                ),
                onPressed: () {
                  _korisnickoImeController.clear();
                  _dataSource.filterServerSide('', _prikazTipa);
                },
                child: const Text("Očisti filtere",
                    style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              Radio<PrikazTipa>(
                value: PrikazTipa.recenzije,
                groupValue: _prikazTipa,
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _prikazTipa = value;
                      _dataSource.filterServerSide(
                          _korisnickoImeController.text, _prikazTipa);
                    });
                  }
                },
              ),
              const Text("Prikaži recenzije"),
              const SizedBox(width: 20),
              Radio<PrikazTipa>(
                value: PrikazTipa.odgovori,
                groupValue: _prikazTipa,
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _prikazTipa = value;
                      _dataSource.filterServerSide(
                          _korisnickoImeController.text, _prikazTipa);
                    });
                  }
                },
              ),
              const Text("Prikaži odgovore"),
            ],
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
          headingTextStyle: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
          dataRowColor: MaterialStateProperty.all(Colors.white),
        ),
        child: AdvancedPaginatedDataTable(
          showCheckboxColumn: false,
          addEmptyRows: false,
          source: _dataSource,
          rowsPerPage: 10,
          columns: const [
            DataColumn(label: Text("Korisničko ime")),
            DataColumn(label: Text("Komentar")),
            DataColumn(label: Text("Broj lajkova")),
            DataColumn(label: Text("Broj dislajkova")),
            DataColumn(label: Text("Opcije")),
          ],
        ),
      ),
    );
  }
}

class RecenzijaDataSource extends AdvancedDataTableSource<dynamic> {
  final RecenzijaProvider recenzijaProvider;
  final RecenzijaOdgovorProvider odgovorProvider;
  final BuildContext context;
  final VoidCallback refreshParent;

  List<dynamic> data = [];
  int page = 1;
  int pageSize = 10;
  int count = 0;
  String korisnickoImeFilter = "";
  PrikazTipa prikazTipa = PrikazTipa.recenzije;

  RecenzijaDataSource({
    required this.recenzijaProvider,
    required this.odgovorProvider,
    required this.context,
    required this.refreshParent,
  });

  void filterServerSide(String korisnickoIme, PrikazTipa tipa) {
    korisnickoImeFilter = korisnickoIme;
    prikazTipa = tipa;
    setNextView();
  }

  @override
  Future<RemoteDataSourceDetails<dynamic>> getNextPage(
      NextPageRequest pageRequest) async {
    page = (pageRequest.offset ~/ pageSize) + 1;

    final filter = {'KorisnickoIme': korisnickoImeFilter};

    try {
      if (prikazTipa == PrikazTipa.recenzije) {
        final recenzijeResult = await recenzijaProvider.get(
          filter: filter,
          page: page,
          pageSize: pageSize,
        );
        data = recenzijeResult.resultList;
        count = recenzijeResult.count;
      } else {
        final odgovoriResult = await odgovorProvider.get(
          filter: filter,
          page: page,
          pageSize: pageSize,
        );
        data = odgovoriResult.resultList;
        count = odgovoriResult.count;
      }

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

    String korisnickoIme = "";
    String komentar = "";
    int brojLajkova = 0;
    int brojDislajkova = 0;

    if (item is Recenzija) {
      korisnickoIme = item.korisnickoIme ?? "";
      komentar = item.komentar;
      brojLajkova = item.brojLajkova;
      brojDislajkova = item.brojDislajkova;
    } else if (item is RecenzijaOdgovor) {
      korisnickoIme = item.korisnickoIme ?? "";
      komentar = item.komentar;
      brojLajkova = item.brojLajkova;
      brojDislajkova = item.brojDislajkova;
    } else {
      return null;
    }

    String prikazKomentara =
        komentar.length > 50 ? '${komentar.substring(0, 50)}...' : komentar;

    return DataRow(
      color: MaterialStateProperty.resolveWith<Color?>((states) {
        if (states.contains(MaterialState.hovered)) {
          return const Color(0xFFD8EBEA);
        }
        return Colors.white;
      }),
      onSelectChanged: (selected) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => AdminRecenzijeDetailsScreen(
              recenzija: item is Recenzija ? item : null,
              odgovor: item is RecenzijaOdgovor ? item : null,
            ),
          ),
        ).then((value) {
          if (value == true) refreshParent();
        });
      },
      cells: [
        DataCell(
          Tooltip(
            message: "Klikni za prikaz detalja",
            child: Padding(
              padding: const EdgeInsets.all(4),
              child: Text(korisnickoIme),
            ),
          ),
        ),
        DataCell(
          Tooltip(
            message: komentar,
            child: Padding(
              padding: const EdgeInsets.all(4),
              child: Text(prikazKomentara),
            ),
          ),
        ),
        DataCell(
          Tooltip(
            message: "Klikni za prikaz detalja",
            child: Padding(
              padding: const EdgeInsets.all(4),
              child: Text(brojLajkova.toString()),
            ),
          ),
        ),
        DataCell(
          Tooltip(
            message: "Klikni za prikaz detalja",
            child: Padding(
              padding: const EdgeInsets.all(4),
              child: Text(brojDislajkova.toString()),
            ),
          ),
        ),
        DataCell(
          Padding(
            padding: const EdgeInsets.all(4),
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => AdminRecenzijeDetailsScreen(
                      recenzija: item is Recenzija ? item : null,
                      odgovor: item is RecenzijaOdgovor ? item : null,
                    ),
                  ),
                ).then((value) {
                  if (value == true) refreshParent();
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF3C6E71),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              ),
              child:
                  const Text("Detalji", style: TextStyle(color: Colors.white)),
            ),
          ),
        ),
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
