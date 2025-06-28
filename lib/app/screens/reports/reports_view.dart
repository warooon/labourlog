import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:labourlog/app/widgets/report_page_tile.dart';
import '../../widgets/month_selection_dialog.dart';
import 'reports_controller.dart';

class ReportsView extends GetView<ReportsController> {
  const ReportsView({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.05,
          vertical: screenHeight * 0.05,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Reports',
              style: TextStyle(fontSize: 45, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: screenHeight * 0.01),
            Text(
              'Generate and view reports',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: screenHeight * 0.075),
            SizedBox(
              height: screenHeight * 0.5,
              width: double.infinity,
              child: Column(
                children: [
                  ReportPageTile(
                    icon: Icons.calendar_month,
                    title: 'Full Attendance Report',
                    subtitle: 'Export a CSV file of all attendance records',
                    onTap: () async {
                      await controller.generateAttendanceReport();
                      await Future.delayed(Duration(milliseconds: 300));
                      Get.snackbar('Success', 'Attendance report downloaded');
                    },
                  ),

                  SizedBox(height: screenHeight * 0.03),
                  ReportPageTile(
                    icon: Icons.summarize_outlined,
                    title: 'Monthly Summary',
                    subtitle:
                        'Export a CSV file of monthly attendance and payment summaries',
                    onTap: () async {
                      final selectedDate = await MonthSelectionDialog.show(
                        context,
                      );

                      if (selectedDate != null) {
                        final formatted =
                            '${selectedDate.year}-${selectedDate.month.toString().padLeft(2, '0')}';
                        await controller.generateMonthlyReports(formatted);

                        await Future.delayed(const Duration(milliseconds: 300));
                        Get.snackbar(
                          'Success',
                          'Monthly reports downloaded for $formatted',
                        );
                      }
                    },
                  ),
                  SizedBox(height: screenHeight * 0.03),
                  ReportPageTile(
                    icon: Icons.currency_rupee,
                    title: 'Payment Records',
                    subtitle: 'Export a CSV file of all payment records',
                    onTap: () async {
                      await controller.generatePaymentsReport();
                      await Future.delayed(Duration(milliseconds: 300));
                      Get.snackbar('Success', 'Payment report downloaded');
                    },
                  ),
                  SizedBox(height: screenHeight * 0.03),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
