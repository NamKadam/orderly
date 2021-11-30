import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:orderly/Blocs/inventory/bloc.dart';
import 'package:orderly/Configs/image.dart';
import 'package:orderly/Configs/theme.dart';
import 'package:orderly/Models/imageFile.dart';
import 'package:orderly/Models/model_invent_list.dart';
import 'package:orderly/Utils/application.dart';
import 'package:orderly/Utils/translate.dart';
import 'package:orderly/Utils/utilOther.dart';
import 'package:orderly/Utils/validate.dart';
import 'package:orderly/Widgets/app_button.dart';
import 'package:orderly/Widgets/app_text_input.dart';

enum AppState {
  free,
  picked,
  cropped,
}
class AddEditInventoryItem extends StatefulWidget{
  String flagAddEdit;
  Inventory inventoryData;

  AddEditInventoryItem({Key key,@required this.flagAddEdit,@required this.inventoryData}):super(key: key);

  _AddEditInventoryItemState createState()=>_AddEditInventoryItemState();
}

class _AddEditInventoryItemState extends State<AddEditInventoryItem>{
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  File _image;
  ImageFile imageFile;
  final picker = ImagePicker();
  AppState state;

  final _textTitleNameController = TextEditingController();
  final _textDescController = TextEditingController();
  // final _textCatController = TextEditingController();
  final _textRateHourController = TextEditingController();
  final _textNoOfItemsController = TextEditingController();
  final _focusTitle = FocusNode();
  final _focusDesc = FocusNode();
  // final _focusCategory = FocusNode();
  final _focusRate = FocusNode();
  final _focusNoOfItems = FocusNode();

  var _validTitle,_validDesc,_validRate,_validItems;
  // var _validCategory;
  InventoryBloc _inventoryBloc;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _inventoryBloc=BlocProvider.of<InventoryBloc>(context);
    if(widget.flagAddEdit=="1"){
      getData();
    }
  }

  void getData(){
    _textTitleNameController.text=widget.inventoryData.productName;
    _textDescController.text=widget.inventoryData.productDesc;
    _textRateHourController.text=widget.inventoryData.ratePerHour;
    _textNoOfItemsController.text=widget.inventoryData.productQty.toString();
  }

  ///On sign up
  void _ValidateItem() {
    UtilOther.hiddenKeyboard(context);
    setState(() {
      _validTitle = UtilValidator.validate(
        data: _textTitleNameController.text,
      );
      _validDesc = UtilValidator.validate(
        data: _textDescController.text,
      );
      // _validCategory = UtilValidator.validate(
      //   data: _textCatController.text,
      // );
      _validRate = UtilValidator.validate(
          data: _textRateHourController.text,
          // type:ValidateType.email
      );
      _validItems = UtilValidator.validate(
        data: _textNoOfItemsController.text,
        // type: ValidateType.phone,
      );


    });
    // if(imageFile==null){
    //   _showMessage("Please upload your image ");
    // }else

    if (_validTitle == null && _validDesc==null&&_validRate==null&&_validItems==null) {
      if(widget.flagAddEdit=="0") {
        _inventoryBloc.add(OnAddInventoryItem(
            title: _textTitleNameController.text,
            desc: _textDescController.text,
            rate: _textRateHourController.text,
            qty: _textNoOfItemsController.text
        ));
      }else{
        _inventoryBloc.add(OnEditInventoryItem(
          prodId: widget.inventoryData.productId.toString(),
            title: _textTitleNameController.text,
            desc: _textDescController.text,
            rate: _textRateHourController.text,
            qty: _textNoOfItemsController.text
        ));
      }

    }
  }

  Widget _buildAvatar() {
    if (_image!=null) {
      return Container(
        width: 120,
        height: 120,
        margin: EdgeInsets.only(top:20.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
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
            Theme.of(context).primaryColor,  // red as border color
          ),
          color:
          Colors.white,
        ),
        child:
        ClipRRect(
          // child: Image.asset(
          //   Images.producerActive,
          //   fit: BoxFit.fill,
          // ),
          borderRadius: BorderRadius.circular(10),
        ),
    );
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
        // mImageFile.image = croppedFile;
        // print(mImageFile.image.path);
        // state = AppState.cropped;
        _image = croppedFile;
        imageFile.imagePath=_image.path;
      });
      Navigator.pop(context);
    }
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

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      key: _scaffoldKey,
      appBar: new AppBar(
        title: Text(
          widget.flagAddEdit=="0"
              ?
          'Add Item'
          :
          "Edit Items",
          style: TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w600,
              fontSize: 18.0,
              color: AppTheme.textColor),
        ),
        leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(
              Icons.arrow_back_ios,
              color: AppTheme.textColor,
            )),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body:BlocBuilder<InventoryBloc,InventoryState>(builder: (context,state){
        if(state is InventoryAddedSuccess){
          Fluttertoast.showToast(msg: "Inventory Added Successfully");
          Navigator.pop(context,widget.flagAddEdit);

        }
        if(state is InventoryUpdatedSuccess){
          Fluttertoast.showToast(msg: "Inventory Updated Successfully");

          Navigator.pop(context,widget.flagAddEdit);
        }
        return Container(
          padding: EdgeInsets.only(left: 20, right: 20),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //image
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child:
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
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
                //title
                Container(margin: EdgeInsets.only(top:25.0,left:20.0,right:20.0),
                    child:AppTextInput(
                      enabled: true,
                      hintText: Translate.of(context).translate('input_title'),
                      errorText: Translate.of(context).translate(_validTitle),
                      icon: Icon(Icons.clear),
                      controller: _textTitleNameController,
                      focusNode: _focusTitle,
                      textInputAction: TextInputAction.next,
                      onChanged: (text) {
                        setState(() {
                          _validTitle = UtilValidator.validate(
                            data: _textTitleNameController.text,
                          );
                        });
                      },
                      onSubmitted: (text) {
                        UtilOther.fieldFocusChange(context, _focusTitle, _focusDesc);
                      },
                      onTapIcon: () async {
                        await Future.delayed(Duration(milliseconds: 100));
                        _textTitleNameController.clear();
                      },
                    )),

                //description
                Container(margin: EdgeInsets.only(top:15.0,left:20.0,right:20.0),
                    child:AppTextInput(
                      enabled: true,
                      hintText: Translate.of(context).translate('input_desc'),
                      errorText: Translate.of(context).translate(_validDesc),
                      icon: Icon(Icons.clear),
                      controller: _textDescController,
                      focusNode: _focusDesc,
                      textInputAction: TextInputAction.next,
                      onChanged: (text) {
                        setState(() {
                          _validDesc = UtilValidator.validate(
                            data: _textDescController.text,

                          );
                        });
                      },
                      onSubmitted: (text) {
                        UtilOther.fieldFocusChange(context, _focusDesc, _focusRate);
                      },
                      onTapIcon: () async {
                        await Future.delayed(Duration(milliseconds: 100));
                        _textDescController.clear();
                      },
                    )),
                //category
                // Container(margin: EdgeInsets.only(top:15.0,left:20.0,right:20.0),
                //     child:AppTextInput(
                //       enabled: false,
                //       icon: Icon(Icons.clear),
                //       controller: _textCatController,
                //       textInputAction: TextInputAction.next,
                //
                //     )),
                //rate
                Container(margin: EdgeInsets.only(top:15.0,left:20.0,right:20.0),
                    child:AppTextInput(
                      enabled: true,
                      hintText: Translate.of(context).translate('input_rate'),
                      errorText: Translate.of(context).translate(_validRate),
                      icon: Icon(Icons.clear),
                      keyboardType: TextInputType.number,

                      controller: _textRateHourController,
                      focusNode: _focusRate,
                      textInputAction: TextInputAction.next,
                      onChanged: (text) {
                        setState(() {
                          _validRate = UtilValidator.validate(
                            data: _textRateHourController.text,
                          );
                        });
                      },
                      onSubmitted: (text) {
                        UtilOther.fieldFocusChange(context, _focusRate, _focusNoOfItems);
                      },
                      onTapIcon: () async {
                        await Future.delayed(Duration(milliseconds: 100));
                        _textRateHourController.clear();
                      },
                    )),
                //no of items
                Container(margin: EdgeInsets.only(top:15.0,left:20.0,right:20.0),
                    child:AppTextInput(
                      enabled: true,
                      hintText: Translate.of(context).translate('input_items'),
                      errorText: Translate.of(context).translate(_validItems),
                      icon: Icon(Icons.clear),
                      keyboardType: TextInputType.number,

                      controller: _textNoOfItemsController,
                      focusNode: _focusNoOfItems,
                      textInputAction: TextInputAction.next,
                      onChanged: (text) {
                        setState(() {
                          _validItems = UtilValidator.validate(
                            data: _textNoOfItemsController.text,
                          );
                        });
                      },

                      onTapIcon: () async {
                        await Future.delayed(Duration(milliseconds: 100));
                        _textNoOfItemsController.clear();
                      },
                    )),

                widget.flagAddEdit=="0"
                    ?
                Padding(padding: EdgeInsets.all(40.0),
                    child:
                      AppButton(
                        onPressed: (){
                          _ValidateItem();
                          // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MainNavigation()));
                        },
                        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(50))),
                        text: 'Add',
                        // loading: addInventory is InventoryAddEditLoading,
                        disableTouchWhenLoading: true,
                      )


                )
                    :
                Padding(
                    padding: EdgeInsets.only(left:20.0,right: 20.0,top:45.0),
                    child:
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                            child:
                            SizedBox(
                                height: 45.0,
                                width: MediaQuery.of(context).size.width,
                                child:
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      side: BorderSide(color: Theme.of(context).primaryColor, width: 1),
                                      primary: Colors.white,

                                      shape:  const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(50)),
                                      )),
                                  // shape: shape,
                                  onPressed: (){
                                    Navigator.pop(context);
                                  },
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Text(
                                        "Cancel",
                                        style: Theme.of(context)
                                            .textTheme
                                            .button
                                            .copyWith(color: AppTheme.appColor, fontWeight: FontWeight.w600),
                                      ),
                                    ],
                                  ),
                                ))),
                        SizedBox(width: 10.0,),
                        Expanded(
                            child:
                           AppButton(
                                  onPressed: () {
                                    _ValidateItem();
                                  },
                                  shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(50))),
                                  text: 'Save',
                                  // loading: editInventory is InventoryAddEditLoading,

                                ),


                        )


                      ],
                    ))
              ],
            ),
          ),
        );
      })

    );
  }

}