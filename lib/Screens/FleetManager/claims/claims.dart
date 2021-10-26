import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:orderly/Configs/image.dart';
import 'package:orderly/Configs/theme.dart';
import 'package:orderly/Screens/Customer/orders/orders_filter.dart';

import 'claims_filter.dart';

class Claims extends StatefulWidget {
  _ClaimsState createState() => _ClaimsState();
}

class _ClaimsState extends State<Claims> {
  String OrderNumber = 'OrderNumber';
  String date = '12 July 2021';
  String itemNumber = '04';
  String amount = '\$1500';

  @override
  Widget build(BuildContext context) {
    var _searchcontroller = TextEditingController();
    return Scaffold(
      body: SafeArea(
         child:
          Column(
        children: [
          Padding(
              padding: EdgeInsets.only(
                  left: 15.0, right: 15.0, top: 10.0, bottom: 10.0),
              child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Colors.white,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          IconButton(
                            icon: Image.asset(
                              Images.search,
                              width: 25.0,
                              height: 25.0,
                            ),
                            onPressed: () {},
                          ),
                          Container(
                              margin: EdgeInsets.only(top: 5.0),
                              width: 200.0,
                              height: 45.0,
                              child: TextFormField(
                                controller: _searchcontroller =
                                    TextEditingController(),
                                style: TextStyle(
                                    fontFamily: 'Poppins',
                                    color: AppTheme.textColor,
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.w400),
                                keyboardType: TextInputType.text,
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "Search for all filters",
                                    hintStyle:
                                        TextStyle(color: AppTheme.textColor)),
                                onChanged: (value) {
                                  print(value);
                                },
                              )),
                        ],
                      ),
                      Row(
                        children: [
                          Container(
                            margin: EdgeInsets.only(right: 10.0),
                            width: 1,
                            height: 20.0,
                            color: AppTheme.textColor,
                          ),
                          Text(
                            'Filters',
                            style: TextStyle(
                                color: AppTheme.textColor,
                                fontSize: 14.0,
                                fontWeight: FontWeight.w400,
                                fontFamily: 'Poppins'),
                          ),
                          IconButton(
                            icon: Image.asset(
                              Images.filter,
                              width: 20.0,
                              height: 20.0,
                            ),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ClaimsFilter()));
                            },
                          ),
                        ],
                      )
                    ],
                  ))),
          Container(
            color: Colors.transparent,
            height: 180,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('\$250,000.50',
                    style: TextStyle(
                        fontSize: 20.0,
                        fontFamily: "Poppins",
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textColor)),
                SizedBox(
                  height: 10.0,
                ),
                Text('Total Transaction last 30 Days',
                    style: TextStyle(
                        fontSize: 14.0,
                        fontFamily: "Poppins",
                        fontWeight: FontWeight.normal,
                        color: AppTheme.textColor)),
                SizedBox(
                  height: 20.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 0.3,
                      height: 70.0,
                      decoration: BoxDecoration(
                        color: Colors.white70,
                        borderRadius: BorderRadius.circular(6.0),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('\$350,000.50',
                              style: TextStyle(
                                  fontSize: 14.0,
                                  fontFamily: "Poppins",
                                  fontWeight: FontWeight.w500,
                                  color: AppTheme.textColor)),
                          Text('Recieved',
                              style: TextStyle(
                                  fontSize: 14.0,
                                  fontFamily: "Poppins",
                                  fontWeight: FontWeight.w500,
                                  color: AppTheme.pinkColor))
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 50.0,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.3,
                      height: 70.0,
                      decoration: BoxDecoration(
                        color: Colors.white70,
                        borderRadius: BorderRadius.circular(6.0),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('\$100,00.00',
                              style: TextStyle(
                                  fontSize: 14.0,
                                  fontFamily: "Poppins",
                                  fontWeight: FontWeight.w500,
                                  color: AppTheme.textColor)),
                          Text('Refunded',
                              style: TextStyle(
                                  fontSize: 14.0,
                                  fontFamily: "Poppins",
                                  fontWeight: FontWeight.w500,
                                  color: AppTheme.appColor))
                        ],
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
          Expanded(
              child:Container(
                    // height: MediaQuery.of(context).size.height * 0.518,
                    child: ListView.builder(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: 10,
                        itemBuilder: (context, index) {
                          return Container(
                            padding: EdgeInsets.only(top: 2, bottom: 2),
                            height: 170,
                            width: double.infinity,
                            child: Card(
                              elevation: 0,
                              child: Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Row(
                                  children: [
                                    Expanded(
                                        flex: 1,
                                        child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(6),
                                            child: Image.asset(
                                              'assets/images/truck-img-square.png',
                                            ))),
                                    Expanded(
                                        flex: 2,
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(left: 20),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(OrderNumber,
                                                  style: TextStyle(
                                                      fontSize: 14.0,
                                                      fontFamily: "Poppins",
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color:
                                                          AppTheme.textColor)),
                                              Text(date,
                                                  style: TextStyle(
                                                      fontSize: 14.0,
                                                      fontFamily: "Poppins",
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color:
                                                          AppTheme.textColor)),
                                              Spacer(),
                                              Text('No of items',
                                                  style: TextStyle(
                                                      fontSize: 14.0,
                                                      fontFamily: "Poppins",
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color:
                                                          AppTheme.textColor)),
                                              Text(itemNumber,
                                                  style: TextStyle(
                                                      fontSize: 14.0,
                                                      fontFamily: "Poppins",
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color:
                                                          AppTheme.textColor))
                                            ],
                                          ),
                                        )),
                                    Expanded(
                                        flex: 1,
                                        child: Column(
                                          children: [
                                            Text(amount,
                                                style: TextStyle(
                                                    fontSize: 14.0,
                                                    fontFamily: "Poppins",
                                                    fontWeight: FontWeight.w500,
                                                    color: AppTheme.textColor)),
                                            Text('Received',
                                                style: TextStyle(
                                                    fontSize: 14.0,
                                                    fontFamily: "Poppins",
                                                    fontWeight: FontWeight.bold,
                                                    color: AppTheme.textColor)),
                                          ],
                                        ))
                                  ],
                                ),
                              ),
                            ),
                          );
                        }),
                  ))
        ],
      )),
    );
  }
}
