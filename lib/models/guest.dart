class Guest {
  final String? id;
  final String name;
  final String phone;
  final String origin;
  final String purpose;
  final DateTime timestamp;

  Guest({
    this.id,
    required this.name,
    required this.phone,
    required this.origin,
    required this.purpose,
    required this.timestamp,
  });

  factory Guest.fromJson(Map<String, dynamic> json) {
    return Guest(
      id: json['id'],
      name: json['name'] ?? '',
      phone: json['phone'] ?? '',
      origin: json['origin'] ?? '',
      purpose: json['purpose'] ?? '',
      timestamp: DateTime.parse(json['timestamp']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'origin': origin,
      'purpose': purpose,
      'timestamp': timestamp.toIso8601String(),
    };
  }
}
