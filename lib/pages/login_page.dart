
import 'package:social_app/components/my_button.dart';
import 'package:social_app/components/my_text_field.dart';
import 'package:social_app/services/auth/auth_service.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  final void Function()? onTap;
  const LoginPage({super.key, this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _pwController = TextEditingController();
  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _pwController.dispose();
  }
  // login method
  void login()async{
    final authService = AuthService();
    await authService.signInWithEmailPassword(_emailController.text, _pwController.text, context);
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
            Text(
                "Welcome back, you've been missed!",
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
            const SizedBox(height: 25),
            // login button
            MyButton(
                text: "Login",
                onTap: login, // onTap: ()=> login, //wrong
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                    "Not a member?",
                  style: TextStyle(color: Theme.of(context).colorScheme.primary),
                ),
                TextButton(
                    onPressed: widget.onTap,
                    child: Text(
                      "Register now",
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
