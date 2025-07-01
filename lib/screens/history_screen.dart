import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/guest_provider.dart';
import 'package:intl/intl.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final guests = Provider.of<GuestProvider>(context).guests;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FA),
      appBar: AppBar(
        title: const Text("Riwayat Kunjungan"),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 1,
      ),
      body: guests.isEmpty
          ? const Center(child: Text("Belum ada data tamu."))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: guests.length,
              itemBuilder: (context, index) {
                final guest = guests[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        blurRadius: 6,
                        offset: const Offset(0, 3),
                      )
                    ],
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.person, size: 32, color: Colors.blue),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              guest.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            if (guest.origin.isNotEmpty)
                              Text(
                                guest.origin,
                                style: const TextStyle(color: Colors.grey),
                              ),
                            const SizedBox(height: 4),
                            Text("📞 ${guest.phone.isEmpty ? '-' : guest.phone}"),
                            Text("📝 ${guest.purpose}"),
                            Text(
                              "🕒 ${DateFormat('dd MMM yyyy, HH:mm').format(guest.timestamp)}",
                              style: const TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                      // 🚫 Tidak ada tombol hapus di sini
                    ],
                  ),
                );
              },
            ),
    );
  }
}
