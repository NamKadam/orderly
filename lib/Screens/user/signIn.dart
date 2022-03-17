import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:orderly/Api/api.dart';
import 'package:orderly/Blocs/login/bloc.dart';
import 'package:orderly/Blocs/user_reg/userReg_bloc.dart';
import 'package:orderly/Blocs/user_reg/userReg_event.dart';
import 'package:orderly/Blocs/user_reg/userReg_state.dart';
import 'package:orderly/Configs/image.dart';
import 'package:orderly/Configs/theme.dart';
import 'package:orderly/Models/signup_navigateFields.dart';
import 'package:orderly/Screens/mainNavigation.dart';
import 'package:orderly/Screens/user/signup.dart';
import 'package:orderly/Screens/user/verify_phone.dart';
import 'package:orderly/Utils/Utils.dart';
import 'package:orderly/Utils/application.dart';
import 'package:orderly/Utils/fcmNotify.dart';
import 'package:orderly/Utils/preferences.dart';
import 'package:orderly/Utils/progressDialog.dart';
import 'package:orderly/Utils/util_preferences.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:orderly/Utils/authentication.dart';
import 'package:orderly/Utils/routes.dart';
import 'package:orderly/Utils/translate.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:device_info/device_info.dart';
import 'package:get_version/get_version.dart';
import 'package:geolocator/geolocator.dart';

import 'package:http/http.dart' as http;



class SignIn extends StatefulWidget{
  final String from,flagRoleType;
  SignIn({Key key, this.from,this.flagRoleType}) : super(key: key);
  SignInState createState()=>SignInState();
}

class SignInState extends State<SignIn>{


  // User? user;
  // final FirebaseAuth _auth = FirebaseAuth.instance;
  // final GoogleSignIn _googleSignIn = GoogleSignIn();

  var firebaseUser_id,versionCode,deviceName;//updated on 10/08/2021 for firebase id i.e uuid
  var lat,lng;
  LoginBloc _userLoginBloc;
  var socialType;
  User user;
  SignUpDataNavigation signUpDataNavigation;


  //to get Version and device name as per platform
  void  getVersionAsPerPlatform() async{
    if (Platform.isAndroid) {
      try {
        versionCode = await GetVersion.projectCode;
        deviceName='android';
        print("versionName:-"+await GetVersion.projectVersion);

        print("versionCode:-"+versionCode+" deviceName:-"+deviceName);

      } on PlatformException {
        print('Failed to get build number.');
      }
    } else if (Platform.isIOS) {
// Platform messages may fail, so we use a try/catch PlatformException.
      try {

        versionCode = await GetVersion.projectVersion;
        deviceName='ios';
        print("versionCode:-"+deviceName+" deviceName:-"+deviceName);

      } on PlatformException {
        print('Failed to get app ID.');
      }
    }
    signUpDataNavigation.versionCode=versionCode;
    signUpDataNavigation.deviceName=deviceName;
    await _getCurrentLocation();

  }

  //to get current latLng
  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        return Future.error(
            'Location permissions are denied (actual value: $permission).');
      }
    }

    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best).
    then((Position position) async {
      // setState(() async {
      // _currentPosition = position;
      lat=position.latitude.toString();
      lng=position.longitude.toString();
      signUpDataNavigation.long=lng;
      signUpDataNavigation.lat=lat;
      // UtilPreferences.setString("latitude", lat);
      // UtilPreferences.setString("longitude", lng);
      print("lat:-"+lat+" lng:-"+lng);

      // });
    }).catchError((dynamic e) {
      print(e);
    });;
    // print(_currentPosition);

  }

  // void _getCurrentLocation() {
  //   Geolocator
  //       .getCurrentPosition(desiredAccuracy: LocationAccuracy.best, forceAndroidLocationManager: true)
  //       .then((Position position) {
  //     // setState(() {
  //     //   _currentPosition = position;
  //     // });
  //     lat=position.latitude.toString();
  //     lng=position.longitude.toString();
  //     print("lat:-"+lat+" lng:-"+lng);
  //   }).catchError((e) {
  //     print(e);
  //   });
  // }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  //to get and save device token
    _userLoginBloc = BlocProvider.of<LoginBloc>(context);
    signUpDataNavigation=SignUpDataNavigation();
    signUpDataNavigation.userType=widget.flagRoleType.toString();

    saveDeviceTokenAndId();
    getVersionAsPerPlatform();
  }

  //save device token
  void saveDeviceTokenAndId() async {
    //for Fcm
    final FirebaseMessaging _fcm = FirebaseMessaging.instance;

    var fcmToken = await _fcm.getToken();
    UtilPreferences.setString(Preferences.fcmToken, fcmToken.toString());
    var token=UtilPreferences.getString(Preferences.fcmToken);
    signUpDataNavigation.fcmId=fcmToken.toString();
    print('tokenFCM:-'+fcmToken.toString());

    //for device Id
    var deviceInfo = DeviceInfoPlugin();
    if (Platform.isAndroid) { // import 'dart:io'
      var androidDeviceId = await deviceInfo.androidInfo;
      print("androiId:-"+androidDeviceId.androidId);

      UtilPreferences.setString(Preferences.deviceId, androidDeviceId.androidId);
      signUpDataNavigation.deviceId=androidDeviceId.androidId.toString();

    } else {
      var iosDeviceId = await deviceInfo.iosInfo;
      print("iosId:-"+ iosDeviceId.identifierForVendor);
      UtilPreferences.setString(Preferences.deviceId, iosDeviceId.identifierForVendor);
      signUpDataNavigation.deviceId=iosDeviceId.identifierForVendor.toString();


    }
  }


  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            'Create Account',
            style: TextStyle(fontSize: 16.0),
          ),),
        body: Container(

          padding: EdgeInsets.only(left: 20, right: 20),
          //updated on 14/06/2021 for background image of sign in
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(Images.bg),
              fit: BoxFit.cover,
            ),
          ),

          child:
          // SingleChildScrollView(
          //   child:
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                // const SizedBox(height: 05.0),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    //for logo
                    SizedBox(height: 20.0,),
                Image.asset(Images.logo,height: 200.0,width:200.0),

                    Text(Translate.of(context).translate('create_account'),style: TextStyle(
                      fontFamily: 'Poppins',fontWeight: FontWeight.w400,color: AppTheme.textColor,
                      fontSize: 14.0
                    )),
                   //facebook
                    LoginWithFB(uuid:firebaseUser_id),
                    //google
                    LoginWithGoogle(uuid:firebaseUser_id,userLoginBloc:_userLoginBloc,
                        user:user,
                        navigateData:signUpDataNavigation),
                    SizedBox(height: 20.0,),
                    //divider
                    Container(
                      width: 260.0,
                        child:_DividerORWidget()),
                    //phone number
                    Padding(padding: EdgeInsets.only(top:15.0,left: 20.0,right: 10.0),
                        child:Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              width:260, //MediaQuery.of(context).size.width,
                              height: 45,
                              decoration: ShapeDecoration(
                                // shape: const BeveledRectangleBorder(
                                //updated on 26/10/2020
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(50.0)),
                                ),
                                color: Theme.of(context).primaryColor,

                              ),

                              child:InkWell(
                                onTap: (){
                                // Navigator.pushNamed(context, Routes.verifyPhone,arguments: widget.flagRoleType,);
                                  signUpDataNavigation.signup_type="phone";
                                  signUpDataNavigation.userType=widget.flagRoleType.toString();
                                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) =>
                                    VerifyPhone(flagRoleType:widget.flagRoleType.toString(),signUpDataNavigation:signUpDataNavigation)));

                                },
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    SizedBox(width:2.0),
                                    Image.asset(Images.phone,height: 45.0,width:40.0),

                                    const SizedBox(
                                      width: 14.0,
                                    ),
                                    Text(
                                      Translate.of(context).translate('login_phone'),
                                      style: TextStyle(fontFamily: 'Poppins-Regular',fontSize: 14.0,color: Colors.white),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                          ],
                        )),
                    SizedBox(height: 20.0,),

                    //terms
                    Text(
                      Translate.of(context).translate('terms'),

                      style:TextStyle(fontFamily: 'Poppins',fontWeight:FontWeight.w400,fontSize: 11.0,color: AppTheme.textColor),
                    ),
                    Text(
                      "Terms of Use and have read and ",
                      style:TextStyle(fontFamily: 'Poppins',fontWeight:FontWeight.w400,fontSize: 11.0,color: AppTheme.textColor),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "understood our",
                          style:TextStyle(fontFamily: 'Poppins',fontWeight:FontWeight.w400,fontSize: 11.0,color: AppTheme.textColor),
                        ),
                        InkWell(
                          onTap: (){
                            Navigator.pushNamed(context, Routes.privacy);
                          },
                            child:Text(
                          " Privacy Policy",
                          style:TextStyle(fontFamily: 'Poppins',fontSize: 12.0,fontWeight:FontWeight.w600,color: Theme.of(context).primaryColor),
                        )),
                      ],
                    )


                  ],
                ),




              ],
            ),
          // ),
        ));
  }
}
class _DividerORWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Widget _dividerWidget = Expanded(
      child: Divider(
        height: 0.5,
        color: AppTheme.textColor,
      ),
    );

    const Widget _spacingWidget = SizedBox(
      width: 8.0,
    );

    final Widget _textWidget = Text(
      'OR',
      style: Theme.of(context).textTheme.subtitle1.copyWith(
        color: AppTheme.textColor,
      ),
    );
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        _dividerWidget,
        _spacingWidget,
        _textWidget,
        _spacingWidget,
        _dividerWidget,
      ],
    );
  }
}

class LoginWithGoogle extends StatefulWidget {
  var uuid;
  LoginBloc userLoginBloc;
  User user;
  SignUpDataNavigation navigateData;
  LoginWithGoogle({this.uuid,this.userLoginBloc,this.user,this.navigateData});

  _LoginWithGoogleState createState()=>_LoginWithGoogleState();
}
class _LoginWithGoogleState extends State<LoginWithGoogle>{
  bool _isSigningIn = false;
  bool google =false;

  ///On show message fail
  Future<void> _showMessage(String message) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'sign_in',
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  message,
                  style: Theme.of(context).textTheme.bodyText1,
                ),
              ],
            ),
          ),
          actions: <Widget>[
            ElevatedButton(
              child: Text(
                'close',
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> checkUser(User user) async{

    widget.userLoginBloc.add(OnLogin(
        fbId: user.uid,
        fcmId: widget.navigateData.fcmId,
      deviceId:widget.navigateData.deviceId
      )
    );

  }





  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    widget.navigateData.signup_type='gmail';
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Padding(padding: EdgeInsets.only(top:10.0,left: 20.0,right: 10.0),
        child:
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            //api to check to registered or not

            BlocBuilder<LoginBloc,LoginState>(builder: (context,register){
              return BlocListener<LoginBloc,LoginState>(listener: (context,state){
                if (state is LoginFail) {
                  _showMessage(
                    Translate.of(context).translate(state.msg),
                  );
                }
                if (state is LoginSuccess) {
                  if(state.userModel.isRegistered=='false'){
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) =>
                        SignUp(user:widget.user,signUpDataNavigation:widget.navigateData)));

                  }else{
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MainNavigation(userType: "0",)));

                  }
                }


              }, child: Container(
                width:260, //MediaQuery.of(context).size.width,
                height: 45,
                decoration: ShapeDecoration(
                  // shape: const BeveledRectangleBorder(
                  //updated on 26/10/2020
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(50.0)),
                  ),
                  color: AppTheme.googleColor,

                ),

                child:

                InkWell(
                  onTap: () async{

                    setState(() {
                      _isSigningIn = true;
                    });
                    widget.user = await Authentication.signInWithGoogle(context: context);
                    setState(() {
                      _isSigningIn = false;
                      widget.uuid=widget.user.uid.toString();

                    });
                    await PsProgressDialog.showProgressWithoutMsg(context);

                    print("fb_id:-"+widget.uuid);
                    if (widget.user != null) {
                      checkUser(widget.user);

                    }

                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(width:2.0),
                      Image.asset(Images.google,height: 45.0,width:40.0),
                      const SizedBox(
                        width: 14.0,
                      ),
                      Text(
                        Translate.of(context).translate('cont_google'),
                        style: TextStyle(fontFamily: 'Poppins-Regular',fontSize: 14.0,color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
              );
            })



          ],
        ));
  }

}

//facebook
class LoginWithFB extends StatefulWidget{
  var uuid;
   LoginWithFB({this.uuid});

  _LoginWithFBState createState()=>_LoginWithFBState();
}

class _LoginWithFBState extends State<LoginWithFB>{

  final FacebookLogin facebookSignIn = new FacebookLogin();
  bool isFbLogin=false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Padding(padding: EdgeInsets.only(top:20.0,left: 20.0,right: 10.0),
        child:
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // BlocBuilder<LoginBloc,LoginState>(builder: (context,login){
            //   return BlocListener<LoginBloc,LoginState>(listener: (context,state){
            //     if (state is LoginFail) {
            //       // _showMessage(
            //       //   // Translate.of(context).translate(state.code), //commented on 9/12/2020
            //       //   Translate.of(context)!.translate(state.code),//added on 9/12/2020
            //       // );
            //     }
            //     if (state is LoginSuccess) {
            //       Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MainNavigation()));
            //     }
            //   },
            //     child: Container(
            //       width:260, //MediaQuery.of(context).size.width,
            //       height: 45,
            //       decoration: ShapeDecoration(
            //         // shape: const BeveledRectangleBorder(
            //         //updated on 26/10/2020
            //         shape: const RoundedRectangleBorder(
            //           borderRadius: BorderRadius.all(Radius.circular(50.0)),
            //         ),
            //         color: AppTheme.facebookColor,
            //
            //       ),
            //
            //       child:
            //       InkWell(
            //         onTap: () async {
            //           User? user = await Authentication.signInWithFb(context: context,fblogin: facebookSignIn);
            //           setState(() {
            //             isFbLogin = false;
            //           });
            //
            //           if (user != null) {
            //             // Navigator.of(context).pushReplacement(
            //             //   MaterialPageRoute(
            //             //     builder: (context) => SignUp(
            //             //       user: user,
            //             //     ),
            //             //   ),
            //             // );
            //             await PsProgressDialog.showProgressWithoutMsg(context);
            //             Navigator.of(context).pushReplacement(
            //               MaterialPageRoute(
            //                   builder: (context) => SignUp()
            //               ),
            //             );
            //             // print(user);
            //           }
            //
            //         },
            //         child: Row(
            //           mainAxisSize: MainAxisSize.max,
            //           mainAxisAlignment: MainAxisAlignment.start,
            //           children: <Widget>[
            //             Image.asset(Images.fb,height: 45.0,width:40.0),
            //
            //             const SizedBox(
            //               width: 14.0,
            //             ),
            //             Text(
            //               Translate.of(context)!.translate('cont_facebook'),
            //               style:TextStyle(fontFamily: 'Poppins-Regular',fontSize: 14.0,color: Colors.white),
            //             ),
            //           ],
            //         ),
            //       ),
            //     ),
            //
            //   );
            // }),

            Container(
              width:260, //MediaQuery.of(context).size.width,
              height: 45,
              decoration: ShapeDecoration(
                // shape: const BeveledRectangleBorder(
                //updated on 26/10/2020
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(50.0)),
                ),
                color: AppTheme.facebookColor,

              ),

              child:
              InkWell(
                onTap: () async {
                  // User user = await Authentication.signInWithFb(context: context,fblogin: facebookSignIn);
                  // setState(() {
                  //   isFbLogin = false;
                  //   widget.uuid=user.uid.toString();
                  // });
                  //
                  // if (user != null) {
                  //
                  //   // Navigator.of(context).pushReplacement(
                  //   //   MaterialPageRoute(
                  //   //     builder: (context) => SignUp(
                  //   //       user: user,
                  //   //     ),
                  //   //   ),
                  //   // );
                  //   // await PsProgressDialog.showProgressWithoutMsg(context);
                  //   // Navigator.of(context).pushReplacement(
                  //   //   MaterialPageRoute(
                  //   //       builder: (context) => SignUp()
                  //   //   ),
                  //   // );
                  //   // print(user);
                  // }
                  Fluttertoast.showToast(msg: "Funcionality Under development");

                },
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(width:2.0),
                    Image.asset(Images.fb,height: 45.0,width:40.0),

                    const SizedBox(
                      width: 14.0,
                    ),
                    Text(
                      Translate.of(context).translate('cont_facebook'),
                      style:TextStyle(fontFamily: 'Poppins-Regular',fontSize: 14.0,color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),

          ],
        )
    );
  }



}


