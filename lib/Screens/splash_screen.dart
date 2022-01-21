import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_version/get_version.dart';
import 'package:orderly/Blocs/authentication/authentication_bloc.dart';
import 'package:orderly/Blocs/authentication/authentication_state.dart';
import 'package:orderly/Blocs/authentication/bloc.dart';
import 'package:orderly/Configs/image.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:orderly/Configs/theme.dart';
import 'package:orderly/Utils/application.dart';
import 'package:orderly/Utils/preferences.dart';
import 'package:orderly/Utils/util_preferences.dart';
import 'package:shared_preferences/shared_preferences.dart';



class SplashScreen extends StatefulWidget {
  SplashScreen({Key key}) : super(key: key);

  @override
  _SplashScreenState createState() {
    return _SplashScreenState();
  }
}

class _SplashScreenState extends State<SplashScreen> {
   AuthBloc authBloc;
   final int splashDuration = 5;

  String versionName="";


   @override
  void initState() {
    // authBloc = BlocProvider.of<AuthBloc>(context);
    // authBloc!.add(OnAuthCheck());
     startTime();
     super.initState();
  }



   startTime() async {
     //to resolve issue of:-flutter-unhandled-exception-missingpluginexceptionno-implementation-found-for add below:-
     // SharedPreferences.setMockInitialValues({});
     // // UtilPreferences.callPreferences();
     // // set up SharedPrefernces
     // Application.preferences = await SharedPreferences.getInstance();
     // var user=UtilPreferences.getString(Preferences.user);
     // print("user"+user.toString());

     return Timer(
         await Duration(seconds: splashDuration),
             () {
           SystemChannels.textInput.invokeMethod('TextInput.hide');
           authBloc = BlocProvider.of<AuthBloc>(context);
           authBloc.add(OnAuthCheck());
           // preferences.clear();

         }
     );
   }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
        Container(
        decoration: BoxDecoration(
        image: DecorationImage(
        image: AssetImage(Images.bg),
    fit: BoxFit.cover,
    ),
    ),
      child:Stack(

        alignment: Alignment.center,
        children: <Widget>[
          Center(

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                // Icon(Icons.ac_unit,size: 40.0,)
                Image.asset(Images.logo, width: 300, height: 300),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 10),
            child: SizedBox(
              width: 10,
              height: 10,
              child: CircularProgressIndicator(strokeWidth: 1),
            ),
          ),
          Positioned(
            bottom: 15.0,
              child:Platform.isAndroid
              ?
              Text("version "+Application.version,style: TextStyle(
                fontSize: 16.0,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w500,
                color: AppTheme.textColor
              ),)
              :
              Text("version "+Application.Iosversion,style: TextStyle(
                  fontSize: 16.0,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w500,
                  color: AppTheme.textColor
              ),)
          )
        ],
      )),
    );
  }
}
