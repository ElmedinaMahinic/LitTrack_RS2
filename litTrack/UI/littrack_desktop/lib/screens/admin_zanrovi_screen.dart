import 'package:flutter/material.dart';
import 'package:littrack_desktop/layouts/master_screen.dart';
import 'package:littrack_desktop/models/zanr.dart';
import 'package:littrack_desktop/providers/zanr_provider.dart';
import 'package:littrack_desktop/providers/utils.dart';
import 'package:advanced_datatable/datatable.dart';
import 'package:advanced_datatable/advanced_datatable_source.dart';
import 'package:littrack_desktop/screens/admin_zanrovi_details.dart';

class AdminZanroviScreen extends StatefulWidget {
  const AdminZanroviScreen({super.key});

  @override
  State<AdminZanroviScreen> createState() => _AdminZanroviScreenState();
}

class _AdminZanroviScreenState extends State<AdminZanroviScreen> {
  final TextEditingController _nazivController = TextEditingController();
  final ZanrProvider _provider = ZanrProvider();
  late ZanrDataSource _dataSource;

  @override
  void initState() {
    super.initState();
    _dataSource = ZanrDataSource(provider: _provider, context: context);
    _dataSource.filterServerSide('');
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreen(
      title: "Žanrovi",
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
              controller: _nazivController,
              decoration: InputDecoration(
                labelText: 'Naziv žanra',
                hintText: 'Unesite naziv žanra',
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                filled: true,
                fillColor: Colors.white,
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
              ),
              onChanged: (value) {
                _dataSource.filterServerSide(value);
              },
            ),
          ),
          const SizedBox(width: 15),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF3C6E71),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            ),
            onPressed: () {
              _nazivController.clear();
              _dataSource.filterServerSide('');
              setState(() {});
            },
            child: const Text("Očisti filtere",
                style: TextStyle(color: Colors.white)),
          ),
          const SizedBox(width: 15),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF3C6E71),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            ),
            onPressed: () async {
              final refresh = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AdminZanrDetailsScreen(),
                ),
              );

              if (refresh == true) {
                _dataSource.filterServerSide(_nazivController.text);
              }
            },
            child:
                const Text("Dodaj žanr", style: TextStyle(color: Colors.white)),
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
            DataColumn(label: Text("Naziv")),
            DataColumn(label: Text("Slika")),
            DataColumn(label: Text("Opcije")),
          ],
        ),
      ),
    );
  }
}

class ZanrDataSource extends AdvancedDataTableSource<Zanr> {
  final ZanrProvider provider;
  final BuildContext context;

  List<Zanr> data = [];
  int page = 1;
  int pageSize = 10;
  int count = 0;
  String nazivFilter = "";

  ZanrDataSource({required this.provider, required this.context});

  void filterServerSide(String naziv) {
    nazivFilter = naziv;
    setNextView();
  }

  @override
  Future<RemoteDataSourceDetails<Zanr>> getNextPage(
      NextPageRequest pageRequest) async {
    page = (pageRequest.offset ~/ pageSize) + 1;
    final filter = {'Naziv': nazivFilter};

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

    return DataRow(
      onSelectChanged: (selected) async {
        final refresh = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AdminZanrDetailsScreen(zanr: item),
          ),
        );

        if (refresh == true) {
          filterServerSide(nazivFilter);
        }
      },
      color: MaterialStateProperty.resolveWith<Color?>(
        (Set<MaterialState> states) {
          if (states.contains(MaterialState.hovered)) {
            return const Color(0xFFD8EBEA); 
          }
          return Colors.white; 
        },
      ),
      cells: [
        DataCell(
          Tooltip(
            message: "Klikni za prikaz detalja",
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text(item.naziv),
            ),
          ),
        ),
        DataCell(
          Tooltip(
            message: "Klikni za prikaz detalja",
            child: Padding(
              padding: const EdgeInsets.all(4),
              child: _buildImage(item.slika),
            ),
          ),
        ),
        DataCell(
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () async {
                  final refresh = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AdminZanrDetailsScreen(zanr: item),
                    ),
                  );

                  if (refresh == true) {
                    filterServerSide(nazivFilter);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF3C6E71),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                ),
                child:
                    const Text("Uredi", style: TextStyle(color: Colors.white)),
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                onPressed: () {
                  showConfirmDialog(
                    context: context,
                    title: "Brisanje",
                    message: "Da li ste sigurni da želite obrisati ovaj žanr?",
                    icon: Icons.warning,
                    iconColor: Colors.red,
                    onConfirm: () async {
                      try {
                        await provider.delete(item.zanrId!);
                        showCustomDialog(
                          context: context,
                          title: "Uspjeh",
                          message: "Žanr je uspješno obrisan.",
                          icon: Icons.check_circle,
                          iconColor: Colors.green,
                        );
                        filterServerSide(nazivFilter);
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
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                ),
                child:
                    const Text("Obriši", style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildImage(String? slikaBase64) {
    if (slikaBase64 == null || slikaBase64.isEmpty) {
      return Image.asset(
        'assets/images/placeholder.png',
        width: 30,
        height: 30,
        fit: BoxFit.cover,
      );
    }

    try {
      return SizedBox(
        width: 30,
        height: 30,
        child: imageFromString(slikaBase64),
      );
    } catch (_) {
      return const Icon(Icons.broken_image);
    }
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => count;

  @override
  int get selectedRowCount => 0;
}
