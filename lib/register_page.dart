import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project_madbuah/http/networks.dart';
import '/login_page.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:quickalert/quickalert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:async';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  bool isPasswordVisible = false;

  bool isConfirmPasswordVisible = false;

  Networks network = Networks();

  TextEditingController fullname = TextEditingController();
  TextEditingController user = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController pass = TextEditingController();
  TextEditingController pass2 = TextEditingController();
  TextEditingController alamat = TextEditingController();
  TextEditingController notelp = TextEditingController();

  Future<void> _register() async {
    Uri url = Uri.parse("${network.register_user}");
    var response = await http.post(url, body: {
      "username": user.text,
      "password": pass.text,
      "fullname": fullname.text,
      "email": email.text,
      "no_telp": notelp.text,
      "alamat": alamat.text,
      "status": "user",
    });
    var data = jsonDecode(response.body);
    if (data[0]['type'] == true) {
      QuickAlert.show(
        context: context,
        type: QuickAlertType.success,
        text: 'Registrasi Berhasil',
        confirmBtnText: "Oke",
        onConfirmBtnTap: () {
          Get.offAll(LoginPage());
        },
        title: "Berhasil",
      );
    } else {
      QuickAlert.show(
        context: context,
        type: QuickAlertType.warning,
        text: 'Gagal Melakukan Registrasi',
        confirmBtnText: "Oke",
        title: "Warning!",
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 200,
              decoration: BoxDecoration(
                borderRadius:
                    BorderRadius.only(bottomLeft: Radius.circular(90)),
                gradient: LinearGradient(
                    colors: [(Color(0xffF5591F)), (Color(0xffF2861E))],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter),
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
                        height: 120,
                        width: 120,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 20),
                      alignment: Alignment.bottomCenter,
                      child: Text(
                        "Daftar",
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    )
                  ],
                ),
              ),
            ),
            Form(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              key: _formKey,
              child: Container(
                margin: EdgeInsets.all(20),
                padding: EdgeInsets.all(20),
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.grey[200]),
                      padding: const EdgeInsets.all(12),
                      margin: const EdgeInsets.only(top: 20, bottom: 10),
                      child: TextFormField(
                        controller: fullname,
                        cursorColor: Color(0xffF5591F),
                        decoration: const InputDecoration(
                          labelText: 'Nama Lengkap',
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
                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.grey[200]),
                      padding: const EdgeInsets.all(12),
                      margin: const EdgeInsets.only(top: 20, bottom: 10),
                      child: TextFormField(
                        controller: user,
                        cursorColor: Color(0xffF5591F),
                        decoration: const InputDecoration(
                          labelText: 'Username',
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
                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.grey[200]),
                      padding: const EdgeInsets.all(12),
                      margin: const EdgeInsets.only(top: 10, bottom: 10),
                      child: TextFormField(
                        controller: email,
                        cursorColor: Color(0xffF5591F),
                        decoration: const InputDecoration(
                          labelText: 'Email',
                          labelStyle: TextStyle(
                            color: Colors.blueGrey,
                          ),
                          suffixIcon: Icon(
                            Icons.email,
                            color: Color(0xffF5591F),
                          ),
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20))),
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.grey[200]),
                      padding: const EdgeInsets.all(12),
                      margin: const EdgeInsets.only(top: 10, bottom: 10),
                      child: TextFormField(
                        controller: pass,
                        cursorColor: Color(0xffF5591F),
                        decoration: const InputDecoration(
                          labelText: 'Sandi',
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
                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.grey[200]),
                      padding: const EdgeInsets.all(12),
                      margin: const EdgeInsets.only(top: 10),
                      child: TextFormField(
                        controller: pass2,
                        cursorColor: Color(0xffF5591F),
                        decoration: const InputDecoration(
                          labelText: 'Konfirmasi Sandi',
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
                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.grey[200]),
                      padding: const EdgeInsets.all(12),
                      margin: const EdgeInsets.only(top: 10),
                      child: TextFormField(
                        controller: alamat,
                        cursorColor: Color(0xffF5591F),
                        decoration: const InputDecoration(
                          labelText: 'Alamat',
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
                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.grey[200]),
                      padding: const EdgeInsets.all(12),
                      margin: const EdgeInsets.only(top: 10),
                      child: TextFormField(
                        controller: notelp,
                        cursorColor: Color(0xffF5591F),
                        decoration: const InputDecoration(
                          labelText: 'No HP',
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
                      height: 20.0,
                    ),
                    GestureDetector(
                      onTap: () async {
                        final isValidForm = _formKey.currentState!.validate();
                        if (isValidForm) {
                          _register();
                        } else {
                          return null;
                        }
                        // _register();
                      },
                      child: Container(
                        height: 53,
                        width: double.infinity,
                        margin: EdgeInsets.symmetric(horizontal: 30),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                  blurRadius: 4,
                                  color: Colors.black12.withOpacity(.2),
                                  offset: Offset(2, 2))
                            ],
                            borderRadius: BorderRadius.circular(12)
                                .copyWith(bottomRight: Radius.circular(12)),
                            gradient: LinearGradient(colors: [
                              Color(0xffF5591F),
                              Color(0xffF2861E)
                            ])),
                        child: Text('Register',
                            style: TextStyle(
                                color: Colors.white.withOpacity(.8),
                                fontSize: 15,
                                fontWeight: FontWeight.bold)),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            "Sudah punya Akun? ",
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
                                    return LoginPage();
                                  },
                                ),
                              );
                            },
                            child: Text(
                              "Login Sekarang",
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
