import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../routes/app_pages.dart';

class AuthController extends GetxController {
  final supabase = Supabase.instance.client;

  Rx<User?> currentUser = Rx<User?>(null);
  RxBool isLoading = false.obs;

@override
void onInit() {
  super.onInit();
  currentUser.value = supabase.auth.currentUser;

  // Defer navigation using post-frame callback
  WidgetsBinding.instance.addPostFrameCallback((_) {
    supabase.auth.onAuthStateChange.listen((data) {
      currentUser.value = data.session?.user;

      if (currentUser.value == null) {
        Get.offAllNamed(Routes.LOGIN);
      } else {
        Get.offAllNamed(Routes.HOME);
      }
    });
  });
}

  Future<bool> login({required String email, required String password}) async {
    try {
      isLoading.value = true;

      final response = await supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );

      currentUser.value = response.user;
      return true;
    } catch (e) {
      debugPrint('Login error: $e');
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await supabase.auth.resetPasswordForEmail(email);
      Get.snackbar('Success', 'Password reset link sent to $email');
    } catch (e) {
      debugPrint('Reset email error: $e');
      Get.snackbar('Error', 'Failed to send reset email');
    }
  }

  Future<void> signOut() async {

    await supabase.auth.signOut();
    currentUser.value = null;
  }
}
