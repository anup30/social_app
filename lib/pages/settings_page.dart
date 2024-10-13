import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:social_app/state_holders/theme_controller.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    ThemeController themeController = Get.find();
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: const Text("Settings"),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.grey,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.blue), // drawer color
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondary, //
          borderRadius: BorderRadius.circular(12),
        ),
        margin: const EdgeInsets.all(24),
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Obx(() => themeController.isDarkMode.value
                ? const Text("Dark Mode")
                : const Text("Light Mode")),
            Switch(
                value: themeController.isDarkMode.value,
                onChanged: (value)=> themeController.toggleTheme(),
            ),
          ],
        ),
      ),
    );
  }
}
