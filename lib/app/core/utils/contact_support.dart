import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../constants/urls.dart';

Future<void> contactSupportOnWhatsApp() async {
  try {
    final message = Uri.encodeComponent(UrlConstants.defaultSupportMessage);
    final phone = UrlConstants.whatsappNumber.replaceAll('+', '');

    final List<String> urls =
        Platform.isAndroid
            ? [
              "whatsapp://send?phone=$phone&text=$message",
              "https://wa.me/$phone?text=$message",
            ]
            : ["https://wa.me/$phone?text=$message"];

    for (final url in urls) {
      final uri = Uri.parse(url);
      final canLaunchIt = await canLaunchUrl(uri);
      debugPrint("Testing $url => Can launch: $canLaunchIt");

      if (canLaunchIt) {
        final launched = await launchUrl(
          uri,
          mode: LaunchMode.externalApplication,
        );
        if (launched) {
          debugPrint("Launched $url successfully");
          return;
        }
      }
    }

    Get.snackbar(
      'Error',
      'Could not open WhatsApp. Please make sure it is installed.',
    );
  } catch (e) {
    debugPrint("Main catch error: $e");
    Get.snackbar('Unexpected Error', 'Something went wrong: $e');
  }
}
