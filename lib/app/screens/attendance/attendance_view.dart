import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../widgets/attendance_tile.dart';
import 'attendance_controller.dart';

class AttendanceView extends GetView<AttendanceController> {
  const AttendanceView({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return DefaultTabController(
      length: 4,
      child: Scaffold(
        floatingActionButton: Obx(() {
          final hasSelection = controller.selectedEmployees.isNotEmpty;
          final count = controller.selectedEmployees.length;

          return hasSelection
              ? FloatingActionButton.extended(
                onPressed: controller.markSelectedAttendance,
                backgroundColor: isDark ? Colors.white : Colors.black,
                label: Row(
                  children: [
                    Icon(
                      Icons.check,
                      color: isDark ? Colors.black : Colors.white,
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Mark $count',
                      style: TextStyle(
                        color: isDark ? Colors.black : Colors.white,
                      ),
                    ),
                  ],
                ),
              )
              : SizedBox.shrink();
        }),

        body: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.05,
            vertical: screenHeight * 0.05,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  GestureDetector(
                    onTap: Get.back,
                    child: Icon(Icons.arrow_back, size: 30),
                  ),
                  SizedBox(width: 10),
                  Text(
                    'MARK ATTENDANCE',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              SizedBox(height: 20),

              Obx(() {
                final selectedDate = controller.selectedDate.value;
                return GestureDetector(
                  onTap: () async {
                    DateTime? picked = await showDatePicker(
                      context: context,
                      initialDate: selectedDate,
                      firstDate: DateTime(2020),
                      lastDate: DateTime.now(),
                      builder: (context, child) {
                        return Theme(
                          data:
                              isDark
                                  ? ThemeData.dark().copyWith(
                                    colorScheme: ColorScheme.dark(
                                      primary: Colors.white,
                                      onPrimary: Colors.black,
                                    ),
                                  )
                                  : ThemeData.light().copyWith(
                                    colorScheme: ColorScheme.light(
                                      primary: Colors.black,
                                      onPrimary: Colors.white,
                                    ),
                                  ),
                          child: child!,
                        );
                      },
                    );
                    if (picked != null) {
                      controller.selectedDate.value = picked;
                      controller.loadAttendanceForDate(picked);
                    }
                  },

                  child: Row(
                    children: [
                      Icon(Icons.calendar_today, size: 18),
                      SizedBox(width: 8),
                      Text(DateFormat('dd MMM yyyy').format(selectedDate)),
                    ],
                  ),
                );
              }),
              SizedBox(height: 15),

              // Search
              Theme(
                data: Theme.of(context).copyWith(
                  textSelectionTheme: TextSelectionThemeData(
                    cursorColor: isDark ? Colors.white : Colors.black,
                    selectionHandleColor: isDark ? Colors.white : Colors.black,
                  ),
                ),
                child: TextField(
                  style: TextStyle(color: isDark ? Colors.white : Colors.black),
                  cursorColor: isDark ? Colors.white : Colors.black,
                  onChanged: controller.updateSearch,
                  decoration: InputDecoration(
                    hintText: 'Search employee...',
                    hintStyle: TextStyle(
                      color: isDark ? Colors.white70 : Colors.black54,
                    ),
                    prefixIcon: Icon(
                      Icons.search,
                      color: isDark ? Colors.white : Colors.black,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: isDark ? Colors.white : Colors.black,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: isDark ? Colors.white : Colors.black,
                        width: 2,
                      ),
                    ),
                  ),
                ),
              ),

              SizedBox(height: 15),

              // Category Tabs
              TabBar(
                onTap: (index) {
                  final categories = ['All', 'Labour', 'Munshi', 'Mistri'];
                  controller.changeCategory(categories[index]);
                },
                tabs: const [
                  Tab(text: 'All'),
                  Tab(text: 'Labour'),
                  Tab(text: 'Munshi'),
                  Tab(text: 'Mistri'),
                ],
                labelColor: (isDark ? Colors.white : Colors.black),
                indicatorColor: (isDark ? Colors.white : Colors.black),
              ),
              SizedBox(height: 15),

              // Batch Mark Options
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    style: ButtonStyle(elevation: WidgetStateProperty.all(0.1)),
                    onPressed: () => controller.markAllAs('present'),
                    child: Text(
                      "All Present",
                      style: TextStyle(
                        color: (isDark ? Colors.white : Colors.black),
                      ),
                    ),
                  ),
                  ElevatedButton(
                    style: ButtonStyle(elevation: WidgetStateProperty.all(0.1)),
                    onPressed: () => controller.markAllAs('absent'),
                    child: Text(
                      "All Absent",
                      style: TextStyle(
                        color: (isDark ? Colors.white : Colors.black),
                      ),
                    ),
                  ),
                  ElevatedButton(
                    style: ButtonStyle(elevation: WidgetStateProperty.all(0.1)),
                    onPressed: () => controller.markAllAs('leave'),
                    child: Text(
                      "All Leave",
                      style: TextStyle(
                        color: (isDark ? Colors.white : Colors.black),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),

              // Mark Selected Button & Count
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //   children: [
              //     ElevatedButton.icon(
              //       icon: Icon(
              //         Icons.check,
              //         color: (isDark ? Colors.white : Colors.black),
              //       ),
              //       label: Text(
              //         "Mark Selected",
              //         style: TextStyle(
              //           color: (isDark ? Colors.white : Colors.black),
              //         ),
              //       ),
              //       onPressed: controller.markSelectedAttendance,
              //     ),
              //     Obx(
              //       () => Text(
              //         "Total Employees: ${controller.totalEmployeeCount}",
              //       ),
              //     ),
              //   ],
              // ),
              SizedBox(height: 10),
              Obx(
                () => Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    "Total Employees: ${controller.totalEmployeeCount}",
                  ),
                ),
              ),

              // Attendance List
              Expanded(
                child: Obx(() {
                  controller.refreshToggle.value;
                  final employees = controller.filteredEmployees;
                  if (employees.isEmpty) {
                    return Center(child: Text('No employees found'));
                  }

                  return ListView.builder(
                    itemCount: employees.length,
                    itemBuilder: (_, index) {
                      final emp = employees[index];
                      final empId = emp['id'];
                      final status =
                          controller.attendanceMap[empId] ?? 'absent';
                      final isSelected = controller.selectedEmployees.contains(
                        empId,
                      );

                      return AttendanceTile(
                        key: ValueKey(
                          '$empId-$status-${isSelected ? "1" : "0"}',
                        ),

                        employee: emp,
                        initialStatus: status,
                        initiallySelected: isSelected,
                        onStatusChange: (newStatus) {
                          controller.setAttendance(empId, newStatus);
                        },
                        onSelect: (selected) {
                          controller.toggleSelection(empId, selected);
                        },
                      );
                    },
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
