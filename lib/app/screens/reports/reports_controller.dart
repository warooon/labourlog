import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../core/utils/csv_exporter.dart';
import '../../widgets/report_loading_widget.dart';

class ReportsController extends GetxController {
  final supabase = Supabase.instance.client;

  Future<void> generateAttendanceReport() async {
    try {
      Get.dialog(const ReportLoadingDialog(), barrierDismissible: false);

      final response = await supabase
          .from('attendance')
          .select('date, status, employees(name, category)')
          .order('date', ascending: false);

      final List<List<dynamic>> csvData = [
        ['Date', 'Employee Name', 'Category', 'Status'],
        ...response.map(
          (record) => [
            record['date'],
            record['employees']['name'],
            record['employees']['category'],
            record['status'],
          ],
        ),
      ];

      await CsvExporter.exportCsv(fileName: 'attendance_report', data: csvData);

      Get.back();
    } catch (e) {
      Get.back();
      Get.snackbar('Error', 'Failed to generate attendance report: $e');
    }
  }

  Future<void> generatePaymentsReport() async {
    try {
      Get.dialog(const ReportLoadingDialog(), barrierDismissible: false);

      final response = await supabase
          .from('payments')
          .select(
            'date, amount, payment_type, notes, deduct_from_advance, employees(name, category, advance_balance)',
          )
          .order('date', ascending: false);

      final List<List<dynamic>> csvData = [
        [
          'Date',
          'Employee Name',
          'Category',
          'Amount',
          'Payment Type',
          'Deducted from Advance?',
          'Advance Remaining',
          'Notes',
        ],
        ...response.map((record) {
          return [
            record['date'],
            record['employees']['name'],
            record['employees']['category'],
            record['amount'],
            record['payment_type'],
            record['deduct_from_advance'] == true ? 'Yes' : 'No',
            record['advance_balance'],
            record['notes'] ?? '',
          ];
        }),
      ];

      await CsvExporter.exportCsv(fileName: 'payment_report', data: csvData);

      Get.back();
    } catch (e) {
      Get.back();
      debugPrint("Payment report generation failed: $e");
      Get.snackbar('Error', 'Failed to generate payment report');
    }
  }

  Future<void> generateMonthlyReports(String month) async {
    try {
      Get.dialog(const ReportLoadingDialog(), barrierDismissible: false);

      final startDate = DateTime.parse('$month-01');
      final endDate = DateTime(startDate.year, startDate.month + 1, 0);

      final dateFormatter = DateFormat('yyyy-MM-dd');

      final attendanceResponse = await supabase
          .from('attendance')
          .select('date, status, employees(name, category)')
          .gte('date', dateFormatter.format(startDate))
          .lte('date', dateFormatter.format(endDate))
          .order('date', ascending: true);

      final attendanceCsv = <List<dynamic>>[
        ['Date', 'Employee Name', 'Category', 'Status'],
        ...attendanceResponse.map(
          (record) => [
            record['date'],
            record['employees']['name'],
            record['employees']['category'],
            record['status'],
          ],
        ),
      ];

      await CsvExporter.exportCsv(
        fileName: 'monthly_attendance_$month',
        data: attendanceCsv,
      );

      final paymentsResponse = await supabase
          .from('payments')
          .select(
            'date, amount, notes, payment_type, deduct_from_advance, employees(name, category, advance_balance)',
          )
          .gte('date', dateFormatter.format(startDate))
          .lte('date', dateFormatter.format(endDate))
          .order('date', ascending: true);

      final paymentsCsv = <List<dynamic>>[
        [
          'Date',
          'Employee Name',
          'Category',
          'Amount Paid',
          'Payment Type',
          'Deducted from Advance?',
          'Advance Remaining',
          'Notes',
        ],
        ...paymentsResponse.map(
          (record) => [
            record['date'],
            record['employees']['name'],
            record['employees']['category'],
            record['amount'],
            record['payment_type'],
            record['deduct_from_advance'] == true ? 'Yes' : 'No',
            record['employees']['advance_balance'] ?? '0',
            record['notes'] ?? '',
          ],
        ),
      ];

      await CsvExporter.exportCsv(
        fileName: 'monthly_payments_$month',
        data: paymentsCsv,
      );

      Get.back();
      Get.snackbar('Success', 'Monthly reports for $month downloaded');
    } catch (e) {
      Get.back();
      debugPrint("Monthly Report Error: $e");
      Get.snackbar('Error', 'Failed to generate monthly reports: $e');
    }
  }
}
