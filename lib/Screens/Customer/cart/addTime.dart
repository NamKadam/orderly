import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:orderly/Api/api.dart';
import 'package:orderly/Configs/image.dart';
import 'package:orderly/Configs/theme.dart';
import 'package:orderly/Utils/Utils.dart';
import 'package:orderly/Utils/translate.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

class AddTime extends StatelessWidget {
  static bool isCheckedCharged = false;
  static bool isCheckedfree = false;
  static bool confirmedFlag=false;
  static String dateTime = "";
  static String radioDay = '',
      deliveryType = '',
      deliverySlot = ''; //by default selected
  static var currentDate, selectedDate, time, chargedAmt;

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  void clearData() {
    AddTime.deliveryType = '';
    AddTime.deliverySlot = '';
    AddTime.dateTime = "";
    AddTime.chargedAmt = null;
    AddTime.currentDate = null;
    AddTime.selectedDate = null;
    AddTime.time = null;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return WillPopScope( //willpopscope is used for ios part to disable swipe where back button is used
        onWillPop: () async => false,
    child:
      Scaffold(
        key: _scaffoldKey,
        appBar: new AppBar(
          title:
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
          InkWell(
              onTap: () {
                if (AddTime.isCheckedCharged == false &&
                    AddTime.isCheckedfree == false) {
                  clearData();
                  print(radioDay);
                }
                Navigator.pop(context);
              },
              child: Icon(
                Icons.arrow_back_ios,
                color: AppTheme.textColor,
                size: 22.0,
              )),
              Text(
                'Choose Delivery Option',
                style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500,
                    fontSize: 17.0,
                    color: AppTheme.textColor),
              ),
              // Your widgets here
            ],
          ),

          // leading: InkWell(
          //     onTap: () {
          //       if (AddTime.isCheckedCharged == false &&
          //           AddTime.isCheckedfree == false) {
          //         clearData();
          //         print(radioDay);
          //       }
          //       Navigator.pop(context);
          //     },
          //     child: Icon(
          //       Icons.arrow_back_ios,
          //       color: AppTheme.textColor,
          //     )),
          backgroundColor: Colors.white,
          elevation: 0,
          automaticallyImplyLeading:false,

        ),
        body: TimeData(scaffoldKey: _scaffoldKey)));
  }
}

class TimeData extends StatefulWidget {
  var scaffoldKey = GlobalKey<ScaffoldState>();

  TimeData({Key key, @required this.scaffoldKey}) : super(key: key);

  _TimeDataState createState() => _TimeDataState();
}

class _TimeDataState extends State<TimeData> {
  String ShowchargedAmt = "", currentDate = "",calendardate="";

  //set date
  Future _selectDate() async {
    DateTime picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now().subtract(Duration(days: 0)),
      lastDate: DateTime(2025),
    );

    compareDates(picked);
    print(picked);

    if (picked != null)
      setState(() {
        AddTime.dateTime = DateFormat("yyyy-MM-dd").format(picked);
        // calendardate=DateFormat("yyyy-MM-dd").format(picked);
      });
  }

  void compareDates(DateTime picked) {
    var now = DateTime.now();
    AddTime.currentDate = DateTime(now.year, now.month, now.day);
    var month = DateFormat("MM").format(picked);
    var year = DateFormat("yyyy").format(picked);
    var day = DateFormat("dd").format(picked);
    AddTime.selectedDate = DateTime(int.parse(year), int.parse(month),
        int.parse(day)); //you can add today's date here
    //DateFormat import package intl
    AddTime.time = DateFormat('hh:mm a').format(DateTime.now());
    print("time:" + AddTime.time);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // AddTime.deliverySlot="0";
    getCharges();
    getCurrentDate();
  }

  //to get chargeable amt
  Future<void> getCharges() async {
    Uri url = Uri.parse(Api.GET_CHARGES);
    var response = await http.get(url);
    if (response.statusCode == 200) {
      final responseJson = json.decode(response.body);
      var charges = responseJson['charges'][0];
      AddTime.chargedAmt = charges['amount'].toString();
      ShowchargedAmt = AddTime.chargedAmt;
      AddTime.deliveryType = "0";
      AddTime.deliverySlot = "";
    }
    if(mounted){
      setState(() {});
    }

  }

  getCurrentDate() {
    var date = new DateTime.now().toString();
    var dateParse = DateTime.parse(date);
    // var formattedDate = new DateFormat('yyyy-MM-dd HH:mm').parse(date);
    // print(new DateFormat('dd MMM yyyy').format(DateTime.parse(date)));

    var formattedDate = "${dateParse.year}-${dateParse.month}-${dateParse.day}";
    setState(() {
      // currentDate = formattedDate.toString();
      // AddTime.currentDate=formattedDate.toString();
      currentDate = DateFormat('yyyy-MM-dd').format(dateParse);
      AddTime.time = DateFormat('hh:mm a').format(dateParse);
      print("currentDate:-" + currentDate);
    });
  }

  @override
  Widget build(BuildContext context) {
    //for check box
    Color getColor(Set<MaterialState> states) {
      const Set<MaterialState> interactiveStates = <MaterialState>{
        MaterialState.pressed,
        MaterialState.hovered,
        MaterialState.focused,
      };
      if (states.any(interactiveStates.contains)) {
        return Colors.white;
      }
      return Theme.of(context).primaryColor;
    }

    // TODO: implement build
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Card(
        elevation: 0.0,
        child: Padding(
            padding: EdgeInsets.all(10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Select Delivery Slot",
                  style: Theme.of(context).textTheme.caption.copyWith(
                      fontSize: 15.0,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textColor,
                      fontFamily: "Poppins"),
                ),

                //for chargeable
                Padding(
                    padding: EdgeInsets.only(top: 15.0),
                    child: Card(
                        elevation: 2.0,
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Checkbox(
                                    checkColor: Colors.white,
                                    fillColor:
                                        MaterialStateProperty.resolveWith(
                                            getColor),
                                    value: AddTime.isCheckedCharged,
                                    onChanged: (bool value) {
                                      getCharges();
                                      setState(() {
                                        AddTime.radioDay='';
                                        AddTime.dateTime='';
                                        AddTime.currentDate='';
                                        // // AddTime.currentDate=currentDate;
                                        AddTime.selectedDate=null;
                                        if(AddTime.isCheckedfree==true){
                                          AddTime.isCheckedfree=!AddTime.isCheckedfree;
                                        }

                                        AddTime.isCheckedCharged = value;



                                      });
                                    }),
                                Text(
                                  Translate.of(context).translate('chargeable delivery'),
                                  style: Theme.of(context)
                                      .textTheme
                                      .caption
                                      .copyWith(
                                          fontSize: 13.0,
                                          fontWeight: FontWeight.w500,
                                          color: AppTheme.textColor,
                                          fontFamily: "Poppins"),
                                ),

                                Padding(
                                    padding: EdgeInsets.only(right: 35.0),
                                    child: Text(
                                      "Chargeable \u{20B9}" + ShowchargedAmt,
                                      style: Theme.of(context)
                                          .textTheme
                                          .caption
                                          .copyWith(
                                              fontSize: 13.0,
                                              fontWeight: FontWeight.w500,
                                              color: Theme.of(context)
                                                  .primaryColor,
                                              fontFamily: "Poppins"),
                                    )),
                              ],
                            ),
                            if(AddTime.isCheckedCharged==true)
                            Padding(
                                padding: EdgeInsets.only(
                                    left: 10.0, right: 5.0, bottom: 10.0),
                                child: Row(
                                  children: [
                                    Text(
                                      "Scheduled delivery for - ",
                                      style: TextStyle(
                                          fontSize: 14.0,
                                          fontFamily: 'Poppins',
                                          fontWeight: FontWeight.w400,
                                          color: AppTheme.appColor),
                                    ),
                                    Text(
                                        DateFormat('dd MMM yyyy').format(
                                            DateTime.parse(currentDate))+" "+AddTime.time,
                                        style: TextStyle(
                                            fontSize: 14.0,
                                            fontFamily: 'Poppins',
                                            fontWeight: FontWeight.w400,
                                            color: AppTheme.textColor))
                                  ],
                                ))
                          ],
                        ))),
                //for planned
                Padding(
                    padding: EdgeInsets.only(top: 10.0),
                    child: Card(
                        elevation: 2.0,
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Checkbox(
                                    checkColor: Colors.white,
                                    fillColor:
                                        MaterialStateProperty.resolveWith(
                                            getColor),
                                    value: AddTime.isCheckedfree,
                                    onChanged: (bool value) {
                                      setState(() {
                                        if (AddTime.isCheckedCharged ==
                                            true) {
                                          AddTime.isCheckedCharged =
                                              !AddTime.isCheckedCharged;
                                        }
                                        AddTime.isCheckedfree = value;
                                        // AddTime.chargedAmt = null;
                                        //
                                        // AddTime.deliveryType = "1";
                                      });
                                    }),

                                Text(
                                  Translate.of(context)
                                      .translate('free delivery'),
                                  style: Theme.of(context)
                                      .textTheme
                                      .caption
                                      .copyWith(
                                          fontSize: 13.0,
                                          fontWeight: FontWeight.w500,
                                          color: AppTheme.textColor,
                                          fontFamily: "Poppins"),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(right: 16.0),
                                    child:Text(
                                  "Free",
                                  style: Theme.of(context)
                                      .textTheme
                                      .caption
                                      .copyWith(
                                          fontSize: 13.0,
                                          fontWeight: FontWeight.w500,
                                          color:
                                              Theme.of(context).primaryColor,
                                          fontFamily: "Poppins"),
                                )),
                              ],
                            ),
                            //choose date
                            if (AddTime.isCheckedfree == true)
                              Column(
                                children: [
                                  Padding(
                                      padding: EdgeInsets.only(
                                          left: 15.0, right: 15.0, top: 10.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            Translate.of(context)
                                                .translate('choose date'),
                                            style: Theme.of(context)
                                                .textTheme
                                                .caption
                                                .copyWith(
                                                    fontSize: 13.0,
                                                    fontWeight:
                                                        FontWeight.w500,
                                                    color: Theme.of(context)
                                                        .primaryColor,
                                                    fontFamily: "Poppins"),
                                          ),
                                          //date
                                          Row(
                                            children: [
                                              Text(
                                                AddTime.dateTime,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .caption
                                                    .copyWith(
                                                        fontSize: 13.0,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: AppTheme
                                                            .textColor,
                                                        fontFamily:
                                                            "Poppins"),
                                              ),
                                              SizedBox(
                                                width: 8.0,
                                              ),
                                              GestureDetector(
                                                child: Image.asset(
                                                  Images.calender,
                                                  height: 20.0,
                                                  width: 20.0,
                                                ),
                                                onTap: () {
                                                  widget.scaffoldKey.currentState.hideCurrentSnackBar();
                                                  _selectDate();
                                                  debugPrint("clicked");
                                                },
                                              )
                                            ],
                                          )
                                        ],
                                      )),
                                  //morning/evening day selection
                                  Padding(
                                    padding: EdgeInsets.only(top: 5.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                            padding: EdgeInsets.only(
                                                left: 15.0, top: 10.0),
                                            child: Text(
                                              // Translate.of(context).translate('choose date'),
                                              "Choose Delivery time",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .caption
                                                  .copyWith(
                                                      fontSize: 13.0,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: Theme.of(context)
                                                          .primaryColor,
                                                      fontFamily: "Poppins"),
                                            )),
                                        SizedBox(
                                          //used to remove vertical spacing between radiListTile
                                          height: 35.0,
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: Theme(
                                                    data: Theme.of(context)
                                                        .copyWith(
                                                      unselectedWidgetColor:
                                                          Theme.of(context)
                                                              .primaryColor,
                                                    ),
                                                    child: ListTileTheme(
                                                        horizontalTitleGap: 1,
                                                        //used to remove horizantal spacing between radio icon and text
                                                        child: RadioListTile(
                                                          dense: true,
                                                          activeColor: Theme
                                                                  .of(context)
                                                              .primaryColor,
                                                          groupValue: AddTime
                                                              .radioDay,
                                                          title: Text(
                                                            'Morning',
                                                            style: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .subtitle2
                                                                .copyWith(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                    color: AppTheme
                                                                        .textColor),
                                                          ),
                                                          value: 'Morning',
                                                          onChanged: (val) {
                                                            setState(() {
                                                              widget.scaffoldKey.currentState.hideCurrentSnackBar();
                                                              AddTime.radioDay =
                                                                  val;
                                                              AddTime.deliverySlot =
                                                                  "0"; //for morning
                                                            });
                                                          },
                                                        ))),
                                              ),
                                              // if(AddTime.radioDay=="Morning")
                                              Padding(
                                                  padding: EdgeInsets.only(
                                                      top: 10.0),
                                                  child: Text(
                                                    "7 am - 11 am",
                                                    style: TextStyle(
                                                        fontSize: 14.0,
                                                        fontFamily: 'Poppins',
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: AppTheme
                                                            .textColor),
                                                  ))
                                            ],
                                          ),
                                        ),
                                        //for evening
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Theme(
                                                  data: Theme.of(context)
                                                      .copyWith(
                                                    unselectedWidgetColor:
                                                        Theme.of(context)
                                                            .primaryColor,
                                                  ),
                                                  child: ListTileTheme(
                                                      horizontalTitleGap: 1,
                                                      child: RadioListTile(
                                                        dense: true,
                                                        activeColor:
                                                            Theme.of(context)
                                                                .primaryColor,
                                                        groupValue:
                                                            AddTime.radioDay,
                                                        title: Text(
                                                          'Evening',
                                                          style: Theme.of(
                                                                  context)
                                                              .textTheme
                                                              .subtitle2
                                                              .copyWith(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  color: AppTheme
                                                                      .textColor),
                                                        ),
                                                        value: 'Evening',
                                                        onChanged: (val) {
                                                          setState(() {
                                                            widget.scaffoldKey.currentState.hideCurrentSnackBar();

                                                            AddTime.radioDay =
                                                                val;
                                                            AddTime.deliverySlot =
                                                                "1"; //for evening
                                                            print("deliverySlot:-" +
                                                                AddTime
                                                                    .deliverySlot);
                                                          });
                                                        },
                                                      ))),
                                            ),

                                            // if(AddTime.radioDay=="Evening")
                                            Padding(
                                                padding: EdgeInsets.all(5.0),
                                                child: Text(
                                                  "5 pm - 9 pm",
                                                  style: TextStyle(
                                                      fontSize: 14.0,
                                                      fontFamily: 'Poppins',
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color:
                                                          AppTheme.textColor),
                                                ))
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              )
                          ],
                        ))),
                //add time
                Padding(
                    padding:
                        EdgeInsets.only(left: 20.0, right: 20.0, top: 30.0),
                    child:
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          side: BorderSide(
                              color: Theme.of(context).primaryColor, width: 1),
                          primary: (AddTime.isCheckedCharged == true ||AddTime.isCheckedfree == true)?
                          Theme.of(context).primaryColor:Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50.0))),
                      // shape: shape,
                      onPressed: () {

                        if (AddTime.isCheckedCharged == true) {
                          AddTime.radioDay='';
                          AddTime.dateTime='';
                          AddTime.selectedDate=null;
                          AddTime.currentDate=currentDate;
                          AddTime.confirmedFlag=true;
                          Navigator.pop(context);
                        } else if (AddTime.isCheckedfree == true) {
                          print("deleiverySlot:-" + AddTime.deliverySlot);
                          AddTime.chargedAmt = null;
                          AddTime.deliveryType = "1";

                          if (AddTime.dateTime != "") {
                            if (AddTime.currentDate.compareTo(AddTime.selectedDate) == 0) {
                              if (AddTime.radioDay != '') {
                                if (AddTime.time.contains("PM") && AddTime.deliverySlot == "0") {
                                  AddTime.confirmedFlag=false;

                                  widget.scaffoldKey.currentState.showSnackBar(
                                      SnackBar(
                                        // duration:const Duration(microseconds: 2),
                                          content: Text(
                                              "Please choose valid delivery time")));
                                } else {
                                  AddTime.confirmedFlag=true;
                                  Navigator.pop(context);
                                }
                              } else {
                                AddTime.confirmedFlag=false;

                                widget.scaffoldKey.currentState.showSnackBar(
                                    SnackBar(
                                        // duration:const Duration(microseconds: 2),
                                        content: Text(
                                            "Please select delivery slot")));
                              }
                            } else {
                              AddTime.confirmedFlag=true;
                              Navigator.pop(context);
                            }
                          } else {
                            AddTime.confirmedFlag=false;

                            widget.scaffoldKey.currentState.showSnackBar(
                                SnackBar(

                                    content:
                                        Text("Please choose delivery date")));
                          }
                        } else {
                          AddTime.confirmedFlag=false;

                          widget.scaffoldKey.currentState.showSnackBar(SnackBar(
                              // duration:const Duration(microseconds: 2),
                              content: Text(
                                  "Please choose atleast 1 delivery Option")));
                        }
                        // if(isCheckedfree!=true && isCheckedCharged!=true){
                        //   _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text("Please choose atleast 1 delivery Option")));
                        // }else
                        //   if(isCheckedCharged=true && _dateTime==""){
                        //   Navigator.pop(context,_dateTime);
                        //   }else if(_dateTime==""){
                        //     _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text("Please choose delivery date")));
                        //   }else {
                        //     Navigator.pop(context, _dateTime);
                        //   }
                      },
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Padding(
                              padding: EdgeInsets.all(10.0),
                              child: Text(
                                'Confirm Delivery Option',
                                style: Theme.of(context)
                                    .textTheme
                                    .button
                                    .copyWith(
                                        color: (AddTime.isCheckedCharged == true || AddTime.isCheckedfree == true)?Colors.white:AppTheme.textColor,
                                        fontWeight: FontWeight.w600),
                              )),
                        ],
                      ),
                    ))
              ],
            )),
      ),
    );
  }
}

class AddTimeData {
  String deliverySlot,
      deliveryType,
      dateTime = "",
      radioDay = '',
      chargedAmt = '';
  bool isCheckedCharged = false, isCheckedFree = false;
  var currentDate, selectedDate, time;

  AddTimeData(
      {this.deliverySlot,
      this.deliveryType,
      this.dateTime,
      this.radioDay,
      this.chargedAmt,
      this.currentDate,
      this.selectedDate,
      this.isCheckedCharged,
      this.isCheckedFree});
}
