import 'package:hive/hive.dart';

part 'guest.g.dart';

@HiveType(typeId: 0)
class Guest extends HiveObject {
  @HiveField(0)
  String name; // Nama lengkap tamu

  @HiveField(1)
  String purpose; // Keperluan kunjungan

  @HiveField(2)
  String phone; // Nomor telepon

  @HiveField(3)
  String origin; // Instansi/Organisasi

  @HiveField(4)
  DateTime timestamp; // Waktu kunjungan

  Guest({
    required this.name,
    required this.purpose,
    this.phone = '',
    this.origin = '',
    required this.timestamp,
  });
}
