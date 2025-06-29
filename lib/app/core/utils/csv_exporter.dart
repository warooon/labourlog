// ignore_for_file: deprecated_member_use

import 'package:csv/csv.dart';
import 'dart:convert';
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;

class CsvExporter {
  static Future<void> exportCsv({
    required String fileName,
    required List<List<dynamic>> data,
  }) async {
    final csv = const ListToCsvConverter().convert(data);

    final bytes = utf8.encode(csv);
    final blob = html.Blob([bytes]);

    final url = html.Url.createObjectUrlFromBlob(blob);

    html.AnchorElement(href: url)
      ..setAttribute("download", "$fileName.csv")
      ..click();

    html.Url.revokeObjectUrl(url);
  }
}
