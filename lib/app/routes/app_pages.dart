import 'package:get/get.dart';
import '../screens/payments/payments_binding.dart';
import '../screens/payments/payments_view.dart';

import '../screens/about/about_view.dart';
import '../screens/appearance/app_appearance_view.dart';
import '../screens/attendance/attendance_binding.dart';
import '../screens/attendance/attendance_view.dart';
import '../screens/employee/employee_binding.dart';
import '../screens/employee/employee_view.dart';
import '../screens/appearance/app_appearance_binding.dart';
import '../screens/dashboard/dashboard_binding.dart';
import '../screens/dashboard/dashboard_view.dart';
import '../screens/employee_edit/employee_edit_binding.dart';
import '../screens/employee_edit/employee_edit_view.dart';
import '../screens/home/home_binding.dart';
import '../screens/home/home_view.dart';
import '../screens/login/login_binding.dart';
import '../screens/login/login_view.dart';
import '../screens/profile/profile_binding.dart';
import '../screens/profile/profile_view.dart';
import '../screens/reports/reports_binding.dart';
import '../screens/reports/reports_view.dart';
import '../screens/splash/splash_binding.dart';
import '../screens/splash/splash_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.SPLASH;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => HomeView(),
      binding: HomeBinding(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: Routes.SPLASH,
      page: () => const SplashView(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: Routes.DASHBOARD,
      page: () => const DashboardView(),
      binding: DashboardBinding(),
    ),
    GetPage(
      name: Routes.LOGIN,
      page: () => const LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: Routes.PROFILE,
      page: () => const ProfileView(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: Routes.REPORTS,
      page: () => const ReportsView(),
      binding: ReportsBinding(),
    ),
    GetPage(
      name: Routes.APP_APPEARANCE,
      page: () => const AppAppearanceView(),
      binding: AppAppearanceBinding(),
    ),
    GetPage(name: Routes.ABOUT, page: () => const AboutView()),
    GetPage(
      name: Routes.EMPLOYEE,
      page: () => const EmployeeView(),
      binding: EmployeeBinding(),
    ),
    GetPage(
      name: Routes.ATTENDANCE,
      page: () => const AttendanceView(),
      binding: AttendanceBinding(),
    ),
    GetPage(
      name: Routes.PAYMENTS,
      page: () => const PaymentsView(),
      binding: PaymentsBinding(),
    ),
    GetPage(
      name: Routes.EMPLOYEE_EDITS,
      page: () {
        final args = Get.arguments as Map<String, dynamic>? ?? {};
        return EditEmployeeView(
          employee: args['employee'] ?? {},
          isEditing: args['isEditing'] ?? true,
        );
      },
      binding: EmployeeEditBinding(),
    ),
  ];
}
