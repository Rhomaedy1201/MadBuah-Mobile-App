import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:project_madbuah/http/networks.dart';
import 'package:http/http.dart' as http;
import 'package:project_madbuah/widgets/loading.dart';
import 'package:quickalert/quickalert.dart';

class EditProfilePage extends StatefulWidget {
  var id_user;
  EditProfilePage({Key? key, this.id_user}) : super(key: key);

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  TextEditingController username = TextEditingController();
  TextEditingController fullName = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController sandi = TextEditingController();
  TextEditingController no_telp = TextEditingController();
  TextEditingController alamat = TextEditingController();

  Networks network = Networks();

  bool isLoading = false;

  Map<String, dynamic> result = {};
  Future<void> _getUser() async {
    setState(() {
      isLoading = true;
    });

    try {
      Uri url = Uri.parse("${network.get_user}?id_user=${widget.id_user}");
      var response = await http.get(url);
      setState(() {
        result = jsonDecode(response.body);
        username.text = result['result'][0]['username'];
        fullName.text = result['result'][0]['fullname'];
        email.text = result['result'][0]['email'];
        sandi.text = result['result'][0]['password'];
        no_telp.text = result['result'][0]['no_telp'];
        alamat.text = result['result'][0]['alamat'];
      });
    } catch (e) {
      log(e.toString());
    }

    setState(() {
      isLoading = false;
    });
  }

  Future<void> editUser() async {
    setState(() {
      isLoading = true;
    });

    try {
      Uri url = Uri.parse(
          "${network.put_user}?username=${username.text}&password=${sandi.text}&fullname=${fullName.text}&email=${email.text}&no_telp=${no_telp.text}&alamat=${alamat.text}2&id_user=${widget.id_user}");
      var response = await http.put(url);
      var result = jsonDecode(response.body);
      if (result[0]['type'] == true) {
        QuickAlert.show(
          context: context,
          type: QuickAlertType.warning,
          text: 'Apakah kamu yakin ingin merubah data?',
          confirmBtnText: "Iya",
          onConfirmBtnTap: () {
            Get.back();
            QuickAlert.show(
              context: context,
              type: QuickAlertType.success,
              text: 'Berhasil Merubah data',
              confirmBtnText: "Iya",
              onConfirmBtnTap: () async {
                Get.back();
                Get.back();
              },
              title: "Success",
            );
          },
          cancelBtnText: "Batal",
          showCancelBtn: true,
          onCancelBtnTap: () {
            Get.back();
          },
          title: "Warning!",
        );
      } else {
        QuickAlert.show(
          context: context,
          type: QuickAlertType.warning,
          text: 'Gagal Merubah data!',
          confirmBtnText: "Iya",
          onConfirmBtnTap: () async {},
          onCancelBtnTap: () {
            Get.back();
          },
          title: "Warning!",
        );
      }
    } catch (e) {
      log(e.toString());
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    _getUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Scaffold(
            body: LoadingWidget(),
          )
        : Scaffold(
            appBar: AppBar(
              elevation: 0,
              backgroundColor: const Color(0xFFFFC085),
              iconTheme: const IconThemeData(
                color: Color(0xffF2861E),
              ),
              centerTitle: true,
              title: const Text(
                "Edit Profile",
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xffF2861E),
                ),
              ),
            ),
            body: SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                child: Column(
                  children: [
                    Container(
                      width: 200,
                      height: 200,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: Lottie.asset('assets/lottie/edit-profile.json'),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Form(
                      child: Column(
                        children: [
                          TextFormField(
                            controller: username,
                            cursorColor: const Color(0xffF2861E),
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(100),
                              ),
                              label: const Text('Username'),
                              floatingLabelStyle:
                                  const TextStyle(color: Color(0xffF5591F)),
                              prefixIcon: const Icon(Icons.person),
                              prefixIconColor: const Color(0xffF5591F),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(100),
                                  borderSide: const BorderSide(
                                      width: 2, color: Color(0xffF5591F))),
                            ),
                          ),
                          const SizedBox(
                            height: 20.0,
                          ),
                          TextFormField(
                            controller: fullName,
                            cursorColor: const Color(0xffF2861E),
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(100),
                              ),
                              label: const Text('Nama Lengkap'),
                              floatingLabelStyle:
                                  const TextStyle(color: Color(0xffF5591F)),
                              prefixIcon: const Icon(Icons.person),
                              prefixIconColor: const Color(0xffF5591F),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(100),
                                  borderSide: const BorderSide(
                                      width: 2, color: Color(0xffF5591F))),
                            ),
                          ),
                          const SizedBox(
                            height: 20.0,
                          ),
                          TextFormField(
                            controller: email,
                            cursorColor: const Color(0xffF2861E),
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(100),
                                ),
                                label: Text('Email'),
                                floatingLabelStyle:
                                    const TextStyle(color: Color(0xffF5591F)),
                                prefixIcon: const Icon(Icons.email),
                                prefixIconColor: const Color(0xffF5591F),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(100),
                                    borderSide: const BorderSide(
                                        width: 2, color: Color(0xffF5591F)))),
                          ),
                          const SizedBox(
                            height: 20.0,
                          ),
                          TextFormField(
                            controller: sandi,
                            cursorColor: Color(0xffF2861E),
                            decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(100),
                                ),
                                label: const Text('Sandi'),
                                floatingLabelStyle:
                                    const TextStyle(color: Color(0xffF5591F)),
                                prefixIcon: const Icon(Icons.lock),
                                prefixIconColor: const Color(0xffF5591F),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(100),
                                    borderSide: const BorderSide(
                                        width: 2, color: Color(0xffF5591F)))),
                          ),
                          const SizedBox(
                            height: 20.0,
                          ),
                          TextFormField(
                            controller: no_telp,
                            cursorColor: Color(0xffF2861E),
                            keyboardType: TextInputType.phone,
                            decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(100),
                                ),
                                label: const Text('No Telp'),
                                floatingLabelStyle:
                                    const TextStyle(color: Color(0xffF5591F)),
                                prefixIcon: const Icon(Icons.lock),
                                prefixIconColor: const Color(0xffF5591F),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(100),
                                    borderSide: const BorderSide(
                                        width: 2, color: Color(0xffF5591F)))),
                          ),
                          const SizedBox(
                            height: 20.0,
                          ),
                          TextField(
                            controller: alamat,
                            cursorColor: const Color(0xffF2861E),
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(100),
                              ),
                              label: const Text('Alamat'),
                              floatingLabelStyle:
                                  TextStyle(color: Color(0xffF5591F)),
                              prefixIcon: const Icon(Icons.maps_home_work),
                              prefixIconColor: const Color(0xffF5591F),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(100),
                                borderSide: const BorderSide(
                                    width: 2, color: Color(0xffF5591F)),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 20.0,
                          ),
                          Container(
                            width: 200,
                            height: 40,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: Color(0xffF2861E),
                                side: BorderSide.none,
                                shape: const StadiumBorder(),
                              ),
                              onPressed: () {
                                editUser();
                              },
                              child: const Text(
                                'Ubah Profil',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
  }
}
