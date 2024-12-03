// social_app : upload photos with comments, chat,
// to add: comment to your pic post, in HomeScreen
// ExpansionTile() : https://api.flutter.dev/flutter/material/ExpansionTile-class.html
// test
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:social_app/social_app.dart';
import 'firebase_options.dart';
import 'state_holders/theme_controller.dart';

void main()async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  Get.put(ThemeController());
  runApp(const SocialApp());
}

// connected to social-app @anupbarua30@gmail.com

// run in console:
// 1. firebase login
// 2. flutter pub global activate flutterfire_cli
// 3. flutterfire configure (select an app in firebase, & used Android application id (or package name): com.example.chat_app)


// flutter clean, flutter pub get, flutter run,

// anup1@example.com, pw: anup123
// anup2@example.com, pw: anup123
// cori@example.com, pw: cori123


