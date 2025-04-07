import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:todoo/screens/auth_check.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: 'AIzaSyDEaAmEBS9RMrPGxhUzJFcOHU3Y4qXaPzA',
        appId: '1:104713538134:android:75c893f8b8941d28b1c9f7',
        messagingSenderId: '104713538134',
        projectId: 'todo-e551a',
        storageBucket: 'todo-e551a.firebasestorage.app',
      )
  );
  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AuthCheck(),
    );
  }
}