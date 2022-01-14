import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:orderly/Blocs/login/bloc.dart';
import 'package:orderly/Configs/image.dart';
import 'package:orderly/Configs/theme.dart';
import 'package:orderly/Models/otpVerifyData.dart';
import 'package:orderly/Models/signup_navigateFields.dart';
import 'package:orderly/Screens/mainNavigation.dart';
import 'package:orderly/Screens/user/signup.dart';
import 'package:orderly/Utils/Utils.dart';
import 'package:orderly/Utils/routes.dart';
import 'package:orderly/Utils/translate.dart';
import 'package:orderly/Utils/util_preferences.dart';
import 'package:orderly/Widgets/app_button.dart';

class OtpScreen extends StatefulWidget{
  final OTPVerify otpVerify;
  SignUpDataNavigation navigateData;
  OtpScreen({Key key, this.otpVerify,this.navigateData}) : super(key: key);

   _OtpScreenState createState()=>_OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen>{
  AnimationController _controller;

  // Variables
  Size _screenSize;
   var _firstDigit;
   var _secondDigit;
   var _thirdDigit;
   var _fourthDigit;
   var _fifthDigit;
   var _sixthDigit;

  int _currentDigit;
  String authStatus="",deviceId="",token="";
  var verificationId,otp;
  AuthCredential authservice;
  LoginBloc _loginBloc;

  var scaffoldKey = new GlobalKey<ScaffoldState>();
  var number,firebaseUser_Id;
  UserCredential authResult;

  @override
  void initState() {
    _loginBloc = BlocProvider.of<LoginBloc>(context);
    getData();
    number=widget.otpVerify.countrycode+widget.otpVerify.phone;
    verifyPhoneNumber(context,number);
  }

  getData() async{
    deviceId=await UtilPreferences.saveDeviceId();
    print("deviceId:-"+deviceId);
    token=await UtilPreferences.getTokenId();
    print("token:-"+token);

  }

  Future<void> verifyPhoneNumber(BuildContext context,String number) async {
    try {
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: number,
        timeout: const Duration(seconds: 15),
        verificationCompleted: (AuthCredential authCredential) {
          //  signIn(authCredential);
          print('verfication completed called sent called');
          //commented on 14/062021
          // setState(() {
          //   authStatus = "sucess";
          // });
          // if (authStatus != "") {
          //   scaffoldKey?.currentState?.showSnackBar(SnackBar(
          //     content: Text(authStatus),
          //   ));
          // }
        },
        verificationFailed: (FirebaseAuthException authException) {
          print(authException.message + "Inside auth failed");
          setState(() {
            // authStatus = "Authentication failed";
            authStatus = authException.message;
          });
          // loader.remove();
          // Helper.hideLoader(loader);
          if (authStatus != "") {
            scaffoldKey.currentState.showSnackBar(SnackBar(
              content: Text(authStatus),
            ));
          }
        },
        codeSent: (String verId, [int forceCodeResent]) {
          // loader.remove();
          // Helper.hideLoader(loader);
          // this.verificationId = verId;
          setState(() {
            authStatus = "OTP has been successfully sent";
            // user.deviceToken = verId;
            verificationId = verId;
            //  users.deviceToken = verId;
          });
          if (authStatus != "") {
            scaffoldKey.currentState.showSnackBar(SnackBar(
              content: Text(authStatus),
            ));
          }
        },
        codeAutoRetrievalTimeout: (String verId) {
          // user.deviceToken = verId;
          //    print('coderetreival sent called' + verificationId);
          setState(() {
            authStatus = "TIMEOUT";
          });
        },
      );
    }catch(e){
      print(e);
    }

  }

  //check otp
  Future<dynamic> checkotp(dynamic phone) async {
    if (verificationId != null && otp != null) {
      try {
        // authservice =await FirebaseAuth.instance(
        //     PhoneAuthProvider.credential(
        //   verificationId: verificationId,
        //   smsCode: otp,
        // ));
        authservice =
            PhoneAuthProvider.credential(
              verificationId: verificationId,
              smsCode: otp,
            );
      } catch (e) {
        print(e);
      }

      // if (authservice!= null) {
      //
      //   // if(widget.otpVerify.flagForLogin=="0"){ //for user Login
      //   //   _loginBloc.add(OnLogin(
      //   //     mobile: phone,
      //   //     otp: "success",
      //   //   ));
      //   // }else if(widget.otpVerify.flagForLogin=="1"){ //for vendor Login
      //   //   _loginVendorBloc.add(OnVendorLogin(
      //   //     mobile: phone,
      //   //     otp: "success",
      //   //   ));
      //   // }
      //
      //   Navigator.pushNamed(context, Routes.signUp);
      //
      // }else{
      //   scaffoldKey.currentState!.showSnackBar(SnackBar(
      //     content: Text("Please enter valid sms code"),
      //   ));
      // }
      //signin with phone number recaptcha

      // ConfirmationResult confirmationResult = await FirebaseAuth.instance.signInWithPhoneNumber(number, RecaptchaVerifier(
      //   container: 'recaptcha',
      //   onSuccess: () {
      //     print('reCAPTCHA Completed!');
      //     },
      //   onExpired: () => print('reCAPTCHA Expired!'),
      //
      //   size: RecaptchaVerifierSize.compact,
      //   theme: RecaptchaVerifierTheme.dark,
      // ));
      // UserCredential userCredential = await confirmationResult.confirm(otp);
      // if (userCredential != null) {
      //   Navigator.pushNamed(context, Routes.signUp);
      // } else {
      //   scaffoldKey.currentState!.showSnackBar(SnackBar(
      //     content: Text("Please enter valid sms code"),
      //   ));
      // }

      // call signin method
      signIn(authservice,phone);
    }


  }
  //updated to check valid sms code
  //SignIn
  signIn(AuthCredential credential, phone) async {
    authResult = await FirebaseAuth.instance
        .signInWithCredential(credential)
        .catchError((onError) {
      print('SignIn Error: ${onError.toString()}\n\n');
    });

    if (authResult != null) {
      firebaseUser_Id=authResult.user.uid.toString();

      print("fb_id"+firebaseUser_Id);

      if(widget.otpVerify.flagRoleType=="0"){ //for customer
        // Navigator.pushNamed(context, Routes.signUp);
        _loginBloc.add(OnLogin(
          fbId: firebaseUser_Id.toString(),
        ));

      }else{//for fleet manager
        _loginBloc.add(OnFleetLogin(
          fbId: firebaseUser_Id.toString(),
          mobile: phone,
          fcmId: token,
          deviceId: deviceId
        ));

      }
    } else {
      scaffoldKey.currentState.showSnackBar(SnackBar(
            content: Text("Please enter valid sms code"),
          ));
    }
  }
  // Return "OTP" input field
  get _getInputField {
    return Row(
      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        _otpTextField(_firstDigit),
        _otpTextField(_secondDigit),
        _otpTextField(_thirdDigit),
        _otpTextField(_fourthDigit),
        _otpTextField(_fifthDigit),
        _otpTextField(_sixthDigit),
      ],
    );
  }

  ///On show message fail
  Future<void> _showMessage(String message) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            "OTP Verification",
            style:TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w400,
              color: AppTheme.textColor
            )
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
            FlatButton(
              child: Text(
                Translate.of(context).translate('close'),
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

  // Returns "Otp custom text field"
  Widget _otpTextField(var digit) {
    return
      Expanded(
        child:
        Container(
            width: MediaQuery.of(context).size.width,
            height: 40.0,
            margin: EdgeInsets.all(15.0),
            alignment: Alignment.center,
            child: Text(
              digit != null ? digit.toString() : "",
              style: TextStyle(
                  fontSize: 18.0,
                  color: AppTheme.textColor,
                  fontFamily: 'Poppins',
                fontWeight: FontWeight.w600
              ),
            ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            border: Border.all(
              color: digit==null?
              Color(0xFFFFD8BC)
              :
              Theme.of(context).primaryColor,  // red as border color
            ),
            color:digit==null?
            Color(0xFFFFD8BC)
                :
            Colors.white,

          ),
            ),
      );
  }

   // Returns "Otp" keyboard
   get _getOtpKeyboard {
     return Container(
       margin: EdgeInsets.only(top:5.0),
         height: MediaQuery.of(context).size.width-100,
         child: Column(
           children: <Widget>[
             Expanded(
               child: Row(
                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                 children: <Widget>[
                   _otpKeyboardInputButton(
                       label: "1",
                       onPressed: () {
                         _setCurrentDigit(1);
                       }),
                   _otpKeyboardInputButton(
                       label: "2",
                       onPressed: () {
                         _setCurrentDigit(2);
                       }),
                   _otpKeyboardInputButton(
                       label: "3",
                       onPressed: () {
                         _setCurrentDigit(3);
                       }),
                 ],
               ),
             ),
             Expanded(
               child: Row(
                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                 children: <Widget>[
                   _otpKeyboardInputButton(
                       label: "4",
                       onPressed: () {
                         _setCurrentDigit(4);
                       }),
                   _otpKeyboardInputButton(
                       label: "5",
                       onPressed: () {
                         _setCurrentDigit(5);
                       }),
                   _otpKeyboardInputButton(
                       label: "6",
                       onPressed: () {
                         _setCurrentDigit(6);
                       }),
                 ],
               ),
             ),
             Expanded(
               child: Row(
                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                 children: <Widget>[
                   _otpKeyboardInputButton(
                       label: "7",
                       onPressed: () {
                         _setCurrentDigit(7);
                       }),
                   _otpKeyboardInputButton(
                       label: "8",
                       onPressed: () {
                         _setCurrentDigit(8);
                       }),
                   _otpKeyboardInputButton(
                       label: "9",
                       onPressed: () {
                         _setCurrentDigit(9);
                       }),
                 ],
               ),
             ),
             Expanded(
               child: Row(
                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                 children: <Widget>[

                   Visibility(
                     maintainSize: true,
                     maintainAnimation: true,
                     maintainState: true,
                     visible: _sixthDigit != null,
                     child: _otpKeyboardActionButton(
                         label: Icon(
                           Icons.check_circle,
                           color: Colors.black,
                         ),
                         onPressed: () {
                           // you can dall OTP verification API.
                         }),
                   ),

                   _otpKeyboardInputButton(
                       label: "0",
                       onPressed: () {
                         _setCurrentDigit(0);
                       }),
                   _otpKeyboardActionButton(
                       label: Icon(
                         Icons.backspace,
                         color: Colors.black,
                       ),
                       onPressed: () {
                         setState(() {
                           if (_sixthDigit != null) {
                             _sixthDigit = null;
                           } else if (_fifthDigit != null) {
                             _fifthDigit = null;
                           }else if (_fourthDigit != null) {
                             _fourthDigit = null;
                           } else if (_thirdDigit != null) {
                             _thirdDigit = null;
                           } else if (_secondDigit != null) {
                             _secondDigit = null;
                           } else if (_firstDigit != null) {
                             _firstDigit = null;
                           }
                         });
                       }),
                 ],
               ),
             ),
           ],
         ));
   }

  // Returns "Otp keyboard input Button"
  Widget _otpKeyboardInputButton({String label, VoidCallback onPressed}) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: new BorderRadius.circular(40.0),
        child: Container(
          height: 80.0,
          width: 80.0,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 30.0,
                color: Colors.black,
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Returns "Otp keyboard action Button"
  _otpKeyboardActionButton({Widget label, VoidCallback onPressed}) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(40.0),
      child: Container(
        height: 80.0,
        width: 80.0,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
        ),
        child: Center(
          child: label,
        ),
      ),
    );
  }

  // Current digit
  void _setCurrentDigit(int i) {
    setState(() {
      _currentDigit = i;
      if (_firstDigit == null) {
        _firstDigit = _currentDigit;
      } else if (_secondDigit == null) {
        _secondDigit = _currentDigit;
      } else if (_thirdDigit == null) {
        _thirdDigit = _currentDigit;
      } else if (_fourthDigit == null) {
        _fourthDigit = _currentDigit;
      }
      else if (_fifthDigit == null) {
        _fifthDigit = _currentDigit;
      }
      else if (_sixthDigit == null) {
        _sixthDigit = _currentDigit;

        otp = _firstDigit.toString() +
            _secondDigit.toString() +
            _thirdDigit.toString() +
            _fourthDigit.toString()+
            _fifthDigit.toString()+
            _sixthDigit.toString();

        // Verify your otp by here. API call
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      key: scaffoldKey,

      appBar: AppBar(
        centerTitle: true,

              title:Text('OTP Verification',style: TextStyle(
              fontFamily: 'Poppins',fontWeight: FontWeight.w600
            ),)
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(Images.bg),
            fit: BoxFit.cover,
          ),
        ),
        child: SingleChildScrollView(
          child:
        Column(
          mainAxisSize: MainAxisSize.max,
          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 10.0,),
            Image.asset(Images.logo,height: 180.0,width:180.0),

            Text(Translate.of(context).translate('otp_verification'),style: TextStyle(color:AppTheme.textColor,
                    fontFamily: 'Poppins',fontWeight:FontWeight.w400,fontSize: 14.0),),
                Text(widget.otpVerify.countrycode+" "+widget.otpVerify.phone,style: TextStyle(color:AppTheme.textColor,
                    fontFamily: 'Poppins',fontWeight:FontWeight.w400,fontSize: 14.0),),
              SizedBox(height: 15.0,),
            _getInputField,
             
            //for login api call
            BlocBuilder<LoginBloc,LoginState>(builder: (context,login){
              return BlocListener<LoginBloc,LoginState>(listener: (context,state){
                if (state is LoginFail) {
                  _showMessage(
                    // Translate.of(context).translate(state.code), //commented on 9/12/2020
                    Translate.of(context).translate(state.msg),//added on 9/12/2020
                  );
                }
                if (state is LoginSuccess) {
                print("isRegistered:-"+state.userModel.isRegistered);
                  if(state.userModel.isRegistered=="false"){
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) =>
                  SignUp(user:authResult.user,signUpDataNavigation:widget.navigateData,phone: widget.otpVerify.phone.toString(),)));
                  }
                  else {
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) =>
                        MainNavigation(userType: widget.otpVerify.flagRoleType)));
                  }
                }
              },
                child:Padding(padding: EdgeInsets.all(20.0),
                    child:
                    AppButton(
                      onPressed: (){
                        if(_firstDigit!=null && _secondDigit!=null && _thirdDigit!=null &&
                            _fourthDigit!=null && _fifthDigit!=null && _sixthDigit!=null){
                          checkotp(widget.otpVerify.phone);
                        }else{
                          _showMessage("Please enter Otp");
                        }
                      },
                      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(50))),
                      text: 'Verify',
                      loading: login is LoginLoading,
                      disableTouchWhenLoading: true,
                    )
                ),
              );
            }),
            // Padding(padding: EdgeInsets.all(20.0),
            //     child:
            //     AppButton(
            //       onPressed: (){
            //         if(_firstDigit!=null && _secondDigit!=null && _thirdDigit!=null &&
            //             _fourthDigit!=null && _fifthDigit!=null && _sixthDigit!=null){
            //           checkotp(widget.otpVerify!.phone);
            //         }else{
            //           _showMessage("Please enter Otp");
            //         }
            //         },
            //       shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(50))),
            //       text: 'Verify',
            //       // loading: login is LoginLoading,
            //       // disableTouchWhenLoading: true,
            //     )
            // ),

            _getOtpKeyboard

          ],
        ),
      )),
    );

  }

}