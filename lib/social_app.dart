import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:social_app/services/auth/auth_gate.dart';
import 'package:social_app/state_holders/theme_controller.dart';

class SocialApp extends StatelessWidget {
  const SocialApp({super.key});
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>(); // -----
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => GetMaterialApp(
        navigatorKey: SocialApp.navigatorKey, //-----
        theme: Get.find<ThemeController>().isDarkMode.value
            ? darkMode //ThemeData.dark()
            : lightMode, //ThemeData.light(),
        home: const AuthGate(),
      ),
    );
  }
}

ThemeData lightMode = ThemeData(
  colorScheme: ColorScheme.light(
    //onPrimary: ,
    //background: Colors.grey.shade300, //deprecated
    surface: Colors.grey.shade200, // 300, post pic surrounding color
    surfaceDim: Colors.grey.shade100,
    primary: Colors.grey.shade500,
    secondary: Colors.grey.shade200,
    tertiary: Colors.white,
    inversePrimary: Colors.grey.shade800,
    //brightness: Brightness.light, // https://stackoverflow.com/questions/62989252/what-is-the-difference-between-themedataprimarycolor-colors-red-and-providing
  ),
  useMaterial3: true,
  scaffoldBackgroundColor: Colors.grey.shade50,
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.grey.shade300,
      foregroundColor: Colors.black,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
    ),
  ),
  iconTheme: IconThemeData(
    color: Colors.blue[300], // doesn't work if icon is in CircleAvatar --------
  ),
  appBarTheme: AppBarTheme(
    backgroundColor: Colors.grey.shade200,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
  ),
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: Colors.grey.shade500,
    shape: const CircleBorder(),
  ),
);

ThemeData darkMode = ThemeData(
  colorScheme: ColorScheme.dark(
    surface: Colors.grey.shade900,
    surfaceDim: Colors.grey.shade800,
    primary: Colors.grey.shade600,
    secondary: Colors.grey.shade700.withOpacity(0.3), //make it darker
    tertiary: Colors.grey.shade800,
    inversePrimary: Colors.grey.shade300,
  ),
  useMaterial3: true,
  scaffoldBackgroundColor: Colors.grey.shade800.withOpacity(0.7), //Colors.transparent, //gives full black
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.grey.shade700,
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
    ),
  ),
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: Colors.grey.shade700,
    shape: const CircleBorder(),
  ),
);