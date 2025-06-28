import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:intl/intl.dart';

import '../dashboard/dashboard_controller.dart';

class AttendanceController extends GetxController {
  final supabase = Supabase.instance.client;

  var employees = [].obs;
  var filteredEmployees = [].obs;
  var selectedCategory = 'All'.obs;
  var searchQuery = ''.obs;
  var totalEmployeeCount = 0.obs;

  var selectedDate = DateTime.now().obs;
  var attendanceMap = <String, String>{}.obs;
  var selectedEmployees = <String>[].obs;
  var originalAttendance = <String, String>{}.obs;

  var refreshToggle = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchEmployees();
    loadAttendanceForDate(selectedDate.value);
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

  void setAttendance(String empId, String status) {
    attendanceMap[empId] = status;
  }

  void toggleSelection(String empId, bool isSelected) {
    if (isSelected) {
      selectedEmployees.add(empId);
    } else {
      selectedEmployees.remove(empId);
    }
  }

  Future<void> loadAttendanceForDate(DateTime date) async {
    try {
      final data = await supabase
          .from('attendance')
          .select()
          .eq('date', DateFormat('yyyy-MM-dd').format(date));

      attendanceMap.clear();
      originalAttendance.clear(); // 👈 also clear and set fresh
      for (var item in data) {
        final empId = item['employee_id'];
        final status = item['status'];
        attendanceMap[empId] = status;
        originalAttendance[empId] = status;
      }

      refreshToggle.toggle();
    } catch (e) {
      Get.snackbar('Error', 'Failed to load attendance');
    }
  }

  Future<void> markSelectedAttendance() async {
    try {
      for (final empId in selectedEmployees) {
        final status = attendanceMap[empId] ?? 'absent';

        await supabase.from('attendance').upsert({
          'employee_id': empId,
          'date': DateFormat('yyyy-MM-dd').format(selectedDate.value),
          'status': status,
        }, onConflict: 'employee_id,date');
      }

      Get.snackbar('Success', 'Attendance marked successfully');
      Get.find<DashboardController>().updateAttendanceCounts();
      selectedEmployees.clear();
    } catch (e) {
      debugPrint("Attendance marking error $e");
      Get.snackbar('Error', 'Failed to mark attendance');
    }
  }

  void markAllAs(String status) {
    bool allAlreadyMarked = filteredEmployees.every((emp) {
      final empId = emp['id'];
      return attendanceMap[empId] == status &&
          selectedEmployees.contains(empId);
    });

    if (allAlreadyMarked) {
      for (final emp in filteredEmployees) {
        final empId = emp['id'];
        selectedEmployees.remove(empId);

        attendanceMap[empId] = originalAttendance[empId] ?? 'absent';
      }
    } else {
      for (final emp in filteredEmployees) {
        final empId = emp['id'];
        attendanceMap[empId] = status;
        if (!selectedEmployees.contains(empId)) {
          selectedEmployees.add(empId);
        }
      }
    }

    refreshToggle.toggle();
  }
}
