import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import '../profile/profile_view.dart';
import '../reports/reports_view.dart';
import 'home_controller.dart';

import '../dashboard/dashboard_view.dart';
// import '../search/search_view.dart';
// import '../profile/profile_view.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  static final List<Widget> _pages = [
    DashboardView(),
    ReportsView(),
    ProfileView(),
  ];

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Obx(() => SafeArea(child: _pages[controller.currentIndex.value])),
      bottomNavigationBar: Obx(
        () => Padding(
          padding: EdgeInsets.only(
            left: screenWidth * 0.05,
            right: screenWidth * 0.05,
            bottom: screenHeight * 0.03,
          ),
          child: GNav(
            rippleColor: Colors.grey.shade300,
            haptic: true,
            selectedIndex: controller.currentIndex.value,
            onTabChange: controller.changeTab,
            gap: 8,
            padding: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.05,
              vertical: screenHeight * 0.02,
            ),
            tabBackgroundColor: Colors.grey.shade200,
            color: Colors.grey,
            activeColor: Colors.black,
            tabs: [
              GButton(icon: Icons.home, text: 'Dashboard'),
              GButton(icon: Icons.insert_chart, text: 'Reports'),
              GButton(icon: Icons.person, text: 'Profile'),
            ],
          ),
        ),
      ),
    );
  }
}
