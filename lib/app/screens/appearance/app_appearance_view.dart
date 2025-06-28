import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'app_appearance_controller.dart';

class AppAppearanceView extends GetView<AppAppearanceController> {
  const AppAppearanceView({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
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
                  onTap: () => Get.back(),
                  child: Icon(Icons.arrow_back, size: 35),
                ),
                SizedBox(width: screenWidth * 0.02),
                Text(
                  'App Appearance',
                  style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(height: screenHeight * 0.01),
            Text(
              'Change App Appearance Setting!',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: screenHeight * 0.05),
            Obx(
              () => SwitchListTile(
                title: Text(
                  'Dark Mode',
                  style: TextStyle(
                    fontSize: 25,
                    color:
                        Theme.of(context).brightness == Brightness.dark
                            ? Colors.white
                            : Colors.black,
                  ),
                ),
                value: controller.isDarkMode.value,
                onChanged: (value) {
                  controller.toggleTheme(value);
                },
                activeColor: isDark ? Colors.white : Colors.black,
                activeTrackColor: isDark ? Colors.white54 : Colors.black26,
                inactiveThumbColor: isDark ? Colors.white54 : Colors.black87,
                inactiveTrackColor: isDark ? Colors.white24 : Colors.black26,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
