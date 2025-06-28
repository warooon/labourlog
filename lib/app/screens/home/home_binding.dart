import 'package:get/get.dart';
import '../dashboard/dashboard_controller.dart';
import 'package:labourlog/app/screens/reports/reports_controller.dart';
import '../profile/profile_controller.dart';
import 'home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(() => HomeController());
    Get.lazyPut<DashboardController>(() => DashboardController());
    Get.lazyPut<ReportsController>(() => ReportsController());
    Get.lazyPut<ProfileController>(() => ProfileController());
  }
}
