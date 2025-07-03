import 'dart:typed_data';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import '../models/guest.dart'; // pastikan ini ditambahkan

class PdfService {
  static Future<Uint8List> generateGuestPdf(List<Guest> guests) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        build: (context) => [
          pw.Text(
            'Laporan Buku Tamu',
            style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold),
          ),
          pw.SizedBox(height: 12),
          pw.Table.fromTextArray(
            border: null,
            headers: ['Nama', 'Keperluan', 'Tanggal', 'Telepon', 'Instansi'],
            data: guests.map((g) {
              return [
                g.name,
                g.purpose,
                DateFormat('dd MMM yyyy – HH:mm').format(g.timestamp),
                g.phone,
                g.origin,
              ];
            }).toList(),
          ),
        ],
      ),
    );

    return pdf.save();
  }
}
