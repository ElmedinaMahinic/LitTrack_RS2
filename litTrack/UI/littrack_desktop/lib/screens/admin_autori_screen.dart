import 'package:flutter/material.dart';
import 'package:littrack_desktop/layouts/master_screen.dart';
import 'package:littrack_desktop/models/autor.dart';
import 'package:littrack_desktop/providers/autor_provider.dart';
import 'package:littrack_desktop/providers/utils.dart';
import 'package:advanced_datatable/datatable.dart';
import 'package:advanced_datatable/advanced_datatable_source.dart';
import 'package:littrack_desktop/screens/admin_autori_details.dart';

class AdminAutoriScreen extends StatefulWidget {
  const AdminAutoriScreen({super.key});

  @override
  State<AdminAutoriScreen> createState() => _AdminAutoriScreenState();
}

class _AdminAutoriScreenState extends State<AdminAutoriScreen> {
  final TextEditingController _imeController = TextEditingController();
  final AutorProvider _provider = AutorProvider();
  late AutorDataSource _dataSource;

  @override
  void initState() {
    super.initState();
    _dataSource = AutorDataSource(
        provider: _provider, context: context, refreshParent: _refreshTable);
    _dataSource.filterServerSide('');
  }

  void _refreshTable() {
    setState(() {
      _dataSource.filterServerSide(_imeController.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreen(
      title: "Autori",
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
              controller: _imeController,
              decoration: InputDecoration(
                labelText: 'Ime ili prezime autora',
                hintText: 'Unesite ime ili prezime',
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
              _imeController.clear();
              _dataSource.filterServerSide('');
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
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AdminAutoriDetailsScreen(),
                ),
              );
              if (result == true) _refreshTable();
            },
            child: const Text("Dodaj autora",
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
            DataColumn(label: Text("Ime")),
            DataColumn(label: Text("Prezime")),
            DataColumn(label: Text("Opcije")),
          ],
        ),
      ),
    );
  }
}

class AutorDataSource extends AdvancedDataTableSource<Autor> {
  final AutorProvider provider;
  final BuildContext context;
  final VoidCallback refreshParent;

  List<Autor> data = [];
  int page = 1;
  int pageSize = 10;
  int count = 0;
  String imeFilter = "";

  AutorDataSource({
    required this.provider,
    required this.context,
    required this.refreshParent,
  });

  void filterServerSide(String ime) {
    imeFilter = ime;
    setNextView();
  }

  @override
  Future<RemoteDataSourceDetails<Autor>> getNextPage(
      NextPageRequest pageRequest) async {
    page = (pageRequest.offset ~/ pageSize) + 1;
    final filter = {'ImePrezime': imeFilter};

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
      }),
      onSelectChanged: (selected) async {
        final result = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AdminAutoriDetailsScreen(autor: item),
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
              child: Text(item.ime),
            ),
          ),
        ),
        DataCell(
          Tooltip(
            message: "Klikni za prikaz detalja",
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(item.prezime),
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
                      builder: (context) =>
                          AdminAutoriDetailsScreen(autor: item),
                    ),
                  );
                  if (result == true) refreshParent();
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
                    message:
                        "Da li ste sigurni da želite obrisati ovog autora?",
                    icon: Icons.warning,
                    iconColor: Colors.red,
                    onConfirm: () async {
                      try {
                        await provider.delete(item.autorId!);
                        showCustomDialog(
                          context: context,
                          title: "Uspjeh",
                          message: "Autor je uspješno obrisan.",
                          icon: Icons.check_circle,
                          iconColor: Colors.green,
                        );
                        filterServerSide(imeFilter);
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
