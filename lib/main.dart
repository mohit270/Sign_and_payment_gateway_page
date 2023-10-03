import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:sign/auth/auth_page.dart';
import 'package:sign/auth/firebase_options.dart';
import 'package:sign/auth/login_or_register_page.dart';
import 'package:sign/auth/login_pages.dart';
import 'package:sign/pay/pay_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AuthPage(),
    );
  }
}
