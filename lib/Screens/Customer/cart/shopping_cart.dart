import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:orderly/Configs/image.dart';
import 'package:orderly/Configs/theme.dart';
import 'package:orderly/Screens/Customer/cart/cart_list_item.dart';
import 'package:orderly/Utils/routes.dart';
import 'package:orderly/Widgets/app_button.dart';

class ShoppingCart extends StatefulWidget{
  _ShoppingCartState createState()=>_ShoppingCartState();
}

class _ShoppingCartState extends State<ShoppingCart>{

  ScrollController _scrollController = ScrollController();
  String date="",currentDate="";
  final _scaffoldKey = GlobalKey<ScaffoldState>();


  Future<void> showPlaceOrderBottomDialog(BuildContext context) async{
    showModalBottomSheet<void>(
        backgroundColor: Colors.transparent,
        context: context,
        builder: (BuildContext context) {
          return Container(child:Align(alignment: Alignment.bottomCenter,
              child:
              new ClipRect(
                child: new BackdropFilter(
                  filter: new ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                  child: new Container(
                      width: MediaQuery.of(context).size.width,
                      height: 220.0,
                      decoration: new BoxDecoration(
                          color: Colors.grey.shade200.withOpacity(0.5)
                      ),
                      child:
                      Container(
                          margin: EdgeInsets.all(20.0),
                          child:
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              //delivery time
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Choose Delivery Time",
                                    style: Theme.of(context).textTheme.caption.copyWith(
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.w600,
                                        color: Theme.of(context).primaryColor,
                                        fontFamily: "Poppins"),
                                  ),
                                  Text(
                                    "date",
                                    style: Theme.of(context).textTheme.caption.copyWith(
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.w600,
                                        color: AppTheme.textColor,
                                        fontFamily: "Poppins"),
                                  ),
                                ],
                              ),
                              // subtotal
                              Padding(padding: EdgeInsets.only(top:5.0),
                                  child:Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,

                                    children: [
                                      Text(
                                        "SubTotal",
                                        style: Theme.of(context).textTheme.caption.copyWith(
                                            fontSize: 14.0,
                                            fontWeight: FontWeight.w600,
                                            color: AppTheme.textColor,
                                            fontFamily: "Poppins"),
                                      ),
                                      Text(
                                        "Choose Delivery Time",
                                        style: Theme.of(context).textTheme.caption.copyWith(
                                            fontSize: 14.0,
                                            fontWeight: FontWeight.w600,
                                            color: AppTheme.textColor,
                                            fontFamily: "Poppins"),
                                      ),
                                    ],
                                  )),
                              //convinience fee
                              Padding(padding: EdgeInsets.only(top:5.0),
                                  child:Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,

                                    children: [
                                      Text(
                                        "Convinience Fee",
                                        style: Theme.of(context).textTheme.caption.copyWith(
                                            fontSize: 12.0,
                                            fontWeight: FontWeight.w400,
                                            color: AppTheme.textColor,
                                            fontFamily: "Poppins"),
                                      ),
                                      Text(
                                        "\$ 75.00",
                                        style: Theme.of(context).textTheme.caption.copyWith(
                                            fontSize: 12.0,
                                            fontWeight: FontWeight.w400,
                                            color: AppTheme.textColor,
                                            fontFamily: "Poppins"),
                                      ),
                                    ],
                                  )),
                              //Total
                              Padding(padding: EdgeInsets.only(top:5.0,bottom:15.0),
                                  child:Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,

                                    children: [
                                      Text(
                                        "Total",
                                        style: Theme.of(context).textTheme.caption.copyWith(
                                            fontSize: 14.0,
                                            fontWeight: FontWeight.w600,
                                            color: AppTheme.textColor,
                                            fontFamily: "Poppins"),
                                      ),
                                      Text(
                                        "\$ 75.00",
                                        style: Theme.of(context).textTheme.caption.copyWith(
                                            fontSize: 14.0,
                                            fontWeight: FontWeight.w600,
                                            color: AppTheme.textColor,
                                            fontFamily: "Poppins"),
                                      ),
                                    ],
                                  )),
                              Padding(padding: EdgeInsets.only(top:15.0),
                                  child:
                                  AppButton(
                                    onPressed: (){
                                      // _signUp();
                                      // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MainNavigation()));

                                    },
                                    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(50))),
                                    text: 'PLACE ORDER',
                                    // loading: login is LoginLoading,
                                    // disableTouchWhenLoading: true,
                                  ))
                            ],
                          )


                      )
                  ),
                ),
              )));
    }
    );
  }

  getCurrentDate(){
    var date = new DateTime.now().toString();
    var dateParse = DateTime.parse(date);
    var formattedDate = "${dateParse.day}/${dateParse.month}/${dateParse.year}";
    setState(() {
      currentDate = formattedDate.toString() ;
      print("currentDate:-"+currentDate);
    });

  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentDate();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      key: _scaffoldKey,
        appBar: new AppBar(
          title: Text('Shopping Cart',style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
            fontSize: 18.0,
            color: AppTheme.textColor
          ),),
          leading: InkWell(
              onTap: (){
                Navigator.pop(context);
                // showPlaceOrderBottomDialog(context);
              },
              child:Icon(Icons.arrow_back_ios,color: AppTheme.textColor,)
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body:Container(
          child: Stack(
            children: <Widget>[
              ListView.separated(
                  controller: _scrollController,
                  physics: const AlwaysScrollableScrollPhysics(),
                  separatorBuilder: (context, index) {
                    return SizedBox(
                      height: 0.0,
                    );
                  },
                  // itemCount: state.members.length,
                  // itemCount: memberlist.length,
                  itemCount: 10,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                        onTap: (){
                          // Navigator.push(
                          //     context,
                          //     MaterialPageRoute(
                          //         builder: (context) =>
                          //         new MemberDetails(userListData:memberlist[index])));

                        },
                        child:
                        // CartListItem(memberlist[index])
                        CartListItem()
                    );
                  }),
              //   return MembersList(memberlist[index]);
              // }),

              Align(alignment: Alignment.bottomCenter,
              child:
              new ClipRect(
                child: new BackdropFilter(
                  filter: new ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                  child: new Container(
                    width: MediaQuery.of(context).size.width,
                    height: 220.0,
                    decoration: new BoxDecoration(
                        color: Colors.grey.shade200.withOpacity(0.5)
                    ),
                    child:
                      Container(
                          margin: EdgeInsets.all(20.0),
                          child:
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              //delivery time
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  GestureDetector(
                                   onTap:() async{
                                     final result = await Navigator.pushNamed(context, Routes.addTime);
                                     print("result:-"+result);
                                     print("currentDate:-"+currentDate);

                                     if(result==""){
                                       setState(() {
                                         date=currentDate;
                                       });
                                     }else{
                                       setState(() {
                                         date=result;
                                       });
                                      }
                                     },
                                      child:
                                      Text(
                                    "Choose Delivery Time",
                                    style: Theme.of(context).textTheme.caption.copyWith(
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.w600,
                                        color: Theme.of(context).primaryColor,
                                        fontFamily: "Poppins"),
                                  )),
                                  Text(
                                   date,
                                    style: Theme.of(context).textTheme.caption.copyWith(
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.w600,
                                        color: AppTheme.textColor,
                                        fontFamily: "Poppins"),
                                  ),
                                ],
                              ),
                              // subtotal
                              Padding(padding: EdgeInsets.only(top:5.0),
                                  child:Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,

                                    children: [
                                      Text(
                                        "SubTotal",
                                        style: Theme.of(context).textTheme.caption.copyWith(
                                            fontSize: 14.0,
                                            fontWeight: FontWeight.w600,
                                            color: AppTheme.textColor,
                                            fontFamily: "Poppins"),
                                      ),
                                      Text(
                                        "Choose Delivery Time",
                                        style: Theme.of(context).textTheme.caption.copyWith(
                                            fontSize: 14.0,
                                            fontWeight: FontWeight.w600,
                                            color: AppTheme.textColor,
                                            fontFamily: "Poppins"),
                                      ),
                                    ],
                                  )),
                              //convinience fee
                              Padding(padding: EdgeInsets.only(top:5.0),
                                  child:Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,

                                    children: [
                                      Text(
                                        "Convinience Fee",
                                        style: Theme.of(context).textTheme.caption.copyWith(
                                            fontSize: 12.0,
                                            fontWeight: FontWeight.w400,
                                            color: AppTheme.textColor,
                                            fontFamily: "Poppins"),
                                      ),
                                      Text(
                                        "\$ 75.00",
                                        style: Theme.of(context).textTheme.caption.copyWith(
                                            fontSize: 12.0,
                                            fontWeight: FontWeight.w400,
                                            color: AppTheme.textColor,
                                            fontFamily: "Poppins"),
                                      ),
                                    ],
                                  )),
                              //Total
                              Padding(padding: EdgeInsets.only(top:5.0,bottom:15.0),
                                  child:Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,

                                    children: [
                                      Text(
                                        "Total",
                                        style: Theme.of(context).textTheme.caption.copyWith(
                                            fontSize: 14.0,
                                            fontWeight: FontWeight.w600,
                                            color: AppTheme.textColor,
                                            fontFamily: "Poppins"),
                                      ),
                                      Text(
                                        "\$ 75.00",
                                        style: Theme.of(context).textTheme.caption.copyWith(
                                            fontSize: 14.0,
                                            fontWeight: FontWeight.w600,
                                            color: AppTheme.textColor,
                                            fontFamily: "Poppins"),
                                      ),
                                    ],
                                  )),
                              Padding(padding: EdgeInsets.only(top:15.0),
                                  child:
                                  AppButton(
                                    onPressed: (){
                                      if(date==""){
                                        _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text("Please Choose Delivery time")));
                                      }
                                      // _signUp();
                                      // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MainNavigation()));
                                    },
                                    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(50))),
                                    text: 'PLACE ORDER',
                                    // loading: login is LoginLoading,
                                    // disableTouchWhenLoading: true,
                                  ))
                            ],
                          )


                      )
                  ),
                ),
              )),
            ],
          ),
        )

    );


    // return Scaffold(
    //   appBar: new AppBar(
    //     title: Text('Shopping Cart',style: TextStyle(
    //       fontFamily: 'Poppins',
    //       fontWeight: FontWeight.w600,
    //       fontSize: 18.0,
    //       color: AppTheme.textColor
    //     ),),
    //     leading: InkWell(
    //         onTap: (){
    //           Navigator.pop(context);
    //         },
    //         child:Icon(Icons.arrow_back_ios,color: AppTheme.textColor,)
    //     ),
    //     backgroundColor: Colors.transparent,
    //     elevation: 0,
    //   ),
    //   body: Container(
    //     child: Column(
    //       children: [
    //         Expanded(
    //           child:
    //           ListView.separated(
    //               controller: _scrollController,
    //               physics: const AlwaysScrollableScrollPhysics(),
    //               separatorBuilder: (context, index) {
    //                 return SizedBox(
    //                   height: 0.0,
    //                 );
    //               },
    //               // itemCount: state.members.length,
    //               // itemCount: memberlist.length,
    //               itemCount: 10,
    //               itemBuilder: (context, index) {
    //                 return GestureDetector(
    //                     onTap: (){
    //                       // Navigator.push(
    //                       //     context,
    //                       //     MaterialPageRoute(
    //                       //         builder: (context) =>
    //                       //         new MemberDetails(userListData:memberlist[index])));
    //
    //                     },
    //                     child:
    //                     // CartListItem(memberlist[index])
    //                     CartListItem()
    //                 );
    //               }),
    //           //   return MembersList(memberlist[index]);
    //           // }),
    //         ),
    //
    //         Container(
    //          margin: EdgeInsets.all(20.0),
    //          child:
    //              Column(
    //                mainAxisAlignment: MainAxisAlignment.start,
    //                crossAxisAlignment: CrossAxisAlignment.start,
    //                children: [
    //                  //delivery time
    //                  Row(
    //                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //                    children: [
    //                      Text(
    //                        "Choose Delivery Time",
    //                        style: Theme.of(context).textTheme.caption.copyWith(
    //                            fontSize: 14.0,
    //                            fontWeight: FontWeight.w600,
    //                            color: Theme.of(context).primaryColor,
    //                            fontFamily: "Poppins"),
    //                      ),
    //                      Text(
    //                        "date",
    //                        style: Theme.of(context).textTheme.caption.copyWith(
    //                            fontSize: 14.0,
    //                            fontWeight: FontWeight.w600,
    //                            color: AppTheme.textColor,
    //                            fontFamily: "Poppins"),
    //                      ),
    //                    ],
    //                  ),
    //                  // subtotal
    //            Padding(padding: EdgeInsets.only(top:5.0),
    //              child:Row(
    //                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //
    //                    children: [
    //                      Text(
    //                        "SubTotal",
    //                        style: Theme.of(context).textTheme.caption.copyWith(
    //                            fontSize: 14.0,
    //                            fontWeight: FontWeight.w600,
    //                            color: AppTheme.textColor,
    //                            fontFamily: "Poppins"),
    //                      ),
    //                      Text(
    //                        "Choose Delivery Time",
    //                        style: Theme.of(context).textTheme.caption.copyWith(
    //                            fontSize: 14.0,
    //                            fontWeight: FontWeight.w600,
    //                            color: AppTheme.textColor,
    //                            fontFamily: "Poppins"),
    //                      ),
    //                    ],
    //                  )),
    //                  //convinience fee
    //            Padding(padding: EdgeInsets.only(top:5.0),
    //              child:Row(
    //                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //
    //                    children: [
    //                      Text(
    //                        "Convinience Fee",
    //                        style: Theme.of(context).textTheme.caption.copyWith(
    //                            fontSize: 12.0,
    //                            fontWeight: FontWeight.w400,
    //                            color: AppTheme.textColor,
    //                            fontFamily: "Poppins"),
    //                      ),
    //                      Text(
    //                        "\$ 75.00",
    //                        style: Theme.of(context).textTheme.caption.copyWith(
    //                            fontSize: 12.0,
    //                            fontWeight: FontWeight.w400,
    //                            color: AppTheme.textColor,
    //                            fontFamily: "Poppins"),
    //                      ),
    //                    ],
    //                  )),
    //                  //Total
    //            Padding(padding: EdgeInsets.only(top:5.0,bottom:15.0),
    //              child:Row(
    //                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //
    //                    children: [
    //                      Text(
    //                        "Total",
    //                        style: Theme.of(context).textTheme.caption.copyWith(
    //                            fontSize: 14.0,
    //                            fontWeight: FontWeight.w600,
    //                            color: AppTheme.textColor,
    //                            fontFamily: "Poppins"),
    //                      ),
    //                      Text(
    //                        "\$ 75.00",
    //                        style: Theme.of(context).textTheme.caption.copyWith(
    //                            fontSize: 14.0,
    //                            fontWeight: FontWeight.w600,
    //                            color: AppTheme.textColor,
    //                            fontFamily: "Poppins"),
    //                      ),
    //                    ],
    //                  )),
    //                  Padding(padding: EdgeInsets.only(top:15.0),
    //                      child:
    //                  AppButton(
    //                    onPressed: (){
    //                      // _signUp();
    //                      // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MainNavigation()));
    //                    },
    //                    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(50))),
    //                    text: 'PLACE ORDER',
    //                    // loading: login is LoginLoading,
    //                    // disableTouchWhenLoading: true,
    //                  ))
    //                ],
    //              )
    //
    //
    //        )
    //
    //
    //       ],
    //     ),
    //   ),
    // );
  }

}