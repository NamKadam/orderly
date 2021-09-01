import 'dart:convert';

import 'package:orderly/Api/api.dart';
import 'package:orderly/Models/cart_model.dart';
import 'package:orderly/Models/model_user.dart';
import 'package:orderly/Models/view_cart.dart';
import 'package:orderly/Utils/preferences.dart';
import 'package:orderly/Utils/util_preferences.dart';

class UserRepository {

  ///Fetch api login
  Future<dynamic> login({String fbId}) async {
    final params = {"fb_id":fbId};
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


  //category producer
  Future<dynamic> fetchProducerCat() async {
    return await Api.getProducerList();
  }
  //api for product list as per producer
  Future<dynamic> fetchProduct({String producerId,String type, String offset}) async {
    final params = {"producer_id":producerId,"type":type,"offset":offset};

    return await Api.getProdList(params);
  }

  //get cartList
  //api for product list as per producer
  Future<dynamic> fetchCartList({String fbId}) async {
    final params = {"user_id":fbId};

    return await Api.getCartList(params);
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