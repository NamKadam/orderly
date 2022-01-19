import 'dart:convert';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:orderly/Api/api.dart';
import 'package:orderly/Blocs/authentication/bloc.dart';
import 'package:orderly/Blocs/home/home_bloc.dart';
import 'package:orderly/Blocs/mycart/bloc.dart';
import 'package:orderly/Blocs/mycart/cart_bloc.dart';
import 'package:orderly/Configs/image.dart';
import 'package:orderly/Configs/theme.dart';
import 'package:orderly/Models/model_scoped_cart.dart';
import 'package:orderly/Models/model_product_List.dart';
import 'package:orderly/Models/model_view_cart.dart';
import 'package:orderly/Screens/Customer/cart/addTime.dart';
import 'package:orderly/Screens/Customer/cart/cart_list_item.dart';
import 'package:orderly/Screens/mainNavigation.dart';
import 'package:orderly/Screens/profile/profAddress/prof_address.dart';
import 'package:orderly/Utils/Utils.dart';
import 'package:orderly/Utils/application.dart';
import 'package:orderly/Utils/connectivity_check.dart';
import 'package:orderly/Utils/preferences.dart';
import 'package:orderly/Utils/routes.dart';
import 'package:orderly/Utils/translate.dart';
import 'package:orderly/Utils/util_preferences.dart';
import 'package:orderly/Widgets/app_button.dart';
import 'package:orderly/Widgets/app_dialogs.dart';
import 'package:orderly/app_bloc.dart';
import 'package:orderly/db/orderly_database.dart';
import 'package:readmore/readmore.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';



class ShoppingCart extends StatefulWidget {
  String producerId,productId,qty,price,flagFrom;
  CartModel cartModel;
  List<Product> productList;



  // double totalCartValue;
  // ShoppingCart({Key key, @required this.producerId, @required this.model})
  //     : super(key: key);

  ShoppingCart({Key key, @required this.price,@required this.cartModel,@required this.productList,@required this.flagFrom})
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
  double OverallTotalVal = 0;
  CartBloc cartBloc;
  bool isconnectedToInternet = false;
  bool flagDataNotAvailable = false;
  List<Cart> _cartList;
  int producerListIndex = 0,subTotal=0;
  final _controller = RefreshController(initialRefresh: false);
  String flagRemove="";
  AddTimeData addTimeresult;

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
                                        date,
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
                                            "\u{20B9}" + totalCartValue.toString(),
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
                                            // "\$ 75.00",
                                              "\u{20B9} 75.00",
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
                                            // "\$ 75.00",
                                              Utils.getCurrencyPerLocale(cartModel.cart[0].currency) + "  75.00",
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
    // var formattedDate = new DateFormat('yyyy-MM-dd HH:mm').parse(date);
    // print(new DateFormat('dd MMM yyyy').format(DateTime.parse(date)));

    // var formattedDate = "${dateParse.year}-${dateParse.month}-${dateParse.day}";
    setState(() {
      // currentDate = formattedDate.toString();
      currentDate = date;//to convert to eg:-12 jan 2022
      print("currentDate:-" + currentDate);

    });
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    addTimeresult=new AddTimeData();
    cartBloc = BlocProvider.of<CartBloc>(context);
    // AppBloc.authBloc.add(OnSaveCart(widget.cartModel));
    // _cartList=_cartDatabase.getCartList() as List<Cart>;
    // OrderlyDatabase.database.getCartList().then((cart) {
    //   setState(() {
    //     cart.forEach((cart) {
    //       _cartList.add(cart);
    //       print(_cartList);
    //     });
    //   });
    // });
    // getCurrentDate();
    // setBlocData();
    getsharedPrefData();

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

  void calculateTotal(List<dynamic> cartList,int index,String flagRemove) {
    totalCartValue = 0;
    quantity = 0;
    String json = jsonEncode(cartList.map((i) => Cart.toJson(i)).toList()).toString();

    // var json1 = jsonEncode(cartList.map((e) => e.toJson()).toList());
    print("cartList:-" + json);
    cartList.forEach((f) {
      print(f.qty);
      totalCartValue += f.ratePerHour * f.qty;
      print('total cart value:-' + totalCartValue.toString());
      print('quantity:-' + quantity.toString());
    });
    if(flagRemove=="1"){
      _cartList.removeAt(index);
      if(_cartList.length<=0){
        flagDataNotAvailable=true;
      }
    }

    OverallTotalVal = totalCartValue + double.parse(cartModel.conveyanceFee);
    setState(() {});
  }

  //overall total
  void calculateOverallTotal(double total,double convenience){
    setState(() {
      OverallTotalVal=total+convenience;
      print("OverallTotal:-"+OverallTotalVal.toString());
    });
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
    if (model.cart.length>0) {
      // return ListView.builder(
      //   padding: EdgeInsets.all(0),
      //   shrinkWrap: true,
      //   physics: NeverScrollableScrollPhysics(),
      //   itemBuilder: (context, index) {Sing
      //     return Padding(
      //       padding: EdgeInsets.only(bottom: 15),
      //       child: Shimmer.fromColors(
      //         child: Row(
      //           children: <Widget>[
      //             Container(
      //               width: 80,
      //               height: 80,
      //               decoration: BoxDecoration(
      //                 borderRadius: BorderRadius.circular(8),
      //                 color: Colors.white,
      //               ),
      //             ),
      //             Padding(
      //               padding: EdgeInsets.only(
      //                 left: 10,
      //                 right: 10,
      //                 top: 5,
      //                 bottom: 5,
      //               ),
      //               child: Column(
      //                 crossAxisAlignment: CrossAxisAlignment.start,
      //                 children: <Widget>[
      //                   Container(
      //                     height: 10,
      //                     width: 180,
      //                     color: Colors.white,
      //                   ),
      //                   Padding(
      //                     padding: EdgeInsets.only(top: 5),
      //                   ),
      //                   Container(
      //                     height: 10,
      //                     width: 150,
      //                     color: Colors.white,
      //                   ),
      //                 ],
      //               ),
      //             ),
      //           ],
      //         ),
      //         baseColor: Theme.of(context).hoverColor,
      //         highlightColor: Theme.of(context).highlightColor,
      //       ),
      //     );
      //   },
      //   itemCount: 8,
      // );


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
                                    baseColor: Theme
                                        .of(context)
                                        .hoverColor,
                                    highlightColor:
                                    Theme
                                        .of(context)
                                        .highlightColor,
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
                                    baseColor: Theme
                                        .of(context)
                                        .hoverColor,
                                    highlightColor:
                                    Theme
                                        .of(context)
                                        .highlightColor,
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
                                    crossAxisAlignment: CrossAxisAlignment
                                        .start,
                                    children: [
                                      Text(
                                        model.cart[index].productName,
                                        // widget.users.firstName+" "+widget.users.lastName,
                                        style: Theme
                                            .of(context)
                                            .textTheme
                                            .caption
                                            .copyWith(
                                            fontSize: 14.0,
                                            fontWeight: FontWeight.w600,
                                            color: AppTheme.textColor,
                                            fontFamily: "Poppins"),
                                      ),
                                      ReadMoreText(
                                          model.cart[index].productDesc == null
                                              ? ""
                                              : model.cart[index].productDesc,
                                          style: Theme
                                              .of(context)
                                              .textTheme
                                              .button
                                              .copyWith(
                                              fontSize: 13.0,
                                              color: AppTheme.textColor,
                                              fontWeight: FontWeight.w400,
                                              fontFamily: "Poppins"),
                                          trimLines: 2,
                                          trimMode: TrimMode.Line,
                                          trimCollapsedText: 'Show more',
                                          trimExpandedText: 'Show less'

                                      ),
                                      Text(
                                        model.cart[index].producerName == null
                                            ? "Sold by: "
                                            : "Sold by: " +
                                            model.cart[index].producerName,
                                        style: Theme
                                            .of(context)
                                            .textTheme
                                            .button
                                            .copyWith(
                                            fontSize: 12.0,
                                            color: AppTheme.appColor,
                                            fontWeight: FontWeight.w500,
                                            fontFamily: "Poppins"),
                                      ),
                                      Text(
                                        model.cart[index].ratePerHour
                                            .toString() +
                                            " " + Utils.getCurrencyPerLocale(
                                            model.cart[index].currency) + " /" +
                                            model.cart[index].unit,
                                        style: Theme
                                            .of(context)
                                            .textTheme
                                            .button
                                            .copyWith(
                                            fontSize: 13.0,
                                            color: Theme
                                                .of(context)
                                                .primaryColor,
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
                            Border.all(color: Theme
                                .of(context)
                                .dividerColor),
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
                                              if ((model.cart[index].qty - 1) ==
                                                  0) {
                                                flagRemove = "1";
                                              } else {
                                                flagRemove = "";
                                                model.updateProduct(
                                                    model.cart[index],
                                                    model.cart[index].qty - 1);

                                                calculateOverallTotal(
                                                    model.totalCartValue,
                                                    double.parse(cartModel.conveyanceFee));

                                                // calculateTotal(model.cart,index,flagRemove);

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
                                          color: Theme
                                              .of(context)
                                              .primaryColor),
                                    ),
                                    Padding(
                                        padding: EdgeInsets.only(left: 15.0),
                                        child: InkWell(
                                            onTap: () {
                                              if ((model.cart[index].qty + 1) >
                                                  widget.productList[index]
                                                      .qty) { //updated on 4/01/2022 for out of stock part
                                                Fluttertoast.showToast(
                                                    msg: "Out Of stock");
                                              } else {
                                                model.updateProduct(
                                                    model.cart[index],
                                                    model.cart[index].qty + 1);
                                              }
                                              // calculateTotal(model.cart,index,"0");
                                              calculateOverallTotal(
                                                  model.totalCartValue,
                                                  double.parse(cartModel.conveyanceFee));
                                            },
                                            child: Image.asset(
                                              Images.plus,
                                              height: 22.0,
                                              width: 22.0,
                                            )
                                        )),
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
                    cartBloc.add(OnDeleteCartList(
                        cartId: _cartList[index].id.toString()));
                    // setState(() {
                    //   if(_cartList[index]==0) {
                    //     flagDataNotAvailable = true;
                    //   }
                    // });
                    model.removeProduct(_cartList[index]);


                    // setState(() {
                    // _cartList.removeAt(index);
                    // model.cart.removeAt(index);
                    //   model.cart.removeAt(index);
                    //   if(_cartList.length==0) {
                    //     flagDataNotAvailable = true;
                    //   }
                    // });

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
  }

  Future<void> setsharedPrefData() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    // // Encode and store data in SharedPreferences
    String encodedData = jsonEncode(cartModel.cart.map((i) => Cart.toJson(i)).toList()).toString();

    // final String encodedData = Cart.encode(cartModel.cart);
    await prefs.setString('cart_key', encodedData);
    Navigator.pop(context);
    // // Fetch and decode data
    // final String cartString = await prefs.getString('cart_key');
    // final List<Cart> cartList = Cart.decode(cartString);

  }

  //get from sharedpref
  Future<void> getsharedPrefData() async{
    print("cartModel:"+Application.cartModel.toString());
    cartModel=new CartModel();
    if(Application.cartModel!=null&&Application.cartModel.cart.length>0){
      _cartList=Application.cartModel.cart;
      cartModel=Application.cartModel;

    }
    // else if(widget.flagFrom=="0"){
    //   _cartList=widget.cartModel.cart;
    //   cartModel=widget.cartModel;
    // }
    else{//from main page cart icon redirection

      // _cartList=Application.cartModel.cart;
      // cartModel=Application.cartModel;
      print(widget.cartModel);

      _cartList=widget.cartModel.cart.length>0 ||widget.cartModel!=null?widget.cartModel.cart:null;
      cartModel=widget.cartModel;
    }
    calculateOverallTotal(cartModel.totalCartValue, double.parse(cartModel.conveyanceFee));
    // calculateOverallTotal(Application.cartModel.totalCartValue, conveniencFee);
    print(_cartList);

  }

  void clearData(){
    AddTime.isCheckedfree=false;
    AddTime.isCheckedCharged=false;
    AddTime.radioDay='';
    AddTime.dateTime="";
    AddTime.deliveryType='';
    AddTime.deliverySlot='';
    AddTime.chargedAmt=null;
    AddTime.currentDate=null;
    AddTime.selectedDate=null;
    AddTime.time=null;
  }



  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        key: _scaffoldKey,
        appBar: new AppBar(
          title: Text(
            'Cart',
            style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
                fontSize: 18.0,
                color: AppTheme.textColor),
          ),
          leading: InkWell(
              onTap: () {
                clearData();
                AppBloc.authBloc.add(OnSaveCart(cartModel));
                // AppBloc.authBloc.add(OnSaveCart(Application.cartModel));
                Navigator.pop(context,cartModel);
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
              // cartModel=new CartModel();
              _cartList = state.cartList;
              if(_cartList==null) {
                flagDataNotAvailable = true;
              }
              // Application.cartModel.addAllProduct(_cartList);
              cartModel.addAllProduct(_cartList);
            }
            //for delete cartList
            if(state is CartDeleteSuccess){
              print('deleted');
            }
            return ScopedModel<CartModel>(
              // model: Application.cartModel!=null?Application.cartModel:cartModel=new CartModel(),
                model:  cartModel,
                child: ScopedModelDescendant<CartModel>(
                  builder: (context, child, model) {
                    cartModel=model;
                    print("cartModel:-"+widget.cartModel.toString());
                    return Container(
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

                                      },
                                      // child: buildCartList(index, Application.cartModel)
                                      child: buildCartList(index, cartModel)

                                  );
                                })),

                            // bottom dialog
                            cartModel.totalCartValue!=0.0
                            // Application.cartModel!=null && Application.cartModel.totalCartValue!=0.0
                                ?
                            Align(
                                alignment: Alignment.bottomCenter,
                                child: new ClipRect(
                                  child: new BackdropFilter(
                                    filter: new ImageFilter.blur(
                                        sigmaX: 10.0, sigmaY: 10.0),
                                    child: new Container(
                                        width: MediaQuery.of(context).size.width,
                                        height: 240.0,
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
                                                          subTotal==0
                                                              ?
                                                          // "\u{20B9}" + cartModel.totalCartValue.toString()
                                                          Utils.getCurrencyPerLocale(cartModel.cart[0].currency) + " "+cartModel.totalCartValue.toString()
                                                          // "\$" + Application.cartModel.totalCartValue.toString()
                                                              :
                                                          Utils.getCurrencyPerLocale(cartModel.cart[0].currency) + " " + subTotal.toString(),
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
                                                //Conveyance fee
                                                Padding(
                                                    padding: EdgeInsets.only(top: 5.0),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                      children: [
                                                        Text(
                                                          "Conveyance Fee",
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
                                                          Utils.getCurrencyPerLocale(cartModel.cart[0].currency) + " " + cartModel.conveyanceFee.toString(),
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
                                                          // OverallTotalVal == 0
                                                          //     ?
                                                          // "\$ " + (subTotal.toDouble() + conveniencFee).toString()
                                                          //     :
                                                          // "\$ " + OverallTotalVal
                                                          //         .toString(),
                                                        Utils.getCurrencyPerLocale(cartModel.cart[0].currency) + " "+OverallTotalVal.toString(),
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
                                                //delivery time
                                                Row(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    // GestureDetector(
                                                    //     onTap: () async {
                                                    //       // final List<String> _response = await Navigator.push(
                                                    //       //   context,
                                                    //       //     await Navigator.pushNamed(context, Routes.addTime));
                                                    //       // //for date
                                                    //       //    if(_response[0]==""){
                                                    //       //      date = currentDate;
                                                    //       //    }else{
                                                    //       //      date = _response[0];
                                                    //       //    }
                                                    //       //    String deliverySlot=_response[3];
                                                    //       //    String deliveryType=_response[2];
                                                    //       //    String amt=_response[1];
                                                    //       //    setState(() {
                                                    //       //
                                                    //       //    });
                                                    //       // addTimeresult = await Navigator.push(context, MaterialPageRoute(builder: (context)=>
                                                    //       await Navigator.push(context, MaterialPageRoute(builder: (context)=>
                                                    //           AddTime()));
                                                    //       print("result:-" + addTimeresult.toString());
                                                    //       print("currentDate:-" + currentDate);
                                                    //
                                                    //       if (AddTime.dateTime == "") {
                                                    //         AddTime.dateTime = currentDate;
                                                    //         AddTime.time=DateFormat('hh:mm a').format(DateTime.now());
                                                    //         AddTime.currentDate=currentDate;
                                                    //         AddTime.selectedDate=currentDate;
                                                    //         date=currentDate;
                                                    //       } else {
                                                    //         date = AddTime.dateTime;
                                                    //       }
                                                    //       //for amt
                                                    //       // if(addTimeresult.chargeAmt!=null){
                                                    //       if(AddTime.chargedAmt!=null){
                                                    //         try {
                                                    //           // subTotal = Application.cartModel.totalCartValue.toInt() + int.parse(AddTime.chargedAmt);
                                                    //           subTotal = cartModel.totalCartValue.toInt() + int.parse(AddTime.chargedAmt);
                                                    //           print(subTotal);
                                                    //         }catch(e){
                                                    //           print(e);
                                                    //         }
                                                    //         // widget.cartModel.totalCartValue+=int.parse(addTimeresult.chargeAmt);
                                                    //       }else{
                                                    //         // subTotal=Application.cartModel.totalCartValue.toInt();
                                                    //         subTotal=cartModel.totalCartValue.toInt();
                                                    //       }
                                                    //       calculateOverallTotal(subTotal.toDouble(), conveniencFee);
                                                    //
                                                    //       setState(() {});
                                                    //
                                                    //     },
                                                    //     child:
                                                    //     // Text(
                                                    //     //   "Choose Delivery",
                                                    //     //   style: Theme.of(context)
                                                    //     //       .textTheme
                                                    //     //       .caption
                                                    //     //       .copyWith(
                                                    //     //       fontSize: 14.0,
                                                    //     //       fontWeight:
                                                    //     //       FontWeight.w600,
                                                    //     //       color:
                                                    //     //       Theme.of(context)
                                                    //     //           .primaryColor,
                                                    //     //       fontFamily:
                                                    //     //       "Poppins"),
                                                    //     // )
                                                    //
                                                    // ),
                                                    Container(
                                                        height: 30.0,
                                                        child:ElevatedButton(

                                                          style: ElevatedButton.styleFrom(
                                                            side: BorderSide(color: Theme.of(context).primaryColor, width: 1),
                                                            primary: Theme.of(context).primaryColor,
                                                            shape: const RoundedRectangleBorder(
                                                                borderRadius:
                                                                BorderRadius.all(Radius.circular(15))),
                                                          ),
                                                          child: Text(
                                                            "Select Delivery Option *",
                                                            style: TextStyle(
                                                                fontWeight: FontWeight.w600,
                                                                fontFamily: 'Poppins',
                                                                fontSize: 12.0,
                                                                color: Colors.white),
                                                          ),
                                                          onPressed: () async {
                                                            _scaffoldKey.currentState.hideCurrentSnackBar();
                                                            await Navigator.push(context, MaterialPageRoute(builder: (context)=>
                                                                AddTime()));
                                                            print("result:-" + addTimeresult.toString());
                                                            print("currentDate:-" + currentDate);

                                                            // if (AddTime.dateTime == "") {
                                                            if (AddTime.isCheckedCharged == true) {
                                                              // AddTime.dateTime = currentDate;
                                                              // AddTime.time=DateFormat('hh:mm a').format(DateTime.now());
                                                              // AddTime.currentDate=AddTime.dateTime;
                                                              AddTime.selectedDate=AddTime.currentDate;
                                                              date=(DateFormat('dd MMM yyyy').format(DateTime.parse(AddTime.currentDate)))+" "+AddTime.time;
                                                              print("date:-"+date);

                                                            } else {
                                                              date=DateFormat('dd MMM yyyy').format(DateTime.parse(AddTime.dateTime));
                                                              String day=AddTime.deliverySlot=="0"?"Morning":"Evening";
                                                              date=date+" - "+day;
                                                              print("date:-"+date+"- "+AddTime.deliverySlot=="0"?"Morning":"Evening");
                                                            }
                                                            //for amt
                                                            // if(addTimeresult.chargeAmt!=null){
                                                            if(AddTime.chargedAmt!=null){
                                                              try {
                                                                // subTotal = Application.cartModel.totalCartValue.toInt() + int.parse(AddTime.chargedAmt);
                                                                subTotal = cartModel.totalCartValue.toInt() + int.parse(AddTime.chargedAmt);
                                                                print(subTotal);
                                                              }catch(e){
                                                                print(e);
                                                              }
                                                              // widget.cartModel.totalCartValue+=int.parse(addTimeresult.chargeAmt);
                                                            }else{
                                                              // subTotal=Application.cartModel.totalCartValue.toInt();
                                                              subTotal=cartModel.totalCartValue.toInt();
                                                            }
                                                            calculateOverallTotal(subTotal.toDouble(), double.parse(cartModel.conveyanceFee));

                                                            setState(() {

                                                            });

                                                          },

                                                        )),
                                                    Text(
                                                      date,
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .caption
                                                          .copyWith(
                                                          fontSize: 13.0,
                                                          fontWeight:
                                                          FontWeight.w500,
                                                          color: AppTheme.textColor,
                                                          fontFamily: "Poppins"),
                                                    ),
                                                  ],
                                                ),
                                                Padding(
                                                    padding: EdgeInsets.only(top: 20.0),
                                                    child: AppButton(
                                                      onPressed: () {
                                                        if (date == "") {
                                                          _scaffoldKey.currentState
                                                              .showSnackBar(SnackBar(
                                                              duration: Duration(seconds: 2),
                                                              content: Text(
                                                                  "Please Select Delivery Option")));
                                                        }else {

                                                          String cart_json = jsonEncode(cartModel.cart.map((i)
                                                          // String cart_json = jsonEncode(Application.cartModel.cart.map((i)
                                                          => Cart.toJson(i)).toList()).toString();
                                                          // var json1 = jsonEncode(cartList.map((e) => e.toJson()).toList());
                                                          print("cartList:-" + cart_json);
                                                          print("cartList:-" + cartModel.cart.toString());
                                                          Navigator.push(context,
                                                              MaterialPageRoute(builder: (context)
                                                              =>ProfAddress(
                                                                // cartDetails: Application.cartModel.cart,
                                                                cartDetails: cartModel.cart,
                                                                // subTotal:Application.cartModel.totalCartValue.toString(),
                                                                subTotal:cartModel.totalCartValue.toString(),
                                                                convFee:cartModel.conveyanceFee.toString(),
                                                                total:OverallTotalVal.toString(),
                                                              )
                                                              )
                                                          );
                                                        }
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
                  },
                ));

          }),
        ));
  }
}
