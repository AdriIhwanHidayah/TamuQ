import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/guest_provider.dart';
import 'package:intl/intl.dart';

class AdminScreen extends StatelessWidget {
  const AdminScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final guests = Provider.of<GuestProvider>(context).guests;

    return Scaffold(
      appBar: AppBar(title: const Text("Admin")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: guests.isEmpty
            ? const Center(child: Text("Belum ada data"))
            : SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columns: const [
                    DataColumn(label: Text("Nama")),
                    DataColumn(label: Text("Waktu")),
                  ],
                  rows: guests
                      .map((guest) => DataRow(cells: [
                            DataCell(Text(guest.name)),
                            DataCell(Text(DateFormat('dd MMM yyyy, HH:mm').format(guest.timestamp))),
                          ]))
                      .toList(),
                ),
              ),
      ),
    );
  }
}
