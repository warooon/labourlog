import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dashboard_controller.dart';
import '../../widgets/dashboard_tile.dart';

class DashboardView extends GetView<DashboardController> {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth > 1000;
        return Scaffold(
          appBar: isWide ? null : AppBar(title: const Text("Dashboard")),
          drawer: isWide ? null : Drawer(child: _buildSidebar(context)),
          body: Row(
            children: [
              if (isWide) _buildSidebar(context),
              Expanded(child: _buildMainMetricsContent(context)),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSidebar(BuildContext context) {
    return NavigationRail(
      selectedIndex: 0,
      onDestinationSelected: (index) {
        switch (index) {
          case 0:
            break;
          case 1:
            Get.toNamed('/attendance');
            break;
          case 2:
            Get.toNamed('/employee');
            break;
          case 3:
            Get.toNamed('/payments');
            break;
        }
      },
      labelType: NavigationRailLabelType.all,
      leading: const Padding(
        padding: EdgeInsets.all(8.0),
        child: Icon(Icons.dashboard, size: 32),
      ),
      destinations: const [
        NavigationRailDestination(
          icon: Icon(Icons.dashboard),
          label: Text('Dashboard'),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.access_time),
          label: Text('Attendance'),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.people),
          label: Text('Employees'),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.attach_money),
          label: Text('Payments'),
        ),
      ],
    );
  }

  Widget _buildMainMetricsContent(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final padding = screenWidth > 1200 ? 64.0 : 32.0;

    return SingleChildScrollView(
      padding: EdgeInsets.all(padding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Dashboard',
            style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Obx(
                () => Text(
                  'Welcome Back, ${controller.adminName.value}!',
                  style: const TextStyle(fontSize: 14),
                ),
              ),
              Text(
                controller.formattedDate,
                style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
              ),
            ],
          ),
          const SizedBox(height: 32),
          Center(
            child: Wrap(
              spacing: 20,
              runSpacing: 20,
              alignment: WrapAlignment.center,
              children: [
                DashboardTile(
                  label: 'Total Present',
                  metricRx: controller.presentCountStr,
                ),
                DashboardTile(
                  label: 'Absent',
                  metricRx: controller.absentCountStr,
                ),
                DashboardTile(
                  label: 'On Leave',
                  metricRx: controller.onLeaveCountStr,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
