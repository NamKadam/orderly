import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:orderly/Configs/image.dart';
import 'package:orderly/Configs/theme.dart';
import 'package:orderly/Utils/translate.dart';
import 'package:orderly/Widgets/app_button.dart';



class ClaimsFilter extends StatefulWidget {
  _ClaimsFilterState createState() => _ClaimsFilterState();
}

class ClaimsOrderStatusTimeFilter {
  String name;
  int index;

  ClaimsOrderStatusTimeFilter({this.name, this.index});
}

class _ClaimsFilterState extends State<ClaimsFilter> {

  int claimId=1,orderId=1;
  String radioClaimItem = 'Recieved';
  List<ClaimsOrderStatusTimeFilter> claimOrdersList = [
    ClaimsOrderStatusTimeFilter(
      index: 1,
      name: 'Received',
    ),
    ClaimsOrderStatusTimeFilter(
      index: 2,
      name: 'Refund',
    ),
    ClaimsOrderStatusTimeFilter(
      index: 3,
      name: 'Both',
    ),
  ];

  String radioItem = 'Last Week';
  List<ClaimsOrderStatusTimeFilter> OrderList = [
    ClaimsOrderStatusTimeFilter(
      index: 1,
      name: 'Last Week',
    ),
    ClaimsOrderStatusTimeFilter(
      index: 2,
      name: 'Last 30 days',
    ),
    ClaimsOrderStatusTimeFilter(
      index: 3,
      name: 'Last 60 days',
    ),
    ClaimsOrderStatusTimeFilter(
      index: 4,
      name: '2020',
    ),
    ClaimsOrderStatusTimeFilter(
      index: 5,
      name: 'Older',
    ),
  ];
  //claimsType
  Widget ClaimsType(){
    return Card(
        color: Colors.white,
        elevation: 0.0,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                  padding: EdgeInsets.only(left: 15.0, right: 15.0, top: 10.0),
                  child: Text(
                    'Claim Type',
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontSize: 14.0,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w400,
                    ),
                  )),
              Padding(
                padding: EdgeInsets.all(10.0),
                child: Card(
                  elevation: 5.0,
                  child: Column(
                    children:
                    // [
                    claimOrdersList.map((data) =>
                        Theme(
                          data: Theme.of(context).copyWith(
                            unselectedWidgetColor:
                            Theme.of(context).primaryColor,
                          ),
                          child: RadioListTile(

                            activeColor: Theme.of(context).primaryColor,
                            title: Text(
                              "${data.name}",
                              style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14.0,
                                  fontFamily: 'Poppins',
                                  color: AppTheme.textColor),
                              // )
                            ),
                            // secondary: IconButton(
                            //     onPressed: () {},
                            //     icon: Image.asset(Images.arrow,
                            //         height: 15.0, width: 15.0)),
                            //for trailing icon
                            value: data.index,
                            groupValue: claimId,
                            onChanged: (val) {
                              setState(() {
                                radioClaimItem = data.name;
                                claimId = data.index;
                                print(claimId);
                              });
                            },
                          ),
                        )).toList(),

                    // radio 1

                    //   Theme(
                    //       data: Theme.of(context).copyWith(
                    //         unselectedWidgetColor:
                    //         Theme.of(context).primaryColor,
                    //       ),
                    //       child: RadioListTile<ClaimsType>(
                    //         activeColor: Theme.of(context).primaryColor,
                    //         title: Text(
                    //           Translate.of(context).translate('received'),
                    //           style: TextStyle(
                    //               fontWeight: FontWeight.w400,
                    //               fontFamily: 'Poppins',
                    //               fontSize: 14.0,
                    //               color: AppTheme.textColor),
                    //           // )
                    //         ),
                    //         // Row(
                    //         //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //         //
                    //         //   children: [
                    //         //     // Padding(
                    //         //     //     padding: EdgeInsets.only(left:15.0),
                    //         //     //     child:
                    //         //     Text(
                    //         //       Translate.of(context)
                    //         //           .translate('my_order'),
                    //         //       style: TextStyle(
                    //         //           fontWeight: FontWeight.w400,
                    //         //           fontFamily: 'Poppins',
                    //         //           fontSize: 14.0,
                    //         //           color: AppTheme.textColor),
                    //         //       // )
                    //         //     ),
                    //         //
                    //         //     IconButton(
                    //         //         onPressed: () {},
                    //         //         icon: Image.asset(Images.arrow,
                    //         //             height: 15.0, width: 15.0))
                    //         //   ],
                    //         // ),
                    //         // secondary:  IconButton(
                    //         //     onPressed: () {},
                    //         //     icon: Image.asset(Images.arrow,
                    //         //         height: 15.0, width: 15.0)),
                    //         value: ClaimsType.received,
                    //         groupValue: _claimsType,
                    //         onChanged: (ClaimsType value) {
                    //           setState(() {
                    //             _claimsType = value;
                    //           });
                    //         },
                    //       )),
                    //   Divider(
                    //     height: 0.5,
                    //     color: Colors.black26,
                    //   ),
                    //   Theme(
                    //       data: Theme.of(context).copyWith(
                    //         unselectedWidgetColor:
                    //         Theme.of(context).primaryColor,
                    //       ),
                    //       child: RadioListTile<ClaimsType>(
                    //         activeColor: Theme.of(context).primaryColor,
                    //         title: Text(
                    //           Translate.of(context).translate('refund'),
                    //           style: TextStyle(
                    //               fontWeight: FontWeight.w400,
                    //               fontFamily: 'Poppins',
                    //               fontSize: 14.0,
                    //               color: AppTheme.textColor),
                    //           // )
                    //         ),
                    //         // Row(
                    //         //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //         //
                    //         //   children: [
                    //         //     // Padding(
                    //         //     //     padding: EdgeInsets.only(left:15.0),
                    //         //     //     child:
                    //         //     Text(
                    //         //       Translate.of(context)
                    //         //           .translate('my_order'),
                    //         //       style: TextStyle(
                    //         //           fontWeight: FontWeight.w400,
                    //         //           fontFamily: 'Poppins',
                    //         //           fontSize: 14.0,
                    //         //           color: AppTheme.textColor),
                    //         //       // )
                    //         //     ),
                    //         //
                    //         //     IconButton(
                    //         //         onPressed: () {},
                    //         //         icon: Image.asset(Images.arrow,
                    //         //             height: 15.0, width: 15.0))
                    //         //   ],
                    //         // ),
                    //         // secondary:  IconButton(
                    //         //     onPressed: () {},
                    //         //     icon: Image.asset(Images.arrow,
                    //         //         height: 15.0, width: 15.0)),
                    //         value: ClaimsType.refunded,
                    //         groupValue: _claimsType,
                    //         onChanged: (ClaimsType value) {
                    //           setState(() {
                    //             _claimsType = value;
                    //           });
                    //         },
                    //       )),
                    //   Divider(
                    //     height: 0.5,
                    //     color: Colors.black26,
                    //   ),
                    //   //radio 2
                    //   Theme(
                    //       data: Theme.of(context).copyWith(
                    //         unselectedWidgetColor:
                    //         Theme.of(context).primaryColor,
                    //       ),
                    //       child: RadioListTile<ClaimsType>(
                    //         activeColor: Theme.of(context).primaryColor,
                    //         title: Text(
                    //           Translate.of(context).translate('both'),
                    //           style: TextStyle(
                    //               fontWeight: FontWeight.w400,
                    //               fontSize: 14.0,
                    //               fontFamily: 'Poppins',
                    //               color: AppTheme.textColor),
                    //           // )
                    //         ),
                    //         // Row(
                    //         //   mainAxisAlignment:
                    //         //       MainAxisAlignment.spaceBetween,
                    //         //   children: [
                    //         //     // Padding(
                    //         //     //     padding: EdgeInsets.only(left:15.0),
                    //         //     //     child:
                    //         //     Text(
                    //         //       Translate.of(context)
                    //         //           .translate('my_order'),
                    //         //       style: TextStyle(
                    //         //           fontWeight: FontWeight.w400,
                    //         //           fontFamily: 'Poppins',
                    //         //           color: AppTheme.textColor),
                    //         //       // )
                    //         //     ),
                    //         //
                    //         //     IconButton(
                    //         //         onPressed: () {},
                    //         //         icon: Image.asset(Images.arrow,
                    //         //             height: 15.0, width: 15.0))
                    //         //   ],
                    //         // ),
                    //         // secondary:  IconButton(
                    //         //     onPressed: () {},
                    //         //     icon: Image.asset(Images.arrow,
                    //         //         height: 15.0, width: 15.0)), //for trailing icon
                    //         value: ClaimsType.both,
                    //         groupValue: _claimsType,
                    //         onChanged: (ClaimsType value) {
                    //           setState(() {
                    //             _claimsType = value;
                    //           });
                    //         },
                    //       )),
                    // ],
                  ),
                ),
              )
            ]));
  }

  //for ordeer type
  Widget OrderType(){
    return Card(
        color: Colors.white,
        elevation: 0.0,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                  padding: EdgeInsets.only(left: 15.0, right: 15.0, top: 10.0),
                  child: Text(
                    'Order Time Filter',
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontSize: 14.0,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w400,
                    ),
                  )),
              Padding(
                padding: EdgeInsets.all(10.0),
                child: Card(
                  elevation: 5.0,
                  child: Column(
                    children:
                    OrderList.map((data) =>
                        Theme(
                          data: Theme.of(context).copyWith(
                            unselectedWidgetColor:
                            Theme.of(context).primaryColor,
                          ),
                          child: RadioListTile(
                            activeColor: Theme.of(context).primaryColor,
                            title: Text(
                              "${data.name}",
                              style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14.0,
                                  fontFamily: 'Poppins',
                                  color: AppTheme.textColor),
                              // )
                            ),
                            secondary: IconButton(
                                onPressed: () {},
                                icon: Image.asset(Images.arrow,
                                    height: 15.0, width: 15.0)),
                            //for trailing icon
                            value: data.index,
                            groupValue: orderId,
                            onChanged: (val) {
                              setState(() {
                                radioItem = data.name;
                                orderId = data.index;
                              });
                            },
                          ),
                        )).toList(),

                    // radio 1

                    // Theme(
                    //     data: Theme.of(context).copyWith(
                    //       unselectedWidgetColor:
                    //       Theme.of(context).primaryColor,
                    //     ),
                    //     child: RadioListTile<OrderTimeFilter>(
                    //       activeColor: Theme.of(context).primaryColor,
                    //       title: Text(
                    //         Translate.of(context).translate('lastWeek'),
                    //         style: TextStyle(
                    //             fontWeight: FontWeight.w400,
                    //             fontFamily: 'Poppins',
                    //             fontSize: 14.0,
                    //             color: AppTheme.textColor),
                    //         // )
                    //       ),
                    //       // Row(
                    //       //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //       //
                    //       //   children: [
                    //       //     // Padding(
                    //       //     //     padding: EdgeInsets.only(left:15.0),
                    //       //     //     child:
                    //       //     Text(
                    //       //       Translate.of(context)
                    //       //           .translate('my_order'),
                    //       //       style: TextStyle(
                    //       //           fontWeight: FontWeight.w400,
                    //       //           fontFamily: 'Poppins',
                    //       //           fontSize: 14.0,
                    //       //           color: AppTheme.textColor),
                    //       //       // )
                    //       //     ),
                    //       //
                    //       //     IconButton(
                    //       //         onPressed: () {},
                    //       //         icon: Image.asset(Images.arrow,
                    //       //             height: 15.0, width: 15.0))
                    //       //   ],
                    //       // ),
                    //       // secondary:  IconButton(
                    //       //     onPressed: () {},
                    //       //     icon: Image.asset(Images.arrow,
                    //       //         height: 15.0, width: 15.0)),
                    //       value: OrderTimeFilter.lastWeek,
                    //       groupValue: _orderTimeFilter,
                    //       onChanged: (OrderTimeFilter value) {
                    //         setState(() {
                    //           _orderTimeFilter = value;
                    //         });
                    //       },
                    //     )),
                    // Divider(
                    //   height: 0.5,
                    //   color: Colors.black26,
                    // ),
                    // Theme(
                    //     data: Theme.of(context).copyWith(
                    //       unselectedWidgetColor:
                    //       Theme.of(context).primaryColor,
                    //     ),
                    //     child: RadioListTile<OrderTimeFilter>(
                    //       activeColor: Theme.of(context).primaryColor,
                    //       title: Text(
                    //         Translate.of(context).translate('last30days'),
                    //         style: TextStyle(
                    //             fontWeight: FontWeight.w400,
                    //             fontFamily: 'Poppins',
                    //             fontSize: 14.0,
                    //             color: AppTheme.textColor),
                    //         // )
                    //       ),
                    //       // Row(
                    //       //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //       //
                    //       //   children: [
                    //       //     // Padding(
                    //       //     //     padding: EdgeInsets.only(left:15.0),
                    //       //     //     child:
                    //       //     Text(
                    //       //       Translate.of(context)
                    //       //           .translate('my_order'),
                    //       //       style: TextStyle(
                    //       //           fontWeight: FontWeight.w400,
                    //       //           fontFamily: 'Poppins',
                    //       //           fontSize: 14.0,
                    //       //           color: AppTheme.textColor),
                    //       //       // )
                    //       //     ),
                    //       //
                    //       //     IconButton(
                    //       //         onPressed: () {},
                    //       //         icon: Image.asset(Images.arrow,
                    //       //             height: 15.0, width: 15.0))
                    //       //   ],
                    //       // ),
                    //       // secondary:  IconButton(
                    //       //     onPressed: () {},
                    //       //     icon: Image.asset(Images.arrow,
                    //       //         height: 15.0, width: 15.0)),
                    //       value: OrderTimeFilter.days30,
                    //       groupValue: _orderTimeFilter,
                    //       onChanged: (OrderTimeFilter value) {
                    //         setState(() {
                    //           _orderTimeFilter = value;
                    //         });
                    //       },
                    //     )),
                    // Divider(
                    //   height: 0.5,
                    //   color: Colors.black26,
                    // ),
                    // //radio 2
                    // Theme(
                    //     data: Theme.of(context).copyWith(
                    //       unselectedWidgetColor:
                    //       Theme.of(context).primaryColor,
                    //     ),
                    //     child: RadioListTile<OrderTimeFilter>(
                    //       activeColor: Theme.of(context).primaryColor,
                    //       title: Text(
                    //         Translate.of(context).translate('last60days'),
                    //         style: TextStyle(
                    //             fontWeight: FontWeight.w400,
                    //             fontSize: 14.0,
                    //             fontFamily: 'Poppins',
                    //             color: AppTheme.textColor),
                    //         // )
                    //       ),
                    //       // Row(
                    //       //   mainAxisAlignment:
                    //       //       MainAxisAlignment.spaceBetween,
                    //       //   children: [
                    //       //     // Padding(
                    //       //     //     padding: EdgeInsets.only(left:15.0),
                    //       //     //     child:
                    //       //     Text(
                    //       //       Translate.of(context)
                    //       //           .translate('my_order'),
                    //       //       style: TextStyle(
                    //       //           fontWeight: FontWeight.w400,
                    //       //           fontFamily: 'Poppins',
                    //       //           color: AppTheme.textColor),
                    //       //       // )
                    //       //     ),
                    //       //
                    //       //     IconButton(
                    //       //         onPressed: () {},
                    //       //         icon: Image.asset(Images.arrow,
                    //       //             height: 15.0, width: 15.0))
                    //       //   ],
                    //       // ),
                    //       // secondary:  IconButton(
                    //       //     onPressed: () {},
                    //       //     icon: Image.asset(Images.arrow,
                    //       //         height: 15.0, width: 15.0)), //for trailing icon
                    //       value: OrderTimeFilter.days60,
                    //       groupValue: _orderTimeFilter,
                    //       onChanged: (OrderTimeFilter value) {
                    //         setState(() {
                    //           _orderTimeFilter = value;
                    //           print("value" + _orderTimeFilter.toString());
                    //         });
                    //       },
                    //     )),
                    // Divider(
                    //   height: 0.5,
                    //   color: Colors.black26,
                    // ),
                    // //radio 3
                    // Theme(
                    //     data: Theme.of(context).copyWith(
                    //       unselectedWidgetColor:
                    //       Theme.of(context).primaryColor,
                    //     ),
                    //     child: RadioListTile<OrderTimeFilter>(
                    //       activeColor: Theme.of(context).primaryColor,
                    //       title: Text(
                    //         Translate.of(context).translate('2020'),
                    //         style: TextStyle(
                    //             fontWeight: FontWeight.w400,
                    //             fontSize: 14.0,
                    //             fontFamily: 'Poppins',
                    //             color: AppTheme.textColor),
                    //         // )
                    //       ),
                    //       value: OrderTimeFilter.year2020,
                    //       groupValue: _orderTimeFilter,
                    //       onChanged: (OrderTimeFilter value) {
                    //         setState(() {
                    //           _orderTimeFilter = value;
                    //           print("value" + _orderTimeFilter.toString());
                    //         });
                    //       },
                    //     )),
                    // Divider(
                    //   height: 0.5,
                    //   color: Colors.black26,
                    // ),
                    // //radio 4
                    // Theme(
                    //     data: Theme.of(context).copyWith(
                    //       unselectedWidgetColor:
                    //       Theme.of(context).primaryColor,
                    //     ),
                    //     child: RadioListTile<OrderTimeFilter>(
                    //       activeColor: Theme.of(context).primaryColor,
                    //       title: Text(
                    //         Translate.of(context).translate('2021'),
                    //         style: TextStyle(
                    //             fontWeight: FontWeight.w400,
                    //             fontSize: 14.0,
                    //             fontFamily: 'Poppins',
                    //             color: AppTheme.textColor),
                    //         // )
                    //       ),
                    //       //for trailing icon
                    //       value: OrderTimeFilter.year2021,
                    //       groupValue: _orderTimeFilter,
                    //       onChanged: (OrderTimeFilter value) {
                    //         setState(() {
                    //           _orderTimeFilter = value;
                    //           print("value" + _orderTimeFilter.toString());
                    //         });
                    //       },
                    //     )),
                    // //faq
                    // Divider(
                    //   height: 0.5,
                    //   color: Colors.black26,
                    // ),
                    // //radio 5
                    // Theme(
                    //     data: Theme.of(context).copyWith(
                    //       unselectedWidgetColor:
                    //       Theme.of(context).primaryColor,
                    //     ),
                    //     child: RadioListTile<OrderTimeFilter>(
                    //       activeColor: Theme.of(context).primaryColor,
                    //       title: Text(
                    //         Translate.of(context).translate('older'),
                    //         style: TextStyle(
                    //             fontWeight: FontWeight.w400,
                    //             fontSize: 14.0,
                    //             fontFamily: 'Poppins',
                    //             color: AppTheme.textColor),
                    //         // )
                    //       ),
                    //       //for trailing icon
                    //       value: OrderTimeFilter.older,
                    //       groupValue: _orderTimeFilter,
                    //       onChanged: (OrderTimeFilter value) {
                    //         setState(() {
                    //           _orderTimeFilter = value;
                    //           print("value:-" + value.toString());
                    //         });
                    //       },
                    //     )),
                    // ],
                  ),
                ),
              )
            ]));
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: new AppBar(
        title: Text(
          'Filter',
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
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              // color: Colors.white,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClaimsType(),
                    // OrderType(),
                    Padding(
                        padding: EdgeInsets.all(25.0),
                        child: AppButton(
                          onPressed: () {
                            // Navigator.pop(context,{"orderId":orderId.toString(),"claimId":claimId.toString()});
                            Navigator.pop(context,claimId.toString());
                          },
                          shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(Radius.circular(50))),
                          text: 'SUBMIT',
                          // loading: login is LoginLoading,
                          // disableTouchWhenLoading: true,
                        ))
                  ],
                ))
          ],
        ),
      ),
    );
  }
}



