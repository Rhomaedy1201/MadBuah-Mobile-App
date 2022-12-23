import 'package:flutter/material.dart';
import 'package:project_madbuah/controller/controll.dart';
import 'package:project_madbuah/pages/dashboard_page.dart';
import 'package:project_madbuah/pages/order_page.dart';
import 'package:project_madbuah/pages/profile_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Navbar extends StatefulWidget {
  var id_user;
  Navbar({Key? key, this.id_user}) : super(key: key);

  @override
  State<Navbar> createState() => _NavbarState();
}

class _NavbarState extends State<Navbar> {
  int _currentIndex = 0;

  String? currentId;
  Future<void> getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? lastValueId = await Controller1.getCheckIdUser();
    setState(() {
      currentId = lastValueId as String?;
    });
    print("currend $currentId");
  }

  @override
  void initState() {
    getUser();
    print("nav id ${widget.id_user}");
    // print("nav id ${widget.id_user}");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: [
        DashboardPage(id_user: widget.id_user),
        OrderPage(id_user: widget.id_user),
        ProfilePage(id_user: widget.id_user),
      ].elementAt(_currentIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Beranda'),
          BottomNavigationBarItem(
              icon: Icon(Icons.shopping_bag), label: 'Pesanan'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
        ],
        currentIndex: _currentIndex,
        selectedItemColor: const Color(0xffF5591F),
        unselectedItemColor: Colors.grey,
        onTap: _changeItem,
      ),
    );
  }

  void _changeItem(int value) {
    print(value);
    setState(() {
      _currentIndex = value;
    });
  }
}
