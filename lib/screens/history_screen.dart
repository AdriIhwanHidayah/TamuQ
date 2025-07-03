import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  List<dynamic> _guests = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchGuests();
  }

  Future<void> fetchGuests() async {
    final url = Uri.parse('http://127.0.0.1:3000/guest'); // Ganti ke IP lokal jika pakai device
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        setState(() {
          _guests = jsonDecode(response.body);
          _isLoading = false;
        });
      } else {
        setState(() => _isLoading = false);
        print("Gagal mengambil data: ${response.statusCode}");
      }
    } catch (e) {
      setState(() => _isLoading = false);
      print("Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FA),
      appBar: AppBar(
        title: const Text("Riwayat Kunjungan"),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 1,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _guests.isEmpty
              ? const Center(child: Text("Belum ada data tamu."))
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _guests.length,
                  itemBuilder: (context, index) {
                    final guest = _guests[index];
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
                                  guest['name'],
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                if ((guest['origin'] ?? '').isNotEmpty)
                                  Text(
                                    guest['origin'],
                                    style: const TextStyle(color: Colors.grey),
                                  ),
                                const SizedBox(height: 4),
                                Text("📞 ${guest['phone']?.isEmpty ?? true ? '-' : guest['phone']}"),
                                Text("📝 ${guest['purpose']}"),
                                Text(
                                  "🕒 ${DateFormat('dd MMM yyyy, HH:mm').format(DateTime.parse(guest['timestamp']))}",
                                  style: const TextStyle(color: Colors.grey),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
    );
  }
}
