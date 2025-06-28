import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'app/routes/app_pages.dart';
import 'app/core/bindings/initial_binding.dart';
import 'app/core/constants/supabase_keys.dart';
import 'app/screens/appearance/app_appearance_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: SupabaseKeys.supabaseUrl,
    anonKey: SupabaseKeys.supabaseAnonKey,
  );

  Get.put(AppAppearanceController(), permanent: true);


  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final appAppearanceController = Get.find<AppAppearanceController>();

    return GetX<AppAppearanceController>(
      builder: (_) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          title: "LabourLog",
          initialBinding: InitialBinding(),
          initialRoute: AppPages.INITIAL,
          getPages: AppPages.routes,
          theme: ThemeData(
            brightness: Brightness.light,
            primarySwatch: Colors.grey,
            useMaterial3: true,
            fontFamily: "Ostent",
          ),
          darkTheme: ThemeData(
            brightness: Brightness.dark,
            useMaterial3: true,
            fontFamily: "Ostent",
          ),
          themeMode: appAppearanceController.isDarkMode.value
              ? ThemeMode.dark
              : ThemeMode.light,
        );
      },
    );
  }
}
