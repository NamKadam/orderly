import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:orderly/Api/api.dart';
import 'package:orderly/Blocs/profile/bloc.dart';
import 'package:orderly/Blocs/profile/profile_bloc.dart';
import 'package:orderly/Configs/image.dart';
import 'package:orderly/Configs/theme.dart';
import 'package:orderly/Models/imageFile.dart';
import 'package:orderly/Models/zipcode/postalcode.dart';
import 'package:orderly/Screens/mainNavigation.dart';
import 'package:orderly/Utils/Utils.dart';
import 'package:orderly/Utils/application.dart';
import 'package:orderly/Utils/translate.dart';
import 'package:orderly/Utils/utilOther.dart';
import 'package:orderly/Utils/validate.dart';
import 'package:orderly/Widgets/app_button.dart';
import 'package:orderly/Widgets/app_text_input.dart';
import 'package:http/http.dart' as http;

class EditProfile extends StatefulWidget{

  _EditProfileState createState()=>_EditProfileState();

}

class _EditProfileState extends State<EditProfile>{
  File _image;
  ImageFile imageFile;
  final picker = ImagePicker();

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
  final _focusStreet = FocusNode();
  final _focusHouseNo = FocusNode();
  dynamic postResultList = <Result>[];

  var _validFirstName,_validLastName,_validEmail,_validMobile,_validZip,_validAddress,address;
  ProfileBloc _profileBloc;
  bool _apiCall = false;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _profileBloc=BlocProvider.of<ProfileBloc>(context);
    getUserData();
  }

  void getUserData(){
    _textFirstNameController.text=Application.user.firstName.toString();
    _textLastNameController.text=Application.user.lastName.toString();
    _textEmailController.text=Application.user.emailId.toString()=="null"?"":Application.user.emailId.toString();
    _textMobileController.text=Application.user.mobile.toString();
    address=Application.user.address;
    _textAddressController.text=Application.user.address;
    _textZipController.text=Application.user.zipcode.toString()!="null"?Application.user.zipcode.toString():"";

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
            color:
            Theme.of(context).primaryColor,  // red as border color
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
            color:
            Theme.of(context).primaryColor,  // red as border color
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

        _image = croppedFile;
        imageFile.imagePath=_image.path;
      });
      Navigator.pop(context);
    }
  }

  void _ValidateProf() {
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
    //  if(Application.user.userType!="0"){ //for fleet
    //    if (_validFirstName == null && _validLastName==null&&_validEmail==null) {
    //
    //      _profileBloc.add(EditFleetProf(
    //          firstName: _textFirstNameController.text.toString(),
    //          lastName: _textLastNameController.text.toString(),
    //          email: _textEmailController.text.toString(),
    //
    //      ));
    //    }
    //
    //  }else{ //for customer
       if (_validFirstName == null && _validLastName==null&&_validZip==null&&_validEmail==null&&_validMobile==null) {

         _profileBloc.add(EditProf(
                      firstName: _textFirstNameController.text.toString(),
                      lastName: _textLastNameController.text.toString(),
                      email: _textEmailController.text.toString(),
                      address:address,
                      zipcode: _textZipController.text,
                      mobile: _textMobileController.text
           ));
       // }
     }
  }


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return
      Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text('Edit Profile'
              , style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          body:
      Container(
          padding: EdgeInsets.only(left: 20, right: 20),
          child: SingleChildScrollView(
            child:Column(
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
                Container(margin: EdgeInsets.only(top:25.0),
                    child:AppTextInput(
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
                Container(margin: EdgeInsets.only(top:15.0,),
                    child:AppTextInput(
                      hintText:Translate.of(context).translate('last_name'),
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
                Container(margin: EdgeInsets.only(top:15.0),
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
                if(_textAddressController.text!="")
                  Column(
                    children: [
                      // Padding(
                      //     padding:EdgeInsets.only(top:postResultList.length>0?0:10
                      //       ,),
                      //     child:
                      //
                      //     Container(
                      //         height: 50.0,
                      //         alignment: Alignment.center,
                      //         decoration: BoxDecoration(
                      //           border: Border.all(color: Theme.of(context).primaryColor),
                      //           color: AppTheme.verifyPhone.withOpacity(0.4),
                      //           borderRadius: BorderRadius.circular(10),
                      //         ),
                      //         child:Align(
                      //           alignment: Alignment.centerLeft,
                      //           child:
                      //           Text(
                      //           "  "+address
                      //             , maxLines: 1,
                      //             overflow: TextOverflow.ellipsis,
                      //             style: TextStyle(fontWeight: FontWeight.w400,fontSize: 14.0,),),
                      //         ))),
                      //updated address part
                      Container(
                          margin: EdgeInsets.only(top:15.0),
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
                      // //street no
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
                //email
              Application.user.signUpType=="gmail"|| Application.user.signUpType=="facebook"
                ?
                Container(margin: EdgeInsets.only(top:15.0),
                    child:
                    AppTextInput(
                      hintText: Translate.of(context).translate('email'),
                      errorText: Translate.of(context).translate(_validEmail),
                      icon: Icon(Icons.clear),
                      enabled: false,
                      controller: _textEmailController,
                      focusNode: _focusEmail,
                      textInputAction: TextInputAction.next,
                      onChanged: (text) {
                        setState(() {
                          _validEmail = UtilValidator.validate(
                            data: _textEmailController.text,
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
                    ))
              :
              Container(margin: EdgeInsets.only(top:15.0,),
                  child:
                  AppTextInput(
                    hintText: Translate.of(context).translate('email'),
                    errorText: Translate.of(context).translate(_validEmail),
                    icon: Icon(Icons.clear),
                    enabled: true,
                    controller: _textEmailController,
                    focusNode: _focusEmail,
                    textInputAction: TextInputAction.next,
                    onChanged: (text) {
                      setState(() {
                        _validEmail = UtilValidator.validate(
                          data: _textEmailController.text,
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
                Container(margin: EdgeInsets.only(top:15.0,),
                    child:
                    AppTextInput(
                      enabled: Application.user.signUpType=="phone"?false:true,
                      hintText:Translate.of(context).translate('mobile'),
                      errorText:Translate.of(context).translate(_validMobile),
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

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    //cancel
                    Expanded(
                        child:Padding(padding: EdgeInsets.only(left:20.0,right:20.0,top:50.0,bottom: 10.0),

                            child:ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  side: BorderSide(color: Theme.of(context).primaryColor, width: 1),
                                  primary: Colors.white,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(50.0)
                                  )
                              ),
                              // shape: shape,
                              onPressed: (){
                                Navigator.pop(context);
                              },
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Padding(padding: EdgeInsets.all(10.0),child:Text(
                                    'Cancel',
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
                      child:Padding(padding: EdgeInsets.only(left:20.0,right:20.0,top:50.0,bottom: 10.0),
                      child:  BlocBuilder<ProfileBloc,ProfileState>(builder: (context,profile){
                        return BlocListener<ProfileBloc,ProfileState>(listener: (context,state){
                        if(state is EditProfSuccess){Application.user.mobile=state.user.mobile;
                        Application.user.emailId=state.user.emailId;
                        Application.user.firstName=state.user.firstName;
                        Application.user.lastName=state.user.lastName;
                        Fluttertoast.showToast(msg: "Profile updated successfully.");

                        Navigator.pop(context,"0");
                        }
                        },
                        child:
                      AppButton(
                      onPressed: (){
                      _ValidateProf();
                      },
                      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(50))),
                      text: 'Save',
                      loading: profile is FetchEditProf,
                      disableTouchWhenLoading: false,
                      )

                      );
                    })
                ))
                  ],
                )
              ],
            ),


    )));
  }

}