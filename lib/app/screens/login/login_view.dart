import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../core/utils/contact_support.dart';
import 'login_controller.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: screenHeight),
          child: Form(
            key: controller.formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: screenHeight * 0.15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      'assets/icons/app_icon.svg',
                      width: 60,
                      height: 60,
                      // ignore: deprecated_member_use
                      color: (isDark ? Colors.white : Colors.black),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      "LabourLog",
                      style: TextStyle(
                        fontSize: 60,
                        color: (isDark ? Colors.white : Colors.black),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: screenHeight * 0.05),
                Theme(
                  data: Theme.of(context).copyWith(
                    textSelectionTheme: TextSelectionThemeData(
                      selectionHandleColor:
                          (isDark ? Colors.white : Colors.black),
                    ),
                  ),
                  child: TextFormField(
                    cursorColor: (isDark ? Colors.white : Colors.black),

                    decoration: InputDecoration(
                      labelText: 'Email',
                      labelStyle: TextStyle(
                        color: (isDark ? Colors.white : Colors.black),
                      ),
                      border: OutlineInputBorder(),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        borderSide: BorderSide(
                          color: (isDark ? Colors.white : Colors.black),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        borderSide: BorderSide(
                          color: (isDark ? Colors.white : Colors.black),
                          width: 2.0,
                        ),
                      ),
                    ),
                    onChanged: (value) => controller.email.value = value,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Email is required';
                      }
                      if (!value.contains('@')) {
                        return 'Enter a valid email';
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(height: screenHeight * 0.02),
                Obx(
                  () => Theme(
                    data: Theme.of(context).copyWith(
                      textSelectionTheme: TextSelectionThemeData(
                        selectionHandleColor:
                            (isDark ? Colors.white : Colors.black),
                      ),
                    ),
                    child: TextFormField(
                      cursorColor: (isDark ? Colors.white : Colors.black),

                      obscureText: controller.isPasswordHidden.value,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        labelStyle: TextStyle(
                          color: (isDark ? Colors.white : Colors.black),
                        ),
                        border: const OutlineInputBorder(),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          borderSide: BorderSide(
                            color: (isDark ? Colors.white : Colors.black),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          borderSide: BorderSide(
                            color: (isDark ? Colors.white : Colors.black),
                            width: 2.0,
                          ),
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            controller.isPasswordHidden.value
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: (isDark ? Colors.white : Colors.black),
                          ),
                          onPressed: () {
                            controller.togglePasswordVisibility();
                          },
                        ),
                      ),
                      onChanged: (value) => controller.password.value = value,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Password is required';
                        }
                        if (value.length < 6) {
                          return 'Password must be at least 6 characters';
                        }
                        return null;
                      },
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.005),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: controller.forgotPassword,
                    child: Text(
                      "Forgot Password?",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: (isDark ? Colors.white : Colors.black),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.02),
                Obx(() {
                  return controller.isLoading.value
                      ? Text("Signing in...")
                      : SizedBox(
                        width: double.infinity,
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          decoration: BoxDecoration(
                            color: (isDark ? Colors.white : Colors.black),
                            borderRadius: BorderRadius.circular(24),
                          ),
                          child: TextButton(
                            onPressed: controller.login,
                            child: Text(
                              "Sign In",
                              style: TextStyle(
                                color: (isDark ? Colors.black : Colors.white),
                                fontSize: 24,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                      );
                }),
                SizedBox(height: screenHeight * 0.1),
                GestureDetector(
                  onTap: contactSupportOnWhatsApp,
                  child: const Text('Contact Support?'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
