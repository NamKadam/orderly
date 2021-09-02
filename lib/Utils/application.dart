import 'package:orderly/Models/model_user.dart';
import 'package:orderly/Models/model_view_cart.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Application {
  static bool debug = false;
  static String version = '1.0.2';
  static SharedPreferences preferences;


  static User user;
  static List<Cart> cart;
  static String token;


  //added on 7/01/2021 for firebase chat
  static const String androidGoogleAppId="1:616488191042:android:2af79d85760b61597e99db"; //mobilesdk_app_id
  static const String androidApiKey="AIzaSyAubWzDXwdeJcnqGp6rwIDytnbS3Up0cDk";
  static const String androidDatabaseUrl="https://medical-demo-d243d.firebaseio.com";
  static const String ProjectId="medical-demo-d243d";
  static const String senderId="616488191042";

  //for ios
  static const String iosGoogleAppId = '1:616488191042:android:2af79d85760b61597e99db';
  static const String iosGcmSenderId = '616488191042';
  static const String iosDatabaseUrl = 'https://medical-demo-d243d.firebaseio.com';
  static const String iosApiKey = 'AIzaSyAubWzDXwdeJcnqGp6rwIDytnbS3Up0cDk';


  ///Singleton factory
  static final Application _instance = Application._internal();

  factory Application() {
    return _instance;
  }

  Application._internal();
}
