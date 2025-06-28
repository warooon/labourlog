import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../routes/app_pages.dart';

class EmployeeController extends GetxController {
  final supabase = Supabase.instance.client;

  var employees = [].obs;
  var filteredEmployees = [].obs;
  var selectedCategory = 'All'.obs;
  var searchQuery = ''.obs;
  var totalEmployeeCount = 0.obs;

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
    Get.toNamed(
      Routes.EMPLOYEE_EDITS,
      arguments: {'employee': employee, 'isEditing': true},
    );
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
}
