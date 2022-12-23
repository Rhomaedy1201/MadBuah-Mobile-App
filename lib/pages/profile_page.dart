import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project_madbuah/widgets/loading.dart';
import '/http/networks.dart';
import 'package:quickalert/quickalert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '/login_page.dart';
import '/pages/edit_profile.dart';
import 'package:http/http.dart' as http;

class ProfilePage extends StatefulWidget {
  var id_user;
  ProfilePage({Key? key, this.id_user}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool isLoading = false;
  Networks network = Networks();

  void removeLogin() {
    QuickAlert.show(
      context: context,
      type: QuickAlertType.warning,
      text: 'Apakah kamu yakin ingin keluar?',
      confirmBtnText: "Iya",
      onConfirmBtnTap: () async {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.remove('valueLogin');
        await prefs.remove('valueId');
        Get.offAll(LoginPage());
      },
      cancelBtnText: "Batal",
      showCancelBtn: true,
      onCancelBtnTap: () {
        Get.back();
      },
      title: "Warning!",
    );
  }

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
      });
      print(result['result'][0]['status']);
    } catch (e) {
      log(e.toString());
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    print("id user profile = ${widget.id_user}");
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
                "Profile",
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xffF2861E),
                ),
              ),
            ),
            body: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: RefreshIndicator(
                  onRefresh: () async {
                    _getUser();
                  },
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: result.length,
                    itemBuilder: (context, index) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const CircleAvatar(
                            radius: 50,
                            backgroundColor: Color(0xFFCCB9A8),
                            child: Icon(
                              Icons.person,
                              size: 55,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(
                            height: 10.0,
                          ),
                          (result['result'][0]['status'] == "admin")
                              ? Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      '${result['result'][index]['fullname']}',
                                      style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const Icon(
                                      Icons.check_circle_rounded,
                                      size: 20,
                                      color: Color(0xFF005CE7),
                                    )
                                  ],
                                )
                              : Text(
                                  '${result['result'][index]['fullname']}',
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                          Text(
                            '${result['result'][index]['email']}',
                            style: const TextStyle(fontSize: 14),
                          ),
                          const SizedBox(
                            height: 10.0,
                          ),
                          const SizedBox(
                            height: 20.0,
                          ),
                          const Divider(),
                          const SizedBox(
                            height: 10.0,
                          ),
                          ProfileMenuWidget(
                            title: "Akun Saya",
                            icon: Icons.person,
                            onPress: () {
                              Get.to(EditProfilePage(
                                id_user: widget.id_user,
                              ));
                            },
                          ),
                          const SizedBox(
                            height: 10.0,
                          ),
                          ProfileMenuWidget(
                            title: "Keluar",
                            icon: Icons.logout_outlined,
                            textColor: Colors.red,
                            onPress: () {
                              removeLogin();
                            },
                          ),
                        ],
                      );
                    },
                  ),
                )),
          );
  }
}

class ProfileMenuWidget extends StatelessWidget {
  const ProfileMenuWidget({
    Key? key,
    required this.title,
    required this.icon,
    required this.onPress,
    this.endIcon = true,
    this.textColor,
  }) : super(key: key);

  final String title;
  final IconData icon;
  final VoidCallback onPress;
  final bool endIcon;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onPress,
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            color: const Color(0xffF2861E).withOpacity(0.1)),
        child: Icon(
          icon,
          color: const Color(0xfff2861E),
        ),
      ),
      title: Text(title),
      trailing: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            color: Colors.grey.withOpacity(0.1)),
        child: const Icon(
          Icons.arrow_forward_ios,
          size: 18,
          color: Colors.grey,
        ),
      ),
    );
  }
}
