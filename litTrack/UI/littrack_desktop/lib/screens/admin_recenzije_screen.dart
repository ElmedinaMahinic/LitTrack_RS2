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
import 'package:provider/provider.dart';

enum PrikazTipa { recenzije, odgovori }

class AdminRecenzijeScreen extends StatefulWidget {
  const AdminRecenzijeScreen({super.key});

  @override
  State<AdminRecenzijeScreen> createState() => _AdminRecenzijeScreenState();
}

class _AdminRecenzijeScreenState extends State<AdminRecenzijeScreen> {
  final TextEditingController _korisnickoImeController =
      TextEditingController();
  late RecenzijaProvider _recenzijaProvider;
  late RecenzijaOdgovorProvider _recenzijaOdgovorProvider;
  late RecenzijaDataSource _dataSource;

  PrikazTipa _prikazTipa = PrikazTipa.recenzije;

  @override
  void initState() {
    super.initState();
    _recenzijaProvider = context.read<RecenzijaProvider>();
    _recenzijaOdgovorProvider = context.read<RecenzijaOdgovorProvider>();
    _dataSource = RecenzijaDataSource(
      recenzijaProvider: _recenzijaProvider,
      odgovorProvider: _recenzijaOdgovorProvider,
      context: context,
      refreshParent: _refreshTable,
    );
    _dataSource.filterServerSide('', _prikazTipa);
  }

  void _refreshTable() {
    if (!mounted) return;
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
                      vertical: 10,
                      horizontal: 12,
                    ),
                  ),
                  onChanged: (value) {
                    _dataSource.filterServerSide(value, _prikazTipa);
                  },
                ),
              ),
              const SizedBox(width: 15),
              ElevatedButton(
                onPressed: () {
                  _korisnickoImeController.clear();
                  _dataSource.filterServerSide('', _prikazTipa);
                  setState(() {});
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
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  ),
                  shape: WidgetStateProperty.all(
                    RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.clear, color: Colors.white),
                    SizedBox(width: 8),
                    Text(
                      "Očisti filtere",
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Tooltip(
                message:
                    'Filtrirajte recenzije po korisničkom imenu i tipu prikaza.',
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
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _prikazTipa = PrikazTipa.recenzije;
                    _dataSource.filterServerSide(
                        _korisnickoImeController.text, _prikazTipa);
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: _prikazTipa == PrikazTipa.recenzije
                      ? const Color(0xFF3C6E71)
                      : Colors.grey[400],
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  elevation: 0,
                ),
                child: Text(
                  'Recenzije',
                  style: TextStyle(
                    color: _prikazTipa == PrikazTipa.recenzije
                        ? Colors.white
                        : Colors.black87,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _prikazTipa = PrikazTipa.odgovori;
                    _dataSource.filterServerSide(
                        _korisnickoImeController.text, _prikazTipa);
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: _prikazTipa == PrikazTipa.odgovori
                      ? const Color(0xFF3C6E71)
                      : Colors.grey[400],
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  elevation: 0,
                ),
                child: Text(
                  'Odgovori',
                  style: TextStyle(
                    color: _prikazTipa == PrikazTipa.odgovori
                        ? Colors.white
                        : Colors.black87,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Tooltip(
                message:
                    'Izaberite da prikažete korisničke recenzije ili odgovore na njih.',
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 128, 136, 132),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                      color: const Color.fromARGB(255, 96, 102, 102), width: 1),
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
      ),
    );
  }

  Widget _buildTable() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: DataTableTheme(
        data: DataTableThemeData(
          headingRowColor: WidgetStateProperty.all(
              const Color.fromARGB(255, 213, 224, 219)),
          headingTextStyle: const TextStyle(
            color: Color(0xFF3C6E71),
            fontWeight: FontWeight.bold,
          ),
          dataRowColor: WidgetStateProperty.all(Colors.white),
        ),
        child: AdvancedPaginatedDataTable(
          showCheckboxColumn: false,
          addEmptyRows: false,
          source: _dataSource,
          rowsPerPage: 10,
          columns: const [
            DataColumn(label: Text("KORISNIČKO IME")),
            DataColumn(label: Text("KOMENTAR")),
            DataColumn(label: Text("BROJ LAJKOVA")),
            DataColumn(label: Text("BROJ DISLAJKOVA")),
            DataColumn(label: Text("OPCIJE")),
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

    return DataRow(
      color: WidgetStateProperty.resolveWith<Color?>((states) {
        if (states.contains(WidgetState.hovered)) {
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
              child: Text(
                korisnickoIme,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ),
        DataCell(
          Tooltip(
            message: komentar,
            child: Container(
              constraints: const BoxConstraints(maxWidth: 200),
              padding: const EdgeInsets.all(4),
              child: Text(
                komentar,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ),
        DataCell(
          Tooltip(
            message: "Klikni za prikaz detalja",
            child: Padding(
              padding: const EdgeInsets.all(4),
              child: Text(
                brojLajkova.toString(),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ),
        DataCell(
          Tooltip(
            message: "Klikni za prikaz detalja",
            child: Padding(
              padding: const EdgeInsets.all(4),
              child: Text(
                brojDislajkova.toString(),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ),
        DataCell(
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
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
                    const EdgeInsets.symmetric(horizontal: 13, vertical: 9),
                  ),
                  shape: WidgetStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  elevation: WidgetStateProperty.all(0),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.info_outline, color: Colors.white, size: 20),
                    SizedBox(width: 6),
                    Text(
                      "Detalji",
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ],
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
