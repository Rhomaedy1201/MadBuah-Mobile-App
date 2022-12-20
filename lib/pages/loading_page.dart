import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '/helper_widget/botnavbar.dart';

class LoadingPage extends StatefulWidget {
  var id_user;
  LoadingPage({super.key, this.id_user});

  @override
  State<LoadingPage> createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {
  @override
  void initState() {
    Timer(
      Duration(seconds: 3),
      () {
        Get.offAll(Navbar(
          id_user: widget.id_user,
        ));
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          width: 150,
          height: 150,
          color: Colors.black,
        ),
      ),
    );
  }
}
