import 'package:social_app/components/my_button.dart';
import 'package:social_app/components/my_text_field.dart';
import 'package:social_app/services/auth/auth_service.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  final void Function()? onTap;
  const RegisterPage({super.key, this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _pwController = TextEditingController();
  final TextEditingController _confirmPwController = TextEditingController();
  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _pwController.dispose();
    _confirmPwController.dispose();
  }
  void register(){
    if(_pwController.text != _confirmPwController.text){
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Passwords didn't match! try again."),
            duration: Duration(seconds: 5),
          ),
      );
      print("Passwords didn't match! try again.");
      return;
    }
    final auth = AuthService();
    auth.signUpWithEmailPassword(_emailController.text, _pwController.text, context);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //logo
            Icon(
              Icons.message,
              size: 60,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 50),
            //welcome bck message
            Text(
              "Let's crete an account for you",
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(color:Theme.of(context).colorScheme.primary),
              // TextStyle(fontSize: 16, color: Theme.of(context).colorScheme.primary,),
            ),
            const SizedBox(height: 25),
            //emil text field
            MyTextField(
              controller: _emailController,
              hintText: 'email',
            ),
            const SizedBox(height: 10),
            // pw text field
            MyTextField(
              controller: _pwController,
              hintText: 'password',
              obscureText: true,
            ),
            const SizedBox(height: 10),
            MyTextField(
              controller: _confirmPwController,
              hintText: 'confirm password',
              obscureText: true,
            ),
            const SizedBox(height: 25),
            // login button
            MyButton(text: "Register", onTap: register),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Already have an account?",
                  style: TextStyle(color: Theme.of(context).colorScheme.primary),
                ),
                TextButton(
                  onPressed: widget.onTap,
                  child: Text(
                    "Login now",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
