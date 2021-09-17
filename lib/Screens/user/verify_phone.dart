import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:orderly/Configs/image.dart';
import 'package:orderly/Configs/theme.dart';
import 'package:orderly/Models/otpVerifyData.dart';
import 'package:orderly/Models/signup_navigateFields.dart';
import 'OtpScreen.dart';
import 'package:orderly/Utils/routes.dart';
import 'package:orderly/Utils/translate.dart';
import 'package:country_list_pick/country_list_pick.dart';
import 'package:orderly/Widgets/app_button.dart';

class VerifyPhone extends StatefulWidget{
  final String flagRoleType;
  SignUpDataNavigation signUpDataNavigation;
  VerifyPhone({Key key, this.flagRoleType,this.signUpDataNavigation}) : super(key: key);

  _VerifyPhoneState createState()=>_VerifyPhoneState();
}

class _VerifyPhoneState extends State<VerifyPhone>{
  final TextEditingController _mobilecontroller = TextEditingController();
  OTPVerify otpVerify=new OTPVerify();
  var countrycode;


  Future<void> _showMessage(String message) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            Translate.of(context).translate('verify_number'),
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


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      // appBar: AppBar(),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(Images.bg),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(Images.logo,height: 180.0,width:180.0),
            Text(
              Translate.of(context).translate('input_mobile'),
              style: TextStyle(fontFamily: 'Poppins',fontWeight:FontWeight.normal,fontSize: 14.0,color: AppTheme.textColor),
            ),
            // Row(
            //   children: [
                CountryListPick(
                  // appBar: AppBar(
                  //   backgroundColor: Colors.amber,
                  //   title: Text('Pick your country'),
                  // ),
                  // if you need custome picker use this
                  pickerBuilder: (context, CountryCode countryCode) {
                    countrycode=countryCode.dialCode.toString();
                    return
                      Row(
                        children: [
                          Container(
                              margin: EdgeInsets.only(left: 25.0),
                            child:
                          Container(
                              padding: EdgeInsets.all(8.0),
                              height: 45.0,
                              decoration: const BoxDecoration(
                                color: Color(0xFFF58634),
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(5.0),
                                  bottomLeft: Radius.circular(5.0),
                                ),
                              ),

                              child:
                              Align(
                                  alignment: Alignment.center,
                                  child:Text(countryCode.dialCode.toString(),
                                    style: TextStyle(
                                        color: Colors.white
                                    ),

                                  )))),
                          Expanded(
                              child:
                              Container(
                                  height: 45.0,
                                  margin: EdgeInsets.only(right: 25.0),
                                  decoration: BoxDecoration(
                                    color: AppTheme.verifyPhone,
                                    borderRadius:   BorderRadius.only(
                                      topRight: Radius.circular(5.0),
                                      bottomRight: Radius.circular(5.0),
                                    ),
                                    border: Border.all(

                                      color: Theme.of(context).primaryColor,  // red as border color
                                    ),
                                  ),
                                  child:
                                  Align(
                                    alignment: Alignment.center,
                                    child:
                                    TextFormField(
                                      controller:_mobilecontroller,
                                      style: TextStyle(
                                          fontFamily: 'Poppins-Regular',color: Colors.black,fontSize: 14.0
                                      ),
                                      keyboardType: TextInputType.phone,
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: "Phone Number",
                                      ),
                                      onChanged: (value) {
                                        // this.phoneNo=value;
                                        print(value);
                                      },
                                    ),
                                  )
                              )
                          ),
                        ],
                      );
                  },
                  // theme: CountryTheme(
                  //   isShowFlag: true,
                  //   isShowTitle: true,
                  //   isShowCode: true,
                  //   isDownIcon: false,
                  //   showEnglishName: true,
                  // ),
                  initialSelection: '+91',
                  // or
                  // initialSelection: 'US'
                  onChanged: (CountryCode code) {
                    print(code.name);
                    print(code.code);
                    print(code.dialCode);
                    print(code.flagUri);
                  },
                ),
                // //phone number
                // Expanded(
                //     child:
                //     Container(
                //         height: 45.0,
                //       margin: EdgeInsets.only(right: 10.0),
                //         decoration: BoxDecoration(
                //           color: AppTheme.verifyPhone,
                //           borderRadius:   BorderRadius.only(
                //             topRight: Radius.circular(5.0),
                //             bottomRight: Radius.circular(5.0),
                //           ),
                //           border: Border.all(
                //
                //             color: Colors.red,  // red as border color
                //           ),
                //         ),
                //         child:
                //          Align(
                //            alignment: Alignment.center,
                //            child:
                //           TextField(
                //             style: TextStyle(
                //               fontFamily: 'Poppins-Regular',color: Colors.black,fontSize: 14.0
                //             ),
                //             keyboardType: TextInputType.phone,
                //             decoration: InputDecoration(
                //               border: InputBorder.none,
                //               hintText: "Phone Number",
                //             ),
                //             onChanged: (value) {
                //               // this.phoneNo=value;
                //               print(value);
                //             },
                //           ),
                //         )
                //     )
                // ),
              // ],
            // )
            //verify phone
            Padding(padding: EdgeInsets.all(25.0),
                child:
                AppButton(
                  onPressed: (){

                if(_mobilecontroller.text.isEmpty){
                _showMessage('Please enter mobile number');
                }else if(_mobilecontroller.text.length!=10){
                _showMessage('Please enter valid number');

                }else{
                  otpVerify.phone=_mobilecontroller.text;
                  otpVerify.countrycode=countrycode.toString();
                  otpVerify.flagRoleType=widget.flagRoleType.toString();
                // Navigator.pushNamed(context, Routes.otp);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => OtpScreen(otpVerify:otpVerify,navigateData:widget.signUpDataNavigation),
                    ),
                  );
                }

                  },
                  shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(50))),
                  text: Translate.of(context).translate('verify_number'),
                  // loading: login is LoginLoading,
                  // disableTouchWhenLoading: true,
                )
            )

          ],
        ),
      ),
    );
  }


}