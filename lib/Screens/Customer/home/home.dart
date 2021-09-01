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
import 'package:orderly/Configs/theme.dart';
import 'package:orderly/Models/model_producer_list.dart';
import 'package:orderly/Models/productList_scopedModel.dart';
import 'package:orderly/Screens/Customer/cart/shopping_cart.dart';
import 'package:orderly/Screens/Customer/home/home_item_detail.dart';
import 'package:orderly/Utils/application.dart';
import 'package:orderly/Utils/connectivity_check.dart';
import 'package:orderly/Utils/progressDialog.dart';
import 'package:orderly/Utils/routes.dart';
import 'package:orderly/Utils/translate.dart';
import 'package:orderly/Widgets/app_button.dart';
import 'package:orderly/Widgets/app_dialogs.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shimmer/shimmer.dart';
import 'package:http/http.dart' as http;


class Home extends StatefulWidget {
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<int> selectedIndexList = []; //for selected index
  List<Product> _productList;
  List<Producer> _producerList;

  ScrollController scrollController = ScrollController();
  HomeBloc _homeBloc;
  int producerListIndex = 0;
  final _controller = RefreshController(initialRefresh: false);

  final _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool _refreshing = false;
  bool isconnectedToInternet = false;
  String type = "ALL";
  int offset = 0;
  bool flagDataNotAvailable = false;

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
              onPressed: () {
                // Navigator.of(context).pop();
                Navigator.push(context, MaterialPageRoute(
                    builder: (context)=> ShoppingCart()
                ));

              },
            ),
          ],
        );
      },
    );
  }


  void initState() {
    super.initState();
    _homeBloc = BlocProvider.of<HomeBloc>(context);

    scrollController.addListener(() {
      if (scrollController.position.maxScrollExtent ==
          scrollController.offset) {
        print('Controller at bottom');
        offset += 10;
        _homeBloc.add(OnLoadingProductList(
          producerId: _producerList[producerListIndex].producerId.toString(),
          type: type,
          offset: offset.toString()
        ));
      }
    });
    setBlocData();
  }

  void setBlocData() async {
    isconnectedToInternet = await ConnectivityCheck.checkInternetConnectivity();
    if (isconnectedToInternet == true) {
      _homeBloc.add(OnLoadingProducerList());
    } else {
      CustomDialogs.showDialogCustom(
          "Internet", "Please check your Internet Connection!", context);
    }
  }

  ///On Refresh List
  Future<void> _onRefresh() async {
    await Future.delayed(Duration(milliseconds: 1000));

    _homeBloc.add(OnLoadingProductList(
        producerId: _producerList[producerListIndex].producerId.toString(),
        type: type,
        offset: offset.toString(),
        ));
    _controller.refreshCompleted();
  }

  Future<void> AddedToCart(String producerId,String productId,String qty,String price) async {
    Map<String,String> params={
      'producer_id':producerId,
      'product_id':productId,
      'user_id':Application.user.fbId,
      'qty':qty,
      'rate_per_hour':price
    };

    var response = await http.post(Uri.parse(Api.ADD_TO_CART),
      body: params,
    );
    try{
      if (response.statusCode == 200) {
        var resp = json.decode(response.body);
        Navigator.push(context, MaterialPageRoute(builder: (context)=>ShoppingCart(price:price)));
      }
    }catch(e){
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
                  onTap: () {
                    print('clicked category');
                    // WidgetsBinding.instance.addPostFrameCallback((_)
                    //     {
                    //       if(mounted) {
                    //         setState(() {
                              producerListIndex = index;
                              type = index == 0 ? "ALL" : "";
                              flagDataNotAvailable = false;
                            // });
                            _homeBloc.add(OnLoadingProductList(
                                producerId: producerList[producerListIndex]
                                    .producerId
                                    .toString(),
                                type: type,
                                offset: offset.toString()));
                    //     }
                    //
                    // });
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
                              color: AppTheme.textColor),
                        ),
                      )
                    ],
                  )));
        },
        itemCount: producerList.length,
      );
    }

    Widget buildListViewItemProd(int index, List<Product> product) {
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
            child: Container(
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
                    )))
            // }
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
                      imageUrl: product[index].productImage,
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
                      product[index].productName,
                      style: Theme.of(context).textTheme.caption.copyWith(
                          fontWeight: FontWeight.w400,
                          fontFamily: 'Poppins',
                          color: AppTheme.textColor),
                    ),
                    Padding(padding: EdgeInsets.only(top: 2)),
                    Text(
                      product[index].ratePerHour.toString() + " \$/hr",
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
                                  primary: AppTheme.verifyPhone,
                                  shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(50))),
                                ),
                                // shape: shape,
                                onPressed: () async {
                                  await PsProgressDialog.showProgressWithoutMsg(context);
                                  AddedToCart(_producerList[producerListIndex].producerId.toString(),
                                      _productList[index].productId.toString(),
                                      _productList[index].qty.toString(),
                                      _productList[index].ratePerHour.toString());                                },
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
              if (state is ProducerListLoadFail) {}
            }, child:
                BlocBuilder<HomeBloc, HomeState>(builder: (context, state) {
              // List<Producer> _producerList;
              // List<Product> _productList;
              if (state is ProducerListSuccess) {
                _producerList = state.producerList;
                _homeBloc.add(OnLoadingProductList(
                    producerId:
                        _producerList[producerListIndex].producerId.toString(),
                    type: type,
                    offset: offset.toString()));
              }

              if (state is ProductListSuccess) {
                _productList = state.productList;
                if (_productList != null) {
                  if (_productList.length <= 0) {
                    flagDataNotAvailable = true;
                  }
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

              // return SafeArea(
              //   child:
              //   SmartRefresher(
              //     enablePullDown: true,
              //     // enablePullUp: state is ProductListSuccess, //used for pagination
              //     // &&
              //     // state.pagination != null &&
              //     // state.pagination.page < state.pagination.maxPage,
              //     onRefresh: _onRefresh,
              //     // onLoading: () {
              //     //   if (state is ProductListSuccess) {
              //     //     // _onLoading(state.pagination.page, state.list);
              //     //     _onRefresh();
              //     //   }
              //     // },
              //     controller: _controller,
              //     // header: ClassicHeader(
              //     //   idleText: Translate.of(context).translate(
              //     //     'pull_down_refresh',
              //     //   ),
              //     //   refreshingText: Translate.of(context).translate(
              //     //     'refreshing',
              //     //   ),
              //     //   // completeText: Translate.of(context).translate(
              //     //   //   'refresh_completed',
              //     //   // ),
              //     //   releaseText: Translate.of(context).translate(
              //     //     'release_to_refresh',
              //     //   ),
              //     //   refreshingIcon: SizedBox(
              //     //     width: 16.0,
              //     //     height: 16.0,
              //     //     child: CircularProgressIndicator(strokeWidth: 2),
              //     //   ),
              //     // ),
              //     // footer: ClassicFooter(
              //     //   loadingText: Translate.of(context).translate('loading'),
              //     //   canLoadingText: Translate.of(context).translate(
              //     //     'release_to_load_more',
              //     //   ),
              //     //   idleText: Translate.of(context).translate(
              //     //     'pull_to_load_more',
              //     //   ),
              //     //   loadStyle: LoadStyle.ShowWhenLoading,
              //     //   loadingIcon: SizedBox(
              //     //     width: 16.0,
              //     //     height: 16.0,
              //     //     child: CircularProgressIndicator(strokeWidth: 2),
              //     //   ),
              //     // ),
              //     child:
                  return Container(
                      height: MediaQuery.of(context).size.height,
                      child:
                      Column(
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
                                      flagDataNotAvailable == false
                                          ? Padding(
                                          padding: EdgeInsets.only(
                                              left: 15,
                                              right: 15,
                                              top: 15.0,
                                              bottom:
                                              selectedIndexList.length > 0
                                                  ? 10.0
                                                  : 80.0),
                                          child: Wrap(
                                            runSpacing: 10,
                                            alignment:
                                            WrapAlignment.spaceBetween,
                                            children: List.generate(
                                                _productList != null
                                                    ? _productList.length
                                                    : 6,
                                                    (index) => index).map((item) {
                                              return buildListViewItemProd(
                                                  item, _productList);
                                            }).toList(),
                                          )
                                        //updated on 7/08/2021
                                        // GridView.builder(
                                        //   padding: EdgeInsets.all(8.0),
                                        //   itemCount: productLists.length,
                                        //   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount( crossAxisCount: 2, mainAxisSpacing: 8, crossAxisSpacing: 8, childAspectRatio: 0.8),
                                        //   itemBuilder: (context, index){
                                        //     return ScopedModel<CartModel>(
                                        //         model: widget.model,
                                        //         child:
                                        //         ScopedModelDescendant<CartModel>(
                                        //             builder: (context, child, model) {
                                        //               model=widget.model;
                                        //               if(model.cart.length==0)
                                        //                 {
                                        //                   model.cart.addAll(productLists);
                                        //
                                        //                 }
                                        //               // return Card( child: Column( children: <Widget>[
                                        //               //   Image.network(productLists[index].imgUrl, height: 120, width: 120,),
                                        //               //   Text(productLists[index].title, style: TextStyle(fontWeight: FontWeight.bold),),
                                        //               //   Text("\$"+productLists[index].price.toString()),
                                        //               //   OutlineButton(
                                        //               //       child: Text("Add"),
                                        //               //       onPressed: () {
                                        //               //         model.addProduct(productLists[index]);
                                        //               //
                                        //               //       }
                                        //               //       )
                                        //               // ]));
                                        //               return Container(
                                        //                   padding: EdgeInsets.only(left: 8),
                                        //
                                        //                   child:
                                        //                   Card(
                                        //                     elevation: 3.0,
                                        //                     shape: RoundedRectangleBorder(
                                        //
                                        //                     ),
                                        //                     child:
                                        //
                                        //                     Column(
                                        //                       crossAxisAlignment: CrossAxisAlignment.center,
                                        //                       children: <Widget>[
                                        //                         CachedNetworkImage(
                                        //                           imageUrl: productLists[index].imgUrl,
                                        //                           imageBuilder: (context, imageProvider) {
                                        //                             return Container(
                                        //                               height: 110,
                                        //                               decoration: BoxDecoration(
                                        //                                 borderRadius: BorderRadius.zero,
                                        //                                 image: DecorationImage(
                                        //                                   image: imageProvider,
                                        //                                   fit: BoxFit.cover,
                                        //                                 ),
                                        //                               ),
                                        //
                                        //                             );
                                        //                           },
                                        //                           placeholder: (context, url) {
                                        //                             return Shimmer.fromColors(
                                        //                               baseColor: Theme
                                        //                                   .of(context)
                                        //                                   .hoverColor,
                                        //                               highlightColor: Theme
                                        //                                   .of(context)
                                        //                                   .highlightColor,
                                        //                               enabled: true,
                                        //                               child: Container(
                                        //                                 height: 110,
                                        //                                 decoration: BoxDecoration(
                                        //                                   borderRadius: BorderRadius.zero,
                                        //                                   color: Colors.white,
                                        //                                 ),
                                        //                               ),
                                        //                             );
                                        //                           },
                                        //                           errorWidget: (context, url, error) {
                                        //                             return Shimmer.fromColors(
                                        //                               baseColor: Theme
                                        //                                   .of(context)
                                        //                                   .hoverColor,
                                        //                               highlightColor: Theme
                                        //                                   .of(context)
                                        //                                   .highlightColor,
                                        //                               enabled: true,
                                        //                               child: Container(
                                        //                                 height: 110,
                                        //                                 decoration: BoxDecoration(
                                        //                                   color: Colors.white,
                                        //                                   borderRadius: BorderRadius.zero,
                                        //                                 ),
                                        //                                 child: Icon(Icons.error),
                                        //                               ),
                                        //                             );
                                        //                           },
                                        //                         ),
                                        //                         Padding(padding: EdgeInsets.only(top: 3)),
                                        //                         Text(
                                        //                           productLists[index].title,
                                        //                           style: Theme
                                        //                               .of(context)
                                        //                               .textTheme
                                        //                               .caption!
                                        //                               .copyWith(fontWeight: FontWeight.w400,fontFamily: 'Poppins',color: AppTheme.textColor),
                                        //                         ),
                                        //                         Padding(padding: EdgeInsets.only(top: 2)),
                                        //                         Text(
                                        //                           productLists[index].price.toString()+" \$/hr",
                                        //                           maxLines: 1,
                                        //                           style: Theme
                                        //                               .of(context)
                                        //                               .textTheme
                                        //                               .subtitle2!
                                        //                               .copyWith(fontWeight: FontWeight.w600,fontFamily: "Poppins",color: Theme.of(context).primaryColor),
                                        //                         ),
                                        //
                                        //                         Padding(padding: EdgeInsets.all(15.0),
                                        //                             child:
                                        //                             SizedBox(
                                        //                                 height: 25.0,
                                        //                                 width: MediaQuery.of(context).size.width,
                                        //                                 child:
                                        //                                 ElevatedButton(
                                        //                                   style: ElevatedButton.styleFrom(
                                        //                                     side: BorderSide(color: Theme.of(context).primaryColor, width: 1),
                                        //                                     primary: selectedIndexList.contains(index)?Theme.of(context).primaryColor:AppTheme.verifyPhone,
                                        //
                                        //                                     shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(50))),
                                        //                                   ),
                                        //                                   // shape: shape,
                                        //                                   onPressed: (){
                                        //                                     // Navigator.push(context, MaterialPageRoute(builder: (context) => HomeItemDetail()));
                                        //
                                        //                                   },
                                        //                                   child:
                                        //                                   !selectedIndexList.contains(index)
                                        //                                       ?
                                        //                                   GestureDetector(
                                        //                                       onTap: (){
                                        //                                         if (!selectedIndexList.contains(index)) {
                                        //                                           selectedIndexList.add(index);
                                        //                                         }
                                        //                                         // else {
                                        //                                         //   selectedIndexList.remove(index);
                                        //                                         // }
                                        //                                         // model.addProduct(productLists[index]);
                                        //                                         setState(() {
                                        //
                                        //                                         });
                                        //                                       },
                                        //                                       child:
                                        //                                       Stack(
                                        //                                         // mainAxisAlignment: MainAxisAlignment.center,
                                        //                                         // crossAxisAlignment: CrossAxisAlignment.center,
                                        //                                         children: <Widget>[
                                        //                                           Align(
                                        //                                               alignment: Alignment.center,
                                        //                                               child:
                                        //                                               Text(
                                        //                                                 'ADD',
                                        //                                                 style: Theme.of(context)
                                        //                                                     .textTheme
                                        //                                                     .button!
                                        //                                                     .copyWith(color: Colors.black, fontWeight: FontWeight.w500,fontSize: 12.0),
                                        //                                               )),
                                        //
                                        //                                           Align(
                                        //                                               alignment: Alignment.centerRight,
                                        //                                               //    child: InkWell(
                                        //                                               // onTap: (){
                                        //                                               //   setState(() {
                                        //                                               //     // flagClickDisableAdd=true;
                                        //                                               //
                                        //                                               //   });
                                        //                                               // },
                                        //                                               child: Icon(Icons.add,size: 20.0,color:Colors.black)
                                        //                                             // )
                                        //                                           )
                                        //
                                        //
                                        //                                         ],
                                        //                                       ))
                                        //                                       :
                                        //                                   index<0
                                        //                                   ?
                                        //                                   Center(child:CircularProgressIndicator())
                                        //                                   :
                                        //                                   Row(
                                        //                                     crossAxisAlignment: CrossAxisAlignment.center,
                                        //                                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        //                                     children: <Widget>[
                                        //                                       InkWell(
                                        //                                           onTap: (){
                                        //                                             // setState(() {
                                        //                                               model.updateProduct(model.cart[index],
                                        //                                                   model.cart[index].qty - 1);
                                        //                                             // });
                                        //
                                        //                                           },
                                        //                                           child: Icon(Icons.remove,color: Colors.white,size: 20.0,)),
                                        //                                       Text(
                                        //                                         model.cart[index].qty.toString(),
                                        //                                         style: Theme.of(context)
                                        //                                             .textTheme
                                        //                                             .button!
                                        //                                             .copyWith(color: Colors.white, fontWeight: FontWeight.w400,fontSize: 12.0),
                                        //                                       ),
                                        //                                       InkWell(
                                        //                                           onTap: (){
                                        //                                             // setState(() {
                                        //                                               model.updateProduct(model.cart[index],
                                        //                                                   model.cart[index].qty + 1);
                                        //                                             // });
                                        //                                           },
                                        //                                           child: Icon(Icons.add,color: Colors.white,size: 20.0,))
                                        //                                     ],
                                        //                                   ),
                                        //
                                        //                                 )
                                        //                             )
                                        //                         )
                                        //                       ],
                                        //                     ),
                                        //                   )
                                        //               );
                                        //             }));
                                        //   },
                                        // ),
                                      )
                                          : Center(
                                        child: Padding(
                                            padding:
                                            EdgeInsets.only(top: 100.0),
                                            child: Text(
                                              "No Data Available",
                                              style: TextStyle(
                                                  fontFamily: 'Poppins',
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 16.0,
                                                  color: AppTheme.textColor),
                                            )),
                                      )
                                    ],
                                  ))),
                        ],
                      ));
              //   ),
              // );
                })
            )
        )
    );
  }
}

// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:orderly/Configs/image.dart';
// import 'package:orderly/Configs/theme.dart';
// import 'package:orderly/Models/cart_model.dart';
// import 'package:orderly/Screens/Customer/home/home_item_detail.dart';
// import 'package:orderly/Utils/translate.dart';
// import 'package:orderly/Widgets/app_button.dart';
// import 'package:shimmer/shimmer.dart';
//
//
// class Home extends StatefulWidget{
//   final CartModel model;
//
//   const Home({Key? key, required this.model}) : super(key: key);
//
//   _HomeState createState()=>_HomeState();
// }
//
// class _HomeState extends State<Home>{
//   List<int> selectedIndexList = []; //for selected index
//   List<Product> productLists=[];
//
//   void getProducts(){
//     for(int i=0;i<10;i++){
//       Product product=new Product(id: i, title: "Prime Roof Truck", price: 25, qty: 1, imgUrl: "http://via.placeholder.com/350x150");
//       productLists.add(product);
//     }
//   }
//
//   void initState() {
//     super.initState();
//     getProducts();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//
//     // Widget buildCategory(List<CategoryModel> location) {
//     Widget buildCategory() {
//       // if (location == null) {
//       //   return ListView.builder(
//       //     scrollDirection: Axis.horizontal,
//       //     padding: EdgeInsets.only(left: 5, right: 20, top: 10, bottom: 15),
//       //     itemBuilder: (context, index) {
//       //       return Padding(
//       //         padding: EdgeInsets.only(left: 15),
//       //         child: AppCategory(
//       //           type: CategoryView.cardLarge,
//       //         ),
//       //       );
//       //     },
//       //     itemCount: List.generate(8, (index) => index).length,
//       //   );
//       // }
//
//       return ListView.builder(
//         scrollDirection: Axis.horizontal,
//         padding: EdgeInsets.only(left: 5, right: 20, top: 10, bottom: 15),
//         itemBuilder: (context, index) {
//           // final item = location[index];
//           return Padding(
//               padding: EdgeInsets.only(left: 15),
//               child:
//               // AppCategory(
//               //   item: item,
//               //   type: CategoryView.cardLarge,
//               //   onPressed: (item) {
//               //     Navigator.pushNamed(
//               //       context,
//               //       Routes.listProduct,
//               //       arguments: item,
//               //     );
//               //   },
//               // ),
//               GestureDetector(
//                   onTap: (){
//                     print('clicked category');
//                   },
//                   child:
//                   Column(
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     children: [
//                       CachedNetworkImage(
//                         imageUrl: "http://via.placeholder.com/350x150",
//                         imageBuilder: (context, imageProvider) {
//                           return Container(
//                             height: 70.0,
//                             width: 70.0,
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.all(
//                                 Radius.circular(35),
//                               ),
//                               image: DecorationImage(
//                                 image: imageProvider,
//                                 fit: BoxFit.cover,
//                               ),
//                             ),
//                             child: Container(
//                               padding: EdgeInsets.all(8),
//
//                             ),
//                           );
//                         },
//                         placeholder: (context, url) {
//                           return Shimmer.fromColors(
//                             baseColor: Theme.of(context).hoverColor,
//                             highlightColor: Theme.of(context).highlightColor,
//                             enabled: true,
//                             child: Container(
//                               height: 70.0,
//                               width: 70.0,
//                               decoration: BoxDecoration(
//                                 borderRadius: BorderRadius.all(
//                                   Radius.circular(35),
//                                 ),
//                               ),
//                             ),
//                           );
//                         },
//                         errorWidget: (context, url, error) {
//                           return Shimmer.fromColors(
//                             baseColor: Theme.of(context).hoverColor,
//                             highlightColor: Theme.of(context).highlightColor,
//                             enabled: true,
//                             child: Container(
//                               height: 70.0,
//                               width: 70.0,
//                               decoration: BoxDecoration(
//                                 borderRadius: BorderRadius.all(
//                                   Radius.circular(35),
//                                 ),
//                               ),
//                               child: Icon(Icons.error),
//                             ),
//                           );
//                         },
//                       ),
//
//                       Padding(
//                         padding: EdgeInsets.only(left: 8, right: 8),
//
//                         child: Text(
//                           'Producers',
//                           style: TextStyle(
//                               fontFamily: 'Poppins',
//                               fontWeight: FontWeight.w600,
//                               fontSize: 12.0,
//                               color: AppTheme.textColor
//                           ),
//                         ),
//
//                       )
//
//                     ],
//                   )
//               )
//
//           );
//         },
//         itemCount: 10,
//       );
//     }
//
//     Widget buildListViewItemProd(index) {
//       // if (location == null) {
//       //   return ListView.builder(
//       //     scrollDirection: Axis.horizontal,
//       //     padding: EdgeInsets.only(left: 5, right: 20, top: 10, bottom: 15),
//       //     itemBuilder: (context, index) {
//       //       return Padding(
//       //         padding: EdgeInsets.only(left: 15),
//       //         child: AppCategory(
//       //           type: CategoryView.cardLarge,
//       //         ),
//       //       );
//       //     },
//       //     itemCount: List.generate(8, (index) => index).length,
//       //   );
//       // }
//
//       // return ListView.builder(
//       //   itemCount: 10,
//       //   scrollDirection: Axis.vertical,
//       //   padding: EdgeInsets.only(left: 5, right: 20, top: 10, bottom: 15),
//       //   itemBuilder: (context, index) {
//
//
//       return FractionallySizedBox(
//           widthFactor: 0.5,
//           child:
//           Container(
//               padding: EdgeInsets.only(left: 8),
//
//               child: Card(
//                 elevation: 3.0,
//                 shape: RoundedRectangleBorder(
//
//                 ),
//                 child:
//
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: <Widget>[
//                     CachedNetworkImage(
//                       imageUrl: "http://via.placeholder.com/350x150",
//                       imageBuilder: (context, imageProvider) {
//                         return Container(
//                           height: 120,
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.zero,
//                             image: DecorationImage(
//                               image: imageProvider,
//                               fit: BoxFit.cover,
//                             ),
//                           ),
//
//                         );
//                       },
//                       placeholder: (context, url) {
//                         return Shimmer.fromColors(
//                           baseColor: Theme
//                               .of(context)
//                               .hoverColor,
//                           highlightColor: Theme
//                               .of(context)
//                               .highlightColor,
//                           enabled: true,
//                           child: Container(
//                             height: 120,
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.zero,
//                               color: Colors.white,
//                             ),
//                           ),
//                         );
//                       },
//                       errorWidget: (context, url, error) {
//                         return Shimmer.fromColors(
//                           baseColor: Theme
//                               .of(context)
//                               .hoverColor,
//                           highlightColor: Theme
//                               .of(context)
//                               .highlightColor,
//                           enabled: true,
//                           child: Container(
//                             height: 120,
//                             decoration: BoxDecoration(
//                               color: Colors.white,
//                               borderRadius: BorderRadius.zero,
//                             ),
//                             child: Icon(Icons.error),
//                           ),
//                         );
//                       },
//                     ),
//                     Padding(padding: EdgeInsets.only(top: 3)),
//                     Text(
//                       "Prime Roof truck ",
//                       style: Theme
//                           .of(context)
//                           .textTheme
//                           .caption!
//                           .copyWith(fontWeight: FontWeight.w400,fontFamily: 'Poppins',color: AppTheme.textColor),
//                     ),
//                     Padding(padding: EdgeInsets.only(top: 2)),
//                     Text(
//                       "25 \$/hr",
//                       maxLines: 1,
//                       style: Theme
//                           .of(context)
//                           .textTheme
//                           .subtitle2!
//                           .copyWith(fontWeight: FontWeight.w600,fontFamily: "Poppins",color: Theme.of(context).primaryColor),
//                     ),
//
//                     Padding(padding: EdgeInsets.all(15.0),
//                         child:
//                         SizedBox(
//                             height: 25.0,
//                             width: MediaQuery.of(context).size.width,
//                             child:
//                             ElevatedButton(
//                               style: ElevatedButton.styleFrom(
//                                 side: BorderSide(color: Theme.of(context).primaryColor, width: 1),
//                                 primary: selectedIndexList.contains(index)?Theme.of(context).primaryColor:AppTheme.verifyPhone,
//
//                                 shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(50))),
//                               ),
//                               // shape: shape,
//                               onPressed: (){
//                                 Navigator.push(context, MaterialPageRoute(builder: (context) => HomeItemDetail()));
//
//                               },
//                               child:
//                               !selectedIndexList.contains(index)
//                                   ?
//                               GestureDetector(
//                                 onTap: (){
//                                   if (!selectedIndexList.contains(index)) {
//                                     selectedIndexList.add(index);
//                                   } else {
//                                     selectedIndexList.remove(index);
//                                   }
//                                   setState(() {
//
//                                   });
//                                 },
//                                 child:
//                               Stack(
//                                 // mainAxisAlignment: MainAxisAlignment.center,
//                                 // crossAxisAlignment: CrossAxisAlignment.center,
//                                 children: <Widget>[
//                                   Align(
//                                       alignment: Alignment.center,
//                                       child:
//                                       Text(
//                                         'ADD',
//                                         style: Theme.of(context)
//                                             .textTheme
//                                             .button!
//                                             .copyWith(color: Colors.black, fontWeight: FontWeight.w500,fontSize: 12.0),
//                                       )),
//
//                                   Align(
//                                       alignment: Alignment.centerRight,
//                                        child:Icon(Icons.add,size: 20.0,color:Colors.black)
//
//                                   )
//
//
//                                 ],
//                               ))
//                                   :
//                               Row(
//                                 crossAxisAlignment: CrossAxisAlignment.center,
//                                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                 children: <Widget>[
//                                   InkWell(
//                                       onTap: (){
//                                         setState(() {
//                                         });
//
//                                       },
//                                       child: Icon(Icons.remove,color: Colors.white,size: 20.0,)),
//                                   Text(
//                                     "_counter.toString()",
//                                     style: Theme.of(context)
//                                         .textTheme
//                                         .button!
//                                         .copyWith(color: Colors.white, fontWeight: FontWeight.w400,fontSize: 12.0),
//                                   ),
//                                   InkWell(
//                                       onTap: (){
//                                         setState(() {
//
//                                         });
//                                       },
//                                       child: Icon(Icons.add,color: Colors.white,size: 20.0,))
//                                 ],
//                               ),
//
//                             )
//                         )
//                     )
//                   ],
//                 ),
//               )
//           )
//         // }
//       );
//     }
//
//     // TODO: implement build
//     return Scaffold(
//       // appBar: AppBar(title: Text("Home"),
//       //   automaticallyImplyLeading:false,
//       // ),
//       body: Container(
//           child:Column(
//             children: [
//               //for producer category
//               Container(
//                 height: 120,
//                 child:
//                 buildCategory(),
//               ),
//
//               //for producer listview items
//               Expanded(
//                   flex: 3,
//                   child:SingleChildScrollView(
//                     child: Column(
//                       children: [
//                         Container(
//                           height: 180,
//                           child: CachedNetworkImage(
//                             imageUrl: "http://via.placeholder.com/350x150",
//                             imageBuilder: (context, imageProvider) {
//                               return Container(
//                                 height: 180,
//                                 decoration: BoxDecoration(
//                                   borderRadius: BorderRadius.zero,
//                                   image: DecorationImage(
//                                     image: imageProvider,
//                                     fit: BoxFit.cover,
//                                   ),
//                                 ),
//
//                               );
//                             },
//                             placeholder: (context, url) {
//                               return Shimmer.fromColors(
//                                 baseColor: Theme
//                                     .of(context)
//                                     .hoverColor,
//                                 highlightColor: Theme
//                                     .of(context)
//                                     .highlightColor,
//                                 enabled: true,
//                                 child: Container(
//                                   height: 120,
//                                   decoration: BoxDecoration(
//                                     borderRadius: BorderRadius.zero,
//                                     color: Colors.white,
//                                   ),
//                                 ),
//                               );
//                             },
//                             errorWidget: (context, url, error) {
//                               return Shimmer.fromColors(
//                                 baseColor: Theme
//                                     .of(context)
//                                     .hoverColor,
//                                 highlightColor: Theme
//                                     .of(context)
//                                     .highlightColor,
//                                 enabled: true,
//                                 child: Container(
//                                   height: 120,
//                                   decoration: BoxDecoration(
//                                     color: Colors.white,
//                                     borderRadius: BorderRadius.zero,
//                                   ),
//                                   child: Icon(Icons.error),
//                                 ),
//                               );
//                             },
//                           ),
//                         ),
//                         // buildListViewItemProd()
//                         Padding(
//                             padding: EdgeInsets.only(left: 15,right: 15,
//                                 top:15.0,bottom: 30.0),
//                             child:
//                             Wrap(
//                               runSpacing: 10,
//                               alignment: WrapAlignment.spaceBetween,
//                               children: List.generate(8, (index) => index).map((item) {
//                                 return buildListViewItemProd(item);
//                                 print(item);
//                               }).toList(),
//                             )
//                         ),
//
//
//                       ],
//                     ),
//                   )),
//               if(selectedIndexList.length>0)
//                 Expanded(child:
//                 Container(
//                     child:
//                     Padding(padding: EdgeInsets.only(left:15.0,right:15.0,top:15.0,bottom:95.0),
//                         child:
//                         SizedBox(
//                             height: 45.0,
//                             width: MediaQuery
//                                 .of(context)
//                                 .size
//                                 .width,
//                             child:
//                             ElevatedButton(
//                               style: ElevatedButton.styleFrom(
//                                 side: BorderSide(color: Theme
//                                     .of(context)
//                                     .primaryColor, width: 1),
//                                 primary: Theme.of(context).primaryColor,
//                                 shape: const RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.all(Radius.circular(
//                                         50))),
//                               ),
//                               // shape: shape,
//                               onPressed: () {
//                                 Navigator.push(context, MaterialPageRoute(builder: (
//                                     context) => HomeItemDetail()));
//                               },
//                               child:
//                               Row(
//                                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                 children: <Widget>[
//                                   Padding(padding: EdgeInsets.only(top:5.0,left:10.0),
//                                     child:
//                                     Column(
//                                       mainAxisAlignment: MainAxisAlignment.start,
//                                       crossAxisAlignment: CrossAxisAlignment.start,
//                                       children: [
//                                         Text(
//                                           'Items',
//                                           style: Theme
//                                               .of(context)
//                                               .textTheme
//                                               .bodyText1!
//                                               .copyWith(color: Colors.white,
//                                               fontWeight: FontWeight.w300,fontSize: 12.0),
//                                         ),
//                                         Row(
//                                           children: [
//                                             Text(
//                                               '\$ 25',
//                                               style: Theme
//                                                   .of(context)
//                                                   .textTheme
//                                                   .bodyText1!
//                                                   .copyWith(color: Colors.white,
//                                                   fontWeight: FontWeight.w600,fontSize: 14.0),
//                                             ),
//                                             Text(
//                                               ' +plus taxes',
//                                               style: Theme
//                                                   .of(context)
//                                                   .textTheme
//                                                   .bodyText1!
//                                                   .copyWith(color: Colors.white,
//                                                   fontWeight: FontWeight.w300,fontSize: 12.0),
//                                             ),
//                                           ],
//                                         )
//
//                                       ],
//                                     ),
//                                   ),
//
//                                   Text(
//                                     'VIEW CART',
//                                     style: Theme
//                                         .of(context)
//                                         .textTheme
//                                         .button!
//                                         .copyWith(color: Colors.white,
//                                         fontWeight: FontWeight.w600),
//                                   ),
//
//                                 ],
//                               ),
//
//                             )
//                         )
//                     )
//                 ),
//                 )
//
//
//             ],
//           )
//
//       ),
//     );
//   }
//
// }
