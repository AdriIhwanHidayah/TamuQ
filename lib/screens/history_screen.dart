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
      appBar: AppBar(title: const Text("Riwayat")),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: guests.length,
        itemBuilder: (context, index) {
          final guest = guests[index];
          return Card(
            child: ListTile(
              title: Text(guest.name),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(guest.purpose),
                  Text(DateFormat('dd, MMM yyyy, hh:mm a').format(guest.timestamp)),
                ],
              ),
              trailing: IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () {
                  Provider.of<GuestProvider>(context, listen: false).removeGuest(guest);
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
