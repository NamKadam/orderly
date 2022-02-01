import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:orderly/Api/api.dart';
import 'package:orderly/Blocs/user_reg/bloc.dart';
import 'package:orderly/Configs/image.dart';
import 'package:orderly/Configs/theme.dart';
import 'package:orderly/Models/imageFile.dart';
import 'package:orderly/Models/signup_navigateFields.dart';
import 'package:orderly/Models/zipcode/postalcode.dart';
import 'package:orderly/Screens/mainNavigation.dart';
import 'package:orderly/Utils/Utils.dart';
import 'package:orderly/Utils/other.dart';
import 'package:orderly/Utils/preferences.dart';
import 'package:orderly/Utils/progressDialog.dart';
import 'package:orderly/Utils/translate.dart';
import 'package:orderly/Utils/util_preferences.dart';
import 'package:orderly/Utils/validate.dart';
import 'package:orderly/Widgets/app_button.dart';
import 'package:orderly/Widgets/app_text_input.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;


enum AppState {
  free,
  picked,
  cropped,
}
class SignUp extends StatefulWidget{
  User user;
   SignUpDataNavigation signUpDataNavigation;
   String phone;

   SignUp({this.user,this.signUpDataNavigation,this.phone});

  _SignUpState createState()=>_SignUpState();
}

class _SignUpState extends State<SignUp>{

  File _image;
  ImageFile imageFile;
  final picker = ImagePicker();
  AppState state;

  final _textFirstNameController = TextEditingController();
  final _textLastNameController = TextEditingController();
  final _textZipController = TextEditingController();
  final _textEmailController = TextEditingController();
  final _textMobileController = TextEditingController();
  final _textStreetController = TextEditingController();
  final _textHouseFlatNoController = TextEditingController();
  final _textAddressController = TextEditingController();
  final _focusName = FocusNode();
  final _focusLastName = FocusNode();
  final _focusEmail = FocusNode();
  final _focusMobile = FocusNode();
  final _focusZip = FocusNode();
  final _focusAddress = FocusNode();
  dynamic postResultList = <Result>[];
  bool _apiCall = false;
  UserRegBloc _userRegBloc;
  var _validFirstName,_validLastName,_validEmail,_validMobile,_validZip,_validAddress;
  var address;
  bool flagEmailEnabled;
  bool flagPhoneEnabled;

  @override
  void initState() {
    super.initState();
    _userRegBloc = BlocProvider.of<UserRegBloc>(context);
    getUserData();
  }

  void getUserData(){
    _validFirstName=null;
    _validLastName=null;
    _validZip=null;
    _validEmail=null;
    _validMobile=null;
    _validAddress=null;
    if(widget.user.displayName!=null) {
      var fullname = widget.user.displayName.toString().split(" ");
      var firstName = fullname[0];
      var lastName = fullname[1];

      _textFirstNameController.text = firstName.toString();
      _textLastNameController.text = lastName.toString();
    }
        else{
      _textFirstNameController.text="";
      _textLastNameController.text="";

    }

    print(widget.user.email);

    if(widget.user.email==null){
      flagEmailEnabled=true;
    }else{
      flagEmailEnabled=false;
      _textEmailController.text=widget.user.email.toString();

    }
    if(widget.phone==null){
      flagPhoneEnabled=true;
    }else{
      flagPhoneEnabled=false;
      _textMobileController.text=widget.phone.toString();

    }
     setState(() {

     });
  }


  void _callAPIForPincode() {
    PsProgressDialog.showProgressWithoutMsg(context);
    Api.fetchPincode(http.Client(), _textZipController.text).then(
            (value) => {

        setState(() {
            print('Value' + value.status.toString());
            // postOfficeList = value.postOffice;
            postResultList = value.result;
            if(postResultList.length<=0){
              _validZip='Please enter valid Zipcode';
              _textAddressController.text="";
            }else{
              _validZip=null;
              address='${postResultList[0].postalCode}, ${postResultList[0].state},'
                  '${postResultList[0].country}, ${postResultList[0].postalLocation},${postResultList[0].province}';
              _textAddressController.text=address;
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

  ///Build Avatar image
  Widget _buildAvatar() {
    if (_image!=null) {
      return Container(
        width: 120,
        height: 120,
        margin: EdgeInsets.only(top:20.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(60),
          border: Border.all(
            color:AppTheme.textColor
            // Theme.of(context).primaryColor,  // red as border color
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

          borderRadius: BorderRadius.circular(60),

        ),

      );
    }
    //updated on 30/11/2020
    return Container(
        width: 120,
        height: 120,
        margin: EdgeInsets.only(top:20.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(60),
          border: Border.all(
            color:AppTheme.textColor,
            // Theme.of(context).primaryColor,  // red as border color
          ),
          color:
          Colors.white,

        ),
        child:
        CircleAvatar(
          child: Image.asset(Images.profile,
            fit: BoxFit.fill,
          height: 120,
          width: 120,),
          backgroundColor: Colors.white,
        )

    );
  }

  //updated on 15/06/2021
  Future<void> customCameraGalleryDialog(BuildContext context)async {
    showModalBottomSheet<void>(
        backgroundColor: Colors.transparent,
        context: context,
        builder: (BuildContext context) {
          // openModalSheet();
          return Container(

            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
            ),
            child: Padding(
              padding: EdgeInsets.only(left: 20, right: 20),
              child: SingleChildScrollView(
                child: IntrinsicHeight(
                  child: Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Upload from",style: Theme.of(context).textTheme.title.copyWith(
                              color: Colors.black,
                              fontSize: 17.0
                          ),),
                          IconButton(icon: Icon(Icons.cancel), onPressed: (){
                            Navigator.pop(context);
                          })
                        ],
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          InkWell(
                            onTap: (){
                              // if(state==AppState.free)
                                _openCamera(context);
                              // else if(state==AppState.cropped);
                            },
                            child:

                            Column(
                              children: [
                                Padding(
                                    padding:EdgeInsets.all(15.0),
                                    child:Image.asset(Images.cameraBlue,width:50.0,height: 50.0,)),


                              ],

                            ),
                          ),
                          InkWell(
                            onTap: (){

                              // if(state==AppState.free)
                                _openGallery(context);
                              // else if(state==AppState.picked)
                                // _cropImage();
                            },

                            child:
                            Column(
                              children: [
                                Padding(
                                    padding:EdgeInsets.all(15.0),
                                    child:
                                    Image.asset(Images.gallery,width:50.0,height: 50.0,)),
                                // Padding(
                                //     padding:EdgeInsets.only(left:8.0,right:8.0,top:6.0),
                                //     child:Text("Whatsapp",style:Theme.of(context).textTheme.bodyText1.copyWith(color: Theme.of(context).primaryColor,fontFamily: 'Roboto',
                                //         fontWeight: FontWeight.w700)
                                //     )),

                              ],

                            ),
                          )

                        ],
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }


  //method to open gallery
  _openGallery(BuildContext context) async {

    final image = await picker.getImage(source: ImageSource.gallery,imageQuality: 25);
    imageFile=new ImageFile();
    if (image != null) {

      _cropImage(image);

    }
  }
//method to open camera
  _openCamera(BuildContext context) async {

    final imageCamera = await picker.getImage(source: ImageSource.camera);
    imageFile=new ImageFile();

    if (imageCamera != null) {

      _cropImage(imageCamera);
      // state = AppState.picked;

    }
  }

  ///On async get Image file
  Future _getImage() async {
    // final image = await pickerUser.getImage(source: ImageSource.gallery,imageQuality: 25);
    final image = await picker.getImage(source: ImageSource.gallery,imageQuality: 25);
    imageFile=new ImageFile();
    if (image != null) {

      _cropImage(image);

    }
  }

  Future<Null> _cropImage(PickedFile imageCropped) async {
    File croppedFile = await ImageCropper.cropImage(
        sourcePath: imageCropped.path,
        aspectRatioPresets: Platform.isAndroid
            ? [
          // CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio4x3,
        ]
            : [
          // CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio4x3,
        ],
        androidUiSettings: AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: Theme.of(context).primaryColor,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.square,
            lockAspectRatio: false),
        iosUiSettings: IOSUiSettings(
          title: 'Cropper',
        ));
    if (croppedFile != null) {

      setState(() {
        // mImageFile.image = croppedFile;
        // print(mImageFile.image.path);
        // state = AppState.cropped;
        _image = croppedFile;
        imageFile.imagePath=_image.path;
      });
      Navigator.pop(context);
    }
  }

  ///On sign up
  void _signUp() {
    UtilOther.hiddenKeyboard(context);
    setState(() {
      _validFirstName = UtilValidator.validate(
        data: _textFirstNameController.text,
      );
      _validLastName = UtilValidator.validate(
        data: _textLastNameController.text,
      );
      _validZip = UtilValidator.validate(
        data: _textZipController.text,
        type: ValidateType.pincode
      );

      _validEmail = UtilValidator.validate(
        data: _textEmailController.text,
        type:ValidateType.email
      );
      _validMobile = UtilValidator.validate(
        data: _textMobileController.text,
        type: ValidateType.phone,
      );


    });
    // if(imageFile==null){
    //   _showMessage("Please upload your image ");
    // }else

    if (_validFirstName == null && _validLastName==null&&_validZip==null&&_validEmail==null&&_validMobile==null &&_validAddress==null) {


      _userRegBloc.add(OnUserRegister(
        firstName: _textFirstNameController.text.toString(),
        lastName: _textLastNameController.text.toString(),
        mobile: _textMobileController.text.toString(),
        email: _textEmailController.text.toString(),
        zipcode: _textZipController.text.toString(),
        // profile_photo: imageFile,
        // address:address,
        address:_textAddressController.text,
          firebaseId:widget.user.uid.toString(),
        deviceId: widget.signUpDataNavigation.deviceId.toString(),
        deviceName: widget.signUpDataNavigation.deviceName.toString(),
        lat: widget.signUpDataNavigation.lat.toString(),
        lng: widget.signUpDataNavigation.long.toString(),
        version: widget.signUpDataNavigation.versionCode.toString(),
        fcmId: widget.signUpDataNavigation.fcmId.toString(),
        userType: widget.signUpDataNavigation.userType.toString(),
        signupType: widget.signUpDataNavigation.signup_type.toString()
      ));
    }
  }

  ///On show message fail
  Future<void> _showMessage(String message,String flag) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            Translate.of(context).translate('sign_up'),
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
                "OK",
              ),
              onPressed: () {
                if(flag=="0"){
                  Navigator.of(context).pop();

                }else{
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MainNavigation(
                    userType: "0", //for cutomer
                  )));

                }
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
    return BlocListener<UserRegBloc,UserRegState>(listener: (context,listen){
      if(listen is RegisterUserFail){
        _showMessage(
            Translate.of(context).translate(listen.msg),
          "0"//for fail
        );
      }

      if(listen is RegisterUserSuccess){
        // Scaffold.of(context).showSnackBar(SnackBar(content:Text('User Registered Successfully')));
        _showMessage(
          "User Registered Successfully","1" //for success
        );
      }


    },
      child:Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('Sign Up'
            ,style: TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        body: Container(
            padding: EdgeInsets.only(left: 20, right: 20),
            child: SingleChildScrollView(
              child:
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //image
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child:
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Stack(
                          alignment: Alignment.bottomRight,
                          children: <Widget>[
                            _buildAvatar(),
                            IconButton(
                              icon:
                              Image.asset(Images.camera,height: 40.0,width:35.0),
                              onPressed:(){
                                customCameraGalleryDialog(context);
                              },
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                  //first name
                  Container(margin: EdgeInsets.only(top:25.0,left:20.0,right:20.0),
                      child:
                      AppTextInput(
                        enabled: true,
                        hintText: Translate.of(context).translate('first_name'),
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
                        hintText: Translate.of(context).translate('last_name'),
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
                        hintText: Translate.of(context).translate('zipcode'),
                        errorText: Translate.of(context).translate(_validZip),
                        icon: Icon(Icons.clear),
                        controller: _textZipController,
                        focusNode: _focusZip,
                        maxLength: 6,
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
                              type: ValidateType.pincode
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
                  //address from zipcode
                  if(postResultList.length>0)
                    Column(
                      children: [
                        // Padding(
                        //   padding:EdgeInsets.only(top:postResultList.length>0?0:10
                        //     ,left:20.0,right: 20.0,),
                        //   child:
                        //
                        //   Container(
                        //       height: 50.0,
                        //       alignment: Alignment.center,
                        //       decoration: BoxDecoration(
                        //         border: Border.all(color: Theme.of(context).primaryColor),
                        //         color: AppTheme.verifyPhone.withOpacity(0.4),
                        //         borderRadius: BorderRadius.circular(10),
                        //       ),
                        //       child:Align(
                        //         alignment: Alignment.centerLeft,
                        //         child:
                        //         Text(
                        //
                        //           // '   ${postResultList[0].postalCode}, ${postResultList[0].state},${postResultList[0].country}, ${postResultList[0].postalLocation}'
                        //           " "+address,
                        //
                        //           maxLines: 1,
                        //           overflow: TextOverflow.ellipsis,
                        //           style: TextStyle(fontWeight: FontWeight.w400,fontSize: 14.0,),),
                        //       ))),

                        //updated addres part
                        Container(margin: EdgeInsets.only(top:15.0,left:20.0,right:20.0),
                            child:AppTextInput(
                              enabled: false,
                              maxLines: 2,
                              controller: _textAddressController,
                              // focusNode: _focusAddress,
                              keyboardType: TextInputType.text,
                              textInputAction: TextInputAction.next,
                              onChanged: (text) {
                                setState(() {
                                  _validAddress = UtilValidator.validate(
                                    data: _textAddressController.text,
                                  );
                                });
                              },

                            )),
                        //street no
                        // Container(
                        //     margin: EdgeInsets.only(top: 15.0,),
                        //     child: AppTextInput(
                        //       enabled: true,
                        //       hintText:
                        //       Translate.of(context).translate('street'),
                        //       errorText: Translate.of(context).translate(_validStreet),
                        //       icon: Icon(Icons.clear),
                        //       controller: _textStreetController,
                        //       focusNode: _focusStreet,
                        //       keyboardType: TextInputType.number,
                        //       textInputAction: TextInputAction.next,
                        //       onChanged: (text) {
                        //         setState(() {
                        //           _validStreet = UtilValidator.validate(
                        //             data: _textStreetController.text,
                        //           );
                        //         });
                        //       },
                        //       onSubmitted: (text) {
                        //         UtilOther.fieldFocusChange(
                        //             context, _focusStreet, _focusHouseNo);
                        //       },
                        //       onTapIcon: () async {
                        //         await Future.delayed(Duration(milliseconds: 100));
                        //         _textStreetController.clear();
                        //       },
                        //     )),
                        // //house no/flat no
                        // Container(
                        //     margin: EdgeInsets.only(top: 15.0,),
                        //     child: AppTextInput(
                        //       enabled: true,
                        //       hintText:
                        //       Translate.of(context).translate('flat'),
                        //       errorText: Translate.of(context).translate(_validHouseNo),
                        //       icon: Icon(Icons.clear),
                        //       controller: _textHouseFlatNoController,
                        //       focusNode: _focusHouseNo,
                        //       textInputAction: TextInputAction.next,
                        //       onChanged: (text) {
                        //         setState(() {
                        //           _validHouseNo = UtilValidator.validate(
                        //             data: _textStreetController.text,
                        //           );
                        //         });
                        //       },
                        //       onSubmitted: (text) {
                        //         UtilOther.fieldFocusChange(
                        //             context, _focusHouseNo, _focusEmail);
                        //       },
                        //       onTapIcon: () async {
                        //         await Future.delayed(Duration(milliseconds: 100));
                        //         _textHouseFlatNoController.clear();
                        //       },
                        //     )),
                      ],
                    ),
                  //    :
                  //     Padding(
                  //     padding:EdgeInsets.only(left:20.0,right: 20.0,),
                  //     child:
                  //     Text(
                  //       'Please enter valid Zipcode',
                  //       style: TextStyle(
                  //           fontFamily: 'Poppins',
                  //           fontWeight: FontWeight.w300,
                  //           fontSize: 12.0,
                  //           color: Colors.red
                  //       ),
                  //     )
                  // ),

                  //email
                  Container(margin: EdgeInsets.only(top:15.0,left:20.0,right:20.0),
                      child:
                      AppTextInput(
                        enabled: flagEmailEnabled,
                        hintText: Translate.of(context).translate('email'),
                        errorText: Translate.of(context).translate(_validEmail),
                        icon: Icon(Icons.clear),
                        keyboardType: TextInputType.emailAddress,
                        controller: _textEmailController,
                        focusNode: _focusEmail,

                        textInputAction: TextInputAction.next,
                        onChanged: (text) {
                          setState(() {
                            _validEmail = UtilValidator.validate(
                                data: _textEmailController.text,
                                type: ValidateType.email
                            );
                          });
                        },
                        onSubmitted: (text) {
                          UtilOther.fieldFocusChange(context, _focusEmail, _focusMobile);
                        },
                        onTapIcon: () async {
                          await Future.delayed(Duration(milliseconds: 100));
                          _textEmailController.clear();
                        },
                      )),

                  //mobile
                  Container(margin: EdgeInsets.only(top:15.0,left:20.0,right:20.0),
                      child:
                      AppTextInput(
                        enabled: flagPhoneEnabled,
                        hintText: Translate.of(context).translate('mobile'),
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

                  //api for registration of User
                  BlocBuilder<UserRegBloc,UserRegState>(builder: (context,register){
                    // return BlocListener<UserRegBloc,UserRegState>(listener: (context,state){
                    //   if (state is RegisterUserFail) {
                    //     _showMessage(
                    //       Translate.of(context).translate(state.msg),
                    //     );
                    //   }
                    //   if (state is RegisterUserSuccess) {
                    //     Scaffold.of(context).showSnackBar(SnackBar(content:Text('User Registered Successfully')));
                    //     Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MainNavigation()));
                    //   }

                    return
                      Padding(padding: EdgeInsets.all(40.0),
                        child:
                        AppButton(
                          onPressed: (){
                            _signUp();
                            // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MainNavigation()));
                          },
                          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(50))),
                          text: 'Register',
                          loading: register is FetchingUserRegister,
                          disableTouchWhenLoading: true,
                        )
                    );


                  })

                  //   Padding(padding: EdgeInsets.all(40.0),
                  //     child:
                  //     AppButton(
                  //       onPressed: (){
                  //         _signUp();
                  //         // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MainNavigation()));
                  //         },
                  //       shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(50))),
                  //       text: 'Register',
                  //       // loading: login is LoginLoading,
                  //       // disableTouchWhenLoading: true,
                  //     )
                  // )

                ],
              ),

            )),
      )
    );

  }

}