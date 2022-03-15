import 'dart:ui';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:orderly/Blocs/authentication/authentication_bloc.dart';
import 'package:orderly/Blocs/authentication/authentication_state.dart';
import 'package:orderly/Configs/image.dart';
import 'package:orderly/Configs/theme.dart';
import 'package:orderly/Models/model_scoped_cart.dart';
import 'package:orderly/Models/model_product_List.dart';
import 'package:orderly/Screens/Customer/cart/shopping_cart.dart';
import 'package:orderly/Screens/Customer/home/home.dart';
import 'package:orderly/Screens/Customer/home/home_old.dart';
import 'package:orderly/Screens/Customer/orders/myOrders.dart';
import 'package:orderly/Screens/Customer/producers/producers.dart';
import 'package:orderly/Screens/FleetManager/claims/claims.dart';
import 'package:orderly/Screens/FleetManager/inventory/inventory_list.dart';
import 'package:orderly/Screens/FleetManager/orders/fleet_orders.dart';
import 'package:orderly/Screens/profile/profile.dart';
import 'package:orderly/Utils/Utils.dart';
import 'package:orderly/Utils/application.dart';
import 'package:orderly/Utils/pushNotify.dart';
import 'package:orderly/Utils/routes.dart';

import 'package:orderly/Utils/translate.dart';


class MainNavigation extends StatefulWidget {
  String flagOrder="",userType,fcmFlagNavigate;
  MainNavigation({Key key,@required this.flagOrder,this.userType,@required this.fcmFlagNavigate}):super(key: key);

  _MainNavigationState createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _selectedIndex = 0;
  String title = "",userType="";

  ///List bottom menu
  List<BottomNavigationBarItem> _bottomBarItem(BuildContext context) {

    if(userType=="0"){
      return [
        // BottomNavigationBarItem(
        //   icon: Icon(Icons.home,size: 15.0,),
        //   title: Text(Translate.of(context).translate('home'),
        //   ),
        // ),
        BottomNavigationBarItem(
          icon: Image.asset(
            Images.home,
            width: 20.0,
            height: 20.0,
          ),
          activeIcon: Image.asset(
            Images.homeActive,
            width: 20.0,
            height: 20.0,
          ),
          title: Text(Translate.of(context).translate('home'),
          ),
        ),

        BottomNavigationBarItem(
          icon: Image.asset(
            Images.producer,
            width: 20.0,
            height: 20.0,
          ),
          activeIcon: Image.asset(
            Images.producerActive,
            width: 20.0,
            height: 20.0,
          ),
          title: Text(Translate.of(context).translate('producer'),
          ),
        ),
        BottomNavigationBarItem(
          icon: Image.asset(
            Images.order,
            width: 20.0,
            height: 20.0,
          ),
          activeIcon: Image.asset(
            Images.orderActive,
            width: 20.0,
            height: 20.0,
          ),
          title: Text(Translate.of(context).translate('my_order'),
          ),
        ),
        BottomNavigationBarItem(
          icon: Image.asset(
            Images.profile,
            width: 20.0,
            height: 20.0,
          ),
          activeIcon: Image.asset(
            Images.profileActive,
            width: 20.0,
            height: 20.0,
          ),
          title: Text(Translate.of(context).translate('profile'),
          ),
        ),
      ];
    }
    else{
      //for fleet
      return [
        BottomNavigationBarItem(
          icon: Image.asset(
            Images.order,
            width: 20.0,
            height: 20.0,
          ),
          activeIcon: Image.asset(
            Images.orderActive,
            width: 20.0,
            height: 20.0,
          ),
          title: Text(Translate.of(context).translate('orders'),
          ),
        ),
        BottomNavigationBarItem(
          icon: Image.asset(
            Images.inventory,
            width: 20.0,
            height: 20.0,
          ),
          activeIcon: Image.asset(
            Images.inventoryActive,
            width: 20.0,
            height: 20.0,
          ),
          title: Text(Translate.of(context).translate('inventory'),
          ),
        ),
        BottomNavigationBarItem(
          icon: Image.asset(
            Images.claim,
            width: 20.0,
            height: 20.0,
          ),
          activeIcon: Image.asset(
            Images.claimActive,
            width: 20.0,
            height: 20.0,
          ),
          title: Text(Translate.of(context).translate('claims'),
          ),
        ),
        BottomNavigationBarItem(
          icon: Image.asset(
            Images.profile,
            width: 20.0,
            height: 20.0,
          ),
          activeIcon: Image.asset(
            Images.profileActive,
            width: 20.0,
            height: 20.0,
          ),
          title:  Text(Translate.of(context).translate('profile')),

        ),
      ];
    }
  }

  ///On change tab bottom menu
  void _onItemTapped(int index) async {
    setState(() {
      _selectedIndex = index;
      print(_selectedIndex);
      if(userType=="0")
        {
          //for customer
          if (_selectedIndex == 0) {
            title = "Home";
          } else if (_selectedIndex == 1) {
            title = "Producers";
          } else if (_selectedIndex == 2) {
            title = "My Orders";
          }
        }
      else{
        //for fleet
        if (_selectedIndex == 0) {
          title = "Orders";
        } else if (_selectedIndex == 1) {
          title = "Inventory";
        } else if (_selectedIndex == 2) {
          title = "Claims";
        }
      }

    });
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // print("userType="+Application.user.userType);
    if(Application.user!=null){
      userType=Application.user.userType;
    }else{
      userType=widget.userType;
    }
    if(widget.flagOrder=="1"){ //from place order to redirect to orders
      _selectedIndex=2;
      title = "My Orders";
    }else {
      if (userType == "0") { //for customer
        title = "Home";
      } else { //for fleet manager
        title = "Orders";
      }
      //for fcm flag navigation
      if(PushNotify.notification!=null){
        if(userType=="1" && PushNotify.notification.flag=="fleet_order"){
          _selectedIndex=0;
        }else if(widget.fcmFlagNavigate=="logout"){  //for logout if userTpe is different
          _selectedIndex=3;
        }
        else if(userType=="0" && PushNotify.notification.flag=="cust_order"){
          _selectedIndex=2;//redirect to customer my orders part
        }
      }

    }

    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: _selectedIndex != 3 && _selectedIndex!=0//3=profile,0=home
            ?
        AppBar(
          title: Text(
            title,
            textAlign:TextAlign.left,
            style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w500,
                fontSize: 18.0,
                color: AppTheme.textColor),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          automaticallyImplyLeading: false,
          actions: [
            Row(
              children: [
                // IconButton(
                //   icon: Image.asset(
                //     Images.search,
                //     width: 30.0,
                //     height: 30.0,
                //   ),
                //   onPressed: () {},
                // ),
                InkWell(
                    onTap: (){

                    },
                    child:Stack(children: [
                      // IconButton(
                      //   icon:
                      Image.asset(
                        Images.notiIcon,
                        width: 37.0,
                        height: 37.0,
                      ),
                      // tooltip: "Save Todo and Retrun to List",
                      //   onPressed: () {},
                      // ),
                      Positioned(
                        right: 5,
                        top: 1,
                        child: new Container(
                          padding: EdgeInsets.all(1),
                          decoration: new BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(8.5),
                          ),
                          constraints: BoxConstraints(
                            minWidth: 17,
                            minHeight: 4,
                          ),
                          child: Text(
                            "0",
                            style: new TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.w400,
                                fontFamily: 'Poppins'
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      // if(Application.user.userType=="1")//for fleet
                      // Positioned(
                      //   right: 5,
                      //   top: 5,
                      //   child: new Container(
                      //     padding: EdgeInsets.all(1),
                      //     decoration: new BoxDecoration(
                      //       color: Colors.red,
                      //       borderRadius: BorderRadius.circular(8.5),
                      //     ),
                      //     constraints: BoxConstraints(
                      //       minWidth: 17,
                      //       minHeight: 17,
                      //     ),
                      //     child: Text(
                      //       "0",
                      //       style: new TextStyle(
                      //           color: Colors.white,
                      //           fontSize: 10,
                      //           fontWeight: FontWeight.w400,
                      //           fontFamily: 'Poppins'
                      //       ),
                      //       textAlign: TextAlign.center,
                      //     ),
                      //   ),
                      // )
                    ],
                    )),
                if(userType=="0") //for customer
                InkWell(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(
                        builder: (context)=> ShoppingCart(flagFrom:"1",cartModel: Application.cartModel,conveyanceFee: Application.preferences.getString("convFee"),) //from main page
                    ));
                  },
                  child: Stack(
                    children: [
                      Image.asset(
                        Images.cart,
                        width: 37.0,
                        height: 37.0,
                      ),
                      // tooltip: "Save Todo and Retrun to List",
                      // onPressed: () {
                      //   // Navigator.push(context, MaterialPageRoute(
                      //   //     builder: (context)=> ShoppingCart()
                      //   // ));
                      // },
                      // ),
                      Positioned(
                        right: 2,
                        top:1,
                        child: new Container(
                          padding: EdgeInsets.all(1),
                          decoration: new BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(8.5),
                          ),
                          constraints: BoxConstraints(
                            minWidth: 17,
                            minHeight: 2,
                          ),
                          child: Text(
                            Application.cartModel!=null?Application.cartModel.cart.length.toString():"0",
                            style: new TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.w400,
                                fontFamily: 'Poppins'
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      )
                    ],
                  ),
                )
              ],
            )
          ],
        )
            : null,
        extendBody: true,
        body: IndexedStack(
          index: _selectedIndex,
          children: <Widget>[
            userType=="0" //for customer
            ?
              Home()
                :  //for fleet manager
              FleetOrders(),
            userType=="0"
              ?
              Producers(model: CartModel())
              :
              InventoryList(),
            userType=="0"
              ?
              MyOrders()
              :
              Claims(),
              Profile(),
          ],
        ),
        bottomNavigationBar: Padding(
            padding: EdgeInsets.all(5.0),
            child: Container(
            // height: 65.0,
                child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Color(0xFF727C8E5C)),
                      borderRadius: BorderRadius.circular(35.0),
                      //   boxShadow: [
                      // BoxShadow(color: Colors.black38, spreadRadius: 0, blurRadius: 10),
                      // ],
                    ),
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(35.0),
                        child: Container(
                            child:
                          //   new BackdropFilter(
                          // filter:
                          //     new ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                          // child:
                          BottomNavigationBar(
                            items: _bottomBarItem(context),
                            currentIndex: widget.flagOrder!="1"?_selectedIndex:2,
                            type: BottomNavigationBarType.fixed,
                            unselectedItemColor:Theme.of(context).unselectedWidgetColor,
                            selectedItemColor:Theme.of(context).primaryColor,
                            showUnselectedLabels:true,
                            onTap: (index) {
                              widget.flagOrder="";
                              _onItemTapped(index);
                            },
                          ),
                        // )
                        )
                    )
                )
            )
        )
    );
  }
}
