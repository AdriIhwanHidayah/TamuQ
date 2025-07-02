import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../providers/guest_provider.dart';
import '../models/guest.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final guestProvider = Provider.of<GuestProvider>(context);
    final guests = guestProvider.guests;

    final Map<String, int> visitPerDay = {};

    for (var guest in guests) {
      final dateKey = DateFormat('dd/MM').format(guest.timestamp);
      visitPerDay[dateKey] = (visitPerDay[dateKey] ?? 0) + 1;
    }

    final sortedKeys = visitPerDay.keys.toList()
      ..sort((a, b) => DateFormat('dd/MM').parse(a).compareTo(DateFormat('dd/MM').parse(b)));

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
              child: BarChart(
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
