import 'dart:async';
import 'package:get/get.dart';
import '../../controllers/auth_controller.dart';
import '../../routes/app_pages.dart';

class SplashController extends GetxController {
  final authController = Get.find<AuthController>();

  final RxInt visibleLines = 0.obs;

  final List<String> bulletPoints = [
    "• Clock in, clock out — like magic 🪄",
    "• Track hours without breaking a sweat 💪",
    "• Pay summaries that *actually* make sense 💰",
    "• Built for workers, not spreadsheets ⚙️",
  ];

  late Timer _animationTimer;
  bool _navigated = false;

  @override
  void onInit() {
    super.onInit();
    _startAnimationLoop();
  }

  @override
  void onReady() {
    super.onReady();

    if (_navigated) return;
    _navigated = true;

    Future.delayed(const Duration(seconds: 4), () {
      final user = authController.currentUser.value;
      if (user != null) {
        Get.offAllNamed(Routes.HOME);
      } else {
        Get.offAllNamed(Routes.LOGIN);
      }
    });
  }

  void _startAnimationLoop() {
    _animationTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (visibleLines.value < bulletPoints.length) {
        visibleLines.value++;
      } else {
        visibleLines.value = 0;
      }
    });
  }

  @override
  void onClose() {
    _animationTimer.cancel();
    super.onClose();
  }
}
