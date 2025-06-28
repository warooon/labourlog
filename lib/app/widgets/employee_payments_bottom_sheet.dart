import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../screens/payments/payments_controller.dart';
import 'add_payment_form.dart';

class EmployeePaymentsBottomSheet extends StatelessWidget {
  final Map employee;

  const EmployeePaymentsBottomSheet({super.key, required this.employee});

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
    final controller = Get.find<PaymentsController>();

    controller.loadPaymentsForEmployee(employee['id']);

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: SingleChildScrollView(
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
                    imageUrl != null
                        ? DecorationImage(
                          image: NetworkImage(imageUrl),
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
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : Colors.black,
              ),
            ),
            const SizedBox(height: 10),
            Divider(color: Colors.grey[400]),
            const SizedBox(height: 10),
            RowInfo(title: "Category", value: category),
            RowInfo(title: "Wage Type", value: wageType),
            RowInfo(title: "Wage Amount", value: "₹$wageAmount"),
            RowInfo(title: "Advance Taken", value: "₹$advance"),
            const SizedBox(height: 30),

            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Payment History",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black,
                ),
              ),
            ),

            const SizedBox(height: 12),

            Obx(() {
              final totalThisMonth = controller.getTotalPaidThisMonth(
                controller.payments,
              );

              return Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Total This Month: ₹$totalThisMonth",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white70 : Colors.black87,
                  ),
                ),
              );
            }),

            const SizedBox(height: 8),

            Align(
              alignment: Alignment.centerRight,
              child: Obx(() {
                return DropdownButton<String>(
                  value: controller.sortMode.value,
                  dropdownColor: isDark ? Colors.grey[900] : Colors.white,
                  style: TextStyle(color: isDark ? Colors.white : Colors.black),
                  underline: Container(),
                  icon: Icon(
                    Icons.sort,
                    color: isDark ? Colors.white : Colors.black,
                  ),
                  items: const [
                    DropdownMenuItem(
                      value: 'date_desc',
                      child: Text("Newest First"),
                    ),
                    DropdownMenuItem(
                      value: 'date_asc',
                      child: Text("Oldest First"),
                    ),
                    DropdownMenuItem(
                      value: 'amount_desc',
                      child: Text("Amount ↓"),
                    ),
                    DropdownMenuItem(
                      value: 'amount_asc',
                      child: Text("Amount ↑"),
                    ),
                  ],
                  onChanged: (value) {
                    controller.sortMode.value = value!;
                    controller.sortPayments();
                  },
                );
              }),
            ),

            const SizedBox(height: 8),

            Obx(() {
              final payments = controller.payments;
              if (payments.isEmpty) {
                return Text(
                  "No payments yet.",
                  style: TextStyle(
                    color: isDark ? Colors.white70 : Colors.black87,
                  ),
                );
              }
              return ListView.separated(
                itemCount: payments.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final p = payments[index];
                  final rawDate = p['date']?.toString();
                  final parsedDate =
                      rawDate != null ? DateTime.tryParse(rawDate) : null;
                  final formattedDate =
                      parsedDate != null
                          ? DateFormat('dd/MM/yyyy').format(parsedDate)
                          : 'N/A';
                  final note = p['notes'] ?? '';

                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.payment,
                          color: isDark ? Colors.white : Colors.black,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "₹${p['amount']}",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: isDark ? Colors.white : Colors.black,
                                ),
                              ),
                              if (note.isNotEmpty)
                                Text(
                                  note,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color:
                                        isDark
                                            ? Colors.white70
                                            : Colors.black87,
                                  ),
                                ),
                            ],
                          ),
                        ),
                        Text(
                          formattedDate,
                          style: TextStyle(
                            fontSize: 12,
                            color: isDark ? Colors.white54 : Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            }),

            const SizedBox(height: 30),

            ElevatedButton.icon(
              icon: Icon(
                Icons.attach_money,
                color: isDark ? Colors.black : Colors.white,
              ),
              label: Text(
                "Add Payment",
                style: TextStyle(color: isDark ? Colors.black : Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                backgroundColor: isDark ? Colors.white : Colors.black,
              ),
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  builder: (_) => AddPaymentForm(employee: employee),
                );
              },
            ),

            const SizedBox(height: 30),
          ],
        ),
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
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              color: isDark ? Colors.white70 : Colors.black87,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
