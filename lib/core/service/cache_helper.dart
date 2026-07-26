// ignore_for_file: strict_top_level_inference

import 'dart:convert';
import 'package:chat_app_ui/features/auth/model/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CacheHelper {
  static SharedPreferences? sharedPreferences;
  static init() async {
    sharedPreferences = await SharedPreferences.getInstance();
  }
    //Encreption
    static Future<void>saveUserData(UserModel usermodel, String key) async {
    String data = jsonEncode(usermodel.tomap());
    await sharedPreferences!.setString(key, data);
  }
    //Decreption
    UserModel? getData(String key) {
    String? data = sharedPreferences!.getString(key);
    if (data != null) {
      Map<String, dynamic> userMap = jsonDecode(data);
      return UserModel.fromJson(userMap);
    }
    return null;
  }
}
