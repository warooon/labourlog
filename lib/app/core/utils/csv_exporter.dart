// ignore_for_file: deprecated_member_use

import 'dart:io';
import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:convert';
import 'dart:html' as html;
import 'package:universal_html/html.dart' as universal_html;

// class CsvExporter {
//   static Future<void> exportCsv({
//     required String fileName,
//     required List<List<dynamic>> data,
//     String? shareText,
//   }) async {
//     try {
//       final csvString = const ListToCsvConverter().convert(data);

//       final directory = await getApplicationDocumentsDirectory();
//       final filePath = '${directory.path}/$fileName.csv';

//       final file = File(filePath);
//       await file.writeAsString(csvString);

//       await Share.shareXFiles([
//         XFile(filePath),
//       ], text: shareText ?? '$fileName Report');
//     } catch (e) {
//       debugPrint('CSV Export Error: $e');
//     }
//   }
// }

class CsvExporter {
  static Future<void> exportCsv({
    required String fileName,
    required List<List<dynamic>> data,
  }) async {
    final csv = const ListToCsvConverter().convert(data);

    final bytes = utf8.encode(csv);
    final blob = html.Blob([bytes]);

    final url = html.Url.createObjectUrlFromBlob(blob);

    final anchor =
        html.AnchorElement(href: url)
          ..setAttribute("download", "$fileName.csv")
          ..click();

    html.Url.revokeObjectUrl(url);
  }
}
