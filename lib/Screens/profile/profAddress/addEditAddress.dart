import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:orderly/Api/api.dart';
import 'package:orderly/Blocs/address/address_bloc.dart';
import 'package:orderly/Blocs/address/address_event.dart';
import 'package:orderly/Blocs/address/address_state.dart';
import 'package:orderly/Blocs/mycart/bloc.dart';
import 'package:orderly/Configs/theme.dart';
import 'package:orderly/Models/model_address.dart';
import 'package:orderly/Models/zipcode/postalcode.dart';
import 'package:orderly/Utils/Utils.dart';
import 'package:orderly/Utils/application.dart';
import 'package:orderly/Utils/translate.dart';
import 'package:orderly/Utils/utilOther.dart';
import 'package:orderly/Utils/validate.dart';
import 'package:orderly/Widgets/app_button.dart';
import 'package:orderly/Widgets/app_text_input.dart';
import 'package:http/http.dart' as http;

class AddEditAddress extends StatefulWidget {
  final String flagAddEdit;
  final Address addressData;

  const AddEditAddress({Key key, @required this.flagAddEdit,@required this.addressData}) : super(key: key);

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
  final _focusEmail = FocusNode();

  var _validFirstName,
      _validLastName,
      _validMobile,
      _validZip,
      _validEmail,
      address;
  dynamic postResultList = <Result>[];
  bool _apiCall = false;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  AddressBloc _addressBloc;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _addressBloc = BlocProvider.of<AddressBloc>(context);

    if (widget.flagAddEdit == "1") //for edit
    {
      getUserData();
    }
  }

  void getUserData() {
    _textFirstNameController.text = widget.addressData.userName.split(" ").first;
    _textLastNameController.text = widget.addressData.userName.split(" ").last;
    _textEmailController.text = widget.addressData.emailId;
    _textZipController.text = widget.addressData.zipcode;
    _textMobileController.text = widget.addressData.mobile;
    address="  "+widget.addressData.address;
  }

  void _callAPIForPincode() {
    Api.fetchPincode(http.Client(), _textZipController.text).then(
        (value) => {
              setState(() {
                print('Value' + value.status.toString());
                // postOfficeList = value.postOffice;
                postResultList = value.result;
                if (postResultList.length <= 0) {
                  _validZip = 'Please enter valid Zipcode';
                } else {
                  _validZip = "";
                  address =
                  '${postResultList[0].postalCode}, ${postResultList[0].state},${postResultList[0].country}, ${postResultList[0].postalLocation}';
                }
                print(value.result);
              })
            }, onError: (error) {
      setState(() {
        _apiCall = false;
        print('Value $error');
        postResultList = [];
      });
    });
  }

  void _ValidateAddress(String flagAddEdit) {
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
    if (_validFirstName == null && _validLastName==null&&_validZip==null&&_validEmail==null&&_validMobile==null) {
       if(flagAddEdit=="0"){
         _addressBloc.add(OnAddAdress(
             fullName: _textFirstNameController.text.toString()+" "+_textLastNameController.text.toString(),
             mobile: _textMobileController.text.toString(),
             email: _textEmailController.text.toString(),
             zipcode: _textZipController.text.toString(),
             address:address,
             city: postResultList[0].district,
             state:postResultList[0].state,
             country: postResultList[0].country
         ));
       }else{
         _addressBloc.add(OnEditAdress(
             fullName: _textFirstNameController.text.toString()+" "+_textLastNameController.text.toString(),
             mobile: _textMobileController.text.toString(),
             email: _textEmailController.text.toString(),
             zipcode: _textZipController.text.toString(),
             address:address,
             city:postResultList.length>0? postResultList[0].district:widget.addressData.city,
             state:postResultList.length>0?postResultList[0].state:widget.addressData.state,
             country:postResultList.length>0?postResultList[0].country:widget.addressData.country,
           addressId: widget.addressData.uaId.toString()
         ));
       }

    }
  }

  Future<void> _showMessage(String message) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            "Address",
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
                "Ok",
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
        key: _scaffoldKey,
        appBar: new AppBar(
          title: Text(
            Translate.of(context).translate('address'),
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
        body: Container(
            child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              //first name
              Container(
                  margin: EdgeInsets.only(top: 25.0, left: 20.0, right: 20.0),
                  child: AppTextInput(
                    enabled: true,
                    hintText:
                    Translate.of(context).translate('input_first_name'),
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
                      UtilOther.fieldFocusChange(
                          context, _focusName, _focusLastName);
                    },
                    onTapIcon: () async {
                      await Future.delayed(Duration(milliseconds: 100));
                      _textFirstNameController.clear();
                    },
                  )),

              //lastName
              Container(
                  margin: EdgeInsets.only(top: 15.0, left: 20.0, right: 20.0),
                  child: AppTextInput(
                    enabled: true,
                    hintText:
                    Translate.of(context).translate('input_last_name'),
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
                      UtilOther.fieldFocusChange(
                          context, _focusLastName, _focusZip);
                    },
                    onTapIcon: () async {
                      await Future.delayed(Duration(milliseconds: 100));
                      _textLastNameController.clear();
                    },
                  )),

              //zip
              Container(
                  margin: EdgeInsets.only(top: 15.0, left: 20.0, right: 20.0),
                  child: AppTextInput(
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
                      if (text.length >= 5) {
                        _apiCall = true;
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
                      UtilOther.fieldFocusChange(
                          context, _focusZip, _focusMobile);
                      print('submitted zip');
                    },
                    onTapIcon: () async {
                      await Future.delayed(Duration(milliseconds: 100));
                      _textZipController.clear();
                      setState(() {
                        _apiCall = false;
                        postResultList = [];
                        _validZip = UtilValidator.validate(
                          data: _textZipController.text,
                        );
                      });
                    },
                  )),

              if (postResultList.length > 0 || widget.flagAddEdit=="1")
                Padding(
                    padding: EdgeInsets.only(
                      top: postResultList.length > 0 ? 0 : 10,
                      left: 20.0,
                      right: 20.0,
                    ),
                    child: Container(
                        height: 50.0,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          border:
                              Border.all(color: Theme.of(context).primaryColor),
                          color: AppTheme.verifyPhone.withOpacity(0.4),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            // '   ${postResultList[0].postalCode}, ${postResultList[0].state},${postResultList[0].country}, ${postResultList[0].postalLocation}',
                           "  "+address,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 14.0,
                            ),
                          ),
                        ))),
              //address
              //email
              Container(
                  margin: EdgeInsets.only(top: 15.0, left: 20.0, right: 20.0),
                  child: AppTextInput(
                    enabled: true,
                    hintText: Translate.of(context).translate('input_email'),
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
                            type: ValidateType.email);
                      });
                    },
                    onSubmitted: (text) {
                      UtilOther.fieldFocusChange(
                          context, _focusEmail, _focusMobile);
                    },
                    onTapIcon: () async {
                      await Future.delayed(Duration(milliseconds: 100));
                      _textEmailController.clear();
                    },
                  )),
              //mobile
              Container(
                  margin: EdgeInsets.only(top: 15.0, left: 20.0, right: 20.0),
                  child: AppTextInput(
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
              BlocBuilder<AddressBloc, AddressState>(
                  builder: (context, address) {
                return BlocListener<AddressBloc, AddressState>(
                    listener: (context, state) {
                      if (state is Add_AddressSuccess) {
                        _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text("Address added successfully")));
                        Navigator.pop(context,widget.flagAddEdit);
                       // _showMessage("Address added successfully.");

                      }

                      if (state is Update_AddressSuccess) {
                        _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text("Address updated successfully")));
                        Navigator.pop(context,widget.flagAddEdit);
                        // _showMessage("Address added successfully.");

                      }
                    },
                    child: Padding(
                        padding:
                            EdgeInsets.only(left: 30.0, right: 20.0, top: 30.0),
                        child: AppButton(
                          onPressed: () {
                            _ValidateAddress(widget.flagAddEdit);
                          },
                          shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(50))),
                          text: widget.flagAddEdit == "0" ? "Add" : "Update",
                          loading: address is AddressLoading,
                          disableTouchWhenLoading: true,
                        )));
              })
            ],
          ),
        )));
  }
}
