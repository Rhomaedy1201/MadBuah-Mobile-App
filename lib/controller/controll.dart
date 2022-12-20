import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Controller1 extends GetxController {
  static Future<bool?> getCheckLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final boolLoginValue = prefs.getBool('valueLogin');
    if (boolLoginValue == null) {
      return false;
    } else {
      return boolLoginValue;
    }
  }

  static Future<String?> getCheckIdUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final stringIdUser = prefs.getString('valueId');
    if (stringIdUser == null) {
      return "";
    } else {
      return stringIdUser;
    }
  }
}
