import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:orderly/Utils/application.dart';
import 'package:orderly/Utils/preferences.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UtilPreferences {

  // static SharedPreferences preferences;
  //
  //  static callPreferences() async{
  //    preferences = await SharedPreferences.getInstance();
  //
  //  }
  static Future<bool> clear() {
    return Application.preferences.clear();
  }

  static bool containsKey(String key) {
    return Application.preferences.containsKey(key);
  }

  static dynamic get(String key) {
    return Application.preferences.get(key);
  }

  static bool getBool(String key) {
    return Application.preferences.getBool(key);
  }

  static double getDouble(String key) {
    return Application.preferences.getDouble(key);
  }

  static int getInt(String key) {
    return Application.preferences.getInt(key);
  }

  static Set<String> getKeys() {
    return Application.preferences.getKeys();
  }

  static String getString(String key) {

    return Application.preferences.getString(key);
  }

  static List<String> getStringList(String key) {
    return Application.preferences.getStringList(key);
  }

  static Future<void> reload() {
    return Application.preferences.reload();
  }

  static Future<bool> remove(String key) {
    return Application.preferences.remove(key);
  }

  static Future<bool> setBool(String key, bool value) {
    return Application.preferences.setBool(key, value);
  }

  static Future<bool> setDouble(String key, double value) {
    return Application.preferences.setDouble(key, value);
  }

  static Future<bool> setInt(String key, int value) {
    return Application.preferences.setInt(key, value);
  }

  static Future<bool> setString(String key, String value) {
     // callPreferences();
    return Application.preferences.setString(key, value);
  }

  static Future<bool> setStringList(String key, List<String> value) {
    return Application.preferences.setStringList(key, value);
  }

  static Future<String> getTokenId() async {
    final FirebaseMessaging _fcm = FirebaseMessaging.instance;

    var fcmToken = await _fcm.getToken();
    UtilPreferences.setString(Preferences.fcmToken, fcmToken.toString());
    var token=UtilPreferences.getString(Preferences.fcmToken);
    print('token:-'+fcmToken.toString());
    return token;
  }

  static Future<String> saveDeviceId() async{
    var deviceInfo = DeviceInfoPlugin();
    if (Platform.isAndroid) { // import 'dart:io'
      var androidDeviceId = await deviceInfo.androidInfo;
      print("androiId"+androidDeviceId.androidId);

      UtilPreferences.setString(Preferences.deviceId, androidDeviceId.androidId);
     return androidDeviceId.androidId;
    } else {
      var iosDeviceId = await deviceInfo.iosInfo;
      print("iosId"+ iosDeviceId.identifierForVendor);
      UtilPreferences.setString(Preferences.deviceId, iosDeviceId.identifierForVendor);
      return iosDeviceId.identifierForVendor;
    }
  }


  ///Singleton factory
  static final UtilPreferences _instance = UtilPreferences._internal();

  factory UtilPreferences() {
    return _instance;
  }

  UtilPreferences._internal();
}
