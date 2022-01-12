import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:orderly/Api/api.dart';
import 'package:orderly/Blocs/authentication/authentication_event.dart';
import 'package:orderly/Blocs/home/bloc.dart';
import 'package:orderly/Blocs/home/home_bloc.dart';
import 'package:orderly/Blocs/home/home_event.dart';
import 'package:orderly/Configs/image.dart';
import 'package:orderly/Configs/theme.dart';
import 'package:orderly/Models/model_producer_list.dart';
import 'package:orderly/Models/model_product_List.dart';
import 'package:orderly/Models/model_scoped_cart.dart';
import 'package:orderly/Models/model_view_cart.dart';
import 'package:orderly/Screens/Customer/cart/shopping_cart.dart';
import 'package:orderly/Screens/Customer/home/home_item_detail.dart';
import 'package:orderly/Utils/application.dart';
import 'package:orderly/Utils/connectivity_check.dart';
import 'package:orderly/Utils/preferences.dart';
import 'package:orderly/Utils/progressDialog.dart';
import 'package:orderly/Utils/routes.dart';
import 'package:orderly/Utils/translate.dart';
import 'package:orderly/Utils/util_preferences.dart';
import 'package:orderly/Widgets/app_button.dart';
import 'package:orderly/Widgets/app_dialogs.dart';
import 'package:orderly/app_bloc.dart';
import 'package:orderly/db/orderly_database.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shimmer/shimmer.dart';
import 'package:http/http.dart' as http;


class Home extends StatefulWidget {
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<int> selectedIndexList = []; //for selected index
  List<Product> _productList,totalProductList;
  List<Producer> _producerList;

  HomeBloc _homeBloc;
  int producerListIndex = 0;
  final _controller = RefreshController(initialRefresh: false);

  final _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool _refreshing = false;
  bool isconnectedToInternet = false;
  String type = "ALL";
  int offset = 0;
  bool flagDataNotAvailable = false;
  CartModel cartModel;
  PagingController<int, Product> _pagingController;
  int _pageSize;
  static bool AddedFlag=false;
  ScrollController _scrollController = new ScrollController();


  Future<bool> _exitApp(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: new Text('Do you want to exit this application?'),
            actions: <Widget>[
              FlatButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: new Text('No'),
              ),
              FlatButton(
                // onPressed: () => Navigator.of(context).pop(true),
                onPressed: () => exit(0), //updated on 12/02/2021
                child: new Text('Yes'),
              ),
            ],
          );
        }) ??
        false;
  }

  Future<void> _showMessage(String message) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            "",
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
            ElevatedButton(
              child: Text(
                'OK',
              ),
              onPressed: () async{
                // Navigator.of(context).pop();
                final result=await Navigator.push(context, MaterialPageRoute(
                    builder: (context)=> ShoppingCart(flagFrom:"0",cartModel: Application.cartModel,) //from home
                ));
                if(result!=null){
                  result[0]=Application.cartModel;
                }

              },
            ),
          ],
        );
      },
    );
  }

  void getOfflineDbProduct(){
    //for producerlist
    OrderlyDatabase.database.getProducerList().then((producer) {
      setState(() {
        // producer.forEach((produc) {
        _producerList=producer;
        print(_producerList);
        // });
      });
    });

    //for product
    OrderlyDatabase.database.getProdList().then((prod) {
      setState(() {
        // prod.forEach((product) {
        _productList=prod;
        print(_productList);
        // });
      });
    });
  }


  void initState() {
    // SystemChannels.textInput.invokeMethod('TextInput.hide');

    cartModel=new CartModel();
    _homeBloc = BlocProvider.of<HomeBloc>(context);
    totalProductList=[];
    paginationCall(_producerList);
    getData();
    // _scrollController.addListener(() {
    //   if (_scrollController.position.pixels ==
    //       _scrollController.position.maxScrollExtent) {
    //     offset+=10;
    //     _homeBloc.add(OnLoadingProductList(
    //       producerId: _producerList[producerListIndex].producerId.toString(),
    //       type: type,
    //       offset:offset.toString(),
    //     ));
    //
    //   }
    // });

    super.initState();

  }

  void paginationCall(List<Producer> producerList){
    _pageSize=10;
    _pagingController= PagingController(firstPageKey: 0);
    //updated on 15/11/2021 for pagination
    _pagingController.addPageRequestListener((pageKey) {
      offset= pageKey;
      print("pageKey:-"+pageKey.toString());
      _homeBloc.add(OnLoadingProductList(
        producerId: producerList[producerListIndex].producerId.toString(),
        type: type,
        offset:offset.toString(),
      ));
    });
  }

  void getData(){
    final String cartString = UtilPreferences.getString(Preferences.cart);
    if(cartString!=null) {

      var _cart= jsonDecode(cartString).toList();
      List<dynamic> _cartList = _cart.map((cartJson) => Cart.fromJson(cartJson)).toList();
      cartModel.addAllProduct(_cartList.cast<Cart>());
      Application.cartModel=cartModel;
      print(_cartList);

    }
    setBlocData();
  }

  void setBlocData() async {
    isconnectedToInternet = await ConnectivityCheck.checkInternetConnectivity();
    if (isconnectedToInternet == true) {
      _homeBloc.add(OnLoadingProducerList());
    } else {
      // CustomDialogs.showDialogCustom(
      //     "Internet", "Please check your Internet Connection!", context);
      getOfflineDbProduct();
    }
  }

  ///On Refresh List
  Future<void> _onRefresh() async {
    _producerList=null;
    totalProductList=[];
    offset=0;
    _pageSize=10;
    await Future.delayed(Duration(milliseconds: 1000));
    //
    // _homeBloc.add(OnLoadingProductList(
    //     producerId: _producerList[producerListIndex].producerId.toString(),
    //     type: type,
    //     offset: offset.toString(),
    //     ));
    // _homeBloc.add(OnLoadingProducerList());
    setBlocData();
    _controller.refreshCompleted();
  }

  Future<void> AddedToCart(CartModel model,String producerId,String productId,String qty,String price) async {
    Map<String,String> params={
      'producer_id':producerId,
      'product_id':productId,
      'user_id':Application.user.fbId,
      // 'qty':qty,
      'qty':"1", //updated on 4/01/2022 by default set to 1
      'rate_per_hour':price
    };

    var response = await http.post(Uri.parse(Api.ADD_TO_CART),
      body: params,
    );

    try{
      if (response.statusCode == 200) {
        var resp = json.decode(response.body);
        if(resp['msg']=="Successed"){
          final Iterable refactorCategory = resp['cart'] ?? [];
          final listCategory = refactorCategory.map((item) {
            return Cart.fromJson(item);
          }).toList();
          // //
          model.addProduct(listCategory[0]);
          AppBloc.authBloc.add(OnSaveCart(model));
          //for offline db
          // OrderlyDatabase.database.add(listCategory[0]);
          // print(OrderlyDatabase.database.toString());
          if(model!=null){
            CartModel cartmodel=await
            Navigator.push(context, MaterialPageRoute(builder: (context)=>
                ShoppingCart(flagFrom:"0",productList:totalProductList,price:price,cartModel:model)));
            if(cartmodel!=null){
              Application.cartModel=cartmodel;
            }
          }
        }else{
          print('exists');
          CartModel cartmodel=await
          Navigator.push(context, MaterialPageRoute(builder: (context)=>
              ShoppingCart(flagFrom:"0",productList:totalProductList,price:price,cartModel:model)));
          if(cartmodel!=null){
            Application.cartModel=cartmodel;
          }
        }
        setState(() {

        });
        // await PsProgressDialog.showProgressWithoutMsg(context);
      }
    }catch(e){
      print(e);
    }
  }


  @override
  Widget build(BuildContext context) {
    //for producer List
    Widget buildCategory(List<Producer> producerList) {
      if (producerList == null) {
        return ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.only(left: 5, right: 20, top: 10, bottom: 15),
          itemBuilder: (context, index) {
            return Shimmer.fromColors(
              baseColor: Theme.of(context).hoverColor,
              highlightColor: Theme.of(context).highlightColor,
              enabled: true,
              child: Container(
                width: MediaQuery.of(context).size.width * 0.21,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      width: 50,
                      height: 50,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 3),
                      child: Text(
                        Translate.of(context).translate('loading'),
                        style: Theme.of(context)
                            .textTheme
                            .caption
                            .copyWith(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
          itemCount: List.generate(8, (index) => index).length,
        );
      }

      return ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.only(left: 5, right: 20, top: 10, bottom: 15),
        itemBuilder: (context, index) {
          final item = producerList[index];
          return Padding(
              padding: EdgeInsets.only(left: 15),
              child: GestureDetector(
                  onTap: () async{
                    print('clicked category');
                    // WidgetsBinding.instance.addPostFrameCallback((_)
                    //     {
                    //       if(mounted) {
                    //         setState(() {
                    offset=0;
                    totalProductList=[];
                    producerListIndex = index;
                    type = index == 0 ? "ALL" : "";
                    flagDataNotAvailable = false;
                    // });
                    paginationCall(producerList);
                    _homeBloc.add(OnLoadingProductList(
                        producerId: producerList[producerListIndex]
                            .producerId
                            .toString(),
                        type: type,
                        offset: offset.toString()));
                    },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      CachedNetworkImage(
                        imageUrl: item.producerIconUrl,
                        imageBuilder: (context, imageProvider) {
                          return Container(
                            height: 60.0,
                            width: 60.0,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(
                                Radius.circular(30),
                              ),
                              image: DecorationImage(
                                image: imageProvider,
                                fit: BoxFit.cover,
                              ),
                            ),
                            child: Container(
                              padding: EdgeInsets.all(8),
                            ),
                          );
                        },
                        placeholder: (context, url) {
                          return Shimmer.fromColors(
                            baseColor: Theme.of(context).hoverColor,
                            highlightColor: Theme.of(context).highlightColor,
                            enabled: true,
                            child: Container(
                              height: 60.0,
                              width: 60.0,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(30),
                                ),
                              ),
                            ),
                          );
                        },
                        errorWidget: (context, url, error) {
                          return Shimmer.fromColors(
                            baseColor: Theme.of(context).hoverColor,
                            highlightColor: Theme.of(context).highlightColor,
                            enabled: true,
                            child: Container(
                              height: 60.0,
                              width: 60.0,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(30),
                                ),
                              ),
                              child: Icon(Icons.error),
                            ),
                          );
                        },
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 8, right: 8),
                        child: Text(
                          item.producerName,
                          style: TextStyle(
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w500,
                              fontSize: 12.0,
                              color: producerListIndex==index?AppTheme.appColor:AppTheme.textColor),
                        ),
                      )
                    ],
                  )));
        },
        itemCount: producerList.length,
      );
    }

    Widget buildListViewItemProd(int index, Product product, CartModel model) {
      print("product:-"+product.toString());
      if (product == null) {
        // return ListView.builder(
        //   padding: EdgeInsets.all(0),
        //   shrinkWrap: true,
        //   physics: NeverScrollableScrollPhysics(),
        //   itemBuilder: (context, index) {
        //     return Padding(
        //       padding: EdgeInsets.only(bottom: 15),
        //       child:
        //       Shimmer.fromColors(
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
        //
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
        return FractionallySizedBox(
            widthFactor: 0.5,
            child:
          Container(
            padding: EdgeInsets.only(left: 8),
            child: Card(
                elevation: 3.0,
                shape: RoundedRectangleBorder(),
                child: Shimmer.fromColors(
                  baseColor: Theme.of(context).hoverColor,
                  highlightColor: Theme.of(context).highlightColor,
                  enabled: true,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        height: 110,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.zero,
                          color: Colors.white,
                        ),
                      ),
                      Padding(padding: EdgeInsets.only(top: 3)),
                      Text(
                        "Loading",
                        style: Theme.of(context).textTheme.caption.copyWith(
                            fontWeight: FontWeight.w400,
                            fontFamily: 'Poppins',
                            color: AppTheme.textColor),
                      ),
                      Padding(padding: EdgeInsets.only(top: 2)),
                      Text(
                        "Loading...",
                        maxLines: 1,
                        style: Theme.of(context)
                            .textTheme
                            .subtitle2
                            .copyWith(
                            fontWeight: FontWeight.w600,
                            fontFamily: "Poppins",
                            color: Theme.of(context).primaryColor),
                      ),
                    ],
                  ),
                ))));
      }
      return Container(
          padding: EdgeInsets.only(left: 8),
          child: Card(
            elevation: 3.0,
            shape: RoundedRectangleBorder(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              // mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                CachedNetworkImage(
                  imageUrl: product.productImage,
                  imageBuilder: (context, imageProvider) {
                    return Container(
                      height: 110,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.zero,
                        image: DecorationImage(
                          image: imageProvider,
                          fit: BoxFit.cover,
                        ),
                      ),
                    );
                  },
                  placeholder: (context, url) {
                    return Shimmer.fromColors(
                      baseColor: Theme.of(context).hoverColor,
                      highlightColor: Theme.of(context).highlightColor,
                      enabled: true,
                      child: Container(
                        height: 110,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.zero,
                          color: Colors.white,
                        ),
                      ),
                    );
                  },
                  errorWidget: (context, url, error) {
                    return Shimmer.fromColors(
                      baseColor: Theme.of(context).hoverColor,
                      highlightColor: Theme.of(context).highlightColor,
                      enabled: true,
                      child: Container(
                        height: 110,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.zero,
                        ),
                        child: Icon(Icons.error),
                      ),
                    );
                  },
                ),
                Padding(padding: EdgeInsets.only(top: 3)),
                Padding(
                    padding: EdgeInsets.only(left:10.0,right: 10.0),
                    child:Text(
                      product.productName,
                      style: Theme.of(context).textTheme.caption.copyWith(
                          fontWeight: FontWeight.w400,
                          fontFamily: 'Poppins',
                          color: AppTheme.textColor),
                    )),
                Padding(padding: EdgeInsets.only(top: 2)),
                Text(
                  product.ratePerHour.toString() + " \u{20B9}/hr",
                  maxLines: 1,
                  style: Theme.of(context).textTheme.subtitle2.copyWith(
                      fontWeight: FontWeight.w600,
                      fontFamily: "Poppins",
                      color: Theme.of(context).primaryColor),
                ),
                //updated on 2/09/2021
                Padding(
                    padding: EdgeInsets.all(15.0),
                    child: SizedBox(
                        height: 25.0,
                        width: MediaQuery.of(context).size.width,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              side: BorderSide(
                                  color: Theme.of(context).primaryColor,
                                  width: 1),
                              primary: AppTheme.verifyPhone,
                              shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(50))),
                            ),
                            // shape: shape,
                            onPressed: () async {
                              // model.addProduct(_productList[index]);
                              // Navigator.push(context, MaterialPageRoute(builder: (context)=>ShoppingCart(price:_productList[index].ratePerHour.toString(),cartModel:model)));
                              if (isconnectedToInternet == true) {
                                AddedFlag=true;

                                await PsProgressDialog
                                    .showProgressWithoutMsg(context);
                                AddedToCart(model,
                                    // _producerList[producerListIndex]
                                    //     .producerId.toString(),
                                    totalProductList[index].producerid.toString(), //updated on 4/01/2022
                                    totalProductList[index].productId
                                        .toString(),
                                    totalProductList[index].qty
                                        .toString(),
                                    totalProductList[index].ratePerHour
                                        .toString());
                              }else{
                                CustomDialogs.showDialogCustom(
                                    "Internet", "Please be online to proceed further!", context);
                              }
                            },
                            child: index < 0
                                ? Center(child: CircularProgressIndicator())
                                :
                            Stack(
                              // mainAxisAlignment: MainAxisAlignment.center,
                              // crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Align(
                                    alignment: Alignment.center,
                                    child: Text(
                                      'ADD',
                                      style: Theme.of(context)
                                          .textTheme
                                          .button
                                          .copyWith(
                                          color: Colors.black,
                                          fontWeight:
                                          FontWeight.w500,
                                          fontSize: 12.0),
                                    )),
                                // Align(
                                //     alignment: Alignment.centerRight,
                                //     //    child: InkWell(
                                //     // onTap: (){
                                //     //   setState(() {
                                //     //     // flagClickDisableAdd=true;
                                //     //
                                //     //   });
                                //     // },
                                //     child: Icon(Icons.add,
                                //         size: 20.0,
                                //         color: Colors.black)
                                //   // )
                                // )
                              ],
                            )
                        )
                    )
                )



              ],
            ),
          ));
    }

    // TODO: implement build
    return WillPopScope(
        onWillPop: () => _exitApp(context),
        child: Scaffold(
            key: _scaffoldKey,
            appBar:
            AppBar(
              title: Text(
                "Home",
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
                    InkWell(
                        onTap: (){

                        },
                        child:Stack(children: [
                      // IconButton(
                      //   icon:
                        Image.asset(
                          Images.notiIcon,
                          width: 35.0,
                          height: 35.0,
                        ),
                        // tooltip: "Save Todo and Retrun to List",
                      //   onPressed: () {},
                      // ),
                      Positioned(
                        right: 5,
                        top: 3,
                        child: new Container(
                          padding: EdgeInsets.all(1),
                          decoration: new BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(8.5),
                          ),
                          constraints: BoxConstraints(
                            minWidth: 15,
                            minHeight: 12,
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
                    // if(Application.user.userType=="0") //for customer
                    InkWell(
                      onTap: () async{
                        CartModel cartmodel=await Navigator.push(context, MaterialPageRoute(
                            builder: (context)=> ShoppingCart(productList: totalProductList,)
                        ));
                        if(cartmodel!=null){
                          setState(() {
                            Application.cartModel=cartModel;

                          });
                        }
                      },
                      child: Stack(
                        children: [
                          Image.asset(
                              Images.cart,
                              width: 35.0,
                              height: 35.0,
                            ),
                            // tooltip: "Save Todo and Retrun to List",
                            // onPressed: () {
                            //   // Navigator.push(context, MaterialPageRoute(
                            //   //     builder: (context)=> ShoppingCart()
                            //   // ));
                            // },
                          // ),
                          Positioned(
                            right: 5,
                            top:1,
                            child: new Container(
                              padding: EdgeInsets.all(1),
                              decoration: new BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(8.5),
                              ),
                              constraints: BoxConstraints(
                                minWidth: 15,
                                minHeight: 12,
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
            ),
            //   automaticallyImplyLeading:false,
            // ),
            body: BlocListener<HomeBloc, HomeState>(listener: (context, state) {
              if (state is ProducerListLoadFail) {}
            }, child:
            BlocBuilder<HomeBloc, HomeState>(builder: (context, state) {
              // List<Producer> _producerList;
              // List<Product> _productList;
              if (state is ProducerListSuccess) {
                _producerList = state.producerList;
                offset=0;
                paginationCall(_producerList);
                _homeBloc.add(OnLoadingProductList(
                    producerId:
                    _producerList[producerListIndex].producerId.toString(),
                    type: type,
                    offset: offset.toString()));
              }

              if (state is ProductListSuccess) {
                  if(_productList==null){
                    _productList = state.productList;
                    totalProductList.addAll(_productList);
                    if (_productList.length>0 ) {
                      flagDataNotAvailable = false;

                      //for pagination
                      final isLastPage = _productList.length < _pageSize;
                      if (isLastPage) {
                        _pagingController.appendLastPage(_productList);
                      } else {
                        final nextPageKey = offset + _productList.length;
                        _pagingController.appendPage(_productList, nextPageKey);
                      }
                    }else {
                      flagDataNotAvailable = true;
                    }
                  }else{
                    // _onRefresh();
                    // _productList=totalProductList;
                  }
              }

              if(state is ProductLoading){
                _productList=null;
              }

              //for addto cart
              if(state is AddToCartSuccess){
                // Navigator.push(context, MaterialPageRoute(
                //     builder: (context)=> ShoppingCart()
                // ));
                Navigator.pushNamed(context, Routes.cart);
              }
              return
                ScopedModel<CartModel>(
                    model:cartModel,
                    child:ScopedModelDescendant<CartModel>(
                        builder: (context, child, model) {
                          return SafeArea(

                              child:
                              SmartRefresher(
                                  enablePullDown: true,
                                  // enablePullUp: true, //used for pagination
                                  // enablePullUp: state is ProductListSuccess, //used for pagination,
                                  onRefresh: _onRefresh,
                                  // onLoading: () {
                                  //         offset += 10;
                                  //         _homeBloc.add(OnLoadingProductList(
                                  //         producerId: _producerList[producerListIndex].producerId.toString(),
                                  //         type: type,
                                  //         offset: offset.toString()
                                  //         ));
                                  //         _controller.refreshCompleted();
                                  //         _controller.loadComplete();
                                  //
                                  //
                                  // },
                                  controller: _controller,
                                  // header: ClassicHeader(
                                  //   idleText: Translate.of(context).translate(
                                  //     'pull_down_refresh',
                                  //   ),
                                  //   refreshingText: Translate.of(context).translate(
                                  //     'refreshing',
                                  //   ),
                                  //   // completeText: Translate.of(context).translate(
                                  //   //   'refresh_completed',
                                  //   // ),
                                  //   releaseText: Translate.of(context).translate(
                                  //     'release_to_refresh',
                                  //   ),
                                  //   refreshingIcon: SizedBox(
                                  //     width: 16.0,
                                  //     height: 16.0,
                                  //     child: CircularProgressIndicator(strokeWidth: 2),
                                  //   ),
                                  // ),
                                  // footer: ClassicFooter(
                                  //   loadingText: Translate.of(context).translate('loading'),
                                  //   canLoadingText: Translate.of(context).translate(
                                  //     'release_to_load_more',
                                  //   ),
                                  //   idleText: Translate.of(context).translate(
                                  //     'pull_to_load_more',
                                  //   ),
                                  //   loadStyle: LoadStyle.ShowWhenLoading,
                                  //   loadingIcon: SizedBox(
                                  //     width: 16.0,
                                  //     height: 16.0,
                                  //     child: CircularProgressIndicator(strokeWidth: 2),
                                  //   ),
                                  // ),
                                  child:
                                    Column(
                                        children: [
                                          Container(
                                            height: 120,
                                            child: buildCategory(_producerList),
                                            // )
                                          ),
                                          Container(
                                            // height: 200,
                                            width: MediaQuery.of(context).size.width,
                                            child:_producerList!=null
                                                ?
                                            CachedNetworkImage(
                                              imageUrl:
                                                  _producerList[producerListIndex].producerImageUrl,

                                              imageBuilder: (context, imageProvider) {
                                                return Container(
                                                  height: 180,
                                                  width: MediaQuery.of(context).size.width,

                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.zero,
                                                    image: DecorationImage(
                                                      image: imageProvider,
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                );
                                              },
                                              placeholder: (context, url) {
                                                return Shimmer.fromColors(
                                                  baseColor:
                                                  Theme.of(context).hoverColor,
                                                  highlightColor:
                                                  Theme.of(context).highlightColor,
                                                  enabled: true,
                                                  child: Container(
                                                    height: 120,
                                                    width: MediaQuery.of(context).size.width,

                                                    decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.zero,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                );
                                              },
                                              errorWidget: (context, url, error) {
                                                return Shimmer.fromColors(
                                                  baseColor:
                                                  Theme.of(context).hoverColor,
                                                  highlightColor:
                                                  Theme.of(context).highlightColor,
                                                  enabled: true,
                                                  child: Container(
                                                    height: 120,
                                                    decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius: BorderRadius.zero,
                                                    ),
                                                    child: Icon(Icons.error),
                                                  ),
                                                );
                                              },
                                            )
                                                :
                                             Shimmer.fromColors(
                                          baseColor: Theme.of(context).hoverColor,
                                highlightColor: Theme.of(context).highlightColor,
                                enabled: true,
                                child:
                                      Container(
                                        width: MediaQuery.of(context).size.width,

                                        // alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.rectangle,
                                          color: Colors.white,
                                        ),

                                      ),
                                  )
                                          ),
                                          flagDataNotAvailable == false
                                              ?
                                          Flexible(
                                              child:
                                              _productList!=null
                                            ?
                                          PagedGridView<int, Product>(
                                            showNewPageProgressIndicatorAsGridChild: false,
                                            showNewPageErrorIndicatorAsGridChild: false,
                                            showNoMoreItemsIndicatorAsGridChild: false,
                                            pagingController: _pagingController,
                                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                              childAspectRatio: 80 / 90,
                                              crossAxisSpacing: 10,
                                              mainAxisSpacing: 10,
                                              crossAxisCount: 2,
                                            ),
                                            builderDelegate: PagedChildBuilderDelegate<Product>(
                                                itemBuilder: (context, item, index) => buildListViewItemProd(index,item,model)
                                              //     CharacterUpdatedScreen(
                                              //   character: item,
                                              // ),
                                            ),
                                          )
                                              // GridView.builder(
                                              //      padding: EdgeInsets.only(left:5.0,right:5.0),
                                              //       itemCount: _productList.length,
                                              //        controller: _scrollController,
                                              //        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount( crossAxisCount: 2, mainAxisSpacing: 8, crossAxisSpacing: 8, childAspectRatio: 0.8),
                                              //      itemBuilder: (context, index){
                                              //
                                              //       return Container(
                                              //    padding: EdgeInsets.only(left: 8),
                                              //
                                              //              child:
                                              //             Card(
                                              //               elevation: 3.0,
                                              //               shape: RoundedRectangleBorder(
                                              //
                                              //                ),
                                              //                child:
                                              //
                                              //                Column(
                                              //                  crossAxisAlignment: CrossAxisAlignment.center,
                                              //                  children: <Widget>[
                                              //                    CachedNetworkImage(
                                              //                      imageUrl: _productList[index].productImage,
                                              //                     imageBuilder: (context, imageProvider) {
                                              //                        return Container(
                                              //                          height: 110,
                                              //                          decoration: BoxDecoration(
                                              //                            borderRadius: BorderRadius.zero,
                                              //                            image: DecorationImage(
                                              //                              image: imageProvider,
                                              //                           fit: BoxFit.cover,
                                              //                           ),
                                              //                          ),
                                              //
                                              //                        );
                                              //                      },
                                              //                     placeholder: (context, url) {
                                              //                       return Shimmer.fromColors(
                                              //                          baseColor: Theme
                                              //                              .of(context)
                                              //                             .hoverColor,
                                              //                         highlightColor: Theme
                                              //                              .of(context)
                                              //                           .highlightColor,
                                              //                         enabled: true,
                                              //                         child: Container(
                                              //                            height: 110,
                                              //                          decoration: BoxDecoration(
                                              //                              borderRadius: BorderRadius.zero,
                                              //                             color: Colors.white,
                                              //                            ),
                                              //                          ),
                                              //                       );
                                              //                      },
                                              //                    errorWidget: (context, url, error) {
                                              //                        return Shimmer.fromColors(
                                              //                          baseColor: Theme
                                              //                              .of(context)
                                              //                              .hoverColor,
                                              //                          highlightColor: Theme
                                              //                             .of(context)
                                              //                              .highlightColor,
                                              //                         enabled: true,
                                              //                        child: Container(
                                              //                            height: 110,
                                              //                           decoration: BoxDecoration(
                                              //                              color: Colors.white,
                                              //                            borderRadius: BorderRadius.zero,
                                              //                          ),
                                              //                            child: Icon(Icons.error),
                                              //                         ),
                                              //                        );
                                              //                      },
                                              //                    ),
                                              //                    Padding(padding: EdgeInsets.only(top: 3)),
                                              //                   Text(
                                              //                     _productList[index].productName,
                                              //                     style: Theme
                                              //                          .of(context)
                                              //                         .textTheme
                                              //                         .caption
                                              //                         .copyWith(fontWeight: FontWeight.w400,fontFamily: 'Poppins',color: AppTheme.textColor),
                                              //                  ),
                                              //                    Padding(padding: EdgeInsets.only(top: 2)),
                                              //                    Text(
                                              //                      _productList[index].ratePerHour.toString()+" \$/hr",
                                              //                      maxLines: 1,
                                              //                     style: Theme
                                              //                          .of(context)
                                              //                       .textTheme
                                              //                          .subtitle2
                                              //                         .copyWith(fontWeight: FontWeight.w600,fontFamily: "Poppins",color: Theme.of(context).primaryColor),
                                              //                  ),
                                              //
                                              //
                                              //                 ],
                                              //                ),
                                              //    )
                                              //     );
                                              //
                                              //    },
                                              // )
                                                  :
                                              Center(child:CircularProgressIndicator())
                                              // Wrap(
                                              //   runSpacing: 10,
                                              //   alignment:
                                              //   WrapAlignment.spaceBetween,
                                              //   children: List.generate(
                                              //       6, (index) => index).map((item) {
                                              //             return buildListViewItemProd(
                                              //                 item, null,model);
                                              //           }).toList(),
                                              // ))
                                          )
                                              :
                                    Center(
                                      child: Padding(
                                          padding:
                                          EdgeInsets.only(top: 100.0),
                                          child: Text("No Data Available",
                                            style: TextStyle(
                                                fontFamily: 'Poppins',
                                                fontWeight: FontWeight.w600,
                                                fontSize: 16.0,
                                                color: AppTheme.textColor),
                                          )),
                                    )

                                        ],
                                      )

                                  //old one
                                  // Container(
                                  //     height: MediaQuery.of(context).size.height,
                                  //     margin: EdgeInsets.all(5.0),
                                  //     child:
                                  //     Column(
                                  //       children: [
                                  //         //for producer category
                                  //         // Expanded(
                                  //         //     child:
                                  //         Container(
                                  //           height: 120,
                                  //           child: buildCategory(_producerList),
                                  //           // )
                                  //
                                  //         ),
                                  //         // Expanded(
                                  //         //   child:
                                  //         //   GridView.builder(
                                  //         //     padding: EdgeInsets.only(left:5.0,right:5.0,bottom:180.0),
                                  //         //     itemCount: _productList.length,
                                  //         //     controller: _scrollController,
                                  //         //     gridDelegate: SliverGridDelegateWithFixedCrossAxisCount( crossAxisCount: 2, mainAxisSpacing: 8, crossAxisSpacing: 8, childAspectRatio: 0.8),
                                  //         //     itemBuilder: (context, index){
                                  //         //
                                  //         //       return Container(
                                  //         //         // padding: EdgeInsets.only(left: 8),
                                  //         //
                                  //         //           child:
                                  //         //           Card(
                                  //         //             elevation: 3.0,
                                  //         //             shape: RoundedRectangleBorder(
                                  //         //
                                  //         //             ),
                                  //         //             child:
                                  //         //
                                  //         //             Column(
                                  //         //               crossAxisAlignment: CrossAxisAlignment.center,
                                  //         //               children: <Widget>[
                                  //         //                 CachedNetworkImage(
                                  //         //                   imageUrl: _productList[index].productImage,
                                  //         //                   imageBuilder: (context, imageProvider) {
                                  //         //                     return Container(
                                  //         //                       height: 110,
                                  //         //                       decoration: BoxDecoration(
                                  //         //                         borderRadius: BorderRadius.zero,
                                  //         //                         image: DecorationImage(
                                  //         //                           image: imageProvider,
                                  //         //                           fit: BoxFit.cover,
                                  //         //                         ),
                                  //         //                       ),
                                  //         //
                                  //         //                     );
                                  //         //                   },
                                  //         //                   placeholder: (context, url) {
                                  //         //                     return Shimmer.fromColors(
                                  //         //                       baseColor: Theme
                                  //         //                           .of(context)
                                  //         //                           .hoverColor,
                                  //         //                       highlightColor: Theme
                                  //         //                           .of(context)
                                  //         //                           .highlightColor,
                                  //         //                       enabled: true,
                                  //         //                       child: Container(
                                  //         //                         height: 110,
                                  //         //                         decoration: BoxDecoration(
                                  //         //                           borderRadius: BorderRadius.zero,
                                  //         //                           color: Colors.white,
                                  //         //                         ),
                                  //         //                       ),
                                  //         //                     );
                                  //         //                   },
                                  //         //                   errorWidget: (context, url, error) {
                                  //         //                     return Shimmer.fromColors(
                                  //         //                       baseColor: Theme
                                  //         //                           .of(context)
                                  //         //                           .hoverColor,
                                  //         //                       highlightColor: Theme
                                  //         //                           .of(context)
                                  //         //                           .highlightColor,
                                  //         //                       enabled: true,
                                  //         //                       child: Container(
                                  //         //                         height: 110,
                                  //         //                         decoration: BoxDecoration(
                                  //         //                           color: Colors.white,
                                  //         //                           borderRadius: BorderRadius.zero,
                                  //         //                         ),
                                  //         //                         child: Icon(Icons.error),
                                  //         //                       ),
                                  //         //                     );
                                  //         //                   },
                                  //         //                 ),
                                  //         //                 Padding(padding: EdgeInsets.only(top: 3)),
                                  //         //                 Text(
                                  //         //                   _productList[index].productName,
                                  //         //                   style: Theme
                                  //         //                       .of(context)
                                  //         //                       .textTheme
                                  //         //                       .caption
                                  //         //                       .copyWith(fontWeight: FontWeight.w400,fontFamily: 'Poppins',color: AppTheme.textColor),
                                  //         //                 ),
                                  //         //                 Padding(padding: EdgeInsets.only(top: 2)),
                                  //         //                 Text(
                                  //         //                   _productList[index].ratePerHour.toString()+" \$/hr",
                                  //         //                   maxLines: 1,
                                  //         //                   style: Theme
                                  //         //                       .of(context)
                                  //         //                       .textTheme
                                  //         //                       .subtitle2
                                  //         //                       .copyWith(fontWeight: FontWeight.w600,fontFamily: "Poppins",color: Theme.of(context).primaryColor),
                                  //         //                 ),
                                  //         //
                                  //         //
                                  //         //               ],
                                  //         //             ),
                                  //         //           )
                                  //         //       );
                                  //         //
                                  //         //     },
                                  //         //   ),
                                  //           // for producer listview items
                                  //           Expanded(
                                  //               flex: 3,
                                  //               child:
                                  //                   SingleChildScrollView(
                                  //                       child:
                                  //                       Column(
                                  //                         children: [
                                  //                           // Expanded(
                                  //                           //     flex: 1,
                                  //                           //     child:
                                  //                           Container(
                                  //                             height: 200,
                                  //                             width: MediaQuery.of(context).size.width,
                                  //                             child: CachedNetworkImage(
                                  //                               imageUrl: _producerList != null
                                  //                                   ? _producerList[producerListIndex]
                                  //                                   .producerImageUrl
                                  //                                   : "http://via.placeholder.com/350x150",
                                  //                               imageBuilder: (context, imageProvider) {
                                  //                                 return Container(
                                  //                                   height: 180,
                                  //                                   width: MediaQuery.of(context).size.width,
                                  //
                                  //                                   decoration: BoxDecoration(
                                  //                                     borderRadius: BorderRadius.zero,
                                  //                                     image: DecorationImage(
                                  //                                       image: imageProvider,
                                  //                                       fit: BoxFit.cover,
                                  //                                     ),
                                  //                                   ),
                                  //                                 );
                                  //                               },
                                  //                               placeholder: (context, url) {
                                  //                                 return Shimmer.fromColors(
                                  //                                   baseColor:
                                  //                                   Theme.of(context).hoverColor,
                                  //                                   highlightColor:
                                  //                                   Theme.of(context).highlightColor,
                                  //                                   enabled: true,
                                  //                                   child: Container(
                                  //                                     height: 120,
                                  //                                     width: MediaQuery.of(context).size.width,
                                  //
                                  //                                     decoration: BoxDecoration(
                                  //                                       borderRadius: BorderRadius.zero,
                                  //                                       color: Colors.white,
                                  //                                     ),
                                  //                                   ),
                                  //                                 );
                                  //                               },
                                  //                               errorWidget: (context, url, error) {
                                  //                                 return Shimmer.fromColors(
                                  //                                   baseColor:
                                  //                                   Theme.of(context).hoverColor,
                                  //                                   highlightColor:
                                  //                                   Theme.of(context).highlightColor,
                                  //                                   enabled: true,
                                  //                                   child: Container(
                                  //                                     height: 120,
                                  //                                     decoration: BoxDecoration(
                                  //                                       color: Colors.white,
                                  //                                       borderRadius: BorderRadius.zero,
                                  //                                     ),
                                  //                                     child: Icon(Icons.error),
                                  //                                   ),
                                  //                                 );
                                  //                               },
                                  //                             ),
                                  //                           ),
                                  //                           // ),
                                  //                           // buildListViewItemProd()
                                  //                           SizedBox(height: 15.0,),
                                  //
                                  //                           // Expanded(
                                  //                           //   flex: 1,
                                  //                           //     child:
                                  //                           flagDataNotAvailable == false
                                  //                               ?
                                  //                           Padding(
                                  //                               padding: EdgeInsets.only(
                                  //                                   left: 10,
                                  //                                   right: 10,
                                  //                                   bottom:
                                  //                                   selectedIndexList.length > 0
                                  //                                       ? 50.0
                                  //                                       : 170.0),
                                  //                               child:
                                  //                           Wrap(
                                  //                             runSpacing: 10,
                                  //                             alignment:
                                  //                             WrapAlignment.spaceBetween,
                                  //                             children: List.generate(
                                  //                                 _productList != null
                                  //                                     ? _productList.length
                                  //                                     : 6,
                                  //                                     (index) => index).map((item) {
                                  //                               return buildListViewItemProd(
                                  //                                   item, _productList,model);
                                  //                             }).toList(),
                                  //                           // ))
                                  //                           //updated on 7/08/2021
                                  //                           // GridView.builder(
                                  //                           //   padding: EdgeInsets.all(8.0),
                                  //                           //   itemCount: _productList.length,
                                  //                           //   controller: _scrollController,
                                  //                           //   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount( crossAxisCount: 2, mainAxisSpacing: 8, crossAxisSpacing: 8, childAspectRatio: 0.8),
                                  //                           //   itemBuilder: (context, index){
                                  //                           //
                                  //                           //               return Container(
                                  //                           //                   padding: EdgeInsets.only(left: 8),
                                  //                           //
                                  //                           //                   child:
                                  //                           //                   Card(
                                  //                           //                     elevation: 3.0,
                                  //                           //                     shape: RoundedRectangleBorder(
                                  //                           //
                                  //                           //                     ),
                                  //                           //                     child:
                                  //                           //
                                  //                           //                     Column(
                                  //                           //                       crossAxisAlignment: CrossAxisAlignment.center,
                                  //                           //                       children: <Widget>[
                                  //                           //                         CachedNetworkImage(
                                  //                           //                           imageUrl: _productList[index].productImage,
                                  //                           //                           imageBuilder: (context, imageProvider) {
                                  //                           //                             return Container(
                                  //                           //                               height: 110,
                                  //                           //                               decoration: BoxDecoration(
                                  //                           //                                 borderRadius: BorderRadius.zero,
                                  //                           //                                 image: DecorationImage(
                                  //                           //                                   image: imageProvider,
                                  //                           //                                   fit: BoxFit.cover,
                                  //                           //                                 ),
                                  //                           //                               ),
                                  //                           //
                                  //                           //                             );
                                  //                           //                           },
                                  //                           //                           placeholder: (context, url) {
                                  //                           //                             return Shimmer.fromColors(
                                  //                           //                               baseColor: Theme
                                  //                           //                                   .of(context)
                                  //                           //                                   .hoverColor,
                                  //                           //                               highlightColor: Theme
                                  //                           //                                   .of(context)
                                  //                           //                                   .highlightColor,
                                  //                           //                               enabled: true,
                                  //                           //                               child: Container(
                                  //                           //                                 height: 110,
                                  //                           //                                 decoration: BoxDecoration(
                                  //                           //                                   borderRadius: BorderRadius.zero,
                                  //                           //                                   color: Colors.white,
                                  //                           //                                 ),
                                  //                           //                               ),
                                  //                           //                             );
                                  //                           //                           },
                                  //                           //                           errorWidget: (context, url, error) {
                                  //                           //                             return Shimmer.fromColors(
                                  //                           //                               baseColor: Theme
                                  //                           //                                   .of(context)
                                  //                           //                                   .hoverColor,
                                  //                           //                               highlightColor: Theme
                                  //                           //                                   .of(context)
                                  //                           //                                   .highlightColor,
                                  //                           //                               enabled: true,
                                  //                           //                               child: Container(
                                  //                           //                                 height: 110,
                                  //                           //                                 decoration: BoxDecoration(
                                  //                           //                                   color: Colors.white,
                                  //                           //                                   borderRadius: BorderRadius.zero,
                                  //                           //                                 ),
                                  //                           //                                 child: Icon(Icons.error),
                                  //                           //                               ),
                                  //                           //                             );
                                  //                           //                           },
                                  //                           //                         ),
                                  //                           //                         Padding(padding: EdgeInsets.only(top: 3)),
                                  //                           //                         Text(
                                  //                           //                           _productList[index].productName,
                                  //                           //                           style: Theme
                                  //                           //                               .of(context)
                                  //                           //                               .textTheme
                                  //                           //                               .caption
                                  //                           //                               .copyWith(fontWeight: FontWeight.w400,fontFamily: 'Poppins',color: AppTheme.textColor),
                                  //                           //                         ),
                                  //                           //                         Padding(padding: EdgeInsets.only(top: 2)),
                                  //                           //                         Text(
                                  //                           //                           _productList[index].ratePerHour.toString()+" \$/hr",
                                  //                           //                           maxLines: 1,
                                  //                           //                           style: Theme
                                  //                           //                               .of(context)
                                  //                           //                               .textTheme
                                  //                           //                               .subtitle2
                                  //                           //                               .copyWith(fontWeight: FontWeight.w600,fontFamily: "Poppins",color: Theme.of(context).primaryColor),
                                  //                           //                         ),
                                  //                           //
                                  //                           //
                                  //                           //                       ],
                                  //                           //                     ),
                                  //                           //                   )
                                  //                           //               );
                                  //                           //
                                  //                           //   },
                                  //                           ),
                                  //                           )
                                  //                               : Center(
                                  //                             child: Padding(
                                  //                                 padding:
                                  //                                 EdgeInsets.only(top: 100.0),
                                  //                                 child: Text(
                                  //                                   "No Data Available",
                                  //                                   style: TextStyle(
                                  //                                       fontFamily: 'Poppins',
                                  //                                       fontWeight: FontWeight.w600,
                                  //                                       fontSize: 16.0,
                                  //                                       color: AppTheme.textColor),
                                  //                                 )),
                                  //                           )
                                  //                         ],
                                  //                       )),
                                  //         )],
                                  //     ))
                              )
                          );
                        }));


            })
            )
        )
    );
  }
  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }
}