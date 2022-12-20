import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project_madbuah/http/networks.dart';
import '/controller/controll.dart';
import '/helper_widget/botnavbar.dart';
import 'package:http/http.dart' as http;
import '/register_page.dart';
import 'package:quickalert/quickalert.dart';
import 'dart:convert';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isPasswordVisible = false;

  Networks network = Networks();

  List result = [];

  Future<String?> resetCheckLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('valueLogin', true);
    setState(() {});
  }

  Future<bool?> _incrementCheckLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? lastValue = await Controller1.getCheckLogin();
    bool? current = lastValue;
    await prefs.setBool('valueLogin', current!);
    print(current);
    setState(() {});
  }

  Future<String?> resetCheckIdUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('valueId', data[0]['id_user']);
    setState(() {});
  }

  Future<String?> _incrementCheckIdUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? lastValueId = await Controller1.getCheckIdUser();
    String? currentId = lastValueId;
    await prefs.setString('valueId', currentId!);
    print("id user : $currentId");
    setState(() {});
  }

  var data;
  Future<void> _login() async {
    try {
      Uri url = Uri.parse(
          "${network.login_user}?username=${userNameController.text}&password=${passwordController.text}");
      var response = await http.get(url);
      setState(() {
        data = jsonDecode(response.body);
        if (data[0]['type'] == true) {
          resetCheckLogin();
          resetCheckIdUser();
          Get.offAll(Navbar(
            id_user: data[0]['id_user'],
          ));
        } else {
          QuickAlert.show(
            context: context,
            type: QuickAlertType.error,
            text: 'Username atau password salah!!!',
            confirmBtnText: "Oke",
            title: "Gagal!",
          );
        }
      });
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  void initState() {
    _incrementCheckLogin();
    _incrementCheckIdUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 300,
              decoration: BoxDecoration(
                borderRadius:
                    BorderRadius.only(bottomLeft: Radius.circular(90)),
                color: Color(0xffF5591F),
                gradient: LinearGradient(
                  colors: [(Color(0xffF5591F)), (Color(0xffF2861E))],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: 20),
                      child: Image.asset(
                        "assets/Madbuah.png",
                        width: 200,
                        height: 200,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 20, bottom: 20),
                      alignment: Alignment.bottomCenter,
                      child: Text(
                        "login".toUpperCase(),
                        style: TextStyle(color: Colors.white, fontSize: 30),
                      ),
                    )
                  ],
                ),
              ),
            ),
            const Padding(padding: EdgeInsets.only(top: 20)),
            Form(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              key: _formKey,
              child: Container(
                margin: const EdgeInsets.all(20),
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.grey[200]),
                      padding: const EdgeInsets.all(12),
                      margin: const EdgeInsets.only(),
                      child: TextField(
                        controller: userNameController,
                        cursorColor: const Color(0xffF5591F),
                        decoration: const InputDecoration(
                          labelText: 'Nama Pengguna',
                          labelStyle: TextStyle(
                            color: Colors.blueGrey,
                          ),
                          suffixIcon: Icon(
                            Icons.person,
                            color: Color(0xffF5591F),
                          ),
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20))),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.grey[200]),
                      padding: const EdgeInsets.all(12),
                      margin: const EdgeInsets.only(),
                      child: TextField(
                        controller: passwordController,
                        obscureText: true,
                        decoration: const InputDecoration(
                          labelText: 'Kata Sandi',
                          labelStyle: TextStyle(
                            color: Colors.blueGrey,
                          ),
                          suffixIcon: Icon(
                            Icons.lock,
                            color: Color(0xffF5591F),
                          ),
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20))),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 30.0,
                    ),
                    Container(
                      child: ElevatedButton(
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(40, 10, 40, 10),
                          child: Text(
                            'login'.toUpperCase(),
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xffF2861E),
                        ),
                        onPressed: () async {
                          // final isValidForm = _formKey.currentState!.validate();
                          // if (isValidForm) {
                          //   var sharedPref =
                          //       await SharedPreferences.getInstance();
                          //   sharedPref.setBool(
                          //       SplashScreenState.KEYLOGIN, true);
                          //   _login();
                          // } else {
                          //   return null;
                          // }
                          _login();
                        },
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            "Belum punya akun? ",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) {
                                    return RegisterPage();
                                  },
                                ),
                              );
                            },
                            child: Text(
                              "Daftar Sekarang",
                              style: TextStyle(color: Color(0xffF5591F)),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
