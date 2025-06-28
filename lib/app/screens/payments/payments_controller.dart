import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../employee_edit/employee_edit_view.dart';

class PaymentsController extends GetxController {
  final supabase = Supabase.instance.client;

  var employees = [].obs;
  var filteredEmployees = [].obs;
  var selectedCategory = 'All'.obs;
  var searchQuery = ''.obs;
  var totalEmployeeCount = 0.obs;

  var payments = <Map>[].obs; // 💰 payments for selected employee
  var sortMode = 'date_desc'.obs;

  @override
  void onInit() {
    super.onInit();
    fetchEmployees();
  }

  Future<void> fetchEmployees() async {
    try {
      final data = await supabase.from('employees').select();
      employees.value = data;
      totalEmployeeCount.value = data.length;
      applyFilters();
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch employees');
    }
  }

  void applyFilters() {
    List filtered = employees;

    if (selectedCategory.value.toLowerCase() != 'all') {
      filtered =
          filtered
              .where(
                (e) =>
                    (e['category'] ?? '').toLowerCase().trim() ==
                    selectedCategory.value.toLowerCase().trim(),
              )
              .toList();
    }

    if (searchQuery.value.isNotEmpty) {
      filtered =
          filtered
              .where(
                (e) => (e['name'] ?? '').toLowerCase().contains(
                  searchQuery.value.toLowerCase(),
                ),
              )
              .toList();
    }

    filteredEmployees.value = filtered;
  }

  void updateSearch(String query) {
    searchQuery.value = query;
    applyFilters();
  }

  void changeCategory(String category) {
    selectedCategory.value = category;
    applyFilters();
  }

  void editEmployee(Map employee) {
    Get.to(() => EditEmployeeView(employee: employee));
  }

  Future<void> deleteEmployee(BuildContext context, Map employee) async {
    final name = employee['name'] ?? 'this employee';
    final isDark = Theme.of(context).brightness == Brightness.dark;

    Get.defaultDialog(
      title: 'Confirm Deletion',
      middleText: 'Are you sure you want to delete $name?',
      textConfirm: 'Yes',
      textCancel: 'No',
      confirmTextColor: isDark ? Colors.black : Colors.white,
      onConfirm: () async {
        Get.back();
        try {
          final id = employee['id'];
          await supabase.from('employees').delete().eq('id', id);
          employees.removeWhere((e) => e['id'] == id);
          applyFilters();
          Get.snackbar('Deleted', '$name has been removed');
        } catch (e) {
          Get.snackbar('Error', 'Failed to delete employee');
        }
      },
      onCancel: () {},
    );
  }

  Future<void> updateAdvance(Map employee, int amountChange) async {
    final id = employee['id'];
    final current =
        int.tryParse(employee['advance_balance']?.toString() ?? '0') ?? 0;
    final updated = current + amountChange;

    try {
      await supabase
          .from('employees')
          .update({'advance_balance': updated})
          .eq('id', id);

      final index = employees.indexWhere((e) => e['id'] == id);
      if (index != -1) {
        final updatedEmployee = Map<String, dynamic>.from(employee);
        updatedEmployee['advance_balance'] = updated;
        employees[index] = updatedEmployee;
        applyFilters();
      }

      Get.snackbar('Advance Updated', 'New advance: ₹$updated');
    } catch (e) {
      Get.snackbar('Error', 'Could not update advance: $e');
    }
  }

  Future<void> loadPaymentsForEmployee(String employeeId) async {
    try {
      final data = await supabase
          .from('payments')
          .select()
          .eq('employee_id', employeeId)
          .order('created_at', ascending: false);
      payments.value = data;
      sortPayments(); 
    } catch (e) {
      payments.clear();
      Get.snackbar('Error', 'Could not fetch payments: $e');
    }
  }

  Future<void> addPayment({
    required Map employee,
    required int amount,
    required String notes,
    required DateTime date,
    required bool deductFromAdvance,
  }) async {
    final employeeId = employee['id'];

    try {
      await supabase.from('payments').insert({
        'employee_id': employeeId,
        'amount': amount,
        'notes': notes,
        'date': date.toIso8601String().split('T').first,
        'deduct_from_advance': deductFromAdvance,
      });

      if (deductFromAdvance) {
        await updateAdvance(employee, -amount);
      }

      await loadPaymentsForEmployee(employeeId);
      Get.snackbar('Payment Added', '₹$amount added for ${employee['name']}');
    } catch (e) {
      Get.snackbar('Error', 'Failed to add payment: $e');
    }
  }

  void sortPayments() {
    final mode = sortMode.value;

    payments.sort((a, b) {
      final aAmount = double.tryParse(a['amount'].toString()) ?? 0;
      final bAmount = double.tryParse(b['amount'].toString()) ?? 0;

      final aDate = DateTime.tryParse(a['date'] ?? '') ?? DateTime.now();
      final bDate = DateTime.tryParse(b['date'] ?? '') ?? DateTime.now();

      switch (mode) {
        case 'amount_asc':
          return aAmount.compareTo(bAmount);
        case 'amount_desc':
          return bAmount.compareTo(aAmount);
        case 'date_asc':
          return aDate.compareTo(bDate);
        case 'date_desc':
        default:
          return bDate.compareTo(aDate);
      }
    });
  }

  int getTotalPaidThisMonth(List<Map> payments) {
    final now = DateTime.now();
    return payments
        .where((p) {
          final date = DateTime.tryParse(p['date'] ?? '') ?? DateTime(2000);
          return date.year == now.year && date.month == now.month;
        })
        .fold(0, (sum, p) => sum + ((p['amount'] ?? 0) as int));
  }
}
