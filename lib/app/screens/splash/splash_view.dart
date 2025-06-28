import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'splash_controller.dart';

class SplashView extends GetView<SplashController> {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    final bulletStyle = TextStyle(fontSize: 16, color: Colors.grey[800]);

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // App Icon and Title
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  'assets/icons/app_icon.svg',
                  width: 60,
                  height: 60,
                ),
                const SizedBox(width: 10),
                const Text(
                  "LabourLog",
                  style: TextStyle(fontSize: 60, color: Colors.black),
                ),
              ],
            ),
            const SizedBox(height: 40),

            // Animated Bullet Points
            Obx(
              () => Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: List.generate(controller.visibleLines.value, (index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 4.0,
                      horizontal: 24.0,
                    ),
                    child: Text(
                      controller.bulletPoints[index],
                      style: bulletStyle,
                      textAlign: TextAlign.center,
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
