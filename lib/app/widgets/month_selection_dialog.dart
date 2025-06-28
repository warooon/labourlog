import 'package:flutter/material.dart';

class MonthSelectionDialog extends StatefulWidget {
  const MonthSelectionDialog({super.key});

  static Future<DateTime?> show(BuildContext context) {
    return showDialog<DateTime>(
      context: context,
      builder: (_) => const MonthSelectionDialog(),
    );
  }

  @override
  State<MonthSelectionDialog> createState() => _MonthSelectionDialogState();
}

class _MonthSelectionDialogState extends State<MonthSelectionDialog> {
  final now = DateTime.now();
  late int selectedYear;
  late int selectedMonth;

  @override
  void initState() {
    super.initState();
    selectedYear = now.year;
    selectedMonth = now.month;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = isDark ? Colors.white : Colors.black;
    final backgroundColor = isDark ? Colors.black : Colors.white;
    final textColor = isDark ? Colors.white : Colors.black;

    return AlertDialog(
      backgroundColor: backgroundColor,
      title: Text('Select Month', style: TextStyle(color: textColor)),
      content: SizedBox(
        height: 300,
        width: double.maxFinite,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: primaryColor),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<int>(
                  value: selectedYear,
                  iconEnabledColor: textColor,
                  dropdownColor: backgroundColor,
                  style: TextStyle(color: textColor),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        selectedYear = value;
                      });
                    }
                  },
                  items: List.generate(5, (index) {
                    final year = now.year - 2 + index;
                    return DropdownMenuItem(
                      value: year,
                      child: Text('$year', style: TextStyle(color: textColor)),
                    );
                  }),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: 12,
                itemBuilder: (_, index) {
                  final month = index + 1;
                  return RadioListTile<int>(
                    title: Text(
                      _monthName(month),
                      style: TextStyle(color: textColor),
                    ),
                    activeColor: primaryColor,
                    value: month,
                    groupValue: selectedMonth,
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          selectedMonth = value;
                        });
                      }
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(null),
          child: Text('Cancel', style: TextStyle(color: primaryColor)),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: primaryColor),
          onPressed: () {
            Navigator.of(context).pop(DateTime(selectedYear, selectedMonth));
          },
          child: Text('Download', style: TextStyle(color: backgroundColor)),
        ),
      ],
    );
  }

  String _monthName(int month) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return months[month - 1];
  }
}
