import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/auth_controller.dart';

class LoginController extends GetxController {
  final email = ''.obs;
  final password = ''.obs;
  final formKey = GlobalKey<FormState>();
  final isLoading = false.obs;

  final AuthController _authController = Get.find<AuthController>();

  final isPasswordHidden = true.obs;
  void togglePasswordVisibility() {
    isPasswordHidden.value = !isPasswordHidden.value;
  }

  void login() async {
    if (!formKey.currentState!.validate()) return;

    isLoading.value = true;
    final success = await _authController.login(
      email: email.value,
      password: password.value,
    );

    isLoading.value = false;

    if (!success) {
      Get.snackbar('Login Failed', 'Please check your credentials');
    }
  }

  void forgotPassword() {
    if (email.value.isEmpty || !email.value.contains('@')) {
      Get.snackbar('Error', 'Enter a valid email to reset password');
      return;
    }

    _authController.sendPasswordResetEmail(email.value);
  }
}
