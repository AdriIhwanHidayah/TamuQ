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
  final _purposeController = TextEditingController();
  DateTime selectedDate = DateTime.now();

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final guest = Guest(
        name: _nameController.text,
        purpose: _purposeController.text,
        timestamp: selectedDate,
      );
      Provider.of<GuestProvider>(context, listen: false).addGuest(guest);
      _nameController.clear();
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
      lastDate: DateTime(2030),
    );
    if (date != null) {
      setState(() => selectedDate = date);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Buku Tamu")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: "Nama"),
                validator: (value) => value!.isEmpty ? "Wajib diisi" : null,
              ),
              TextFormField(
                controller: _purposeController,
                decoration: const InputDecoration(labelText: "Keperluan"),
                validator: (value) => value!.isEmpty ? "Wajib diisi" : null,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: Text(DateFormat('dd MMM, yyyy').format(selectedDate)),
                  ),
                  ElevatedButton(
                    onPressed: _pickDate,
                    child: const Text("Pilih Tanggal"),
                  )
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submit,
                child: const Text("SUBMIT"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
