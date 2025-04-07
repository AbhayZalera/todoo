import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../controller/auth_controller.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthController auth = AuthController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Future<void> login() async {
    final user =
    await auth.login(emailController.text, passwordController.text);

    if (user == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(
          const SnackBar(content: Text('Invalid email or Password')));
    }
  }

  Future<void> googleSignIn() async {
    final user = await auth.googleSignIn();
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Something Went Wrong')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("To Do App Login")),
        body: Center(child:
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: emailController,
                decoration: InputDecoration(
                    labelText: "Email", hintText: 'Email'),
                keyboardType: TextInputType.emailAddress,
              ),
            ),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: passwordController,
                decoration: InputDecoration(
                    labelText: "Password", hintText: 'Password'),
                obscureText: true,
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(onPressed: login, child: Text('LogIn')),
            SizedBox(height: 20),
            ElevatedButton(onPressed: googleSignIn, child: Text("SignIn With Google")),
          ],
        ),)

    );
  }
}