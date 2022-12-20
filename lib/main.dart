import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project_madbuah/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Madbuah',
      defaultTransition: Transition.size,
      home: SplashScreen(),
    );
  }
}
