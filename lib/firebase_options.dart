// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyDOM9wDdWDsiwKALBTJZz5CS6C9wIXxhpQ',
    appId: '1:249491045519:web:fdf7c0a7cef0b6785004fa',
    messagingSenderId: '249491045519',
    projectId: 'social-app-76c8c',
    authDomain: 'social-app-76c8c.firebaseapp.com',
    storageBucket: 'social-app-76c8c.appspot.com',
    measurementId: 'G-YZ0M9VXN19',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCYSKJR8-U_QMnHm9385Ypi9ArzVILFf1k',
    appId: '1:249491045519:android:233bbe2b6dcff7c75004fa',
    messagingSenderId: '249491045519',
    projectId: 'social-app-76c8c',
    storageBucket: 'social-app-76c8c.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCcEW5PocG1RD1f_GwFU_qlOaqe8hwnEHc',
    appId: '1:249491045519:ios:2bb95de41f7e9bbb5004fa',
    messagingSenderId: '249491045519',
    projectId: 'social-app-76c8c',
    storageBucket: 'social-app-76c8c.appspot.com',
    iosBundleId: 'com.example.socialApp',
  );
}
