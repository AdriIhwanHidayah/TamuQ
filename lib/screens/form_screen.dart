import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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

  Future<void> _submit() async {
    if (_formKey.currentState!.validate()) {
      final url = Uri.parse('http://127.0.0.1:3000/guest'); // Ganti IP jika pakai emulator

      final guestData = {
        "id": DateTime.now().millisecondsSinceEpoch.toString(),
        "name": _nameController.text,
        "phone": _phoneController.text,
        "origin": _orgController.text,
        "purpose": _purposeController.text,
        "timestamp": selectedDate.toIso8601String()
      };

      try {
        final response = await http.post(
          url,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(guestData),
        );

        if (response.statusCode == 200) {
          _nameController.clear();
          _phoneController.clear();
          _orgController.clear();
          _purposeController.clear();
          setState(() => selectedDate = DateTime.now());

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Data berhasil dikirim")),
          );
        } else {
          throw Exception('Gagal: ${response.body}');
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: $e")),
        );
      }
    }
  }

  void _pickDate() async {
    final DateTime? date = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2023),
      lastDate: DateTime(2035),
    );
    if (date != null) setState(() => selectedDate = date);
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
              children: [
                const Text("Form Buku Tamu", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 24),

                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: "Nama Lengkap",
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) => value!.isEmpty ? "Wajib diisi" : null,
                ),
                const SizedBox(height: 16),

                TextFormField(
                  controller: _phoneController,
                  decoration: const InputDecoration(
                    labelText: "Nomor Telepon",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),

                TextFormField(
                  controller: _orgController,
                  decoration: const InputDecoration(
                    labelText: "Organisasi / Instansi",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),

                TextFormField(
                  controller: _purposeController,
                  decoration: const InputDecoration(
                    labelText: "Keperluan",
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) => value!.isEmpty ? "Wajib diisi" : null,
                ),
                const SizedBox(height: 16),

                Row(
                  children: [
                    Expanded(child: Text(DateFormat('dd MMM yyyy').format(selectedDate))),
                    ElevatedButton(
                      onPressed: _pickDate,
                      child: const Text("Pilih Tanggal"),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                ElevatedButton(
                  onPressed: _submit,
                  child: const Text("SUBMIT"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
