import 'package:shared_preferences/shared_preferences.dart';

class TokenManager {
  static Future<String> getToken() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getString('jwt_token') ?? "";
  }
}