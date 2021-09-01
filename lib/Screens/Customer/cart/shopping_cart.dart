import 'dart:convert';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:orderly/Api/api.dart';
import 'package:orderly/Blocs/authentication/bloc.dart';
import 'package:orderly/Blocs/home/home_bloc.dart';
import 'package:orderly/Blocs/mycart/bloc.dart';
import 'package:orderly/Blocs/mycart/cart_bloc.dart';
import 'package:orderly/Configs/image.dart';
import 'package:orderly/Configs/theme.dart';
import 'package:orderly/Models/cart_model.dart';
import 'package:orderly/Models/productList_scopedModel.dart';
import 'package:orderly/Models/view_cart.dart';
import 'package:orderly/Screens/Customer/cart/cart_list_item.dart';
import 'package:orderly/Utils/application.dart';
import 'package:orderly/Utils/connectivity_check.dart';
import 'package:orderly/Utils/routes.dart';
import 'package:orderly/Utils/translate.dart';
import 'package:orderly/Utils/util_preferences.dart';
import 'package:orderly/Widgets/app_button.dart';
import 'package:orderly/Widgets/app_dialogs.dart';
import 'package:orderly/app_bloc.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:http/http.dart' as http;



class ShoppingCart extends StatefulWidget {
  String producerId,productId,qty,price;
  // CartModel model;

  // double totalCartValue;
  // ShoppingCart({Key key, @required this.producerId, @required this.model})
  //     : super(key: key);

  ShoppingCart({Key key, @required this.price})
      : super(key: key);

  _ShoppingCartState createState() => _ShoppingCartState();
}

class _ShoppingCartState extends State<ShoppingCart> {
  ScrollController _scrollController = ScrollController();
  String date = "", currentDate = "";
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  CartModel cartModel;
  double totalCartValue = 0;
  int quantity = 0;
  double OverallTotalVal = 0, conveniencFee = 75.0;
  CartBloc cartBloc;
  bool isconnectedToInternet = false;
  bool flagDataNotAvailable = false;
  List<Cart> _cartList;
  int producerListIndex = 0;
  final _controller = RefreshController(initialRefresh: false);
  String flagRemove="";


  Future<void> showPlaceOrderBottomDialog(BuildContext context) async {
    showModalBottomSheet<void>(
        backgroundColor: Colors.transparent,
        context: context,
        builder: (BuildContext context) {
          return Container(
              child: Align(
                  alignment: Alignment.bottomCenter,
                  child: new ClipRect(
                    child: new BackdropFilter(
                      filter: new ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                      child: new Container(
                          width: MediaQuery.of(context).size.width,
                          height: 220.0,
                          decoration: new BoxDecoration(
                              color: Colors.grey.shade200.withOpacity(0.5)),
                          child: Container(
                              margin: EdgeInsets.all(20.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  //delivery time
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Choose Delivery Time",
                                        style: Theme.of(context)
                                            .textTheme
                                            .caption
                                            .copyWith(
                                                fontSize: 14.0,
                                                fontWeight: FontWeight.w600,
                                                color: Theme.of(context)
                                                    .primaryColor,
                                                fontFamily: "Poppins"),
                                      ),
                                      Text(
                                        "date",
                                        style: Theme.of(context)
                                            .textTheme
                                            .caption
                                            .copyWith(
                                                fontSize: 14.0,
                                                fontWeight: FontWeight.w600,
                                                color: AppTheme.textColor,
                                                fontFamily: "Poppins"),
                                      ),
                                    ],
                                  ),
                                  // subtotal
                                  Padding(
                                      padding: EdgeInsets.only(top: 5.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "SubTotal",
                                            style: Theme.of(context)
                                                .textTheme
                                                .caption
                                                .copyWith(
                                                    fontSize: 14.0,
                                                    fontWeight: FontWeight.w600,
                                                    color: AppTheme.textColor,
                                                    fontFamily: "Poppins"),
                                          ),
                                          Text(
                                            "\$" + totalCartValue.toString(),
                                            style: Theme.of(context)
                                                .textTheme
                                                .caption
                                                .copyWith(
                                                    fontSize: 14.0,
                                                    fontWeight: FontWeight.w600,
                                                    color: AppTheme.textColor,
                                                    fontFamily: "Poppins"),
                                          ),
                                        ],
                                      )),
                                  //convinience fee
                                  Padding(
                                      padding: EdgeInsets.only(top: 5.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "Convinience Fee",
                                            style: Theme.of(context)
                                                .textTheme
                                                .caption
                                                .copyWith(
                                                    fontSize: 12.0,
                                                    fontWeight: FontWeight.w400,
                                                    color: AppTheme.textColor,
                                                    fontFamily: "Poppins"),
                                          ),
                                          Text(
                                            "\$ 75.00",
                                            style: Theme.of(context)
                                                .textTheme
                                                .caption
                                                .copyWith(
                                                    fontSize: 12.0,
                                                    fontWeight: FontWeight.w400,
                                                    color: AppTheme.textColor,
                                                    fontFamily: "Poppins"),
                                          ),
                                        ],
                                      )),
                                  //Total
                                  Padding(
                                      padding: EdgeInsets.only(
                                          top: 5.0, bottom: 15.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "Total",
                                            style: Theme.of(context)
                                                .textTheme
                                                .caption
                                                .copyWith(
                                                    fontSize: 14.0,
                                                    fontWeight: FontWeight.w600,
                                                    color: AppTheme.textColor,
                                                    fontFamily: "Poppins"),
                                          ),
                                          Text(
                                            "\$ 75.00",
                                            style: Theme.of(context)
                                                .textTheme
                                                .caption
                                                .copyWith(
                                                    fontSize: 14.0,
                                                    fontWeight: FontWeight.w600,
                                                    color: AppTheme.textColor,
                                                    fontFamily: "Poppins"),
                                          ),
                                        ],
                                      )),
                                  Padding(
                                      padding: EdgeInsets.only(top: 15.0),
                                      child: AppButton(
                                        onPressed: () {
                                          // _signUp();
                                          // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MainNavigation()));
                                        },
                                        shape: const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(50))),
                                        text: 'PLACE ORDER',
                                        // loading: login is LoginLoading,
                                        // disableTouchWhenLoading: true,
                                      ))
                                ],
                              ))),
                    ),
                  )));
        });
  }

  getCurrentDate() {
    var date = new DateTime.now().toString();
    var dateParse = DateTime.parse(date);
    var formattedDate = "${dateParse.day}/${dateParse.month}/${dateParse.year}";
    setState(() {
      currentDate = formattedDate.toString();
      print("currentDate:-" + currentDate);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    cartBloc = BlocProvider.of<CartBloc>(context);
    getCurrentDate();
    setBlocData();
  }
  ///On Refresh List
  Future<void> _onRefresh() async {
    cartBloc.add(OnLoadingCartList());
  }

  void setBlocData() async {
    isconnectedToInternet = await ConnectivityCheck.checkInternetConnectivity();
    if (isconnectedToInternet == true) {
      cartBloc.add(OnLoadingCartList());
    } else {
      CustomDialogs.showDialogCustom(
          "Internet", "Please check your Internet Connection!", context);
    }
  }

  void calculateTotal(List<Cart> cartList,int index,String flagRemove) {
    totalCartValue = 0;
    quantity = 0;
    String json = jsonEncode(cartList);
    // var json1 = jsonEncode(cartList.map((e) => e.toJson()).toList());
    print("cartList:-" + json);
    cartList.forEach((f) {
      print(f.qty);
      totalCartValue += int.parse(f.ratePerHour) * f.qty;
      print('total cart value:-' + totalCartValue.toString());
      print('quantity:-' + quantity.toString());
    });
    if(flagRemove=="1"){
      _cartList.removeAt(index);
      if(_cartList.length<=0){
        flagDataNotAvailable=true;
      }
    }

    OverallTotalVal = totalCartValue + conveniencFee;
    setState(() {});
  }

  void removeProduct(List<Cart> cart, Cart cartItem) {
    int index = cart.indexWhere((i) => i.id == cartItem.id);
    cart[index].qty = 1;
    cart.removeWhere((item) => item.id == cartItem.id);
    // widget.model.cart.removeAt(index);
    _cartList.removeAt(index);
    // calculateTotal(cart);
  }



  // for cartList
  Widget buildCartList(int index, CartModel model) {
    if (model==null) {
      return ListView.builder(
        padding: EdgeInsets.all(0),
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.only(bottom: 15),
            child: Shimmer.fromColors(
              child: Row(
                children: <Widget>[
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.white,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      left: 10,
                      right: 10,
                      top: 5,
                      bottom: 5,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          height: 10,
                          width: 180,
                          color: Colors.white,
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 5),
                        ),
                        Container(
                          height: 10,
                          width: 150,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              baseColor: Theme.of(context).hoverColor,
              highlightColor: Theme.of(context).highlightColor,
            ),
          );
        },
        itemCount: 8,
      );
    }

    return Padding(
      padding: const EdgeInsets.only(
        top: 5,

      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            color: Colors.transparent,
            // height: MediaQuery.of(context).size.height * 0.15,
            // width: MediaQuery.of(context).size.width ,
            // decoration: BoxDecoration(
            //   borderRadius: BorderRadius.circular(10.0),
            // ),
            child: Card(
                elevation: 0.0,
                // shape: RoundedRectangleBorder(
                //     borderRadius: BorderRadius.circular(5.0),
                //     side: BorderSide(
                //       color: Colors.grey,
                //       width: 0.5,
                //     )),
                // borderOnForeground: true,
                child: Column(
                  children: [
                    Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CachedNetworkImage(
                              filterQuality: FilterQuality.medium,
                              // imageUrl: Api.PHOTO_URL + widget.users.avatar,
                              // imageUrl:
                              //     "https://images.unsplash.com/photo-1438761681033-6461ffad8d80?ixid=MXwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=1050&q=80",
                              imageUrl: model.cart[index].productImg == null
                                  ? "https://images.unsplash.com/photo-1438761681033-6461ffad8d80?ixid=MXwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=1050&q=80"
                                  : model.cart[index].productImg,
                              placeholder: (context, url) {
                                return Shimmer.fromColors(
                                  baseColor: Theme.of(context).hoverColor,
                                  highlightColor:
                                      Theme.of(context).highlightColor,
                                  enabled: true,
                                  child: Container(
                                    height: 80,
                                    width: 80,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                );
                              },
                              imageBuilder: (context, imageProvider) {
                                return Container(
                                  height: 80,
                                  width: 80,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: imageProvider,
                                      fit: BoxFit.cover,
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                );
                              },
                              errorWidget: (context, url, error) {
                                return Shimmer.fromColors(
                                  baseColor: Theme.of(context).hoverColor,
                                  highlightColor:
                                      Theme.of(context).highlightColor,
                                  enabled: true,
                                  child: Container(
                                    height: 80,
                                    width: 80,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Icon(Icons.error),
                                  ),
                                );
                              },
                            ),
                            SizedBox(
                              width: 10.0,
                            ),
                            Expanded(
                                child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  model.cart[index].productName,
                                  // widget.users.firstName+" "+widget.users.lastName,
                                  style: Theme.of(context)
                                      .textTheme
                                      .caption
                                      .copyWith(
                                          fontSize: 14.0,
                                          fontWeight: FontWeight.w600,
                                          color: AppTheme.textColor,
                                          fontFamily: "Poppins"),
                                ),
                                Text(
                                  model.cart[index].productDesc == null
                                      ? ""
                                      : model.cart[index].productDesc,
                                  style: Theme.of(context)
                                      .textTheme
                                      .button
                                      .copyWith(
                                          fontSize: 13.0,
                                          color: AppTheme.textColor,
                                          fontWeight: FontWeight.w400,
                                          fontFamily: "Poppins"),
                                ),
                                Text(
                                  model.cart[index].productName == null
                                      ? "sold by: "
                                      : "sold by: " +
                                          model.cart[index].productName,
                                  style: Theme.of(context)
                                      .textTheme
                                      .button
                                      .copyWith(
                                          fontSize: 12.0,
                                          color: AppTheme.textColor,
                                          fontWeight: FontWeight.w300,
                                          fontFamily: "Poppins"),
                                ),
                                Text(
                                  model.cart[index].ratePerHour.toString() +
                                      " \$/Hr",
                                  style: Theme.of(context)
                                      .textTheme
                                      .button
                                      .copyWith(
                                          fontSize: 13.0,
                                          color: Theme.of(context).primaryColor,
                                          fontWeight: FontWeight.w600,
                                          fontFamily: "Poppins"),
                                ),
                              ],
                            )),
                          ],
                        )),
                    //quantity
                    Container(
                        margin: EdgeInsets.all(15.0),
                        decoration: BoxDecoration(
                          border:
                              Border.all(color: Theme.of(context).dividerColor),
                          borderRadius: BorderRadius.all(
                            Radius.circular(45.0),
                          ),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Quantity',
                                style: TextStyle(
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: 'Poppins',
                                    color: AppTheme.textColor),
                              ),
                              Row(
                                children: [
                                  Padding(
                                      padding: EdgeInsets.only(right: 15.0),
                                      child: InkWell(
                                          onTap: () {
                                            if ((model.cart[index].qty-1)== 0) {
                                              flagRemove="1";
                                            }else{
                                              flagRemove="";
                                              model.updateProduct(
                                                  model.cart[index],
                                                  model.cart[index].qty - 1);

                                              calculateTotal(model.cart,index,flagRemove);

                                            }

                                          },
                                          child: Image.asset(Images.minus,
                                              height: 22.0, width: 22.0))),
                                  Text(
                                    model.cart[index].qty.toString(),
                                    style: TextStyle(
                                        fontSize: 15.0,
                                        fontWeight: FontWeight.w600,
                                        fontFamily: 'Poppins',
                                        color: Theme.of(context).primaryColor),
                                  ),
                                  Padding(
                                      padding: EdgeInsets.only(left: 15.0),
                                      child: InkWell(
                                          onTap: () {
                                            model.updateProduct(
                                                model.cart[index],
                                                model.cart[index].qty + 1);
                                            calculateTotal(model.cart,index,"0");
                                          },
                                          child: Image.asset(
                                            Images.plus,
                                            height: 22.0,
                                            width: 22.0,
                                          ))),
                                ],
                              )
                            ],
                          ),
                        )),
                  ],
                )),
          ),
          Positioned(
            right: 0.0,
            top: 5.0,
            child: Container(
              // width:30.0,height:30.0,
              decoration: BoxDecoration(
                  // color: Colors.greenAccent,
                  // borderRadius: BorderRadius.circular(20.0),
                  ),
              margin: const EdgeInsets.symmetric(horizontal: 4.0),
              child:
                  // CircleAvatar(
                  // child:
                  IconButton(
                // hoverColor: Theme.of(context).primaryColor,
                splashColor: Colors.white,
                icon: Image.asset(
                  Images.delete,
                  width: 15.0,
                  height: 15.0,
                ),

                onPressed: () {
                  // if (_formKey.currentState.validate()) {
                  // sendMessage();
                  // }
                  // Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //         builder: (context) =>
                  //         new MemberDetails(userListData:widget.users))
                  // );
                },
              ),
              // backgroundColor: Colors.black,
              // )
            ),
          ),
        ],
      ),
    );
  }

  // Future<void> getsharedPrefData() async{
  //   final SharedPreferences prefs = await SharedPreferences.getInstance();
  //   // Encode and store data in SharedPreferences
  //   final String encodedData = Cart.encode(cartModel.cart);
  //
  //   await prefs.setString('musics_key', encodedData);
  //   // Fetch and decode data
  //   final String musicsString = await prefs.getString('musics_key');
  //   final List<Music> musics = Music.decode(musicsString);
  //
  // }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        key: _scaffoldKey,
        appBar: new AppBar(
          title: Text(
            'Shopping Cart',
            style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
                fontSize: 18.0,
                color: AppTheme.textColor),
          ),
          leading: InkWell(
              onTap: () {
                // Navigator.pop(context);
                // showPlaceOrderBottomDialog(context);

              },
              child: Icon(
                Icons.arrow_back_ios,
                color: AppTheme.textColor,
              )),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: BlocListener<CartBloc, CartState>(
          listener: (context, state) {},
          child: BlocBuilder<CartBloc, CartState>(builder: (context, state) {
            if (state is CartListSuccess) {
              cartModel=new CartModel();

              _cartList = state.cartList;
              if(_cartList==null) {
                flagDataNotAvailable = true;
              }
                cartModel.addAllProduct(_cartList);

             }
            return
              Container(
                    // height: MediaQuery.of(context).size.height,
                    child:
                  Column(
                    children: [
                      Expanded(child:
                    ListView.separated(
                          controller: _scrollController,
                          physics: const AlwaysScrollableScrollPhysics(),
                          separatorBuilder: (context, index) {
                            return SizedBox(
                              height: 0.0,
                            );
                          },
                          itemCount: _cartList!=null?_cartList.length:6,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                                onTap: () {
                                  // Navigator.push(
                                  //     context,
                                  //     MaterialPageRoute(
                                  //         builder: (context) =>
                                  //         new MemberDetails(userListData:memberlist[index])));
                                },
                                child: ScopedModel<CartModel>(
                                    model: cartModel,
                                    child: ScopedModelDescendant<CartModel>(
                                      builder: (context, child, model) {
                                        cartModel = model;
                                        print(cartModel);
                                        totalCartValue=cartModel.totalCartValue;
                                        return buildCartList(index, model);
                                      },
                                    )));
                          })),

                      //bottom dialog
                      flagDataNotAvailable==false
                            ?
                        Align(
                            alignment: Alignment.bottomCenter,
                            child: new ClipRect(
                              child: new BackdropFilter(
                                filter: new ImageFilter.blur(
                                    sigmaX: 10.0, sigmaY: 10.0),
                                child: new Container(
                                    width: MediaQuery.of(context).size.width,
                                    height: 220.0,
                                    decoration: new BoxDecoration(
                                        color:
                                        Colors.grey.shade200.withOpacity(0.5)),
                                    child: Container(
                                        margin: EdgeInsets.all(20.0),
                                        child: Column(
                                          mainAxisAlignment:
                                          MainAxisAlignment.start,
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: [
                                            //delivery time
                                            Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                              children: [
                                                GestureDetector(
                                                    onTap: () async {
                                                      final result =
                                                      await Navigator.pushNamed(
                                                          context,
                                                          Routes.addTime);
                                                      print("result:-" + result);
                                                      print("currentDate:-" +
                                                          currentDate);

                                                      if (result == "") {
                                                        setState(() {
                                                          date = currentDate;
                                                        });
                                                      } else {
                                                        setState(() {
                                                          date = result;
                                                        });
                                                      }
                                                    },
                                                    child: Text(
                                                      "Choose Delivery Time",
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .caption
                                                          .copyWith(
                                                          fontSize: 14.0,
                                                          fontWeight:
                                                          FontWeight.w600,
                                                          color:
                                                          Theme.of(context)
                                                              .primaryColor,
                                                          fontFamily:
                                                          "Poppins"),
                                                    )),
                                                Text(
                                                  date,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .caption
                                                      .copyWith(
                                                      fontSize: 14.0,
                                                      fontWeight:
                                                      FontWeight.w600,
                                                      color: AppTheme.textColor,
                                                      fontFamily: "Poppins"),
                                                ),
                                              ],
                                            ),
                                            // subtotal
                                            Padding(
                                                padding: EdgeInsets.only(top: 5.0),
                                                child: Row(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                                  children: [
                                                    Text(
                                                      "SubTotal",
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .caption
                                                          .copyWith(
                                                          fontSize: 14.0,
                                                          fontWeight:
                                                          FontWeight.w600,
                                                          color: AppTheme
                                                              .textColor,
                                                          fontFamily:
                                                          "Poppins"),
                                                    ),
                                                    Text(
                                                      "\$" +
                                                          totalCartValue.toString(),
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .caption
                                                          .copyWith(
                                                          fontSize: 14.0,
                                                          fontWeight:
                                                          FontWeight.w600,
                                                          color: AppTheme
                                                              .textColor,
                                                          fontFamily:
                                                          "Poppins"),
                                                    ),
                                                  ],
                                                )),
                                            //convinience fee
                                            Padding(
                                                padding: EdgeInsets.only(top: 5.0),
                                                child: Row(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                                  children: [
                                                    Text(
                                                      "Convinience Fee",
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .caption
                                                          .copyWith(
                                                          fontSize: 12.0,
                                                          fontWeight:
                                                          FontWeight.w400,
                                                          color: AppTheme
                                                              .textColor,
                                                          fontFamily:
                                                          "Poppins"),
                                                    ),
                                                    Text(
                                                      "\$ " +
                                                          conveniencFee.toString(),
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .caption
                                                          .copyWith(
                                                          fontSize: 12.0,
                                                          fontWeight:
                                                          FontWeight.w400,
                                                          color: AppTheme
                                                              .textColor,
                                                          fontFamily:
                                                          "Poppins"),
                                                    ),
                                                  ],
                                                )),
                                            //Total
                                            Padding(
                                                padding: EdgeInsets.only(
                                                    top: 5.0, bottom: 15.0),
                                                child: Row(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                                  children: [
                                                    Text(
                                                      "Total",
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .caption
                                                          .copyWith(
                                                          fontSize: 14.0,
                                                          fontWeight:
                                                          FontWeight.w600,
                                                          color: AppTheme
                                                              .textColor,
                                                          fontFamily:
                                                          "Poppins"),
                                                    ),
                                                    Text(
                                                      OverallTotalVal == 0
                                                          ? "\$ " +
                                                          (totalCartValue +
                                                              conveniencFee)
                                                              .toString()
                                                          : "\$ " +
                                                          OverallTotalVal
                                                              .toString(),
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .caption
                                                          .copyWith(
                                                          fontSize: 14.0,
                                                          fontWeight:
                                                          FontWeight.w600,
                                                          color: AppTheme
                                                              .textColor,
                                                          fontFamily:
                                                          "Poppins"),
                                                    ),
                                                  ],
                                                )),
                                            Padding(
                                                padding: EdgeInsets.only(top: 15.0),
                                                child: AppButton(
                                                  onPressed: () {
                                                    if (date == "") {
                                                      _scaffoldKey.currentState
                                                          .showSnackBar(SnackBar(
                                                          content: Text(
                                                              "Please Choose Delivery time")));
                                                    }
                                                    // _signUp();
                                                    // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MainNavigation()));
                                                  },
                                                  shape:
                                                  const RoundedRectangleBorder(
                                                      borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(
                                                              50))),
                                                  text: 'PLACE ORDER',
                                                  // loading: login is LoginLoading,
                                                  // disableTouchWhenLoading: true,
                                                ))
                                          ],
                                        ))),
                              ),
                            ))
                            :
                        Expanded(
                          flex:10,
                        child:Container(
                            child:
                            Center(
                                child: Text(
                                  "No Data Available",
                                  style: TextStyle(
                                      fontSize: 16.0,
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w600,
                                      color: AppTheme.textColor),
                                ))))

                    ],
                  )
            //         Stack(
            //           children: <Widget>[
            //       //listview for cart
            //      Padding(
            //        padding: EdgeInsets.only(bottom: 50.0),
            //       child:
                //       ListView.separated(
            //       controller: _scrollController,
            //       physics: const AlwaysScrollableScrollPhysics(),
            //       separatorBuilder: (context, index) {
            //         return SizedBox(
            //           height: 0.0,
            //         );
            //       },
            //       // itemCount: state.members.length,
            //       // itemCount: memberlist.length,
            //       itemCount: _cartList!=null?_cartList.length:6,
            //       itemBuilder: (context, index) {
            //         return GestureDetector(
            //             onTap: () {
            //               // Navigator.push(
            //               //     context,
            //               //     MaterialPageRoute(
            //               //         builder: (context) =>
            //               //         new MemberDetails(userListData:memberlist[index])));
            //             },
            //             child: ScopedModel<CartModel>(
            //                 model: cartModel,
            //                 child: ScopedModelDescendant<CartModel>(
            //                   builder: (context, child, model) {
            //                     cartModel = model;
            //                     print(cartModel);
            //                     if (cartModel.cart.length == 0) {
            //                       cartModel.cart.addAll(_cartList);
            //                     }
            //                     return buildCartList(index, model);
            //                   },
            //                 )));
            //       })),
            //   //custom dialog for time and total
            //     flagDataNotAvailable==false
            //       ?
            //   Align(
            //       alignment: Alignment.bottomCenter,
            //       child: new ClipRect(
            //         child: new BackdropFilter(
            //           filter: new ImageFilter.blur(
            //               sigmaX: 10.0, sigmaY: 10.0),
            //           child: new Container(
            //               width: MediaQuery.of(context).size.width,
            //               height: 220.0,
            //               decoration: new BoxDecoration(
            //                   color:
            //                   Colors.grey.shade200.withOpacity(0.5)),
            //               child: Container(
            //                   margin: EdgeInsets.all(20.0),
            //                   child: Column(
            //                     mainAxisAlignment:
            //                     MainAxisAlignment.start,
            //                     crossAxisAlignment:
            //                     CrossAxisAlignment.start,
            //                     children: [
            //                       //delivery time
            //                       Row(
            //                         mainAxisAlignment:
            //                         MainAxisAlignment.spaceBetween,
            //                         children: [
            //                           GestureDetector(
            //                               onTap: () async {
            //                                 final result =
            //                                 await Navigator.pushNamed(
            //                                     context,
            //                                     Routes.addTime);
            //                                 print("result:-" + result);
            //                                 print("currentDate:-" +
            //                                     currentDate);
            //
            //                                 if (result == "") {
            //                                   setState(() {
            //                                     date = currentDate;
            //                                   });
            //                                 } else {
            //                                   setState(() {
            //                                     date = result;
            //                                   });
            //                                 }
            //                               },
            //                               child: Text(
            //                                 "Choose Delivery Time",
            //                                 style: Theme.of(context)
            //                                     .textTheme
            //                                     .caption
            //                                     .copyWith(
            //                                     fontSize: 14.0,
            //                                     fontWeight:
            //                                     FontWeight.w600,
            //                                     color:
            //                                     Theme.of(context)
            //                                         .primaryColor,
            //                                     fontFamily:
            //                                     "Poppins"),
            //                               )),
            //                           Text(
            //                             date,
            //                             style: Theme.of(context)
            //                                 .textTheme
            //                                 .caption
            //                                 .copyWith(
            //                                 fontSize: 14.0,
            //                                 fontWeight:
            //                                 FontWeight.w600,
            //                                 color: AppTheme.textColor,
            //                                 fontFamily: "Poppins"),
            //                           ),
            //                         ],
            //                       ),
            //                       // subtotal
            //                       Padding(
            //                           padding: EdgeInsets.only(top: 5.0),
            //                           child: Row(
            //                             mainAxisAlignment:
            //                             MainAxisAlignment
            //                                 .spaceBetween,
            //                             children: [
            //                               Text(
            //                                 "SubTotal",
            //                                 style: Theme.of(context)
            //                                     .textTheme
            //                                     .caption
            //                                     .copyWith(
            //                                     fontSize: 14.0,
            //                                     fontWeight:
            //                                     FontWeight.w600,
            //                                     color: AppTheme
            //                                         .textColor,
            //                                     fontFamily:
            //                                     "Poppins"),
            //                               ),
            //                               Text(
            //                                 "\$" +
            //                                     totalCartValue.toString(),
            //                                 style: Theme.of(context)
            //                                     .textTheme
            //                                     .caption
            //                                     .copyWith(
            //                                     fontSize: 14.0,
            //                                     fontWeight:
            //                                     FontWeight.w600,
            //                                     color: AppTheme
            //                                         .textColor,
            //                                     fontFamily:
            //                                     "Poppins"),
            //                               ),
            //                             ],
            //                           )),
            //                       //convinience fee
            //                       Padding(
            //                           padding: EdgeInsets.only(top: 5.0),
            //                           child: Row(
            //                             mainAxisAlignment:
            //                             MainAxisAlignment
            //                                 .spaceBetween,
            //                             children: [
            //                               Text(
            //                                 "Convinience Fee",
            //                                 style: Theme.of(context)
            //                                     .textTheme
            //                                     .caption
            //                                     .copyWith(
            //                                     fontSize: 12.0,
            //                                     fontWeight:
            //                                     FontWeight.w400,
            //                                     color: AppTheme
            //                                         .textColor,
            //                                     fontFamily:
            //                                     "Poppins"),
            //                               ),
            //                               Text(
            //                                 "\$ " +
            //                                     conveniencFee.toString(),
            //                                 style: Theme.of(context)
            //                                     .textTheme
            //                                     .caption
            //                                     .copyWith(
            //                                     fontSize: 12.0,
            //                                     fontWeight:
            //                                     FontWeight.w400,
            //                                     color: AppTheme
            //                                         .textColor,
            //                                     fontFamily:
            //                                     "Poppins"),
            //                               ),
            //                             ],
            //                           )),
            //                       //Total
            //                       Padding(
            //                           padding: EdgeInsets.only(
            //                               top: 5.0, bottom: 15.0),
            //                           child: Row(
            //                             mainAxisAlignment:
            //                             MainAxisAlignment
            //                                 .spaceBetween,
            //                             children: [
            //                               Text(
            //                                 "Total",
            //                                 style: Theme.of(context)
            //                                     .textTheme
            //                                     .caption
            //                                     .copyWith(
            //                                     fontSize: 14.0,
            //                                     fontWeight:
            //                                     FontWeight.w600,
            //                                     color: AppTheme
            //                                         .textColor,
            //                                     fontFamily:
            //                                     "Poppins"),
            //                               ),
            //                               Text(
            //                                 OverallTotalVal == 0
            //                                     ? "\$ " +
            //                                     (totalCartValue +
            //                                         conveniencFee)
            //                                         .toString()
            //                                     : "\$ " +
            //                                     OverallTotalVal
            //                                         .toString(),
            //                                 style: Theme.of(context)
            //                                     .textTheme
            //                                     .caption
            //                                     .copyWith(
            //                                     fontSize: 14.0,
            //                                     fontWeight:
            //                                     FontWeight.w600,
            //                                     color: AppTheme
            //                                         .textColor,
            //                                     fontFamily:
            //                                     "Poppins"),
            //                               ),
            //                             ],
            //                           )),
            //                       Padding(
            //                           padding: EdgeInsets.only(top: 15.0),
            //                           child: AppButton(
            //                             onPressed: () {
            //                               if (date == "") {
            //                                 _scaffoldKey.currentState
            //                                     .showSnackBar(SnackBar(
            //                                     content: Text(
            //                                         "Please Choose Delivery time")));
            //                               }
            //                               // _signUp();
            //                               // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MainNavigation()));
            //                             },
            //                             shape:
            //                             const RoundedRectangleBorder(
            //                                 borderRadius:
            //                                 BorderRadius.all(
            //                                     Radius.circular(
            //                                         50))),
            //                             text: 'PLACE ORDER',
            //                             // loading: login is LoginLoading,
            //                             // disableTouchWhenLoading: true,
            //                           ))
            //                     ],
            //                   ))),
            //         ),
            //       ))
            //       :
            //   Container(
            //       child: Center(
            //           child: Text(
            //             "No Data Available",
            //             style: TextStyle(
            //                 fontSize: 16.0,
            //                 fontFamily: 'Poppins',
            //                 fontWeight: FontWeight.w600,
            //                 color: AppTheme.textColor),
            //           )))
            //   ],
            // ),
            );
          }),
        ));
  }
}
