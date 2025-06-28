import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class DashboardTile extends StatelessWidget {
  final String label;
  final String? routeName;
  final IconData? icon;
  final String? metric; 
  final RxString? metricRx; 
  final bool isSignOut;
  final VoidCallback? onTap;
  final Color? textColor;
  final String? lottieAsset;

  const DashboardTile({
    super.key,
    required this.label,
    this.routeName,
    this.icon,
    this.metric,
    this.metricRx,
    this.isSignOut = false,
    this.onTap,
    this.textColor,
    this.lottieAsset,
  });

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final Color effectiveTextColor =
        textColor ?? (isDark ? Colors.white : Colors.black);

    return GestureDetector(
      onTap: () {
        if (isSignOut) {
          onTap?.call();
        } else if (routeName != null) {
          Get.toNamed(routeName!);
        }
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.grey.shade400,
            width: screenWidth * 0.003,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        padding: EdgeInsets.all(screenWidth * 0.04),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: Text(
                label,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: screenWidth * 0.045,
                  fontWeight: FontWeight.w700,
                  color: effectiveTextColor,
                ),
              ),
            ),
            SizedBox(height: screenHeight * 0.005),

            // 👇 Metric logic
            if (metricRx != null)
              Obx(
                () => FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    metricRx!.value,
                    style: TextStyle(
                      fontSize: screenWidth * 0.07,
                      fontWeight: FontWeight.w800,
                      color: effectiveTextColor,
                    ),
                  ),
                ),
              )
            else if (metric != null)
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  metric!,
                  style: TextStyle(
                    fontSize: screenWidth * 0.07,
                    fontWeight: FontWeight.w800,
                    color: effectiveTextColor,
                  ),
                ),
              )
            else if (lottieAsset != null)
              Flexible(
                child: Lottie.asset(
                  lottieAsset!,
                  height: screenWidth * 0.2,
                  fit: BoxFit.contain,
                ),
              )
            else if (icon != null)
              Icon(icon, size: screenWidth * 0.12, color: effectiveTextColor),
          ],
        ),
      ),
    );
  }
}
