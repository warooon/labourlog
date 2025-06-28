import 'package:get/get.dart';
import 'app_appearance_controller.dart';

class AppAppearanceBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AppAppearanceController>(() => AppAppearanceController());
  }
}
