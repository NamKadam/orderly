import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:http/http.dart' as http;
import 'package:orderly/Blocs/theme/theme_bloc.dart';
import 'package:orderly/Utils/preferences.dart';
import 'package:orderly/Utils/util_preferences.dart';


class Authentication {
  static SnackBar customSnackBar({String content}) {
    return SnackBar(
      backgroundColor: Colors.black,
      content: Text(
        content,
        style: TextStyle(color: Colors.redAccent, letterSpacing: 0.5),
      ),
    );
  }

  static Future<FirebaseApp> initializeFirebase({BuildContext context,
  }) async {
    FirebaseApp firebaseApp = await Firebase.initializeApp();

    User user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      // Navigator.of(context).pushReplacement(
      //   MaterialPageRoute(
      //     builder: (context) => UserInfoScreen(
      //       user: user,
      //     ),
      //   ),
      // );
    }

    return firebaseApp;
  }

  static Future<User> signInWithGoogle({BuildContext context}) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User user;

    if (kIsWeb) {
      GoogleAuthProvider authProvider = GoogleAuthProvider();

      try {
        final UserCredential userCredential =
            await auth.signInWithPopup(authProvider);

        user = userCredential.user;
      } catch (e) {
        print(e);
      }
    } else {
      final GoogleSignIn googleSignIn = GoogleSignIn();

      final GoogleSignInAccount googleSignInAccount =
          await googleSignIn.signIn();

      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;

        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );

        try {
          final UserCredential userCredential =
              await auth.signInWithCredential(credential);

          user = userCredential.user;
        } on FirebaseAuthException catch (e) {
          if (e.code == 'account-exists-with-different-credential') {
            ScaffoldMessenger.of(context).showSnackBar(
              Authentication.customSnackBar(
                content:
                    'The account already exists with a different credential',
              ),
            );
          } else if (e.code == 'invalid-credential') {
            ScaffoldMessenger.of(context).showSnackBar(
              Authentication.customSnackBar(
                content:
                    'Error occurred while accessing credentials. Try again.',
              ),
            );
          }
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            Authentication.customSnackBar(
              content: 'Error occurred using Google Sign In. Try again.',
            ),
          );
        }
      }
    }

    return user;
  }


  static Future<void> signOut({BuildContext context,String signInFlag}) async {
    if(signInFlag=='0'){
      final GoogleSignIn googleSignIn = GoogleSignIn();

      try {
        if (!kIsWeb) {
          await googleSignIn.signOut();
        }
        await FirebaseAuth.instance.signOut();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          Authentication.customSnackBar(
            content: 'Error signing out. Try again.',
          ),
        );
      }
    }else {
      final FacebookLogin facebookLogin = FacebookLogin();
      try {
        await facebookLogin.logOut();
        await FirebaseAuth.instance.signOut();
      }catch(e){
        ScaffoldMessenger.of(context).showSnackBar(
          Authentication.customSnackBar(
            content: 'Error signing out. Try again.',
          ),
        );
      }

    }

  }

  //for B
  static Future<User> signInWithFb({BuildContext context,FacebookLogin fblogin}) async{
    FirebaseAuth auth = FirebaseAuth.instance;
    final FacebookLoginResult facebookLoginResult=await fblogin.logIn(['email', 'public_profile','user_friends']);
    if (facebookLoginResult.status == FacebookLoginStatus.loggedIn) {
      FacebookAccessToken result =
          facebookLoginResult.accessToken;

      String accessToken=result.token.toString();

      // Firebase Base Login
      if (result != null) {
        final AuthCredential credential =
        // FacebookAuthProvider.getCredential(accessToken: result);
        FacebookAuthProvider.credential(accessToken);

        try {
          final User user = (await auth.signInWithCredential(credential)).user;
          print('signed in' + user.displayName.toString());
          // await fblogin.logOut();
          // await _firebaseAuth.signOut();
          // return FacebookLoginUserHolder(user, profile);
          return user;
        } on PlatformException catch (e) {
          print(e);


          return null;
        }
      } else {
        return null;
      }
    }

  }
}
