import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:orderly/Api/api.dart';
import 'package:orderly/Blocs/home/bloc.dart';
import 'package:orderly/Blocs/home/home_bloc.dart';
import 'package:orderly/Blocs/home/home_event.dart';
import 'package:orderly/Configs/image.dart';
import 'package:orderly/Configs/theme.dart';
import 'package:orderly/Models/model_scoped_cart.dart';
import 'package:orderly/Models/model_producer_list.dart';
import 'package:orderly/Models/model_product_List.dart';
import 'package:orderly/Screens/Customer/cart/shopping_cart.dart';
import 'package:orderly/Screens/Customer/home/home_item_detail.dart';
import 'package:orderly/Utils/connectivity_check.dart';
import 'package:orderly/Utils/routes.dart';
import 'package:orderly/Utils/translate.dart';
import 'package:orderly/Widgets/app_button.dart';
import 'package:orderly/Widgets/app_dialogs.dart';
import 'package:shimmer/shimmer.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:http/http.dart' as http;


class HomeUpdated extends StatefulWidget {
  CartModel model;

  HomeUpdated({Key key, @required this.model}) : super(key: key);

  _HomeUpdatedState createState() => _HomeUpdatedState();
}

class _HomeUpdatedState extends State<HomeUpdated> {
  List<int> selectedIndexList = []; //for selected index
  List<Products> productLists = [];
  List<Products> cartList = []; //added as per total calculate count
  List<Producer> _producerList ; //added as per total calculate count
  double totalCartValue = 0;
  int quantity = 0;
  ScrollController scrollController = ScrollController();
  HomeBloc _homeBloc;
  int producerListIndex = 0;
  final GlobalKey<RefreshIndicatorState> refreshKey =
  new GlobalKey<RefreshIndicatorState>();
  final _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool _refreshing = false;
  bool isconnectedToInternet = false;
  String type = "ALL";
  int offset=0;
  bool flagNoData=false;
  CartModel model;

  // void getProducts() {
  //   for (int i = 0; i < 10; i++) {
  //     Products product = new Products(
  //         id: i,
  //         title: "Prime Roof Truck",
  //         price: 25,
  //         qty: 1,
  //         imgUrl: "http://via.placeholder.com/350x150");
  //     productLists.add(product);
  //   }
  // }

  void fetchProducts(String producerId,String type,String offset) async {
    productLists=[];
    final response = await http.post(
      Uri.parse(Api.GET_PROD_LIST),
      body: ({"producer_id":producerId,"type":type,"offset":offset}),
    );
    print('RESPONSE - ${response.body.length}');
    if (response.statusCode == 200) {
      final responseJson = json.decode(response.body);
      var productList=responseJson['product'];
      var msg=responseJson['msg'];
      try {
        if (msg == "Success") {
          for (var productData in productList) {
            Products product=new Products(id: productData['product_id'],
            productName: productData['product_name'],
            ratePerHour: productData['rate_per_hour'],
            qty: productData['product_qty'],
            productImage: productData['product_image'],
            productDesc: productData['product_desc'],
            truckName: productData['truck_name'],
            displayStatus: productData['display_status'],
              truckNumber:productData['truck_number'],
            );
            flagNoData=false;
            productLists.add(product);
          }
          print("productLists:-"+productList.toString());

        }
        else{
         flagNoData=true;
        }
        setState(() {

        });
      }catch(e)
      {
        print(e);
      }
    }

  }


  //added on 14/12/2020
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

  void initState() {
    super.initState();
    // getProducts();
    setBlocData();
  }

  void setBlocData() async {
    isconnectedToInternet = await ConnectivityCheck.checkInternetConnectivity();
    if (isconnectedToInternet == true) {
      _homeBloc = BlocProvider.of<HomeBloc>(context);
      _homeBloc.add(OnLoadingProducerList());

    } else {
      CustomDialogs.showDialogCustom(
          "Internet", "Please check your Internet Connection!", context);
    }
  }

  void calculateTotal(List<Products> cartList) {
    totalCartValue = 0;
    quantity = 0;
    String json = jsonEncode(cartList);
    // var json1 = jsonEncode(cartList.map((e) => e.toJson()).toList());
    print("cartList:-"+json);
    cartList.forEach((f) {
      totalCartValue += int.parse(f.ratePerHour) * f.qty;
      quantity += f.qty;
      print('total cart value:-' + totalCartValue.toString());
      print('quantity:-' + quantity.toString());
    });
    setState(() {

    });
  }

  void removeProduct(List<Products> cart, Products product) {
    int index = cart.indexWhere((i) => i.id == product.id);
    cart[index].qty = 1;
    cart.removeWhere((item) => item.id == product.id);
    selectedIndexList.removeAt(index);
    // // calculateTotal();
    // notifyListeners();
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
                  onTap: () {
                    print('clicked category');
                    setState(() {
                      producerListIndex = index;
                      type=index==0?"ALL":"";
                      flagNoData=false;
                      productLists=[];

                    });

                    print("id:-"+producerList[producerListIndex].producerId.toString());
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      CachedNetworkImage(
                        imageUrl: item.producerIconUrl,
                        imageBuilder: (context, imageProvider) {
                          return Container(
                            height: 70.0,
                            width: 70.0,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(
                                Radius.circular(35),
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
                              height: 70.0,
                              width: 70.0,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(35),
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
                              height: 70.0,
                              width: 70.0,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(35),
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
                              fontWeight: FontWeight.w600,
                              fontSize: 12.0,
                              color:
                              AppTheme.textColor
                          ),
                        ),
                      )
                    ],
                  )));
        },
        itemCount: producerList.length,
      );
    }

    Widget buildListViewItemProd(index, CartModel model) {
      print("cartModel:-"+model.toString());
      if (model == null) {
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
      return FractionallySizedBox(
          widthFactor: 0.5,
          child: Container(
              padding: EdgeInsets.only(left: 8),
              child: Card(
                elevation: 3.0,
                shape: RoundedRectangleBorder(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    CachedNetworkImage(
                      imageUrl: productLists[index].productImage,
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
                    Text(
                      productLists[index].productName,
                      style: Theme.of(context).textTheme.caption.copyWith(
                          fontWeight: FontWeight.w400,
                          fontFamily: 'Poppins',
                          color: AppTheme.textColor),
                    ),
                    Padding(padding: EdgeInsets.only(top: 2)),
                    Text(
                      productLists[index].ratePerHour.toString() + " \$/hr",
                      maxLines: 1,
                      style: Theme.of(context).textTheme.subtitle2.copyWith(
                          fontWeight: FontWeight.w600,
                          fontFamily: "Poppins",
                          color: Theme.of(context).primaryColor),
                    ),
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
                                primary: selectedIndexList.contains(index)
                                    ? Theme.of(context).primaryColor
                                    : AppTheme.verifyPhone,
                                shape: const RoundedRectangleBorder(
                                    borderRadius:
                                    BorderRadius.all(Radius.circular(50))),
                              ),
                              // shape: shape,
                              onPressed: () {
                                // Navigator.push(context, MaterialPageRoute(builder: (context) => HomeItemDetail()));
                              },
                              child: 
                              // !selectedIndexList.contains(index)
                              //     ?
                              GestureDetector(
                                  onTap: () {
                                    // if (!selectedIndexList
                                    //     .contains(index)) {
                                    //   selectedIndexList.add(index);
                                    // }
                                    // else {
                                    //   selectedIndexList.remove(index);
                                    // }
                                    // cartList.add(productLists[index]);
                                    //   widget.model.cart.addAll(cartList);
                                    //
                                    // calculateTotal(cartList);
                                    // setState(() {});
                                    widget.model.addProduct(productLists[index]);
                                    // Navigator.push(context, MaterialPageRoute(builder: (context)=>
                                    // ShoppingCart(producerId: _producerList[producerListIndex].producerId.toString(),
                                    //     model: widget.model)));
                                  },
                                  child: Stack(
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
                                  ))
                                  // : index < 0
                                  // ? Center(
                                  // child: CircularProgressIndicator())
                              //     : Row(
                              //   crossAxisAlignment:
                              //   CrossAxisAlignment.center,
                              //   mainAxisAlignment:
                              //   MainAxisAlignment.spaceBetween,
                              //   children: <Widget>[
                              //     InkWell(
                              //         onTap: () {
                              //
                              //           model.updateProduct(model.cart[index], model.cart[index].qty - 1);
                              //
                              //           if (model.cart[index].qty== 0) {
                              //             // cartList.removeAt(index);
                              //             removeProduct(cartList,model.cart[index]);
                              //           }
                              //           calculateTotal(cartList);
                              //
                              //         },
                              //         child: Icon(
                              //           Icons.remove,
                              //           color: Colors.white,
                              //           size: 20.0,
                              //         )),
                              //     Text(
                              //       model.cart[index].qty
                              //           .toString(),
                              //       style: Theme.of(context)
                              //           .textTheme
                              //           .button
                              //           .copyWith(
                              //           color: Colors.white,
                              //           fontWeight:
                              //           FontWeight.w400,
                              //           fontSize: 12.0),
                              //     ),
                              //     InkWell(
                              //         onTap: () {
                              //           // setState(() {
                              //           model.updateProduct(
                              //               model.cart[index],
                              //               model.cart[index].qty +
                              //                   1);
                              //           calculateTotal(cartList);
                              //           // });
                              //         },
                              //         child: Icon(
                              //           Icons.add,
                              //           color: Colors.white,
                              //           size: 20.0,
                              //         ))
                              //   ],
                              // ),
                            )))
                  ],
                ),
              ))
        // }
      );
    }

    // TODO: implement build
    return WillPopScope(
        onWillPop: () => _exitApp(context),
        child: Scaffold(
            key: _scaffoldKey,
            // appBar: AppBar(title: Text("Home"),
            //   automaticallyImplyLeading:false,
            // ),
            body: BlocListener<HomeBloc, HomeState>(listener: (context, state) {
              if (state is ProducerListLoadFail) {

              }


            }, child:
            BlocBuilder<HomeBloc, HomeState>(builder: (context, state) {
              // List<Producer> _producerList;
              if (state is ProducerListSuccess) {
                _producerList = state.producerList;

                if(flagNoData==false && productLists.length<=0){

                  fetchProducts(_producerList[producerListIndex].producerId.toString(), type, offset.toString());
                  print("id:-"+_producerList[producerListIndex].producerId.toString());

                }

              }
              return RefreshIndicator(
                  key: refreshKey,
                  child: Container(
                      height: MediaQuery.of(context).size.height,
                      child: Column(
                        children: [
                          //for producer category
                          // Expanded(
                          //     child:
                          Container(
                            height: 120,
                            child: buildCategory(_producerList),
                            // )
                          ),

                          // for producer listview items
                          Expanded(
                              flex: 3,
                              child: SingleChildScrollView(
                                  child: Column(
                                    children: [
                                      // Expanded(
                                      //     flex: 1,
                                      //     child:
                                      Container(
                                        height: 200,
                                        child: CachedNetworkImage(
                                          imageUrl: _producerList != null
                                              ? _producerList[producerListIndex]
                                              .producerImageUrl
                                              : "http://via.placeholder.com/350x150",
                                          imageBuilder: (context, imageProvider) {
                                            return Container(
                                              height: 180,
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
                                        ),
                                      ),
                                      // ),
                                      // buildListViewItemProd()

                                      // Expanded(
                                      //   flex: 1,
                                      //     child:
                                      flagNoData==false
                                          ?
                                      Padding(
                                          padding: EdgeInsets.only(
                                              left: 15,
                                              right: 15,
                                              top: 15.0,
                                              bottom: selectedIndexList.length > 0
                                                  ? 10.0
                                                  : 80.0),
                                          child: Wrap(
                                            runSpacing: 10,
                                            alignment: WrapAlignment.spaceBetween,
                                            children: List.generate(
                                                productLists.length,
                                                    (index) => index).map((item) {
                                              return ScopedModel<CartModel>(
                                                  model: widget.model,
                                                  child: ScopedModelDescendant<
                                                      CartModel>(
                                                      builder: (context, child, model) {
                                                        // widget.model = model;
                                                        print("model"+widget.model.toString());
                                                        // if (widget.model.cart.length == 0) {
                                                        //   widget.model.cart.addAll(productLists);
                                                        // }

                                                        return buildListViewItemProd(item, widget.model);
                                                      }));
                                            }).toList(),
                                          )

                                      )
                                          :
                                          Container(
                                            margin: EdgeInsets.only(top:150.0,left:20.0,right:20.0),
                                              child:Center(child:Text("No Data Available",
                                          style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.w600,
                                            fontFamily: 'Poppins',
                                            color:AppTheme.textColor
                                          ),)))
                                    ],
                                  ))),

                          if (selectedIndexList.length > 0)
                            Expanded(
                              child: Container(
                                  height: 40.0,
                                  child: Padding(
                                      padding: EdgeInsets.only(
                                          left: 15.0,
                                          right: 15.0,
                                          top: 10.0,
                                          bottom: 95.0),
                                      child:
                                      // SizedBox(
                                      //     height: 40.0,
                                      //     width: MediaQuery
                                      //         .of(context)
                                      //         .size
                                      //         .width,
                                      //     child:
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          side: BorderSide(
                                              color: Theme.of(context)
                                                  .primaryColor,
                                              width: 1),
                                          primary:
                                          Theme.of(context).primaryColor,
                                          shape: const RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(50))),
                                        ),
                                        onPressed: () {
                                          // Navigator.push(
                                          //     context,
                                          //     MaterialPageRoute(
                                          //         builder: (context) =>
                                          //             HomeItemDetail()));
                                          print("model:-"+widget.model.cart.toString());
                                          // Navigator.push(context,MaterialPageRoute(builder: (context)=>
                                          //     ShoppingCart(cartList: cartList,totalCartValue:totalCartValue)));
                                          // Navigator.pushNamed(
                                          //     context, Routes.cart,arguments: cartList,);
                                        },
                                        child: Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Padding(
                                              padding: EdgeInsets.only(
                                                  top: 5.0, left: 10.0),
                                              child: Column(
                                                mainAxisAlignment:
                                                MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    quantity.toString() +
                                                        " Items",
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyText1
                                                        .copyWith(
                                                        color: Colors.white,
                                                        fontWeight:
                                                        FontWeight.w300,
                                                        fontSize: 12.0),
                                                  ),
                                                  Row(
                                                    children: [
                                                      Text(
                                                        '\$ ' +
                                                            totalCartValue
                                                                .toString(),
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .bodyText1
                                                            .copyWith(
                                                            color: Colors
                                                                .white,
                                                            fontWeight:
                                                            FontWeight
                                                                .w600,
                                                            fontSize: 14.0),
                                                      ),
                                                      Text(
                                                        ' +plus taxes',
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .bodyText1
                                                            .copyWith(
                                                            color: Colors
                                                                .white,
                                                            fontWeight:
                                                            FontWeight
                                                                .w300,
                                                            fontSize: 12.0),
                                                      ),
                                                    ],
                                                  )
                                                ],
                                              ),
                                            ),
                                           Text(
                                                  'VIEW CART',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .button
                                                      .copyWith(
                                                      color: Colors.white,
                                                      fontWeight:
                                                      FontWeight.w600),
                                                ),
                                          ],
                                        ),
                                      )
                                    // )
                                  )),
                            )
                        ],
                      )),
                  onRefresh: () async {
                    setState(() {
                      _refreshing = true;
                    });
                    // _homeBloc.add(OnLoadingProducerList());
                    productLists=[];
                    setBlocData();
                  });
            }))));
  }
}

