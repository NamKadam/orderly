import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_version/get_version.dart';
import 'package:orderly/Blocs/login/bloc.dart';
import 'package:orderly/Configs/image.dart';
import 'package:orderly/Configs/theme.dart';
import 'package:orderly/Models/imageFile.dart';
import 'package:orderly/Screens/mainNavigation.dart';
import 'package:orderly/Screens/profile/edit_profile.dart';
import 'package:orderly/Screens/user/choiceScreen.dart';
import 'package:orderly/Utils/Utils.dart';
import 'package:orderly/Utils/application.dart';
import 'package:orderly/Utils/authentication.dart';
import 'package:orderly/Utils/routes.dart';
import 'package:orderly/Utils/translate.dart';
import 'package:orderly/Widgets/app_button.dart';
import 'package:url_launcher/url_launcher.dart';

class Profile extends StatefulWidget{
  _ProfileState createState()=>_ProfileState();
}

class _ProfileState extends State<Profile>{
  LoginBloc _loginBloc;
  bool fromProf=true;


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
        style: TextStyle(fontFamily: 'Poppins',fontWeight: FontWeight.w500,
            fontSize: 18.0,
            color: AppTheme.textColor),),
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading:false,
        actions: [
          InkWell(
            onTap:() async{
              final result=await Navigator.pushNamed(context, Routes.editProfile);
              if(result!=null){

                setState(() {
                  
                });
              }
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
        margin: EdgeInsets.only(bottom: 75.0),
        child:SingleChildScrollView(
        child:
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HeaderWidget(),
            SizedBox(height: 5.0,),//for spacing
            CardViewWidget(fromProf:fromProf),
            SizedBox(height: 5.0,), //for spacing
            //logout
    BlocBuilder<LoginBloc,LoginState>(builder: (context,profile){
    return BlocListener<LoginBloc,LoginState>(listener: (context,state){
      if (state is LogoutSuccess) //added on 9/12/2020
      {
        // Navigator.popAndPushNamed(context, Routes.roleType);
        // Navigator.of(context).pushReplacementNamed(Routes.roleType);
        // Navigator.pushReplacementNamed(context, Routes.roleType);
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => ChoiceScreen()),
              (Route<dynamic> route) => false,
        );

      }
      },
      child:  Container(color: Colors.white,
          child:Padding(
              padding: EdgeInsets.all(20.0),
              child:
              // ElevatedButton(
              //   style: ElevatedButton.styleFrom(
              //       side: BorderSide(color: Theme.of(context).primaryColor, width: 1),
              //       primary: Colors.white,
              //       shape: RoundedRectangleBorder(
              //           borderRadius: BorderRadius.circular(10.0)
              //       )
              //   ),
              //   // shape: shape,
              //   onPressed: (){
              //     // Navigator.pop(context);
              //     Authentication.signOut(context: context, signInFlag: "0");
              //     _loginBloc.add(OnLogout());
              //     // Navigator.popAndPushNamed(context, Routes.roleType);
              //   },
              //   child: Row(
              //     crossAxisAlignment: CrossAxisAlignment.center,
              //     mainAxisAlignment: MainAxisAlignment.center,
              //     children: <Widget>[
              //       Padding(padding: EdgeInsets.all(10.0),child:Text(
              //         Translate.of(context).translate('log_out'),
              //         style: Theme.of(context)
              //             .textTheme
              //             .button
              //             .copyWith(color: AppTheme.textColor, fontWeight: FontWeight.w600),
              //       )
              //       ),
              //     ],
              //   ),
              // )

            //updated on 14/01/2022
              AppButton(
                onPressed: (){
                  Authentication.signOut(context: context, signInFlag: "0");
                 _loginBloc.add(OnLogout());
                },
                shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(50))),
                text: 'Logout',
                loading: profile is LogoutLoading,
                disableTouchWhenLoading: true,
              )
          )
      ),
    );
    }
    )],
        )),

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
        ClipRect(
            child: Image.asset(Images.profileActive,
              fit: BoxFit.fitWidth,),
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
                padding:EdgeInsets.all(10.0),
                child:Text(
              Application.user!=null
                  ?
              Application.user.firstName+" "+Application.user.lastName
              :
              "",
              style: TextStyle(fontFamily: 'Poppins',fontWeight: FontWeight.w600,
                  fontSize: 16.0,
                  color:AppTheme.textColor),
            )),
            //email
            if(Application.user.emailId!="null")
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
  bool fromProf;
  CardViewWidget({Key key,@required this.fromProf}):super(key: key);
  _CardViewWidgetState createState()=>_CardViewWidgetState();
}
class _CardViewWidgetState extends State<CardViewWidget>{
  String versionName="";

  void openwhatsapp() async{
    var no="9960035092";
    var numbers = "+91"+no;
    String url() {
      if (Platform.isIOS) {
        // return "whatsapp://wa.me/$numbers/?text=${Uri.parse("Hello")}";
        // https://api.whatsapp.com/send?phone
        return "https://wa.me/$numbers/?text=${Uri.parse("Hello")}";
      } else {
        return "whatsapp://send?phone=$numbers&text=${Uri.parse("Hello")}";
      }

    }
    if (await canLaunch(url())) {
      await launch(url());
    } else {
      throw 'Could not launch ${url()}';
    }

  }

  void getVersionName() async{
    versionName = await GetVersion.projectVersion;


  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getVersionName();
  }


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
              InkWell(
          onTap: ()
          {
            if(Application.user.userType=="0"){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>MainNavigation(flagOrder: "1"))); //for customer my orders
            }else{
              Navigator.pushNamed(context,Routes.mainNavi); //for fleet orders

            }
          },
                child:

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                      padding: EdgeInsets.only(left:15.0),
                      child:Text(Translate.of(context).translate('my_order'),style: TextStyle(fontWeight:FontWeight.w400,
                          fontFamily: 'Poppins',color: AppTheme.textColor),
                      )),

                  IconButton(
                      icon: Image.asset(Images.arrow,height: 15.0,width:15.0)

                  )
                ],
              )),
              Divider(
                height: 0.5,
                color: Colors.black26,
              ),
              //help
              InkWell(
                onTap: (){
                  openwhatsapp();
                },
                  child:
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                      padding: EdgeInsets.only(left:15.0),
                      child:Text(Translate.of(context).translate('help'),style: TextStyle(fontWeight:FontWeight.w400,
                          fontFamily: 'Poppins',color: AppTheme.textColor),
                      )),
                  IconButton(icon: Image.asset(Images.arrow,height: 15.0,width:15.0)
                  )
                ],
              )),
              Divider(
                height: 0.5,
                color: Colors.black26,
              ),
              //address
              if(Application.user.userType=="0")
              InkWell(
                onTap: (){
                  Navigator.pushNamed(context, Routes.address,arguments:widget.fromProf );

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
              InkWell(
                onTap: (){
                  print("clicked faq");
                  Navigator.pushNamed(context, Routes.faq);
                },
                child:
                Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                      padding: EdgeInsets.only(left:15.0),
                      child:Text(Translate.of(context).translate('faq'),style: TextStyle(fontWeight:FontWeight.w400,
                          fontFamily: 'Poppins',color: AppTheme.textColor),
                      )),

                  IconButton(
                      icon: Image.asset(Images.arrow,height: 15.0,width:15.0)

                  )
                ],
              )),
              Divider(
                height: 0.5,
                color: Colors.black26,
              ),
              //terms
              GestureDetector(
                onTap: (){
                  Navigator.pushNamed(context, Routes.terms);
                },
                child:
                Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                      padding: EdgeInsets.only(left:15.0),
                      child:Text(Translate.of(context).translate('terms_of_use'),style: TextStyle(fontWeight:FontWeight.w400,
                          fontFamily: 'Poppins',color: AppTheme.textColor),
                      )),

                  IconButton(
                      icon: Image.asset(Images.arrow,height: 15.0,width:15.0)

                  )
                ],
              )),
              Divider(
                height: 0.5,
                color: Colors.black26,
              ),
              //privacy
          GestureDetector(
            onTap: (){
              Navigator.pushNamed(context, Routes.privacy);
            },
            child:
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                      padding: EdgeInsets.only(left:15.0),
                      child:Text(Translate.of(context).translate('privacy_policy'),style: TextStyle(fontWeight:FontWeight.w400,
                          fontFamily: 'Poppins',color: AppTheme.textColor),
                      )),

                  IconButton(
                      icon: Image.asset(Images.arrow,height: 15.0,width:15.0)

                  )
                ],
              )),
              Divider(
                height: 0.5,
                color: Colors.black26,
              ),
              Padding(
                  padding: EdgeInsets.all(15.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(
        "Version " ,
        style: TextStyle(
            fontSize: 14.0,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w400,
            color: AppTheme.textColor),
      ),
      Text(
        Platform.isAndroid?versionName:Application.Iosversion,
        style: TextStyle(
            fontSize: 14.0,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w500,
            color: AppTheme.textColor),
      )
    ],
    )
                 )
            ],
          ),
        ),
      ),
    );
  }

}