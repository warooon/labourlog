import 'package:get/get.dart';
import 'employee_edit_controller.dart';

class EmployeeEditBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<EmployeeEditController>(() => EmployeeEditController());
  }
}
