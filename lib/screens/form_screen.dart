import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../models/guest.dart';
import '../providers/guest_provider.dart';

class FormScreen extends StatefulWidget {
  const FormScreen({super.key});

  @override
  State<FormScreen> createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _orgController = TextEditingController();
  final _purposeController = TextEditingController();
  DateTime selectedDate = DateTime.now();

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final guest = Guest(
        name: _nameController.text,
        phone: _phoneController.text,
        origin: _orgController.text,
        purpose: _purposeController.text,
        timestamp: selectedDate,
      );
      Provider.of<GuestProvider>(context, listen: false).addGuest(guest);

      _nameController.clear();
      _phoneController.clear();
      _orgController.clear();
      _purposeController.clear();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Data berhasil disimpan")),
      );
    }
  }

  void _pickDate() async {
    final DateTime? date = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2023),
      lastDate: DateTime(2035),
    );
    if (date != null) {
      setState(() => selectedDate = date);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FA),
      appBar: AppBar(
        title: const Text("Buku Tamu"),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 1,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Center(
                  child: Text(
                    "Form Buku Tamu",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Nama Lengkap
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: "Nama Lengkap",
                    hintText: "Masukkan nama lengkap",
                    filled: true,
                    fillColor: Color(0xFFF1F4F8),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) => value!.isEmpty ? "Wajib diisi" : null,
                ),
                const SizedBox(height: 16),

                // No Telepon
                TextFormField(
                  controller: _phoneController,
                  decoration: const InputDecoration(
                    labelText: "Nomor Telepon",
                    hintText: "Masukkan nomor telepon (opsional)",
                    filled: true,
                    fillColor: Color(0xFFF1F4F8),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),

                // Organisasi
                TextFormField(
                  controller: _orgController,
                  decoration: const InputDecoration(
                    labelText: "Organisasi / Instansi",
                    hintText: "Masukkan nama organisasi (opsional)",
                    filled: true,
                    fillColor: Color(0xFFF1F4F8),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),

                // Keperluan
                TextFormField(
                  controller: _purposeController,
                  maxLines: 2,
                  decoration: const InputDecoration(
                    labelText: "Keperluan",
                    hintText: "Masukkan keperluan",
                    filled: true,
                    fillColor: Color(0xFFF1F4F8),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) => value!.isEmpty ? "Wajib diisi" : null,
                ),
                const SizedBox(height: 16),

                // Tanggal
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        DateFormat('dd MMM yyyy').format(selectedDate),
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                      ),
                      icon: const Icon(Icons.calendar_today, size: 18),
                      label: const Text("Pilih Tanggal"),
                      onPressed: _pickDate,
                    )
                  ],
                ),
                const SizedBox(height: 24),

                // Submit
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: _submit,
                    child: const Text(
                      "SUBMIT",
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
