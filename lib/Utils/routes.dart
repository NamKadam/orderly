import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:orderly/Screens/Customer/address/address.dart';
import 'package:orderly/Screens/Customer/cart/addTime.dart';
import 'package:orderly/Screens/Customer/cart/shopping_cart.dart';
import 'package:orderly/Screens/mainNavigation.dart';
import 'package:orderly/Screens/profile/edit_profile.dart';
import 'package:orderly/Screens/profile/faq.dart';
import 'package:orderly/Screens/profile/profAddress/profAddress.dart';
import '../Screens/profile/privacyPolicy.dart';
import '../Screens/profile/termsOfUse.dart';
import 'package:orderly/Screens/user/OtpScreen.dart';

import 'package:orderly/Screens/user/choiceScreen.dart';

import 'package:orderly/Screens/user/signIn.dart';
import 'package:orderly/Screens/user/signup.dart';
import 'package:orderly/Screens/user/verify_phone.dart';


class Routes {

  static const String signIn = "/signIn";
  static const String signUp = "/signUp";
  static const String roleType='/roleType';
  static const String mainNavi='/maninNavi';
  static const String otp = "/otp"; //added on 6/02/2021
  static const String verifyPhone = "/verifyPhone";
  static const String otpRegUser = "/otpREgUser"; //added on 9/02/2021
  static const String forgotPassword = "/forgotPassword";
  static const String editProfile = "/editProfile";
  static const String profAddress = "/profaddress";
  static const String cart = "/cart";
  static const String terms='/terms';
  static const String privacy='/privacy';
  static const String faq='/faq';


  Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case signIn:
        return MaterialPageRoute(
          builder: (context) {
            // return SignIn(from: settings.arguments);
            return SignIn(from: settings.arguments.toString(),flagRoleType: settings.arguments.toString(),);
          },
          fullscreenDialog: false,
        );

      case signUp:
        return MaterialPageRoute(
          builder: (context) {
            return SignUp();
          },
          fullscreenDialog: false,
        );

    case mainNavi:
     return MaterialPageRoute(
       builder: (context) {
         return MainNavigation();
       },
       fullscreenDialog: false,
     );

     // case verifyPhone:
     //  return MaterialPageRoute(
     //    builder: (context) {
     //      return VerifyPhone(flagRoleType:settings.arguments.toString(),signUpDataNavigation: ,);
     //    },
     //    fullscreenDialog: false,
     //  );

    case roleType:
     return MaterialPageRoute(
       builder: (context) {
         return ChoiceScreen();
       },
       fullscreenDialog: false,
     );




      case profAddress:
        return MaterialPageRoute(builder: (context){
          return ProfAddress(fromProf: settings.arguments);
        });

        //added on 6/02/2021
      // case otp:
      //   return MaterialPageRoute(
      //     builder: (context) {
      //       return OtpScreen(mobNo: settings.arguments.toString());
      //     },
      //     fullscreenDialog: false,
      //   );
      case cart:
        return MaterialPageRoute(
          builder: (context) {
            return ShoppingCart();
          },
        );
    //added on 27/11/2020

    case editProfile:
        return MaterialPageRoute(
          builder: (context) {
            return EditProfile();
          },
        );


      case terms:
        return MaterialPageRoute(
          builder: (context) {
            return TermsOfUse();
          },
        );

      case privacy:
        return MaterialPageRoute(
          builder: (context) {
            return PrivacyPolicy();
          },
        );

      case faq:
        return MaterialPageRoute(
          builder: (context) {
            return FAQ();
          },
        );

      // case changeLanguage:
      //   return MaterialPageRoute(
      //     builder: (context) {
      //       return LanguageSetting();
      //     },
      //   );

      // case themeSetting:
      //   return MaterialPageRoute(
      //     builder: (context) {
      //       return ThemeSetting();
      //     },
      //   );




      default:
        return MaterialPageRoute(
          builder: (context) {
            return Scaffold(
              appBar: AppBar(
                title: Text("Not Found"),
              ),
              body: Center(
                child: Text('No path for ${settings.name}'),
              ),
            );
          },
        );
    }
  }

  ///Singleton factory
  static final Routes _instance = Routes._internal();

  factory Routes() {
    return _instance;
  }

  Routes._internal();
}
