import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../screens/payments/payments_controller.dart';

class AddPaymentForm extends StatefulWidget {
  final Map employee;

  const AddPaymentForm({super.key, required this.employee});

  @override
  State<AddPaymentForm> createState() => _AddPaymentFormState();
}

class _AddPaymentFormState extends State<AddPaymentForm> {
  final _formKey = GlobalKey<FormState>();
  final amountController = TextEditingController();
  final noteController = TextEditingController();
  bool addToAdvance = false;
  bool deductFromAdvance = false;
  DateTime selectedDate = DateTime.now();
  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PaymentsController>();
    final emp = widget.employee;

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : Colors.black;
    final buttonBgColor = isDark ? Colors.white : Colors.black;
    final buttonTextColor = isDark ? Colors.black : Colors.white;

    final formattedDate =
        "${selectedDate.year}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.day.toString().padLeft(2, '0')}";

    return SingleChildScrollView(
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 24,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Form(
        key: _formKey,
        child: Theme(
          data: Theme.of(context).copyWith(
            textTheme: Theme.of(
              context,
            ).textTheme.apply(bodyColor: textColor, displayColor: textColor),
            textSelectionTheme: const TextSelectionThemeData(
              selectionHandleColor: Colors.black,
              cursorColor: Colors.black,
            ),
            inputDecorationTheme: InputDecorationTheme(
              labelStyle: TextStyle(color: textColor),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: textColor.withOpacity(0.5)),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: textColor),
              ),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Add Payment for ${emp['name']}",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: amountController,
                decoration: const InputDecoration(labelText: 'Amount'),
                keyboardType: TextInputType.number,
                validator: (val) => val!.isEmpty ? 'Enter amount' : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: noteController,
                decoration: const InputDecoration(labelText: 'Note'),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Add to Advance", style: TextStyle(color: textColor)),
                  Switch.adaptive(
                    activeColor: textColor,
                    value: addToAdvance,
                    onChanged: (val) => setState(() => addToAdvance = val),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Deduct from Advance",
                    style: TextStyle(color: textColor),
                  ),
                  Switch.adaptive(
                    activeColor: textColor,
                    value: deductFromAdvance,
                    onChanged: (val) => setState(() => deductFromAdvance = val),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text("Payment Date"),
                subtitle: Text(
                  formattedDate,
                  style: TextStyle(color: textColor),
                ),
                trailing: IconButton(
                  icon: Icon(Icons.calendar_today, color: textColor),
                  onPressed: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: selectedDate,
                      firstDate: DateTime(2020),
                      lastDate: DateTime.now(),
                      builder: (context, child) {
                        return Theme(
                          data:
                              isDark
                                  ? ThemeData.dark().copyWith(
                                    colorScheme: const ColorScheme.dark(
                                      primary: Colors.white,
                                      onPrimary: Colors.black,
                                    ),
                                  )
                                  : ThemeData.light().copyWith(
                                    colorScheme: const ColorScheme.light(
                                      primary: Colors.black,
                                      onPrimary: Colors.white,
                                    ),
                                  ),
                          child: child!,
                        );
                      },
                    );
                    if (picked != null) setState(() => selectedDate = picked);
                  },
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                icon: Icon(Icons.check, color: buttonTextColor),
                label: const Text("Submit"),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(48),
                  backgroundColor: buttonBgColor,
                  foregroundColor: buttonTextColor,
                ),
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    final amount = int.tryParse(amountController.text) ?? 0;
                    if (amount == 0) {
                      Get.snackbar(
                        'Invalid Amount',
                        'Amount must be greater than 0',
                      );
                      return;
                    }

                    await controller.addPayment(
                      employee: emp,
                      amount: amount,
                      notes: noteController.text.trim(),
                      date: selectedDate,
                      deductFromAdvance: deductFromAdvance,
                    );

                    if (addToAdvance) {
                      await controller.updateAdvance(emp, amount);
                    }

                    Navigator.of(context).pop(); // <- fixed missing parentheses
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
