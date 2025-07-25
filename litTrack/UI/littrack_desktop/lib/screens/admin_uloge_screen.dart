import 'package:flutter/material.dart';
import 'package:littrack_desktop/layouts/master_screen.dart';
import 'package:littrack_desktop/models/uloga.dart';
import 'package:littrack_desktop/providers/uloga_provider.dart';
import 'package:littrack_desktop/providers/utils.dart';
import 'package:advanced_datatable/datatable.dart';
import 'package:advanced_datatable/advanced_datatable_source.dart';
import 'package:littrack_desktop/screens/admin_uloge_details.dart';
import 'package:provider/provider.dart';

class AdminUlogeScreen extends StatefulWidget {
  const AdminUlogeScreen({super.key});

  @override
  State<AdminUlogeScreen> createState() => _AdminUlogeScreenState();
}

class _AdminUlogeScreenState extends State<AdminUlogeScreen> {
  final TextEditingController _nazivController = TextEditingController();
  late UlogaProvider _provider;
  late UlogaDataSource _dataSource;

  @override
  void initState() {
    super.initState();
    _provider = context.read<UlogaProvider>();
    _dataSource = UlogaDataSource(provider: _provider, context: context);
    _dataSource.filterServerSide('');
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreen(
      title: "Korisničke uloge",
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
                labelText: 'Naziv uloge',
                hintText: 'Unesite naziv uloge',
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
            child: const Text(
              "Očisti filtere",
              style: TextStyle(color: Colors.white),
            ),
          ),
          const SizedBox(width: 15),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF3C6E71),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            ),
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AdminUlogaDetailsScreen(),
                ),
              );
              if (result == true) {
                _dataSource.filterServerSide(_nazivController.text);
              }
            },
            child: const Text(
              "Dodaj ulogu",
              style: TextStyle(color: Colors.white),
            ),
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
            DataColumn(label: Text("Opcije")),
          ],
        ),
      ),
    );
  }
}

class UlogaDataSource extends AdvancedDataTableSource<Uloga> {
  final UlogaProvider provider;
  final BuildContext context;

  List<Uloga> data = [];
  int page = 1;
  int pageSize = 10;
  int count = 0;
  String nazivFilter = "";

  UlogaDataSource({required this.provider, required this.context});

  void filterServerSide(String naziv) {
    nazivFilter = naziv;
    setNextView();
  }

  @override
  Future<RemoteDataSourceDetails<Uloga>> getNextPage(
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
      color: MaterialStateProperty.resolveWith<Color?>(
        (Set<MaterialState> states) {
          if (states.contains(MaterialState.hovered)) {
            return const Color(0xFFD8EBEA);
          }
          return Colors.white;
        },
      ),
      onSelectChanged: (selected) async {
        if (selected == true) {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AdminUlogaDetailsScreen(uloga: item),
            ),
          );
          if (result == true) {
            filterServerSide(nazivFilter);
          }
        }
      },
      cells: [
        DataCell(
          Tooltip(
            message: 'Klikni za prikaz detalja',
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(item.naziv),
            ),
          ),
        ),
        DataCell(
          Row(
            children: [
              ElevatedButton(
                onPressed: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AdminUlogaDetailsScreen(uloga: item),
                    ),
                  );
                  if (result == true) {
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
                    message: "Da li ste sigurni da želite obrisati ovu ulogu?",
                    icon: Icons.warning,
                    iconColor: Colors.red,
                    onConfirm: () async {
                      try {
                        await provider.delete(item.ulogaId!);
                        showCustomDialog(
                          context: context,
                          title: "Uspjeh",
                          message: "Uloga je uspješno obrisana.",
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

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => count;

  @override
  int get selectedRowCount => 0;
}