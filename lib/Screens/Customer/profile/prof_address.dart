import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:orderly/Configs/theme.dart';
import 'package:orderly/Utils/translate.dart';
import 'package:orderly/Widgets/app_button.dart';
import 'package:orderly/Widgets/app_text_input.dart';

class ProfAddress extends StatefulWidget{
  _ProfAddressState createState()=>_ProfAddressState();
}

class _ProfAddressState extends State<ProfAddress>{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(

      appBar: AppBar(
        title: Text(Translate.of(context).translate('address')
          ,style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body:
      Container(
        height: 250.0,
        width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.only(top:8.0),
            child:
            Card(
              child:
                  Padding(
                    padding: EdgeInsets.all(20.0),
                 child:
                 Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Namrata kadam',
                  style: TextStyle(fontFamily: 'Poppins',fontWeight: FontWeight.w600,
                      fontSize: 16.0,
                      color:AppTheme.textColor),
                ),
                //email
                Text(
                  '244,somwar peth,near khadiche maidan,pune-411011',
                  style: TextStyle(fontFamily: 'Poppins',fontWeight: FontWeight.w400,
                      fontSize: 12.0,
                      color:AppTheme.textColor),
                ),
                //mobile
                Padding(
                    padding:EdgeInsets.only(top:2.0,bottom: 15.0),child:Text(
                  'Mobile:- +91 9730259440',
                  style: TextStyle(fontFamily: 'Poppins',fontWeight: FontWeight.w400,
                      fontSize: 12.0,
                      color:AppTheme.textColor),
                )),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    //cancel
                    Expanded(
                        child:Padding(padding: EdgeInsets.only(left:20.0,right:20.0,top:30.0),

                            child:ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  side: BorderSide(color: Theme.of(context).primaryColor, width: 1),
                                  primary: Colors.white,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(50.0)
                                  )
                              ),
                              // shape: shape,
                              onPressed: (){},
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Padding(padding: EdgeInsets.all(10.0),child:Text(
                                    'Edit',
                                    style: Theme.of(context)
                                        .textTheme
                                        .button
                                        .copyWith(color: AppTheme.textColor, fontWeight: FontWeight.w600),
                                  )
                                  ),
                                ],
                              ),
                            )
                        )),
                    //save
                    Expanded(
                        child:Padding(padding: EdgeInsets.only(left:20.0,right:20.0,top:30.0),
                            child:
                            AppButton(
                              onPressed: (){
                                // _signUp();
                                // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MainNavigation()));
                              },
                              shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(50))),
                              text: 'Remove',
                              // loading: login is LoginLoading,
                              // disableTouchWhenLoading: true,
                            )
                        )
                    )
                  ],
                )

                ],
            ),
      ),
    )));
  }
  
}