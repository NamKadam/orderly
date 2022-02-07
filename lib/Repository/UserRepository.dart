import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:orderly/Api/api.dart';
import 'package:orderly/Blocs/custorderDet/bloc.dart';
import 'package:orderly/Models/model_scoped_cart.dart';
import 'package:orderly/Models/model_user.dart';
import 'package:orderly/Models/model_view_cart.dart';
import 'package:orderly/Utils/preferences.dart';
import 'package:orderly/Utils/util_preferences.dart';

class UserRepository {

  ///Fetch api login
  Future<dynamic> login({String fbId}) async {
    final params = {"fb_id":fbId};
    return await Api.login(params);
  }
  //fleet login
  Future<dynamic> fleetlogin({String fbId,String mobile,String fcmId,String deviceId}) async {
    final params = {"fb_id":fbId,"mobile":mobile,"fcm_id":fcmId,"device_id":deviceId};
    return await Api.fleetlogin(params);
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

  //save cart
  Future<dynamic> saveCart(CartModel cartModel) async {
    return await UtilPreferences.setString(
      Preferences.cart,
      jsonEncode(cartModel.cart.map((i) => Cart.toJson(i)).toList()).toString(),);
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

  Future<dynamic> fetchAddressList({String fbId}) async {
    final params = {"userid":fbId};
    return await Api.getAddress(params);
  }

  //fetch myOrders
  Future<dynamic> fetchMyOrdersList({String fbId}) async
  {
    final params = {"userid":fbId};
    return await Api.getOrdersList(params);
  }

  //track order
  Future<dynamic> fetchTrackOrdersList({String orderId}) async
  {
    final params = {"order_details_id":orderId};
    return await Api.getTrackOrderList(params);
  }

  Future<dynamic> fetchFleetOrdersList({String producerId,String status}) async
  {
    final params = {"producerid":producerId,"status":status};
    return await Api.getFleetOrdersList(params);
  }

  Future<dynamic> fetchFleetOrdersDet({String orderId,String status,String producerId}) async
  {
    final params = {"orderid":orderId,"status":status,"producerid":producerId};
    return await Api.getFleetOrdersDet(params);
  }

  //for temp and latLng
  Future<dynamic> fetchFleetOrdersDetTemp({String orderId,String status}) async
  {
    final params = {"order_details_id":orderId,"order_status":status};
    return await Api.getFleetOrdersDetTemp(params);
  }

  //fleet return Replace
  Future<dynamic> fetchFleetReturnReplace({String producerId}) async
  {
    final params = {"producerid":producerId};
    return await Api.getFleetReturnReplace(params);
  }

  Future<dynamic> fetchFleetInventory({String producerId}) async
  {
    final params = {"producer_id":producerId};
    return await Api.viewInventoryList(params);
  }

  Future<dynamic> fetchClaimOrdersList({String producerId,String claimType}) async
  {
    final params = {"producer_id":producerId,"claim_type":claimType};
    return await Api.getClaimOrdersList(params);
  }

  //faq List
  Future<dynamic> getFAQList() async {
    return await Api.getFAQLIst();
  }

  ///Get from Storage
  dynamic getUser() {
    return UtilPreferences.getString(Preferences.user);
  }

  //get cart details
  ///Get from Storage
  dynamic getCart() {
    return UtilPreferences.getString(Preferences.cart);
  }

  ///Delete Storage
  Future<dynamic> deleteUser() async {
    return await UtilPreferences.remove(Preferences.user);
  }

  Future<dynamic> deleteCart() async {
    return await UtilPreferences.remove(Preferences.cart);
  }
}

