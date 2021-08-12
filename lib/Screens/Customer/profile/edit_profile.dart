import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:orderly/Configs/image.dart';
import 'package:orderly/Configs/theme.dart';
import 'package:orderly/Models/imageFile.dart';
import 'package:orderly/Screens/mainNavigation.dart';
import 'package:orderly/Utils/translate.dart';
import 'package:orderly/Utils/utilOther.dart';
import 'package:orderly/Utils/validate.dart';
import 'package:orderly/Widgets/app_button.dart';
import 'package:orderly/Widgets/app_text_input.dart';

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
  final _focusName = FocusNode();
  final _focusLastName = FocusNode();
  final _focusEmail = FocusNode();
  final _focusMobile = FocusNode();
  final _focusZip = FocusNode();

  var _validFirstName,_validLastName,_validEmail,_validMobile,_validZip;


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

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Edit Profile'
          ,style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Container(
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
                Container(margin: EdgeInsets.only(top:25.0,left:20.0,right:20.0),
                    child:AppTextInput(
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
                      hintText: Translate.of(context).translate('input_zipcode'),
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
                        setState(() {
                          _validZip = UtilValidator.validate(
                            data: _textZipController.text,
                          );
                        });
                      },
                      onSubmitted: (text) {
                        UtilOther.fieldFocusChange(context, _focusZip, _focusEmail);
                      },
                      onTapIcon: () async {
                        await Future.delayed(Duration(milliseconds: 100));
                        _textZipController.clear();
                      },
                    )),

                //email

                Container(margin: EdgeInsets.only(top:15.0,left:20.0,right:20.0),
                    child:
                    AppTextInput(
                      hintText: Translate.of(context).translate('input_email'),
                      errorText: Translate.of(context).translate(_validEmail),
                      icon: Icon(Icons.clear),
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
                Container(margin: EdgeInsets.only(top:15.0,left:20.0,right:20.0),
                    child:
                    AppTextInput(
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

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    //cancel
                    Expanded(
                        child:Padding(padding: EdgeInsets.only(left:20.0,right:20.0,top:50.0),

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
                      child:Padding(padding: EdgeInsets.only(left:20.0,right:20.0,top:50.0),
                        child:
                        AppButton(
                          onPressed: (){
                            // _signUp();
                            // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MainNavigation()));
                          },
                          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(50))),
                          text: 'Save',
                          // loading: login is LoginLoading,
                          // disableTouchWhenLoading: true,
                        )
                    )
                    )
                  ],
                )



              ],
            ),

          )),
    );
  }

}