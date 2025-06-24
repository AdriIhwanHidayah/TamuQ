import 'package:hive/hive.dart';

part 'guest.g.dart';


@HiveType(typeId: 0)
class Guest extends HiveObject {
  @HiveField(0)
  String name;

  @HiveField(1)
  String purpose;

  @HiveField(2)
  String phone;

  @HiveField(3)
  String origin;

  @HiveField(4)
  DateTime timestamp;

  Guest({
    required this.name,
    required this.purpose,
    this.phone = '',
    this.origin = '',
    required this.timestamp,
  });
}
