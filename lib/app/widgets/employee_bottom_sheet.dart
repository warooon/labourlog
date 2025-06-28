import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../screens/employee/employee_controller.dart';
import 'action_button.dart';

class EmployeeBottomSheet extends StatelessWidget {
  final Map employee;
  final controller = Get.find<EmployeeController>();

  EmployeeBottomSheet({super.key, required this.employee});

  @override
  Widget build(BuildContext context) {
    final name = employee['name'] ?? '';
    final category = employee['category'] ?? '';
    final wageType = (employee['wage_type'] ?? '').toString().toLowerCase();
    final wageAmount =
        wageType == 'daily'
            ? employee['daily_wage']?.toString() ?? 'N/A'
            : wageType == 'monthly'
            ? employee['monthly_wage']?.toString() ?? 'N/A'
            : 'N/A';
    final advance = employee['advance_balance']?.toString() ?? '0';
    final imageUrl = employee['photo_url'];

    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 16),
          Container(
            height: 120,
            width: 120,
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(24),
              image:
                  (imageUrl != null && imageUrl.isNotEmpty)
                      ? DecorationImage(
                        image: NetworkImage(() {
                          return imageUrl;
                        }()),
                        fit: BoxFit.cover,
                      )
                      : null,

              color:
                  imageUrl == null
                      ? (isDark ? Colors.white : Colors.black)
                      : Colors.transparent,
            ),
            child:
                imageUrl == null
                    ? Center(
                      child: Text(
                        name.isNotEmpty ? name[0] : '?',
                        style: TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.black : Colors.white,
                        ),
                      ),
                    )
                    : null,
          ),
          const SizedBox(height: 20),
          Text(
            name,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Divider(color: Colors.grey[400]),
          const SizedBox(height: 10),
          RowInfo(title: "Category", value: category),
          RowInfo(title: "Wage Type", value: wageType),
          RowInfo(title: "Wage Amount", value: "₹$wageAmount"),
          RowInfo(title: "Advance Taken", value: "₹$advance"),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ActionButton(
                icon: Icons.edit,
                label: "Edit",
                onPressed: () {
                  Navigator.pop(context);
                  controller.editEmployee(employee);
                },
              ),
              ActionButton(
                icon: Icons.delete,
                label: "Delete",
                onPressed: () {
                  Navigator.pop(context);
                  controller.deleteEmployee(context, employee);
                },
                color: Colors.red,
              ),
            ],
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }
}

class RowInfo extends StatelessWidget {
  final String title;
  final String value;

  const RowInfo({super.key, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(fontSize: 16)),
          Text(
            value,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
