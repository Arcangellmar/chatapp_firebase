import 'package:shared_preferences/shared_preferences.dart';

class HelperFunction {
  static String userLoggerInKey = "ISLOGGEDIN";
  static String userNameKey = "USERNAMEKEY";
  static String userEmailKey = "USEREMAILKEY";

  static Future<bool?> getUserLoggedInStatus() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    return sharedPreferences.getBool(userLoggerInKey);
  }

  static Future<bool> saveUserLoggedInStatus(bool isUserLoggedIn) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    return await sharedPreferences.setBool(userLoggerInKey, isUserLoggedIn);
  }

  static Future<bool> saveUserNameSF(String userName) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    return await sharedPreferences.setString(userNameKey, userName);
  }

  static Future<bool> saveUserEmailSF(String userEmail) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    return await sharedPreferences.setString(userEmailKey, userEmail);
  }


  static Future<String?> getUserEmailFromSF() async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.getString(userEmailKey);
  }

  static Future<String?> getUserNameFromSF() async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.getString(userNameKey);
  }

}