import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/guest_provider.dart';
import 'package:intl/intl.dart';
import 'login_screen.dart'; // ✅ Tambahkan ini

class AdminScreen extends StatelessWidget {
  const AdminScreen({super.key});

  void _logout(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final guests = Provider.of<GuestProvider>(context).guests;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FA),
      appBar: AppBar(
        title: const Text("Admin - Data Tamu"),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 1,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: () => _logout(context),
          )
        ],
      ),
      body: guests.isEmpty
          ? const Center(child: Text("Belum ada data kunjungan."))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              scrollDirection: Axis.horizontal,
              child: DataTable(
                headingRowColor: MaterialStateProperty.all(const Color(0xFFE3E9F7)),
                columns: const [
                  DataColumn(label: Text('Nama')),
                  DataColumn(label: Text('Telepon')),
                  DataColumn(label: Text('Instansi')),
                  DataColumn(label: Text('Keperluan')),
                  DataColumn(label: Text('Waktu')),
                  DataColumn(label: Text('Aksi')),
                ],
                rows: guests.map((guest) {
                  return DataRow(cells: [
                    DataCell(Text(guest.name)),
                    DataCell(Text(guest.phone.isNotEmpty ? guest.phone : '-')),
                    DataCell(Text(guest.origin.isNotEmpty ? guest.origin : '-')),
                    DataCell(Text(guest.purpose)),
                    DataCell(Text(DateFormat('dd MMM yyyy, HH:mm').format(guest.timestamp))),
                    DataCell(
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          Provider.of<GuestProvider>(context, listen: false).removeGuest(guest);
                        },
                      ),
                    ),
                  ]);
                }).toList(),
              ),
            ),
    );
  }
}
