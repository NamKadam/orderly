import 'package:flutter/material.dart';
import 'package:orderly/Configs/image.dart';
import 'package:orderly/Configs/theme.dart';
import 'package:orderly/Utils/translate.dart';
import 'package:intl/intl.dart';


class AddTime extends StatefulWidget {
  _AddTimeState createState() => _AddTimeState();
}

class _AddTimeState extends State<AddTime> {
  bool isCheckedCharged = false;
  bool isCheckedfree = false;
  String _dateTime="",finalDate="";
  String radioDay='Morning'; //by default selected
  final _scaffoldKey = GlobalKey<ScaffoldState>();


  //set date
  Future _selectDate() async {
    DateTime picked = await showDatePicker(
      context: context,
      initialDate: new DateTime.now(),
      firstDate: new DateTime(1970),
      lastDate: new DateTime(2022),
    );
    //DateFormat import package intl
    if(picked != null)
      setState(() => _dateTime = DateFormat("dd/MM/yyyy").format(picked));
  }




  @override
  void initState() {
    // TODO: implement initState
    super.initState();
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
    return Scaffold(
      key: _scaffoldKey,
        appBar: new AppBar(
          title: Text(
            'Add Time',
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
          width: MediaQuery.of(context).size.width,
          child: Card(
            elevation: 0.0,
            child: Padding(
                padding: EdgeInsets.all(15.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Choose Delivery Option",
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
                            child: Row(
                              children: [
                                Checkbox(
                                    checkColor: Colors.white,
                                    fillColor:
                                        MaterialStateProperty.resolveWith(
                                            getColor),
                                    value: isCheckedCharged,
                                    onChanged: (bool value) {
                                      setState(() {
                                        if(isCheckedfree==true){
                                          isCheckedfree=!isCheckedfree;
                                        }
                                        isCheckedCharged = value;
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
                                Text(
                                  "Chargeable \$150",
                                  style: Theme.of(context)
                                      .textTheme
                                      .caption
                                      .copyWith(
                                          fontSize: 13.0,
                                          fontWeight: FontWeight.w500,
                                          color: Theme.of(context).primaryColor,
                                          fontFamily: "Poppins"),
                                ),
                              ],
                            ))),
                    //for planned
                    Padding(
                        padding: EdgeInsets.only(top: 10.0),
                        child: Card(
                            elevation: 2.0,
                            child: 
                                Padding(
                                  padding: EdgeInsets.all(5.0),
                                    child:
                            Column(
                              children: [
                                Row(
                                  children: [
                                    Checkbox(
                                        checkColor: Colors.white,
                                        fillColor:
                                        MaterialStateProperty.resolveWith(
                                            getColor),
                                        value: isCheckedfree,
                                        onChanged: (bool value) {
                                          setState(() {
                                            if(isCheckedCharged==true){
                                              isCheckedCharged=!isCheckedCharged;
                                            }
                                            isCheckedfree = value;
                                          });
                                        }),
                                    Text(
                                      Translate.of(context).translate('free delivery'),
                                      style: Theme.of(context)
                                          .textTheme
                                          .caption
                                          .copyWith(
                                          fontSize: 13.0,
                                          fontWeight: FontWeight.w500,
                                          color: AppTheme.textColor,
                                          fontFamily: "Poppins"),
                                    ),
                                     Text(
                                      "Free",
                                      style: Theme.of(context)
                                          .textTheme
                                          .caption
                                          .copyWith(
                                          fontSize: 13.0,
                                          fontWeight: FontWeight.w500,
                                          color: Theme.of(context).primaryColor,
                                          fontFamily: "Poppins"),
                                    ),
                                  ],
                                ),
                                //choose date
                                Padding(
                                  padding: EdgeInsets.only(left:15.0,right: 15.0,top:10.0),
                                    child:Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                  Text(
                                    Translate.of(context).translate('choose date'),
                                    style: Theme.of(context)
                                        .textTheme
                                        .caption
                                        .copyWith(
                                        fontSize: 13.0,
                                        fontWeight: FontWeight.w500,
                                        color: Theme.of(context).primaryColor,
                                        fontFamily: "Poppins"),
                                  ),
                                  //date
                                      Row(
                                        children: [
                                          Text(
                                            _dateTime,
                                            style: Theme.of(context)
                                                .textTheme
                                                .caption
                                                .copyWith(
                                                fontSize: 13.0,
                                                fontWeight: FontWeight.w500,
                                                color: AppTheme.textColor,
                                                fontFamily: "Poppins"),
                                          ),
                                          SizedBox(width: 8.0,),
                                          GestureDetector(

                                            child: Image.asset(Images.calender, height: 20.0,
                                              width: 20.0,),
                                            onTap: (){
                                              _selectDate();
                                              debugPrint("clicked");
                                            },
                                          )
                                        ],
                                      )

                                ],)),
                                //morning/evenig day selection
                                Padding(
                                  padding: EdgeInsets.only(top:5.0,bottom:5.0),
                                  child:
                                  Row(
                                    children: [
                                      Expanded(
                                        child:
                                        Theme(
                                            data: Theme.of(context).copyWith(
                                              unselectedWidgetColor: Theme.of(context).primaryColor,
                                            ),
                                            child:RadioListTile(
                                              activeColor: Theme.of(context).primaryColor,
                                              groupValue: radioDay,
                                              title: Text('Morning',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .subtitle2
                                                    .copyWith(fontWeight: FontWeight.w500,color: AppTheme.textColor),),
                                              value: 'Morning',
                                              onChanged: (val) {

                                                setState(() {
                                                  radioDay = val;
                                                });
                                              },
                                            )),
                                      ),

                                      Expanded(
                                        child:
                                        Theme(
                                            data: Theme.of(context).copyWith(
                                              unselectedWidgetColor: Theme.of(context).primaryColor,
                                            ),
                                            child:RadioListTile(
                                              activeColor: Theme.of(context).primaryColor,
                                              groupValue: radioDay,
                                              title: Text('Evening',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .subtitle2
                                                    .copyWith(fontWeight: FontWeight.w500,color: AppTheme.textColor),),
                                              value: 'Female',
                                              onChanged: (val) {
                                                setState(() {
                                                  radioDay = val;
                                                });
                                              },
                                            )),
                                      )
                                    ],
                                  ),

                                ),
                              ],
                            ),
                                )
                            )),
                    //add time
                    Padding(padding: EdgeInsets.only(left:20.0,right:20.0,top:30.0),

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
                            if(isCheckedCharged==true){
                              Navigator.pop(context,_dateTime);
                            }else if(isCheckedfree==true && _dateTime!=""){
                              Navigator.pop(context,_dateTime);

                            }else{
                              _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text("Please choose atleast 1 delivery Option")));

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
                              Padding(padding: EdgeInsets.all(10.0),child:Text(
                                'Add Time',
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
                  ],
                )),
          ),
        ));
  }
}
