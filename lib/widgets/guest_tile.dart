import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class GuestTile extends StatelessWidget {
  final Map<String, dynamic> guest;

  const GuestTile({super.key, required this.guest});

  @override
  Widget build(BuildContext context) {
    final timestamp = DateTime.tryParse(guest['timestamp'] ?? '');

    return ListTile(
      title: Text(guest['name'] ?? 'Tanpa Nama'),
      subtitle: Text(guest['purpose'] ?? '-'),
      trailing: Text(
        timestamp != null
            ? DateFormat('dd MMM yyyy, HH:mm').format(timestamp)
            : '-',
      ),
    );
  }
}
