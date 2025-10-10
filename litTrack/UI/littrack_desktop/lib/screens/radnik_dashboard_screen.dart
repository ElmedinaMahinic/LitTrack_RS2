import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:littrack_desktop/layouts/master_screen.dart';
import 'package:littrack_desktop/providers/narudzba_provider.dart';
import 'package:provider/provider.dart';
import 'package:littrack_desktop/providers/utils.dart';
import 'package:pdf/widgets.dart' as pw;
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class RadnikDashboardScreen extends StatefulWidget {
  const RadnikDashboardScreen({super.key});

  @override
  State<RadnikDashboardScreen> createState() => _RadnikDashboardScreenState();
}

class _RadnikDashboardScreenState extends State<RadnikDashboardScreen> {
  int brojPreuzetih = 0;
  int brojZavrsenih = 0;
  int brojOtkazanih = 0;
  bool isLoading = true;

  List<int> narudzbePoMjesecima = List.filled(12, 0);

  final Map<String?, String?> stateDisplayToValue = {
    null: null, // "Sve narudžbe"
    'Samo kreirane': 'kreirana',
    'Samo u toku': 'uToku',
    'Samo preuzete': 'preuzeta',
    'Samo poništene': 'ponistena',
    'Samo završene': 'zavrsena',
  };

  String? selectedDisplayState;

  List<String?> get availableDisplayStates => stateDisplayToValue.keys.toList();

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    final narudzbaProvider = context.read<NarudzbaProvider>();

    try {
      final preuzete =
          await narudzbaProvider.get(filter: {"stateMachine": "preuzeta"});
      final zavrsene =
          await narudzbaProvider.get(filter: {"stateMachine": "zavrsena"});
      final otkazane =
          await narudzbaProvider.get(filter: {"stateMachine": "otkazana"});

      final String? backendSelectedState = selectedDisplayState != null
          ? stateDisplayToValue[selectedDisplayState!]
          : null;

      final narudzbePoMjesecimaData =
          await narudzbaProvider.getBrojNarudzbiPoMjesecima(
        stateFilter: backendSelectedState,
      );

      setState(() {
        brojPreuzetih = preuzete.count;
        brojZavrsenih = zavrsene.count;
        brojOtkazanih = otkazane.count;
        narudzbePoMjesecima = narudzbePoMjesecimaData;
        isLoading = false;
      });
    } catch (e) {
      showCustomDialog(
        context: context,
        title: 'Greška',
        message: e.toString(),
        icon: Icons.error,
        iconColor: Colors.red,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreen(
      title: 'Statistika narudžbi',
      child: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 25),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Center(
                      child: Wrap(
                        alignment: WrapAlignment.center,
                        spacing: 30,
                        runSpacing: 30,
                        children: [
                          _buildStatCard(getPreuzeteText(brojPreuzetih),
                              brojPreuzetih, Icons.inventory_2),
                          _buildStatCard(getZavrseneText(brojZavrsenih),
                              brojZavrsenih, Icons.check_circle),
                          _buildStatCard(getOtkazaneText(brojOtkazanih),
                              brojOtkazanih, Icons.cancel),
                        ],
                      ),
                    ),
                    const SizedBox(height: 50),
                    _buildFilterSection(),
                    const SizedBox(height: 25),
                    _buildLineChart(),
                    const SizedBox(height: 25),
                    _buildSaveReportButton(),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildFilterSection() {
    return Container(
      constraints: const BoxConstraints(minHeight: 100),
      decoration: BoxDecoration(
        color: const Color(0xFFF9F9F9),
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Color.fromARGB(68, 0, 0, 0),
            blurRadius: 8,
            offset: Offset(0, 4),
            spreadRadius: 0,
          ),
        ],
      ),
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Prikazane narudžbe:",
            style: TextStyle(
              fontSize: 16.5,
              fontWeight: FontWeight.w700,
              color: Color(0xFF3C6E71),
            ),
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<String?>(
            decoration: InputDecoration(
              filled: true,
              fillColor: const Color(0xFFF9F9F9),
              prefixIcon: const Icon(
                Icons.filter_list,
                color: Color(0xFF3C6E71),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
            ),
            dropdownColor: const Color(0xFFF9F9F9),
            style: const TextStyle(
              color: Color(0xFF3C6E71),
              fontWeight: FontWeight.w600,
            ),
            value: selectedDisplayState,
            hint: const Text(
              "Sve narudžbe",
              style: TextStyle(color: Colors.black54),
            ),
            items: availableDisplayStates.map((displayValue) {
              return DropdownMenuItem<String?>(
                value: displayValue,
                child: Text(displayValue ?? "Sve narudžbe"),
              );
            }).toList(),
            onChanged: (value) async {
              setState(() {
                selectedDisplayState = value;
                isLoading = true;
              });
              await loadData();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildLineChart() {
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'Maj',
      'Jun',
      'Jul',
      'Avg',
      'Sep',
      'Okt',
      'Nov',
      'Dec'
    ];
    final chartLineColor = const Color(0xFF3C6E71);
    final backgroundColor = const Color(0xFFF9F9F9);

    final totalOrders = narudzbePoMjesecima.fold(0, (sum, item) => sum + item);

    String getNarudzbaLabel(int broj) {
      if (broj == 1) return 'narudžba';
      if (broj >= 2 && broj <= 4) return 'narudžbe';
      return 'narudžbi';
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 6.0),
          child: Text(
            "Broj narudžbi po mjesecu",
            style: TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.bold,
              color: chartLineColor,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 19.0),
          child: Text(
            "Ukupan broj narudžbi: $totalOrders",
            style: const TextStyle(
              fontSize: 14.5,
              fontWeight: FontWeight.w500,
              color: Color.fromARGB(181, 0, 0, 0),
            ),
            textAlign: TextAlign.center,
          ),
        ),
        SizedBox(
          height: 350,
          width: double.infinity,
          child: Container(
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(16),
              boxShadow: const [
                BoxShadow(
                  color: Color.fromARGB(68, 0, 0, 0),
                  blurRadius: 6,
                  offset: Offset(0, 3),
                ),
              ],
              border: Border.all(color: Colors.grey.shade300),
            ),
            padding: const EdgeInsets.all(16),
            child: LineChart(
              LineChartData(
                backgroundColor: const Color.fromARGB(255, 230, 236, 234),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    axisNameWidget: const Padding(
                      padding: EdgeInsets.only(bottom: 8),
                      child: Text(
                        'Broj narudžbi',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 14.5,
                          color: Color.fromARGB(181, 0, 0, 0),
                        ),
                      ),
                    ),
                    axisNameSize: 50,
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
                      interval: 5,
                      getTitlesWidget: (value, meta) =>
                          Text('${value.toInt()}'),
                    ),
                  ),
                  rightTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 35,
                      interval: 5,
                      getTitlesWidget: (value, meta) => Text(
                        '${value.toInt()}',
                        style: TextStyle(
                          color: backgroundColor,
                          fontSize: 1,
                        ),
                      ),
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    axisNameWidget: const Padding(
                      padding: EdgeInsets.only(top: 8),
                      child: Text(
                        'Mjesec',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 14.5,
                          color: Color.fromARGB(181, 0, 0, 0),
                        ),
                      ),
                    ),
                    axisNameSize: 28,
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 1,
                      getTitlesWidget: (value, meta) {
                        final index = value.toInt();
                        if (index >= 0 && index < months.length) {
                          return Text(months[index]);
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                  ),
                  topTitles: AxisTitles(
                    axisNameWidget: const Padding(
                      padding: EdgeInsets.only(bottom: 8),
                      child: Text(
                        'Mjesec',
                        style: TextStyle(
                          color: Color(0xFFF9F9F9),
                          fontSize: 10,
                        ),
                      ),
                    ),
                    axisNameSize: 5,
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 1,
                      getTitlesWidget: (value, meta) {
                        final index = value.toInt();
                        if (index >= 0 && index < months.length) {
                          return Text(
                            months[index],
                            style: TextStyle(
                              color: backgroundColor,
                              fontSize: 12,
                            ),
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                  ),
                ),
                minY: 0,
                maxY: (narudzbePoMjesecima.reduce((a, b) => a > b ? a : b) + 5)
                    .toDouble(),
                gridData: const FlGridData(show: true),
                borderData: FlBorderData(
                  show: true,
                  border: const Border(
                    left: BorderSide(),
                    bottom: BorderSide(),
                    top: BorderSide(),
                    right: BorderSide(),
                  ),
                ),
                lineBarsData: [
                  LineChartBarData(
                    spots: List.generate(
                      narudzbePoMjesecima.length,
                      (index) => FlSpot(
                        index.toDouble(),
                        narudzbePoMjesecima[index].toDouble(),
                      ),
                    ),
                    isCurved: true,
                    preventCurveOverShooting: true,
                    barWidth: 3,
                    color: chartLineColor,
                    dotData: const FlDotData(show: true),
                    belowBarData: BarAreaData(show: false),
                    showingIndicators: List.generate(12, (index) => index),
                  ),
                ],
                lineTouchData: LineTouchData(
                  enabled: true,
                  touchTooltipData: LineTouchTooltipData(
                    getTooltipItems: (touchedSpots) {
                      return touchedSpots.map((LineBarSpot spot) {
                        final broj = spot.y.toInt();
                        final label = getNarudzbaLabel(broj);
                        return LineTooltipItem(
                          '$broj $label',
                          const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        );
                      }).toList();
                    },
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSaveReportButton() {
    return SizedBox(
      width: 180,
      height: 45,
      child: ElevatedButton.icon(
        onPressed: _saveReport,
        icon: const Icon(Icons.picture_as_pdf, color: Colors.white, size: 20),
        label: const Text(
          "Sačuvaj izvještaj",
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.resolveWith<Color>((states) {
            if (states.contains(MaterialState.hovered)) {
              return const Color(0xFF51968F);
            }
            return const Color(0xFF3C6E71);
          }),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          elevation: MaterialStateProperty.all(4),
          padding: MaterialStateProperty.all(
            const EdgeInsets.symmetric(horizontal: 16),
          ),
          shadowColor: MaterialStateProperty.all(Colors.black54),
        ),
      ),
    );
  }

  Future<void> _saveReport() async {
    try {
      await showConfirmDialog(
        context: context,
        title: "Generisanje PDF-a",
        message: "Želite li generisati PDF sa podacima o narudžbama?",
        icon: Icons.picture_as_pdf,
        iconColor: Colors.redAccent,
        onConfirm: () async {
          try {
            final filePath = await generatePdf();

            await showCustomDialog(
              context: context,
              title: "Uspjeh",
              message: "Izvještaj uspješno sačuvan.\nLokacija: $filePath",
              icon: Icons.check_circle_outline,
              iconColor: Colors.green,
            );
          } catch (e) {
            await showCustomDialog(
              context: context,
              title: "Greška",
              message: "Došlo je do greške pri generisanju PDF-a:\n$e",
              icon: Icons.error,
              iconColor: Colors.red,
            );
          }
        },
      );
    } catch (e) {
      await showCustomDialog(
        context: context,
        title: "Greška",
        message: e.toString(),
        icon: Icons.error,
        iconColor: Colors.red,
      );
    }
  }

  Future<String> generatePdf() async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        build: (context) => [
          pw.Text(
            'Statistika narudzbi',
            style: pw.TextStyle(
              fontSize: 20,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
          pw.SizedBox(height: 20),
          pw.Text('Broj preuzetih narudzbi: $brojPreuzetih'),
          pw.Text('Broj zavrsenih narudzbi: $brojZavrsenih'),
          pw.Text('Broj otkazanih narudzbi: $brojOtkazanih'),
          pw.SizedBox(height: 20),
          pw.Text(
            'Prikazane narudzbe: ${selectedDisplayState ?? "Sve narudzbe"}',
          ),
          pw.SizedBox(height: 15),
          pw.Text('Narudzbe po mjesecima:'),
          pw.SizedBox(height: 10),
          pw.TableHelper.fromTextArray(
            headers: ['Mjesec', 'Broj narudzbi'],
            data: List.generate(
              narudzbePoMjesecima.length,
              (index) =>
                  ['${index + 1}. mjesec', '${narudzbePoMjesecima[index]}'],
            ),
            headerStyle: pw.TextStyle(
              fontWeight: pw.FontWeight.bold,
            ),
            cellAlignment: pw.Alignment.centerLeft,
            cellPadding: const pw.EdgeInsets.all(5),
          ),
          pw.SizedBox(height: 10),
          pw.Text(
            'Ukupan broj narudzbi: ${narudzbePoMjesecima.fold<int>(0, (sum, item) => sum + item)}',
            style: pw.TextStyle(
              fontWeight: pw.FontWeight.bold,
            ),
          ),
        ],
      ),
    );

    final dir = await getApplicationDocumentsDirectory();
    final vrijeme = DateTime.now();
    final formattedDate =
        '${vrijeme.year}-${vrijeme.month.toString().padLeft(2, '0')}-${vrijeme.day.toString().padLeft(2, '0')}';
    final path = '${dir.path}/Statistika-Radnik-$formattedDate.pdf';

    final file = File(path);
    await file.writeAsBytes(await pdf.save());
    return path;
  }

  String getPreuzeteText(int count) {
    if (count == 1) return "Preuzeta narudžba";
    if (count >= 2 && count <= 4) return "Preuzete narudžbe";
    return "Preuzetih narudžbi";
  }

  String getZavrseneText(int count) {
    if (count == 1) return "Završena narudžba";
    if (count >= 2 && count <= 4) return "Završene narudžbe";
    return "Završenih narudžbi";
  }

  String getOtkazaneText(int count) {
    if (count == 1) return "Otkazana narudžba";
    if (count >= 2 && count <= 4) return "Otkazane narudžbe";
    return "Otkazanih narudžbi";
  }

  Widget _buildStatCard(String title, int value, IconData icon) {
    return Container(
      width: 240,
      constraints: const BoxConstraints(minHeight: 120),
      decoration: BoxDecoration(
        color: const Color(0xFFD5E0DB),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF3C6E71), width: 1.5),
        boxShadow: const [
          BoxShadow(
            color: Color.fromARGB(78, 0, 0, 0),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 17),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 32, color: const Color(0xFF3C6E71)),
          const SizedBox(height: 12),
          Text(
            value.toString(),
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF3C6E71),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 5),
          Text(
            title,
            style: const TextStyle(
              fontSize: 14.5,
              color: Color(0xFF3C6E71),
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
