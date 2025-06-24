import 'package:flutter/material.dart';
import '../models/guest.dart';
import '../services/db_service.dart';

class GuestProvider extends ChangeNotifier {
  List<Guest> guests = [];

  void loadGuests() {
    guests = DbService.getGuests();
    notifyListeners();
  }

  void addGuest(Guest guest) async {
    await DbService.addGuest(guest);
    loadGuests();
  }

  void removeGuest(Guest guest) async {
    await DbService.removeGuest(guest);
    loadGuests();
  }

  void clearGuests() async {
    await DbService.clearGuests();
    loadGuests();
  }

  List<Guest> searchGuests(String keyword) {
    return guests.where((guest) =>
      guest.name.toLowerCase().contains(keyword.toLowerCase()) ||
      guest.purpose.toLowerCase().contains(keyword.toLowerCase())
    ).toList();
  }
}
