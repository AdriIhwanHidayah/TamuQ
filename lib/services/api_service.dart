import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'http://10.0.2.2:3000'; // Ubah jika di emulator Android

  static Future<bool> sendGuestData(Map<String, dynamic> data) async {
    final url = Uri.parse('$baseUrl/guest');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(data),
      );

      if (response.statusCode == 200) {
        print('Sukses: ${response.body}');
        return true;
      } else {
        print('Gagal: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Error: $e');
      return false;
    }
  }
}
