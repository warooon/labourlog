// ignore_for_file: constant_identifier_names

part of 'app_pages.dart';

abstract class Routes {
  Routes._();

  static const HOME = _Paths.HOME;
  static const SPLASH = _Paths.SPLASH;
  static const LOGIN = _Paths.LOGIN;
  static const DASHBOARD = _Paths.DASHBOARD;
  static const PROFILE = _Paths.PROFILE;
  static const REPORTS = _Paths.REPORTS;
  static const APP_APPEARANCE = _Paths.APP_APPEARANCE;
  static const ABOUT = _Paths.ABOUT;
  static const EMPLOYEE = _Paths.EMPLOYEE;
  static const EMPLOYEE_EDITS = _Paths.EMPLOYEE_EDITS;
  static const ATTENDANCE = _Paths.ATTENDANCE;
  static const PAYMENTS = _Paths.PAYMENTS;
}

abstract class _Paths {
  static const HOME = '/home';
  static const SPLASH = '/splash';
  static const LOGIN = '/login';
  static const DASHBOARD = '/dashboard';
  static const PROFILE = '/profile';
  static const REPORTS = '/reports';
  static const APP_APPEARANCE = '/appappearance';
  static const ABOUT = '/about';
  static const EMPLOYEE = '/employee';
  static const EMPLOYEE_EDITS = '/editemployee';
  static const ATTENDANCE = '/attendance';
  static const PAYMENTS = '/payments';
}
