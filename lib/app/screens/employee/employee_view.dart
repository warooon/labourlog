import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../routes/app_pages.dart';
import '../../widgets/employee_bottom_sheet.dart';
import 'employee_controller.dart';

class EmployeeView extends GetView<EmployeeController> {
  const EmployeeView({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return DefaultTabController(
      length: 4,
      child: Scaffold(
        body: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.05,
            vertical: screenHeight * 0.05,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: Get.back,
                    child: Icon(Icons.arrow_back, size: 35),
                  ),
                  SizedBox(width: screenWidth * 0.02),
                  Text(
                    'EMPLOYEE MANAGEMENT',
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              SizedBox(height: screenHeight * 0.02),

              Theme(
                data: Theme.of(context).copyWith(
                  textSelectionTheme: TextSelectionThemeData(
                    selectionHandleColor:
                        (isDark ? Colors.white : Colors.black),
                  ),
                ),
                child: TextField(
                  onChanged: controller.updateSearch,
                  cursorColor: (isDark ? Colors.white : Colors.black),
                  decoration: InputDecoration(
                    hintText: 'Search employee...',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color:
                            (isDark
                                ? Colors.white
                                : Colors
                                    .black), // Change this to your desired active color
                        width: 2.0,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: screenHeight * 0.02),

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
              SizedBox(height: screenHeight * 0.02),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      Get.toNamed(
                        Routes.EMPLOYEE_EDITS,
                        arguments: {'employee': {}, 'isEditing': false},
                      );
                    },

                    child: Row(
                      children: [
                        Icon(
                          Icons.add,
                          color: (isDark ? Colors.white : Colors.black),
                        ),
                        Text(
                          "Add Employee",
                          style: TextStyle(
                            color: (isDark ? Colors.white : Colors.black),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Obx(
                    () => Text(
                      "Total Employees: ${controller.totalEmployeeCount}",
                      style: TextStyle(
                        color: (isDark ? Colors.white : Colors.black),
                      ),
                    ),
                  ),
                ],
              ),

              Expanded(
                child: Obx(() {
                  final employees = controller.filteredEmployees;
                  if (employees.isEmpty) {
                    return Center(child: Text('No employees found'));
                  }

                  return ListView.builder(
                    itemCount: employees.length,
                    itemBuilder: (_, index) {
                      final emp = employees[index];
                      final name = emp['name'] ?? '';
                      final category = emp['category'] ?? '';
                      final wageType = emp['wage_type'] ?? '';
                      final imageUrl = emp['avatar_url'];

                      return Card(
                        child: ListTile(
                          onTap: () => showEmployeeDetails(emp, context),
                          leading:
                              imageUrl != null
                                  ? CircleAvatar(
                                    backgroundImage: NetworkImage(imageUrl),
                                  )
                                  : CircleAvatar(
                                    backgroundColor:
                                        (isDark ? Colors.white : Colors.black),
                                    child: Text(
                                      name.isNotEmpty ? name[0] : '?',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color:
                                            (isDark
                                                ? Colors.black
                                                : Colors.white),
                                      ),
                                    ),
                                  ),
                          title: Text(name),
                          subtitle: Text('$category | $wageType'),
                        ),
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

  void showEmployeeDetails(Map emp, BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      builder: (context) => EmployeeBottomSheet(employee: emp),
    );
  }
}
