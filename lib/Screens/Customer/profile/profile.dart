import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:orderly/Blocs/login/bloc.dart';
import 'package:orderly/Configs/image.dart';
import 'package:orderly/Configs/theme.dart';
import 'package:orderly/Models/imageFile.dart';
import 'package:orderly/Screens/mainNavigation.dart';
import 'package:orderly/Utils/application.dart';
import 'package:orderly/Utils/authentication.dart';
import 'package:orderly/Utils/routes.dart';
import 'package:orderly/Utils/translate.dart';

class Profile extends StatefulWidget{
  _ProfileState createState()=>_ProfileState();
}

class _ProfileState extends State<Profile>{
  LoginBloc _loginBloc;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loginBloc = BlocProvider.of<LoginBloc>(context);
  }


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(title:
      Text("Profile",
        style: TextStyle(fontFamily: 'Poppins',fontWeight: FontWeight.w400,
            fontSize: 18.0,
            color: AppTheme.textColor),),
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading:false,
        actions: [
          InkWell(
            onTap:(){
              Navigator.pushNamed(context, Routes.editProfile);
            },
            child:
            Padding(
                padding:EdgeInsets.all(15.0),child:Text(
              'EDIT',
              style: TextStyle(fontFamily: 'Poppins',fontWeight: FontWeight.w600,
                  fontSize: 15.0,
                  color:Theme.of(context).primaryColor),
            ))
          )
        ],
      ),
      body: Container(
        child:SingleChildScrollView(
      child:
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HeaderWidget(),
            SizedBox(height: 5.0,),//for spacing

            CardViewWidget(),
            SizedBox(height: 5.0,), //for spacing

            //logout
            Container(color: Colors.white,
                child:Padding(
                padding: EdgeInsets.all(20.0),
              child:ElevatedButton(
              style: ElevatedButton.styleFrom(
                side: BorderSide(color: Theme.of(context).primaryColor, width: 1),
                primary: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)
                )
              ),
              // shape: shape,
              onPressed: (){
                // Navigator.pop(context);
                Authentication.signOut(context: context, signInFlag: "0");
                _loginBloc.add(OnLogout());
                Navigator.popAndPushNamed(context, Routes.roleType);
              },
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(padding: EdgeInsets.all(10.0),child:Text(
                    Translate.of(context).translate('log_out'),
                    style: Theme.of(context)
                        .textTheme
                        .button
                        .copyWith(color: AppTheme.textColor, fontWeight: FontWeight.w600),
                  )
                  ),
                ],
              ),
            )
            )
            )
          ],
        ),

      ),
      )

    );
  }

}

class HeaderWidget extends StatelessWidget{

  File _image;
  ImageFile imageFile;

  ///Build Avatar image
  Widget _buildAvatar() {
    if (_image!=null) {
      return Container(
        width: 100,
        height: 100,
        margin: EdgeInsets.only(top:20.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color:
            AppTheme.appColor,  // red as border color
          ),
          color:
          Colors.white,

        ),

        child:
        ClipRRect(
          child: Image.file(
            _image,
            fit: BoxFit.fill,
          ),

          borderRadius: BorderRadius.circular(10),

        ),

      );
    }
    //updated on 30/11/2020
    return Container(
        width: 100,
        height: 100,
        margin: EdgeInsets.only(top:20.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color:
            AppTheme.appColor,  // red as border color
          ),
          color:
          Colors.white,

        ),
        child:
        CircleAvatar(
          //   child: Image.asset(Images.manager,
          //     fit: BoxFit.fitWidth,),
          backgroundColor: Colors.white,
        )

    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
        padding: EdgeInsets.all(8.0),
        color: Colors.white,
        child:
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Align(
              alignment:Alignment.center,
              child:_buildAvatar(),
            ),
            //name
            Padding(
                padding:EdgeInsets.all(10.0),child:Text(
              Application.user.firstName+" "+Application.user.lastName,
              style: TextStyle(fontFamily: 'Poppins',fontWeight: FontWeight.w600,
                  fontSize: 16.0,
                  color:AppTheme.textColor),
            )),
            //email
            Text(
              Application.user.emailId,
              style: TextStyle(fontFamily: 'Poppins',fontWeight: FontWeight.w200,
                  fontSize: 12.0,
                  color:AppTheme.textColor),
            ),
            //mobile
            Padding(
                padding:EdgeInsets.only(top:2.0,bottom: 15.0),child:Text(
              "+91 "+Application.user.mobile,
              style: TextStyle(fontFamily: 'Poppins',fontWeight: FontWeight.w400,
                  fontSize: 12.0,
                  color:AppTheme.textColor),
            ))
          ],
        )

    );
  }

}

class CardViewWidget extends StatefulWidget{
  _CardViewWidgetState createState()=>_CardViewWidgetState();
}
class _CardViewWidgetState extends State<CardViewWidget>{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      color: Colors.white,
      child: Padding(
        padding: EdgeInsets.all(20.0),
        child: Card(
          elevation: 5.0,
          child: Column(
            children: [
              //orders
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                      padding: EdgeInsets.only(left:15.0),
                      child:Text(Translate.of(context).translate('my_order'),style: TextStyle(fontWeight:FontWeight.w400,
                          fontFamily: 'Poppins',color: AppTheme.textColor),
                      )),

                  IconButton(onPressed: (){},
                      icon: Image.asset(Images.arrow,height: 15.0,width:15.0)

                  )
                ],
              ),
              Divider(
                height: 0.5,
                color: Colors.black26,
              ),
              //help
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                      padding: EdgeInsets.only(left:15.0),
                      child:Text(Translate.of(context).translate('help'),style: TextStyle(fontWeight:FontWeight.w400,
                          fontFamily: 'Poppins',color: AppTheme.textColor),
                      )),

                  IconButton(onPressed: (){},
                      icon: Image.asset(Images.arrow,height: 15.0,width:15.0)

                  )
                ],
              ),
              Divider(
                height: 0.5,
                color: Colors.black26,
              ),
              //address
              InkWell(
                onTap: (){
                  Navigator.pushNamed(context, Routes.address);

                },
              child:
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                      padding: EdgeInsets.only(left:15.0),
                      child:Text(Translate.of(context).translate('address'),style: TextStyle(fontWeight:FontWeight.w400,
                          fontFamily: 'Poppins',color: AppTheme.textColor),
                      )),

                  IconButton(onPressed: (){
                    Navigator.pushNamed(context, Routes.address);
                  },
                      icon: Image.asset(Images.arrow,height: 15.0,width:15.0)

                  )
                ],
              )),
              //faq
              Divider(
                height: 0.5,
                color: Colors.black26,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                      padding: EdgeInsets.only(left:15.0),
                      child:Text(Translate.of(context).translate('faq'),style: TextStyle(fontWeight:FontWeight.w400,
                          fontFamily: 'Poppins',color: AppTheme.textColor),
                      )),

                  IconButton(onPressed: (){},
                      icon: Image.asset(Images.arrow,height: 15.0,width:15.0)

                  )
                ],
              ),
              Divider(
                height: 0.5,
                color: Colors.black26,
              ),
              //terms
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                      padding: EdgeInsets.only(left:15.0),
                      child:Text(Translate.of(context).translate('terms_of_use'),style: TextStyle(fontWeight:FontWeight.w400,
                          fontFamily: 'Poppins',color: AppTheme.textColor),
                      )),

                  IconButton(onPressed: (){},
                      icon: Image.asset(Images.arrow,height: 15.0,width:15.0)

                  )
                ],
              ),
              Divider(
                height: 0.5,
                color: Colors.black26,
              ),
              //privacy
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                      padding: EdgeInsets.only(left:15.0),
                      child:Text(Translate.of(context).translate('privacy_policy'),style: TextStyle(fontWeight:FontWeight.w400,
                          fontFamily: 'Poppins',color: AppTheme.textColor),
                      )),

                  IconButton(onPressed: (){},
                      icon: Image.asset(Images.arrow,height: 15.0,width:15.0)

                  )
                ],
              ),

            ],
          ),
        ),
      ),
    );
  }

}