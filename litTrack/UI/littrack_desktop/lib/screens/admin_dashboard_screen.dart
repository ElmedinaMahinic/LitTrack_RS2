import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:littrack_desktop/layouts/master_screen.dart';
import 'package:littrack_desktop/providers/arhiva_provider.dart';
import 'package:littrack_desktop/providers/licna_preporuka_provider.dart';
import 'package:littrack_desktop/providers/moja_listum_provider.dart';
import 'package:littrack_desktop/providers/narudzba_provider.dart';
import 'package:littrack_desktop/providers/preporuka_provider.dart';
import 'package:littrack_desktop/providers/recenzija_odgovor_provider.dart';
import 'package:littrack_desktop/providers/recenzija_provider.dart';
import 'package:littrack_desktop/providers/report_provider.dart';
import 'package:littrack_desktop/providers/utils.dart';
import 'package:provider/provider.dart';
import 'package:file_selector/file_selector.dart';
import 'dart:typed_data';
import 'package:intl/intl.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  int procitaneKnjige = 0;
  int arhiviraneKnjige = 0;
  int brojRecenzija = 0;
  int brojPreporuka = 0;
  int knjigeZaBuduceCitanje = 0;
  String najdrazaKnjigaNaziv = "";
  bool isLoading = true;

  late final ReportProvider _reportProvider;

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
    _reportProvider = context.read<ReportProvider>();
    loadData();
  }

  Future<void> loadData() async {
    final mojaListaProvider = context.read<MojaListumProvider>();
    final arhivaProvider = context.read<ArhivaProvider>();
    final recenzijaProvider = context.read<RecenzijaProvider>();
    final odgovorProvider = context.read<RecenzijaOdgovorProvider>();
    final preporukaProvider = context.read<PreporukaProvider>();
    final licnaPreporukaProvider = context.read<LicnaPreporukaProvider>();
    final narudzbaProvider = context.read<NarudzbaProvider>();

    try {
      final procitane =
          await mojaListaProvider.get(filter: {"jeProcitana": true});
      final zaBuduce =
          await mojaListaProvider.get(filter: {"jeProcitana": false});
      final arhiva = await arhivaProvider.get();
      final recenzije = await recenzijaProvider.get();
      final odgovori = await odgovorProvider.get();
      final preporuke = await preporukaProvider.get();
      final licnePreporuke = await licnaPreporukaProvider.get();
      final najdraza = await arhivaProvider.getNajdrazaKnjigaNaziv();

      final String? backendSelectedState = selectedDisplayState != null
          ? stateDisplayToValue[selectedDisplayState!]
          : null;

      final narudzbePoMjesecimaData =
          await narudzbaProvider.getBrojNarudzbiPoMjesecima(
        stateFilter: backendSelectedState,
      );

      setState(() {
        procitaneKnjige = procitane.count;
        knjigeZaBuduceCitanje = zaBuduce.count;
        arhiviraneKnjige = arhiva.count;
        brojRecenzija = recenzije.count + odgovori.count;
        brojPreporuka = preporuke.count + licnePreporuke.count;
        najdrazaKnjigaNaziv = najdraza;
        narudzbePoMjesecima = narudzbePoMjesecimaData;
        isLoading = false;
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
    }
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreen(
      title: 'Statistika korisnika',
      child: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 25),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Wrap(
                      alignment: WrapAlignment.center,
                      spacing: 30,
                      runSpacing: 30,
                      children: [
                        _buildStatCard(getProcitaneKnjigeText(procitaneKnjige),
                            procitaneKnjige, Icons.check_circle),
                        _buildStatCard(
                            getArhiviraneKnjigeText(arhiviraneKnjige),
                            arhiviraneKnjige,
                            Icons.archive),
                        _buildStatCard(getRecenzijeText(brojRecenzija),
                            brojRecenzija, Icons.mode_comment),
                        _buildStatCard(getPreporukeText(brojPreporuka),
                            brojPreporuka, Icons.mail),
                        _buildStatCard(getZaBuduceText(knjigeZaBuduceCitanje),
                            knjigeZaBuduceCitanje, Icons.bookmark),
                        _buildStatCard("Trenutna najdraža knjiga",
                            najdrazaKnjigaNaziv, Icons.favorite),
                      ],
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
            initialValue: selectedDisplayState,
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
    const chartLineColor = Color(0xFF3C6E71);
    const backgroundColor = Color(0xFFF9F9F9);

    final totalOrders = narudzbePoMjesecima.fold(0, (sum, item) => sum + item);

    String getNarudzbaLabel(int broj) {
      if (broj == 1) return 'narudžba';
      if (broj >= 2 && broj <= 4) return 'narudžbe';
      return 'narudžbi';
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Padding(
          padding: EdgeInsets.only(bottom: 6.0),
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
              color: Color.fromARGB(159, 0, 0, 0),
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
                          color: Color.fromARGB(159, 0, 0, 0),
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
                        style: const TextStyle(
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
                          color: Color.fromARGB(159, 0, 0, 0),
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
                            style: const TextStyle(
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
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          elevation: WidgetStateProperty.all(4),
          padding: WidgetStateProperty.all(
            const EdgeInsets.symmetric(horizontal: 16),
          ),
          shadowColor: WidgetStateProperty.all(Colors.black54),
        ),
      ),
    );
  }

  Future<void> _saveReport() async {
    try {
      await showConfirmDialog(
        context: context,
        title: "Generisanje PDF-a",
        message: "Želite li preuzeti PDF sa statističkim podacima korisnika?",
        icon: Icons.picture_as_pdf,
        iconColor: Colors.redAccent,
        onConfirm: () async {
          try {
            final bytes = await _reportProvider.getAdminStatistikaPdf(
              stateMachine: selectedDisplayState != null
                  ? stateDisplayToValue[selectedDisplayState!]
                  : null,
            );

            if (bytes.isEmpty) return;

            final name =
                'AdminStatistika_${DateFormat('ddMMyyyy_HHmm').format(DateTime.now().toLocal())}.pdf';

            final location = await getSaveLocation(
              suggestedName: name,
              acceptedTypeGroups: [
                const XTypeGroup(label: 'PDF', extensions: ['pdf']),
              ],
            );

            if (location == null) return;

            final pdfBytes = Uint8List.fromList(bytes);

            final file = XFile.fromData(
              pdfBytes,
              name: name,
              mimeType: 'application/pdf',
            );

            await file.saveTo(location.path);

            if (!mounted) return;

            await showCustomDialog(
              context: context,
              title: "Uspjeh",
              message:
                  "PDF izvještaj je uspješno sačuvan.\nLokacija: ${location.path}",
              icon: Icons.check_circle_outline,
              iconColor: Colors.green,
            );
          } catch (e) {
            if (!mounted) return;
            await showCustomDialog(
              context: context,
              title: "Greška",
              message: "Greška pri preuzimanju PDF-a:\n$e",
              icon: Icons.error,
              iconColor: Colors.red,
            );
          }
        },
      );
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

  String getProcitaneKnjigeText(int count) {
    if (count == 1) return "Čitanje";
    if (count >= 2 && count <= 4) return "Čitanja";
    return "Čitanja";
  }

  String getArhiviraneKnjigeText(int count) {
    if (count == 1) return "Arhiviranje";
    if (count >= 2 && count <= 4) return "Arhiviranja";
    return "Arhiviranja";
  }

  String getRecenzijeText(int count) {
    if (count == 1) return "Napisana recenzija";
    if (count >= 2 && count <= 4) return "Napisane recenzije";
    return "Napisanih recenzija";
  }

  String getPreporukeText(int count) {
    if (count == 1) return "Preporuka";
    if (count >= 2 && count <= 4) return "Preporuke";
    return "Preporuka";
  }

  String getZaBuduceText(int count) {
    if (count == 1) return "Planirano čitanje";
    if (count >= 2 && count <= 4) return "Planirana čitanja";
    return "Planiranih čitanja";
  }

  Widget _buildStatCard(String title, dynamic value, IconData icon) {
    final isInt = value is int;
    final valueText = value.toString();

    return Container(
      width: 240,
      height: 140,
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
          const SizedBox(height: 6),
          if (isInt) ...[
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Color(0xFF3C6E71),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              valueText,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF3C6E71),
              ),
            ),
          ] else ...[
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      title,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF3C6E71),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      valueText,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF3C6E71),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
