import 'package:flutter/material.dart';
import '../models/guest.dart';
import 'package:intl/intl.dart';

class GuestTile extends StatelessWidget {
  final Guest guest;

  const GuestTile({super.key, required this.guest});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(guest.name),
      subtitle: Text(guest.purpose),
      trailing: Text(DateFormat('dd MMM yyyy, HH:mm').format(guest.timestamp)),
    );
  }
}
