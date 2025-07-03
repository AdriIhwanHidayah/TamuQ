import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  Map<String, int> visitPerDay = {};
  List<String> sortedKeys = [];

  @override
  void initState() {
    super.initState();
    fetchGuestData();
  }

  Future<void> fetchGuestData() async {
    final url = Uri.parse('http://127.0.0.1:3000/guest'); // Ubah ke IP lokal jika pakai emulator/device
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        final Map<String, int> tempVisit = {};

        for (var item in data) {
          final dateKey = DateFormat('dd/MM').format(DateTime.parse(item['timestamp']));
          tempVisit[dateKey] = (tempVisit[dateKey] ?? 0) + 1;
        }

        final keys = tempVisit.keys.toList()
          ..sort((a, b) => DateFormat('dd/MM').parse(a).compareTo(DateFormat('dd/MM').parse(b)));

        setState(() {
          visitPerDay = tempVisit;
          sortedKeys = keys;
        });
      } else {
        print('Gagal fetch data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard Kunjungan'),
        centerTitle: true,
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text(
              'Statistik Jumlah Tamu per Hari',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: visitPerDay.isEmpty
                  ? const Center(child: CircularProgressIndicator())
                  : BarChart(
                      BarChartData(
                        alignment: BarChartAlignment.spaceAround,
                        barTouchData: BarTouchData(enabled: true),
                        titlesData: FlTitlesData(
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 28,
                              interval: 1,
                              getTitlesWidget: (value, meta) => Text(value.toInt().toString()),
                            ),
                          ),
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (value, meta) {
                                final index = value.toInt();
                                if (index < 0 || index >= sortedKeys.length) return const Text('');
                                return Text(
                                  sortedKeys[index],
                                  style: const TextStyle(fontSize: 10),
                                );
                              },
                            ),
                          ),
                          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        ),
                        borderData: FlBorderData(show: false),
                        barGroups: List.generate(sortedKeys.length, (index) {
                          final key = sortedKeys[index];
                          final count = visitPerDay[key]!;
                          return BarChartGroupData(
                            x: index,
                            barRods: [
                              BarChartRodData(toY: count.toDouble(), width: 18, color: Colors.teal),
                            ],
                          );
                        }),
                        gridData: FlGridData(show: false),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
