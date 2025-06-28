import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppAppearanceController extends GetxController {
  var isDarkMode = false.obs;

  static const _themeKey = 'isDarkMode';

  @override
  void onInit() {
    super.onInit();
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final savedDark = prefs.getBool(_themeKey) ?? Get.isPlatformDarkMode;
    isDarkMode.value = savedDark;
    Get.changeThemeMode(savedDark ? ThemeMode.dark : ThemeMode.light);
  }

  Future<void> toggleTheme(bool dark) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_themeKey, dark);

    isDarkMode.value = dark;
    Get.changeThemeMode(dark ? ThemeMode.dark : ThemeMode.light);
  }
}
