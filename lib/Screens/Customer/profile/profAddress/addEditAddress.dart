import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:orderly/Api/api.dart';
import 'package:orderly/Configs/theme.dart';
import 'package:orderly/Models/zipcode/postalcode.dart';
import 'package:orderly/Utils/application.dart';
import 'package:orderly/Utils/translate.dart';
import 'package:orderly/Utils/utilOther.dart';
import 'package:orderly/Utils/validate.dart';
import 'package:orderly/Widgets/app_button.dart';
import 'package:orderly/Widgets/app_text_input.dart';
import 'package:http/http.dart' as http;


class AddEditAddress extends StatefulWidget {
  final String flagAddEdit;
  const AddEditAddress({Key key, @required this.flagAddEdit}) : super(key: key);

  AddEditAddressState createState() => AddEditAddressState();
}

class AddEditAddressState extends State<AddEditAddress> {

  final _textFirstNameController = TextEditingController();
  final _textLastNameController = TextEditingController();
  final _textZipController = TextEditingController();
  final _textEmailController = TextEditingController();
  final _textMobileController = TextEditingController();
  final _focusName = FocusNode();
  final _focusLastName = FocusNode();
  final _focusMobile = FocusNode();
  final _focusZip = FocusNode();

  var _validFirstName,_validLastName,_validMobile,_validZip,address;
  dynamic postResultList = <Result>[];
  bool _apiCall = false;
  final _scaffoldKey = GlobalKey<ScaffoldState>();


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(widget.flagAddEdit=="1") //for edit
        {
      getUserData();
    }
  }

  void getUserData(){
    _textFirstNameController.text=Application.user.firstName;
    _textLastNameController.text=Application.user.lastName;
    _textZipController.text="";
    _textMobileController.text=Application.user.mobile;

  }

  void _callAPIForPincode() {
    Api.fetchPincode(http.Client(), _textZipController.text).then(
            (value) => {
          setState(() {
            print('Value' + value.status.toString());
            // postOfficeList = value.postOffice;
            postResultList = value.result;
            if(postResultList.length<=0){
              _validZip='Please enter valid Zipcode';

            }else{
              _validZip="";
              address='${postResultList[0].postalCode}, ${postResultList[0].state},${postResultList[0].country}, ${postResultList[0].postalLocation}';

            }
            print(value.result);

          })
        }, onError: (error) {
      setState(() {
        _apiCall=false;
        print('Value $error');
        postResultList = [];
      });
    });
  }



  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      key: _scaffoldKey,
      appBar: new AppBar(
        title: Text(Translate.of(context).translate('address'),style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
            fontSize: 18.0,
            color: AppTheme.textColor
        ),),
        leading: InkWell(
            onTap: (){
              Navigator.pop(context);

            },
            child:Icon(Icons.arrow_back_ios,color: AppTheme.textColor,)
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Container(
        child:SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              //first name
              Container(margin: EdgeInsets.only(top:25.0,left:20.0,right:20.0),
                  child:AppTextInput(
                    enabled: true,
                    hintText: Translate.of(context).translate('input_first_name'),
                    errorText: Translate.of(context).translate(_validFirstName),
                    icon: Icon(Icons.clear),
                    controller: _textFirstNameController,
                    focusNode: _focusName,
                    textInputAction: TextInputAction.next,
                    onChanged: (text) {
                      setState(() {
                        _validFirstName = UtilValidator.validate(
                          data: _textFirstNameController.text,
                        );
                      });
                    },
                    onSubmitted: (text) {
                      UtilOther.fieldFocusChange(context, _focusName, _focusLastName);
                    },
                    onTapIcon: () async {
                      await Future.delayed(Duration(milliseconds: 100));
                      _textFirstNameController.clear();
                    },
                  )),

              //lastName
              Container(margin: EdgeInsets.only(top:15.0,left:20.0,right:20.0),
                  child:AppTextInput(
                    enabled: true,
                    hintText: Translate.of(context).translate('input_last_name'),
                    errorText: Translate.of(context).translate(_validLastName),
                    icon: Icon(Icons.clear),
                    controller: _textLastNameController,
                    focusNode: _focusLastName,
                    textInputAction: TextInputAction.next,
                    onChanged: (text) {
                      setState(() {
                        _validLastName = UtilValidator.validate(
                          data: _textLastNameController.text,
                        );
                      });
                    },
                    onSubmitted: (text) {
                      UtilOther.fieldFocusChange(context, _focusLastName, _focusZip);
                    },
                    onTapIcon: () async {
                      await Future.delayed(Duration(milliseconds: 100));
                      _textLastNameController.clear();
                    },
                  )),

              //zip
              Container(margin: EdgeInsets.only(top:15.0,left:20.0,right:20.0),
                  child:
                  AppTextInput(
                    enabled: true,
                    hintText: Translate.of(context).translate('input_zipcode'),
                    errorText: Translate.of(context).translate(_validZip),
                    icon: Icon(Icons.clear),
                    controller: _textZipController,
                    focusNode: _focusZip,
                    maxLength: 5,
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly
                    ],
                    textInputAction: TextInputAction.next,
                    onChanged: (text) {
                      if(text.length>=5){
                        _apiCall=true;
                        _callAPIForPincode();
                      }

                      // setState(() {
                      _validZip = UtilValidator.validate(
                        data: _textZipController.text,
                      );
                      //
                      // });

                    },

                    onSubmitted: (text) {
                      UtilOther.fieldFocusChange(context, _focusZip, _focusMobile);
                      print('submitted zip');
                    },
                    onTapIcon: () async {
                      await Future.delayed(Duration(milliseconds: 100));
                      _textZipController.clear();
                      setState(() {
                        _apiCall=false;
                        postResultList=[];
                        _validZip = UtilValidator.validate(
                          data: _textZipController.text,
                        );
                      });

                    },
                  )),

              if(postResultList.length>0)

                Padding(
                    padding:EdgeInsets.only(top:postResultList.length>0?0:10
                      ,left:20.0,right: 20.0,),
                    child:

                    Container(
                        height: 50.0,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          border: Border.all(color: Theme.of(context).primaryColor),
                          color: AppTheme.verifyPhone.withOpacity(0.4),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child:Align(
                          alignment: Alignment.centerLeft,
                          child:
                          Text(

                            '   ${postResultList[0].postalCode}, ${postResultList[0].state},${postResultList[0].country}, ${postResultList[0].postalLocation}'
                            ,

                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontWeight: FontWeight.w400,fontSize: 14.0,),),
                        ))),

              //mobile
              Container(margin: EdgeInsets.only(top:15.0,left:20.0,right:20.0),
                  child:
                  AppTextInput(
                    enabled: true,
                    hintText: Translate.of(context).translate('input_mobile'),
                    errorText: Translate.of(context).translate(_validMobile),
                    icon: Icon(Icons.clear),
                    controller: _textMobileController,
                    focusNode: _focusMobile,
                    maxLength: 10,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly
                    ],
                    keyboardType: TextInputType.phone,
                    textInputAction: TextInputAction.next,
                    onChanged: (text) {
                      setState(() {
                        _validMobile = UtilValidator.validate(
                          data: _textMobileController.text,
                        );
                      });
                    },

                    onTapIcon: () async {
                      await Future.delayed(Duration(milliseconds: 100));
                      _textMobileController.clear();
                    },
                  )),
              Padding(padding: EdgeInsets.only(left:30.0,right:20.0,top:30.0),
                  child:
                  AppButton(
                    onPressed: (){
                      // _signUp();
                      // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MainNavigation()));
                    },
                    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(50))),
                    text:widget.flagAddEdit=="0"?"Add":"Update",
                    // loading: login is LoginLoading,
                    // disableTouchWhenLoading: true,
                  )
              )
            ],
          ),
        )
      ),
    );
  }
}
