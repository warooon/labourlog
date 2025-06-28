import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/utils/contact_support.dart';

class AboutView extends GetView {
  const AboutView({super.key});

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
              Row(
                children: [
                  GestureDetector(
                    onTap: () => Get.back(),
                    child: Icon(Icons.arrow_back, size: 35),
                  ),
                  SizedBox(width: screenWidth * 0.02),
                  Text(
                    'About',
                    style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              SizedBox(height: screenHeight * 0.01),
              Text(
                'About the App & Customer Support Contact',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white70 : Colors.black87,
                ),
              ),
              SizedBox(height: screenHeight * 0.05),

              // About the App
              Text(
                'About the App',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black,
                ),
              ),
              SizedBox(height: 10),
              Text(
                'LabourLog is a digital solution designed to simplify workforce tracking and labor management for businesses and site administrators. With an intuitive interface, the app offers real-time monitoring, secure authentication, and seamless communication features.\n\n'
                'Key features include:\n'
                '- Secure login and user management\n'
                '- Time tracking and attendance logs\n'
                '- Admin insights and workforce analytics\n'
                '- Theme customization and accessibility options\n\n'
                'We are committed to continuous improvement and regularly update the app based on user feedback and evolving needs.',
                style: TextStyle(
                  fontSize: 16,
                  color: isDark ? Colors.white70 : Colors.black87,
                ),
              ),
              SizedBox(height: 30),

              // Privacy Policy
              Text(
                'Privacy Policy',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black,
                ),
              ),
              SizedBox(height: 10),
              Text(
                'At LabourLog, your privacy is our priority. We collect only the essential information required to deliver a smooth and secure experience. This includes user credentials, activity logs, and optional profile data like names or photos.\n\n'
                'All data is securely stored and managed through our backend service (Supabase). We do not sell, share, or misuse your information. Access to data is restricted and encrypted where applicable.\n\n'
                'By using the app, you agree to our data practices. For more details or inquiries, please contact us.',
                style: TextStyle(
                  fontSize: 16,
                  color: isDark ? Colors.white70 : Colors.black87,
                ),
              ),
              SizedBox(height: 30),

              Text(
                'Contact Us',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black,
                ),
              ),
              SizedBox(height: 10),
              Text(
                'I\'d love to hear from you! Whether you have a question, feedback, or need support, I am here to help.\n\n'
                'Support Email: varunvashisht.work@gmail.com\n'
                'WhatsApp Support: +91 9773970683\n'
                'Business Hours: Mon-Fri, 9:00 AM - 5:00 PM (IST)\n\n'
                'Or use the “Contact Support” button within the app to reach us instantly via WhatsApp.',
                style: TextStyle(
                  fontSize: 16,
                  color: isDark ? Colors.white70 : Colors.black87,
                ),
              ),
              SizedBox(height: screenHeight * 0.05),
              Align(
                alignment: Alignment.center,
                child: GestureDetector(
                  onTap: contactSupportOnWhatsApp,
                  child: Text(
                    "Contact Support?",
                    style: TextStyle(
                      color: (isDark ? Colors.white70 : Colors.grey),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
