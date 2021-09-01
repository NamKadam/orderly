import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:orderly/Blocs/authentication/authentication_bloc.dart';
import 'package:orderly/Blocs/authentication/authentication_state.dart';
import 'package:orderly/Configs/image.dart';
import 'package:orderly/Configs/theme.dart';
import 'package:orderly/Models/cart_model.dart';
import 'package:orderly/Models/productList_scopedModel.dart';
import 'package:orderly/Screens/Customer/home/home.dart';
import 'package:orderly/Screens/Customer/home/homeUpdated.dart';
import 'package:orderly/Screens/Customer/orders/myOrders.dart';
import 'package:orderly/Screens/Customer/producers/producers.dart';
import 'package:orderly/Screens/Customer/profile/profile.dart';
import 'package:orderly/Utils/routes.dart';

import 'package:orderly/Utils/translate.dart';

// import 'package:orderly/flutterexample.dart';

class MainNavigation extends StatefulWidget {
  _MainNavigationState createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _selectedIndex = 0;
  var title = "Home";

  ///List bottom menu
  List<BottomNavigationBarItem> _bottomBarItem(BuildContext context) {
    return [
      BottomNavigationBarItem(
        icon: Icon(Icons.home),
        title: Padding(
          padding: EdgeInsets.only(top: 3),
          child: Text(Translate.of(context).translate('home')),
        ),
      ),
      BottomNavigationBarItem(
        icon: Image.asset(
          Images.producer,
          width: 25.0,
          height: 25.0,
        ),
        activeIcon: Image.asset(
          Images.producerActive,
          width: 25.0,
          height: 25.0,
        ),
        title: Padding(
          padding: EdgeInsets.only(top: 3),
          child: Text(Translate.of(context).translate('producer')),
        ),
      ),
      BottomNavigationBarItem(
        icon: Image.asset(
          Images.order,
          width: 25.0,
          height: 25.0,
        ),
        activeIcon: Image.asset(
          Images.orderActive,
          width: 25.0,
          height: 25.0,
        ),
        title: Padding(
          padding: EdgeInsets.only(top: 3),
          child: Text(Translate.of(context).translate('my_order')),
        ),
      ),
      BottomNavigationBarItem(
        icon: Image.asset(
          Images.profile,
          width: 25.0,
          height: 25.0,
        ),
        activeIcon: Image.asset(
          Images.profileActive,
          width: 25.0,
          height: 25.0,
        ),
        title: Padding(
          padding: EdgeInsets.only(top: 3),
          child: Text(Translate.of(context).translate('profile')),
        ),
      ),
    ];
  }

  ///On change tab bottom menu
  void _onItemTapped(int index) async {
    setState(() {
      _selectedIndex = index;
      if (_selectedIndex == 0) {
        title = "Home";
      } else if (_selectedIndex == 1) {
        title = "Producers";
      } else if (_selectedIndex == 2) {
        title = "My Orders";
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: _selectedIndex != 3 //3=profile
            ? AppBar(
                title: Text(
                  title,
                  style: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w400,
                      fontSize: 18.0,
                      color: AppTheme.textColor),
                ),
                backgroundColor: Colors.transparent,
                elevation: 0,
                automaticallyImplyLeading: false,
                actions: [
                  Row(
                    children: [
                      IconButton(
                        icon: Image.asset(
                          Images.search,
                          width: 30.0,
                          height: 30.0,
                        ),
                        onPressed: () {},
                      ),
                      Stack(children: [
                        IconButton(
                          icon: Image.asset(
                            Images.notiIcon,
                            width: 30.0,
                            height: 30.0,
                          ),
                          // tooltip: "Save Todo and Retrun to List",
                          onPressed: () {},
                        ),
                        Positioned(
                          right: 5,
                          top: 5,
                          child: new Container(
                            padding: EdgeInsets.all(1),
                            decoration: new BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(8.5),
                            ),
                            constraints: BoxConstraints(
                              minWidth: 17,
                              minHeight: 17,
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
                        )
                      ],
                      ),

                      Stack(
                        children: [
                          IconButton(
                            icon: Image.asset(
                              Images.cart,
                              width: 30.0,
                              height: 30.0,
                            ),
                            // tooltip: "Save Todo and Retrun to List",
                            onPressed: () {
                              Navigator.pushNamed(context, Routes.cart);
                            },
                          ),
                          Positioned(
                            right: 5,
                            top: 5,
                            child: new Container(
                              padding: EdgeInsets.all(1),
                              decoration: new BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(8.5),
                              ),
                              constraints: BoxConstraints(
                                minWidth: 17,
                                minHeight: 17,
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
                          )
                        ],
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
            Home(),
            // HomeUpdated(model: CartModel()),
            // FlutterExample(),
            Producers(model: CartModel()),
            MyOrders(),
            Profile(),
          ],
        ),
        bottomNavigationBar: Padding(
            padding: EdgeInsets.all(10.0),
            child: Container(
                child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Color(0xFF727C8E5C)),
                      borderRadius: BorderRadius.circular(30.0),

                      //   boxShadow: [
                      // BoxShadow(color: Colors.black38, spreadRadius: 0, blurRadius: 10),
                      // ],
                    ),
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(30.0),
                        child: Container(
                            child: new BackdropFilter(
                          filter:
                              new ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                          child: BottomNavigationBar(
                            items: _bottomBarItem(context),
                            currentIndex: _selectedIndex,
                            type: BottomNavigationBarType.fixed,
                            unselectedItemColor:
                                Theme.of(context).unselectedWidgetColor,
                            selectedItemColor: Theme.of(context).primaryColor,
                            showUnselectedLabels: true,
                            onTap: (index) {
                              _onItemTapped(index);
                            },
                          ),
                        )))))));
  }
}
