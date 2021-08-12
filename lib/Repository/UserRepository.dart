import 'dart:convert';

import 'package:orderly/Api/api.dart';
import 'package:orderly/Models/model_user.dart';
import 'package:orderly/Utils/preferences.dart';
import 'package:orderly/Utils/util_preferences.dart';

class UserRepository {

  ///Fetch api login
  Future<dynamic> login({String api_token,String mobile, String otp}) async {
    final params = {"api_token":api_token,"mobile": mobile, "otp": otp};
    return await Api.login(params);
  }

  Future<dynamic> userReg({String api_token,String mobile, String otp}) async {
    final params = {"api_token":api_token,"mobile": mobile, "otp": otp};
    return await Api.login(params);
  }

  ///Save Storage
  Future<dynamic> saveUser(User user) async {
    return await UtilPreferences.setString(
      Preferences.user,
      jsonEncode(user.toJson()),
    );
  }

  ///Get from Storage
  dynamic getUser() {
    return UtilPreferences.getString(Preferences.user);
  }

  ///Delete Storage
  Future<dynamic> deleteUser() async {
    return await UtilPreferences.remove(Preferences.user);
  }
}