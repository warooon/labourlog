import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:labourlog/app/controllers/auth_controller.dart';
import 'package:labourlog/app/widgets/profile_page_tile.dart';
import '../../routes/app_pages.dart';
import 'package:flutter_initicon/flutter_initicon.dart';
import '../../widgets/password_update_dialog.dart';
import 'profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});

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
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Profile',
                style: TextStyle(fontSize: 45, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: screenHeight * 0.01),
              Text(
                'Manage Profile and App Settings',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              SizedBox(height: screenHeight * 0.05),
              Obx(() {
                return Row(
                  children: [
                    CircleAvatar(
                      radius: 35,
                      backgroundColor: Colors.grey[300],
                      backgroundImage:
                          controller.photoUrl.value.isNotEmpty
                              ? NetworkImage(controller.photoUrl.value)
                              : null,
                      child:
                          controller.photoUrl.value.isEmpty
                              ? Initicon(
                                text: controller.name.value,
                                backgroundColor:
                                    isDark ? Colors.white : Colors.black,
                                size: 70,
                              )
                              : null,
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            controller.name.value,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text("Administrator"),
                        ],
                      ),
                    ),
                  ],
                );
              }),
              SizedBox(height: screenHeight * 0.05),
              ProfilePageTile(
                icon: Icons.settings,
                title: "App Appearance",
                subtitle: "Change Appearance",
                onTap: () => Get.toNamed(Routes.APP_APPEARANCE),
              ),
              SizedBox(height: screenHeight * 0.02),

              ProfilePageTile(
                icon: Icons.password,
                title: "Change Password",
                subtitle: "Update your password",
                onTap: () {
                  Get.dialog(PasswordUpdateDialog());
                },
              ),
              SizedBox(height: screenHeight * 0.02),
              ProfilePageTile(
                icon: Icons.info_outline_rounded,
                title: "About",
                subtitle: "About the App & Contact Support",
                onTap: () => Get.toNamed(Routes.ABOUT),
              ),
              SizedBox(height: screenHeight * 0.02),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12.0),
                child: GestureDetector(
                  onTap: Get.find<AuthController>().signOut,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.logout, size: 36, color: Colors.red),
                      SizedBox(width: screenWidth * 0.04),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Sign Out",
                              style: const TextStyle(
                                color: Colors.red,
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "See you again!",
                              style: TextStyle(fontSize: 14, color: Colors.red),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: screenHeight * 0.02),
            ],
          ),
        ),
      ),
    );
  }
}
