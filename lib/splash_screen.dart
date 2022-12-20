import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project_madbuah/pages/loading_page.dart';
import '/controller/controll.dart';
import '/helper_widget/botnavbar.dart';
import '/login_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  bool isSkipLogin = false;

  String? currentId;
  bool? current;
  Future<void> checkSkip() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? lastValue = await Controller1.getCheckLogin();
    setState(() {
      current = lastValue as bool?;
    });
    String? lastValueId = await Controller1.getCheckIdUser();
    setState(() {
      currentId = lastValueId as String?;
    });
    print("Login Skip type = $current");
    print("id User = $currentId");
    if (current == true) {
      setState(() {
        isSkipLogin = true;
      });
    } else {
      setState(() {
        isSkipLogin = false;
      });
    }
  }

  @override
  void initState() {
    checkSkip();
    Timer(
      Duration(seconds: 3),
      () {
        (isSkipLogin == true)
            ? Get.offAll(
                Navbar(id_user: currentId),
              )
            : Get.offAll(
                LoginPage(),
              );
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
                color: Color(0xffF5591F),
                gradient: LinearGradient(
                    colors: [(Color(0xffF5591F)), (Color(0xffF2861E))],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter)),
          ),
          Center(
            child: Container(
              child: Image.asset(
                "assets/Madbuah.png",
                width: 400,
                height: 400,
              ),
            ),
          )
        ],
      ),
    );
  }
}
