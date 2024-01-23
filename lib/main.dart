import 'package:flutter/material.dart';
import 'SignuUp.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      showSemanticsDebugger: false,
debugShowCheckedModeBanner: false,
home: Scaffold(
  body: SignupScreen(),
),
    );
  }
}
