import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:social_app/state_holders/theme_controller.dart';

class ChatBubble extends StatelessWidget {
  final String message;
  final bool isCurrentUser;
  const ChatBubble({
    super.key,
    required this.message,
    required this.isCurrentUser
  });

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Get.find<ThemeController>().isDarkMode.value;
    return Align(
      alignment: isCurrentUser? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.8,
        ),
        decoration: BoxDecoration(
          color: isCurrentUser? Colors.green.shade500: Theme.of(context).colorScheme.surfaceDim, // Colors.grey.shade500,
          borderRadius: BorderRadius.circular(12),
        ),
        margin: const EdgeInsets.symmetric(vertical: 2),
        padding: const EdgeInsets.all(12),
        child: Text(
          message,
         // style: TextStyle(color: isDarkMode? Colors.white: Colors.black), // takes auto for light/dark
        ), // use SelectableText() to select ---
      ),
    );
  }
}
