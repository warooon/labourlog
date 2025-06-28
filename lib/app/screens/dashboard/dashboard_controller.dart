import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../controllers/auth_controller.dart';
import '../../routes/app_pages.dart';

class DashboardController extends GetxController {
  final supabase = Supabase.instance.client;
  final adminName = ''.obs;
  final presentCount = 0.obs;
  final onLeaveCount = 0.obs;
  final absentCount = 0.obs;
  final totalEmployeeCount = 0.obs;

  final presentCountStr = ''.obs;
  final absentCountStr = ''.obs;
  final onLeaveCountStr = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchAdminName();
    updateAttendanceCounts();
    ever(presentCount, (val) => presentCountStr.value = val.toString());
    ever(absentCount, (val) => absentCountStr.value = val.toString());
    ever(onLeaveCount, (val) => onLeaveCountStr.value = val.toString());
  }

  List<Map<String, dynamic>> get dashboardTiles => [
    {
      'label': 'Total Present',
      'metricRx': presentCountStr,
      'crossAxisCount': 3,
      'mainAxisCount': 2,
    },
    {
      'label': 'Absent',
      'metricRx': absentCountStr,

      'crossAxisCount': 2,
      'mainAxisCount': 2,
    },
   
    {
      'label': 'Mark Attendance',
      'icon': Icons.how_to_reg,
      'route': "",
      'crossAxisCount': 3,
      'mainAxisCount': 3,
      'routeName': Routes.ATTENDANCE,
    },
 {
      'label': 'On Leave',
      'metricRx': onLeaveCountStr,
      'crossAxisCount': 2,
      'mainAxisCount': 2,
    },
    {
      'label': 'Payments',
      'icon': Icons.attach_money,
      'route': "",
      'crossAxisCount': 2,
      'mainAxisCount': 3,
      'routeName': Routes.PAYMENTS,
    },
    {
      'label': 'Employee Management',
      'icon': Icons.people,
      'route': "",
      'crossAxisCount': 3,
      'mainAxisCount': 2,
      'routeName': Routes.EMPLOYEE,
    },
  ];

  void fetchAdminName() async {
    final user = Get.find<AuthController>().currentUser;
    final res =
        await supabase
            .from('admins')
            .select('name')
            .eq('id', user.value!.id)
            .single();
    if (res['name'] != null) {
      final name = (res['name'] as String).split(' ').first;
      adminName.value = name;
    }
  }

  void updateAttendanceCounts() async {
    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());

    final presentResponse = await supabase
        .from('attendance')
        .select('*')
        .eq('date', today)
        .eq('status', 'present');

    final leaveResponse = await supabase
        .from('attendance')
        .select('*')
        .eq('date', today)
        .eq('status', 'leave');

    final employeeResponse = await supabase.from('employees').select('id');

    final total = employeeResponse.length;
    final present = presentResponse.length;
    final leave = leaveResponse.length;
    final absent = total - (present + leave);

    presentCount.value = present;
    onLeaveCount.value = leave;
    absentCount.value = absent;

    debugPrint("PRESENT COUNT: $present");
    debugPrint("LEAVE COUNT: $leave");
    debugPrint("ABSENT COUNT: $absent");
  }

  String get formattedDate {
    final today = DateTime.now();
    return DateFormat('dd/MM/yyyy').format(today);
  }
}
