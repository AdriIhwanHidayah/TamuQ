import 'package:hive/hive.dart';
import '../models/guest.dart';

class DbService {
  static const String boxName = 'guestBox';

  static Future<void> addGuest(Guest guest) async {
    final box = Hive.box<Guest>(boxName);
    await box.add(guest);
  }

  static List<Guest> getGuests() {
    final box = Hive.box<Guest>(boxName);
    return box.values.toList();
  }

  static Future<void> removeGuest(Guest guest) async {
    await guest.delete();
  }

  static Future<void> clearGuests() async {
    final box = Hive.box<Guest>(boxName);
    await box.clear();
  }
}
