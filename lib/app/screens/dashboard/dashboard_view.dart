// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:labourlog/app/widgets/dashboard_tile.dart';
// import 'dashboard_controller.dart';
// import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

// class DashboardView extends GetView<DashboardController> {
//   const DashboardView({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final screenHeight = MediaQuery.of(context).size.height;
//     final screenWidth = MediaQuery.of(context).size.width;

//     return Scaffold(
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: EdgeInsets.symmetric(
//             horizontal: screenWidth * 0.05,
//             vertical: screenHeight * 0.05,
//           ),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 'Dashboard',
//                 style: TextStyle(fontSize: 45, fontWeight: FontWeight.bold),
//               ),
//               SizedBox(height: screenHeight * 0.01),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Obx(
//                     () => Text(
//                       'Welcome Back, ${controller.adminName.value}!',
//                       style: TextStyle(
//                         fontSize: 18,
//                         fontWeight: FontWeight.w600,
//                       ),
//                     ),
//                   ),
//                   Text(
//                     controller.formattedDate,
//                     style: TextStyle(
//                       fontSize: 14,
//                       fontWeight: FontWeight.w600,
//                       color: Colors.grey.shade700,
//                     ),
//                   ),
//                 ],
//               ),
//               SizedBox(height: screenHeight * 0.05),

//               StaggeredGrid.count(
//                 crossAxisCount: 5,
//                 mainAxisSpacing: 12,
//                 crossAxisSpacing: 12,
//                 children: List.generate(controller.dashboardTiles.length, (
//                   index,
//                 ) {
//                   final tile = controller.dashboardTiles[index];
//                   final crossAxisCellCount = tile['crossAxisCount'] ?? 2;
//                   final mainAxisCellCount = tile['mainAxisCount'] ?? 1;

//                   return StaggeredGridTile.count(
//                     crossAxisCellCount: crossAxisCellCount,
//                     mainAxisCellCount: mainAxisCellCount,
//                     child: DashboardTile(
//                       label: tile['label'] ?? '',
//                       routeName: tile['routeName'],
//                       icon: tile['icon'],
//                       metric: tile['metric'],
//                       isSignOut: tile['isSignOut'] ?? false,
//                       onTap: tile['onTap'],
//                       textColor: tile['textColor'],
//                       lottieAsset: tile['lottieAsset'],
//                       metricRx: tile['metricRx'],
//                     ),
//                   );
//                 }),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dashboard_controller.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import '../../widgets/dashboard_tile.dart';

class DashboardView extends GetView<DashboardController> {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth > 1000;
        return Scaffold(
          appBar: isWide
              ? null
              : AppBar(
                  title: const Text("Dashboard"),
                ),
          drawer: isWide ? null : Drawer(child: _buildSidebar(context)),
          body: Row(
            children: [
              if (isWide) _buildSidebar(context),
              Expanded(
                child: _buildMainContent(context, isWide),
              ),
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
        // Example navigation
        if (index == 1) Get.toNamed('/employees');
        if (index == 2) Get.toNamed('/attendance');
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
          icon: Icon(Icons.people),
          label: Text('Employees'),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.access_time),
          label: Text('Attendance'),
        ),
      ],
    );
  }

  Widget _buildMainContent(BuildContext context, bool isWide) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final crossAxisTileCount = isWide ? 6 : 4;
    final titleFontSize = isWide ? 32.0 : 24.0;

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(
        horizontal: screenWidth * 0.04,
        vertical: screenHeight * 0.04,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Dashboard',
            style: TextStyle(
              fontSize: titleFontSize,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: screenHeight * 0.01),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Obx(() => Text(
                    'Welcome Back, ${controller.adminName.value}!',
                    style: TextStyle(fontSize: isWide ? 18 : 14),
                  )),
              Text(
                controller.formattedDate,
                style: TextStyle(
                  fontSize: isWide ? 14 : 12,
                  color: Colors.grey.shade700,
                ),
              ),
            ],
          ),
          SizedBox(height: screenHeight * 0.03),
          StaggeredGrid.count(
            crossAxisCount: crossAxisTileCount,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            children: List.generate(controller.dashboardTiles.length, (index) {
              final tile = controller.dashboardTiles[index];
              final crossAxisCellCount = tile['crossAxisCount'] ?? 2;
              final mainAxisCellCount = tile['mainAxisCount'] ?? 1;

              return StaggeredGridTile.count(
                crossAxisCellCount: isWide
                    ? crossAxisCellCount
                    : (crossAxisCellCount > 2 ? 2 : 1),
                mainAxisCellCount: mainAxisCellCount,
                child: DashboardTile(
                  label: tile['label'] ?? '',
                  routeName: tile['routeName'],
                  icon: tile['icon'],
                  metric: tile['metric'],
                  isSignOut: tile['isSignOut'] ?? false,
                  onTap: tile['onTap'],
                  textColor: tile['textColor'],
                  lottieAsset: tile['lottieAsset'],
                  metricRx: tile['metricRx'],
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
