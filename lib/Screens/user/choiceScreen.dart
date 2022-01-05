import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:orderly/Configs/theme.dart';
import 'package:orderly/Screens/mainNavigation.dart';
import 'package:orderly/Screens/user/verify_phone.dart';
import 'package:orderly/Utils/Utils.dart';
import 'package:orderly/Utils/routes.dart';
import 'package:orderly/Utils/translate.dart';
import 'package:orderly/Widgets/app_button.dart';
import 'package:orderly/Configs/image.dart';
import 'package:orderly/Configs/image.dart';



class ChoiceScreen extends StatefulWidget{
  _ChoiceScreenState createState()=>_ChoiceScreenState();
}

class _ChoiceScreenState extends State<ChoiceScreen>{
  bool flagClickCust=false;
  bool flagClickManager=false;
  String flagRoleType="";
  Future<void> _showMessage(String message) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            "",
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
                'OK',
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(title: Text("sdfsdgs"),),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(Images.bg),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Hi!",style: TextStyle(color:AppTheme.textColor,
              fontFamily: 'Poppins',fontWeight:FontWeight.w600,fontSize: 20.0),),
              Padding(
                padding: EdgeInsets.all(15.0),
                child:

              Text(Translate.of(context).translate('are_you_customer'),
                  textAlign: TextAlign.center,
                  style: TextStyle(fontFamily: 'Poppins',
                      fontWeight: FontWeight.w500,
                      fontSize: 18.0,color: AppTheme.textColor,)
              )),
             SizedBox(height: 30.0,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [

                 Padding(
                   padding: EdgeInsets.all(8.0),
                     child:
                         Column(
                           children: [
                             InkWell(
                             onTap: (){
                               setState(() {
                                 flagClickCust=!flagClickCust;
                                 flagClickManager=false;

                               });
                             },
                   child:flagClickCust==false
                      ?
                   Image.asset(Images.customer,height: 100.0,width: 100.0,)

                       :
                   Image.asset(Images.customerActive,height: 100.0,width: 100.0,)

                             ),
          Text('Customer',
              textAlign: TextAlign.center,
              style: TextStyle(fontFamily: 'Poppins',
                fontWeight: FontWeight.w400,
                fontSize: 14.0,color: flagClickCust==false?
                  AppTheme.textColor
                      :
                  Theme.of(context).primaryColor)
          ),


                           ],
                         )
    ),

                  Padding(
                      padding: EdgeInsets.all(8.0),

                      child:
                          Column(
                            children: [
                              InkWell(
                                  onTap: (){
                                    setState(() {
                                     flagClickCust=false;
                                      flagClickManager=!flagClickManager;
                                    });
                                    // Navigator.pushNamed(context, Routes.signIn);
                                  },
                                  child:flagClickManager==false
                                      ?
                                  Image.asset(Images.manager,height: 100.0,width: 100.0,)
                              :
                                  Image.asset(Images.managerActive,height: 100.0,width: 100.0,)
                              ),

                              Text('Fleet Manager',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14.0,
                                    color: flagClickManager==false?
                                    AppTheme.textColor
                                  :
                                    Theme.of(context).primaryColor)
                              ),
                            ],
                          )

                  )
                ],
              ),
         Padding(padding: EdgeInsets.all(20.0),
             child:
             AppButton(
               onPressed: (){
                 if(flagClickCust==true){
                   flagRoleType="0";//for customer
                   Navigator.pushNamed(context, Routes.signIn,arguments: flagRoleType);
                 }
                 else if(flagClickManager==true){
                   flagRoleType="1";//for fleet manager

                   Navigator.push(context, MaterialPageRoute(builder: (context) =>
                       VerifyPhone(flagRoleType:flagRoleType)
                   ));

                 }else{
                   Fluttertoast.showToast(msg: "Please select one option");
                 }
               },
               shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(50))),
               text: Translate.of(context).translate('started'),
               // loading: login is LoginLoading,
               // disableTouchWhenLoading: true,
             )
         )

            ],
          ),
        ),
      ),
    );
  }

}