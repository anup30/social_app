//import 'package:social_app/pages/chat_page.dart';
import 'package:social_app/pages/home_page.dart';
import 'package:social_app/services/auth/login_or_register.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot){
          if(snapshot.hasData){
            return const HomePage(); // ChatPage()
          }
          else{
            return const LoginOrRegister();
          }
        },
      ),
    );
  }
}
