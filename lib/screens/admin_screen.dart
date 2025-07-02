import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:printing/printing.dart';

import '../models/guest.dart';
import '../providers/guest_provider.dart';
import '../services/pdf_service.dart';
import 'dashboard_screen.dart'; // 👈 pastikan path benar

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Guest> _filteredGuests = [];

  DateTime? _startDate;
  DateTime? _endDate;

  @override
  void initState() {
    super.initState();
    final guests = context.read<GuestProvider>().guests;
    _filteredGuests = guests;
    _searchController.addListener(_applyFilters);
  }

  void _applyFilters() {
    final query = _searchController.text.toLowerCase();
    final guests = context.read<GuestProvider>().guests;

    setState(() {
      _filteredGuests = guests.where((guest) {
        final matchesSearch = guest.name.toLowerCase().contains(query) ||
            guest.purpose.toLowerCase().contains(query);

        final matchesDate = (_startDate == null || guest.timestamp.isAfter(_startDate!.subtract(const Duration(days: 1)))) &&
            (_endDate == null || guest.timestamp.isBefore(_endDate!.add(const Duration(days: 1))));

        return matchesSearch && matchesDate;
      }).toList();
    });
  }

  void _pickDateRange() async {
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2023),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      initialDateRange: _startDate != null && _endDate != null
          ? DateTimeRange(start: _startDate!, end: _endDate!)
          : null,
    );

    if (picked != null) {
      setState(() {
        _startDate = picked.start;
        _endDate = picked.end;
      });
      _applyFilters();
    }
  }

  void _resetDateFilter() {
    setState(() {
      _startDate = null;
      _endDate = null;
    });
    _applyFilters();
  }

  void _exportToPdf() async {
    final pdfData = await PdfService.generateGuestPdf(_filteredGuests);
    await Printing.layoutPdf(onLayout: (format) => pdfData);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final guestProvider = Provider.of<GuestProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Panel Admin'),
        centerTitle: true,
        backgroundColor: Colors.indigo.shade600,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.picture_as_pdf),
            tooltip: 'Export PDF',
            onPressed: _filteredGuests.isEmpty ? null : _exportToPdf,
          ),
          IconButton(
            icon: const Icon(Icons.bar_chart),
            tooltip: 'Lihat Dashboard',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const DashboardScreen()),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // 🔎 Search Bar
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                hintText: 'Cari nama atau keperluan...',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),

          // 🗓️ Date Filter
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [
                ElevatedButton.icon(
                  onPressed: _pickDateRange,
                  icon: const Icon(Icons.date_range),
                  label: const Text('Pilih Tanggal'),
                ),
                const SizedBox(width: 12),
                if (_startDate != null && _endDate != null)
                  Expanded(
                    child: Text(
                      'Filter: ${DateFormat('dd/MM/yyyy').format(_startDate!)} - ${DateFormat('dd/MM/yyyy').format(_endDate!)}',
                      style: const TextStyle(fontStyle: FontStyle.italic),
                    ),
                  ),
                if (_startDate != null && _endDate != null)
                  IconButton(
                    icon: const Icon(Icons.clear),
                    tooltip: 'Reset Filter',
                    onPressed: _resetDateFilter,
                  ),
              ],
            ),
          ),

          // 📋 Daftar tamu
          Expanded(
            child: _filteredGuests.isEmpty
                ? const Center(child: Text('Tidak ada hasil ditemukan.'))
                : ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: _filteredGuests.length,
                    itemBuilder: (context, index) {
                      final guest = _filteredGuests[index];
                      return AdminGuestCard(
                        guest: guest,
                        onDelete: () {
                          guestProvider.removeGuest(guest);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Data tamu dihapus')),
                          );
                          _applyFilters();
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class AdminGuestCard extends StatelessWidget {
  final Guest guest;
  final VoidCallback onDelete;

  const AdminGuestCard({
    super.key,
    required this.guest,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final dateFormatted = DateFormat('dd MMM yyyy • HH:mm').format(guest.timestamp);

    return Card(
      elevation: 3,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Nama dan tombol hapus
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text(
                    guest.name,
                    style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outline, color: Colors.red),
                  onPressed: onDelete,
                ),
              ],
            ),
            const SizedBox(height: 6),

            Row(
              children: [
                const Icon(Icons.work_outline, size: 16),
                const SizedBox(width: 6),
                Text(guest.purpose),
              ],
            ),
            if (guest.phone.isNotEmpty)
              Row(
                children: [
                  const Icon(Icons.phone, size: 16),
                  const SizedBox(width: 6),
                  Text(guest.phone),
                ],
              ),
            if (guest.origin.isNotEmpty)
              Row(
                children: [
                  const Icon(Icons.business, size: 16),
                  const SizedBox(width: 6),
                  Text(guest.origin),
                ],
              ),
            const SizedBox(height: 6),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                dateFormatted,
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
