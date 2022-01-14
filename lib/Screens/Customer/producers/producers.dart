import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:orderly/Api/api.dart';
import 'package:orderly/Blocs/authentication/authentication_event.dart';
import 'package:orderly/Blocs/home/home_bloc.dart';
import 'package:orderly/Blocs/home/home_event.dart';
import 'package:orderly/Blocs/home/home_state.dart';
import 'package:orderly/Blocs/producer/bloc.dart';
import 'package:orderly/Blocs/producer/producer_bloc.dart';
import 'package:orderly/Configs/theme.dart';
import 'package:orderly/Models/model_producer_list.dart';
import 'package:orderly/Models/model_product_List.dart';
import 'package:orderly/Models/model_scoped_cart.dart';
import 'package:orderly/Models/model_view_cart.dart';
import 'package:orderly/Screens/Customer/cart/shopping_cart.dart';
import 'package:orderly/Utils/Utils.dart';
import 'package:orderly/Utils/application.dart';
import 'package:orderly/Utils/connectivity_check.dart';
import 'package:orderly/Utils/preferences.dart';
import 'package:orderly/Utils/progressDialog.dart';
import 'package:orderly/Utils/routes.dart';
import 'package:orderly/Utils/translate.dart';
import 'package:orderly/Utils/util_preferences.dart';
import 'package:orderly/Widgets/app_dialogs.dart';
import 'package:orderly/app_bloc.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:readmore/readmore.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shimmer/shimmer.dart';
import 'package:http/http.dart' as http;

class Producers extends StatefulWidget {
  CartModel model;

  Producers({Key key, @required this.model}) : super(key: key);

  @override
  _ProducersState createState() => _ProducersState();
}

class _ProducersState extends State<Producers> {
  bool _expand = false;
  List<Producer> _producerTabList;
  List<Product> __productTabList, totalProductTabList;

  bool isconnectedToInternet = false;
  String type = "ALL";
  ProducerProdBloc _producerProdBloc;
  bool flagDataNotAvailable = false;
  CartModel cartModel;
  PagingController<int, Product> _pagingTabController;
  int _pageSize;
  int offset = 0, producerListIndex = 0;
  final _controller = RefreshController(initialRefresh: false);
  final _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    cartModel = new CartModel();
    _producerProdBloc = BlocProvider.of<ProducerProdBloc>(context);
    totalProductTabList = [];
    // paginationCall(_producerTabList);
    getData();
  }

  void paginationCall(List<Producer> producerList) {
    _pageSize = 10;
    _pagingTabController = PagingController(firstPageKey: 0);
    //updated on 15/11/2021 for pagination
    _pagingTabController.addPageRequestListener((pageKey) {
      offset = pageKey;
      print("pageKey:-" + pageKey.toString());
      _producerProdBloc.add(OnLoadingProductTabList(
        producerId: producerList[producerListIndex].producerId.toString(),
        type: type,
        offset: offset.toString(),
      ));
    });
  }

  void getData() {
    final String cartString = UtilPreferences.getString(Preferences.cart);
    if (cartString != null) {
      var _cart = jsonDecode(cartString).toList();
      List<dynamic> _cartList =
          _cart.map((cartJson) => Cart.fromJson(cartJson)).toList();
      cartModel.addAllProduct(_cartList.cast<Cart>());
      Application.cartModel = cartModel;
      print(_cartList);
    }
    setBlocData();
  }

  void setBlocData() async {
    isconnectedToInternet = await ConnectivityCheck.checkInternetConnectivity();
    if (isconnectedToInternet == true) {
      _producerProdBloc.add(OnLoadingProducerTabList());
    } else {
      CustomDialogs.showDialogCustom(
          "Internet", "Please check your Internet Connection!", context);
    }
  }

  ///On Refresh List
  Future<void> _onRefresh() async {
    _producerTabList = null;
    totalProductTabList = [];
    offset = 0;
    _pageSize = 10;
    await Future.delayed(Duration(milliseconds: 1000));
    paginationCall(_producerTabList);
    setBlocData();
    _controller.refreshCompleted();
  }

  Widget buildListViewItemProd(int index, Product product, CartModel model) {
    if (product == null) {
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
                          style: Theme.of(context).textTheme.subtitle2.copyWith(
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
                  padding: EdgeInsets.only(left: 10.0, right: 10.0),
                  child: Text(
                    product.productName,
                    style: Theme.of(context).textTheme.caption.copyWith(
                        fontWeight: FontWeight.w400,
                        fontFamily: 'Poppins',
                        color: AppTheme.textColor),
                  )),
              Padding(padding: EdgeInsets.only(top: 2)),
              Text(
                product.ratePerHour.toString() + "\u{20B9}/hr",
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
                                borderRadius:
                                    BorderRadius.all(Radius.circular(50))),
                          ),
                          // shape: shape,
                          onPressed: () async {
                            // model.addProduct(__productTabList[index]);
                            // Navigator.push(context, MaterialPageRoute(builder: (context)=>ShoppingCart(price:__productTabList[index].ratePerHour.toString(),cartModel:model)));
                            // if (isConnectedToInternet == true) {
                            //   await PsProgressDialog
                            //       .showProgressWithoutMsg(context);
                            //   // AddedToCart(model,
                            //   //     widget.producerList[widget.index]
                            //   //         .producerId.toString(),
                            //   //     widget.totalProductTabList[index].productId
                            //   //         .toString(),
                            //   //     widget.totalProductTabList[index].qty
                            //   //         .toString(),
                            //   //     widget.totalProductTabList[index].ratePerHour
                            //   //         .toString());
                            // } else {
                            //   CustomDialogs.showDialogCustom(
                            //       "Internet",
                            //       "Please be online to proceed further!",
                            //       context);
                            // }
                          },
                          child: index < 0
                              ? Center(child: CircularProgressIndicator())
                              : Stack(
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
                                                  fontWeight: FontWeight.w500,
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
                                ))))
            ],
          ),
        ));
  }

  Widget buildCategory(List<Producer> producerList, CartModel model) {
    if (producerList == null) {
      return ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          return Shimmer.fromColors(
            baseColor: Theme.of(context).hoverColor,
            highlightColor: Theme.of(context).highlightColor,
            enabled: true,
            child: Container(
              margin: EdgeInsets.only(top: 10.0),
              width: MediaQuery.of(context).size.width,
              height: 200.0,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.rectangle,
              ),
            ),
          );
        },
        itemCount: List.generate(8, (index) => index).length,
      );
    }

    return ListView.builder(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      // padding: EdgeInsets.only(
      //   top: 5,
      // ),
      itemBuilder: (context, index) {
        return Column(
          children: [
            GestureDetector(
                onTap: () async {
                  print('clicked category');
                  // WidgetsBinding.instance.addPostFrameCallback((_)
                  //     {
                  //       if(mounted) {
                  //         setState(() {
                  if (_producerTabList[index].expand == false) {
                    //imp
                    Producer.setAllExpand(_producerTabList);
                  }
                  // _producerTabList[index].tapcount=producerList[index].tapcount+1;

                  _producerTabList[index].expand =
                      !_producerTabList[index].expand;
                  offset = 0;
                  totalProductTabList = [];
                  producerListIndex = index;
                  type = index == 0 ? "ALL" : "";
                  flagDataNotAvailable = false;
                  // });
                  paginationCall(_producerTabList);
                  _producerProdBloc.add(OnLoadingProductTabList(
                      producerId: _producerTabList[producerListIndex]
                          .producerId
                          .toString(),
                      type: type,
                      offset: offset.toString()));
                },
                child:
                Stack(
                  // mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    CachedNetworkImage(
                      imageUrl: _producerTabList[index].producerImageUrl,
                      imageBuilder: (context, imageProvider) {
                        return Container(
                          width: MediaQuery.of(context).size.width,
                          margin: EdgeInsets.only(top: 5.0),
                          height: 180.0,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.rectangle,
                          ),
                          child: Image.network(
                            _producerTabList[index].producerImageUrl,
                            fit: BoxFit.fill,
                          ),
                        );
                      },
                      placeholder: (context, url) {
                        return Shimmer.fromColors(
                          baseColor: Theme.of(context).hoverColor,
                          highlightColor: Theme.of(context).highlightColor,
                          enabled: true,
                          child: Container(
                            height: 180.0,
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.rectangle,
                            ),
                            child: Image.network(
                              _producerTabList[index].producerImageUrl,
                              fit: BoxFit.fill,
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
                            height: 180.0,
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.rectangle,
                            ),
                            child: Image.network(
                              _producerTabList[index].producerIconUrl,
                              fit: BoxFit.fill,
                            ),
                          ),
                        );
                      },
                    ),
                    Container(
                      width:250.0,
                        height:180.0,
                        child:Padding(
                        padding: EdgeInsets.only(left:15.0,top:20.0),
                        child: Stack(
                          // mainAxisAlignment: MainAxisAlignment.start,
                          // crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _producerTabList[index].producerName,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontFamily: 'Poppins',
                                      fontSize: 14.0,
                                      color: Colors.black),
                                ),
                                SizedBox(height: 3.0,),

                                ReadMoreText(_producerTabList[index].producerDesc,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontFamily: 'Poppins',
                                        fontSize: 12.0,
                                        height: 1.2,
                                        color: Colors.black),
                                    trimLines: 4,
                                    trimMode: TrimMode.Line,
                                    trimCollapsedText: 'Show more',
                                    trimExpandedText: 'Show less'),
                              ],
                            ),

                            // SizedBox(height: 45.0,),

                            //for view All
                            Positioned(
                              bottom:5.0,
                                child:Container(
                                    height: 30.0,
                                width: 100.0,
                                child:ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                side: BorderSide(color: Colors.white, width: 1),
                                primary: Colors.white,
                                shape: const RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(15))),
                              ),
                              child: Text(
                                "VIEW All",
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontFamily: 'Poppins',
                                    fontSize: 11.0,
                                    color: Colors.black),
                              ),
                              onPressed: () async {
                                if (_producerTabList[index].expand == false) {
                                  //imp
                                  Producer.setAllExpand(_producerTabList);
                                }
                                // _producerTabList[index].tapcount=producerList[index].tapcount+1;

                                _producerTabList[index].expand =
                                !_producerTabList[index].expand;
                                offset = 0;
                                totalProductTabList = [];
                                producerListIndex = index;
                                type = index == 0 ? "ALL" : "";
                                flagDataNotAvailable = false;
                                // });
                                paginationCall(_producerTabList);
                                _producerProdBloc.add(OnLoadingProductTabList(
                                    producerId: _producerTabList[producerListIndex]
                                        .producerId
                                        .toString(),
                                    type: type,
                                    offset: offset.toString()));
                              },
                            ))
                            )
                          ],
                        )))

                    //   SizedBox(
                    //     height: 200,
                    //     width: MediaQuery.of(context).size.width,
                    //     child:
                    //     Container(
                    //       decoration: BoxDecoration(
                    //         color: Colors.white,
                    //         shape: BoxShape.rectangle,
                    //
                    //       ),
                    //       child: Image.network( _producerTabList[index].producerIconUrl, fit: BoxFit.fill,),
                    //
                    //     ),
                    //   ),
                    // Padding(
                    // padding: EdgeInsets.only(left: 8, right: 8),
                    // child: Text(
                    // _producerTabList[index].producerName,
                    // style: TextStyle(
                    // fontFamily: 'Poppins',
                    // fontWeight: FontWeight.w600,
                    // fontSize: 12.0,
                    // color: AppTheme.textColor),
                    // ),
                    // )
                  ],
                )),
            if (_producerTabList != null &&
                _producerTabList[index].expand == true)
              ExpandedSection(
                  productList: __productTabList,
                  totalProductTabList: totalProductTabList,
                  producerList: producerList,
                  expand: _producerTabList[index].expand,
                  index: producerListIndex,
                  cartModel: model,
                  isConnectedToInternet: isconnectedToInternet,
                  pagingController: _pagingTabController,
                  noData: flagDataNotAvailable)

            // Container(
            //     height: 300.0,
            //     // height: MediaQuery.of(context).size.height,
            //     child:
            //
            //     __productTabList != null
            //         ?
            //     Padding(
            //       padding: EdgeInsets.only(top:10.0),
            //       child:
            //
            //       PagedGridView<int, Product>(
            //           showNewPageProgressIndicatorAsGridChild: false,
            //           showNewPageErrorIndicatorAsGridChild: false,
            //           showNoMoreItemsIndicatorAsGridChild: false,
            //           pagingController: _pagingTabController,
            //           gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            //             childAspectRatio: 80 / 90,
            //             crossAxisSpacing: 10,
            //             mainAxisSpacing: 10,
            //             crossAxisCount: 2,
            //           ),
            //           builderDelegate: PagedChildBuilderDelegate<Product>(
            //               itemBuilder: (context, item, index) =>
            //                   buildListViewItemProd(index, item, model)
            //             //     CharacterUpdatedScreen(
            //             //   character: item,
            //             // ),
            //           )),
            //     )
            //         :
            //     Center(child: CircularProgressIndicator())
            //
            // )
          ],
        );
      },
      itemCount: _producerTabList != null ? _producerTabList.length : 10,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        body: BlocListener<ProducerProdBloc, ProducerProdState>(
            listener: (context, state) {
          if (state is ProducerListTabLoadFail) {}
        }, child: BlocBuilder<ProducerProdBloc, ProducerProdState>(
                builder: (context, state) {
          if (state is ProducerListTabSuccess) {
            _producerTabList = state.producerList;
            offset = 0;
            // paginationCall(_producerTabList);
            _producerProdBloc.add(OnLoadingProductTabList(
                producerId:
                    _producerTabList[producerListIndex].producerId.toString(),
                type: type,
                offset: offset.toString()));
          }

          if (state is ProductListTabSuccess) {
            if (__productTabList == null) {
              __productTabList = state.productList;
              totalProductTabList.addAll(__productTabList);
              if (__productTabList.length > 0) {
                //for pagination
                flagDataNotAvailable = false;

                final isLastPage = __productTabList.length < _pageSize;
                if (isLastPage) {
                  _pagingTabController.appendLastPage(__productTabList);
                } else {
                  final nextPageKey = offset + __productTabList.length;
                  _pagingTabController.appendPage(
                      __productTabList, nextPageKey);
                }
              } else {
                flagDataNotAvailable = true;
              }
            }
          }

          if (state is ProductTabLoading) {
            __productTabList = null;
          }
          //for addto cart
          if (state is AddToCartTabSuccess) {
            Navigator.pushNamed(context, Routes.cart);
          }
          return ScopedModel<CartModel>(
              model: cartModel,
              child: ScopedModelDescendant<CartModel>(
                  builder: (context, child, model) {
                return SafeArea(
                    child: SmartRefresher(
                        enablePullDown: true,
                        onRefresh: _onRefresh,
                        controller: _controller,
                        child:
                            // CustomScrollView(
                            //     slivers: <Widget>[
                            //
                            //   SliverToBoxAdapter(
                            //       child:
                            //       Container(child:
                        SingleChildScrollView(child:
                            buildCategory(_producerTabList, model)))
                    // buildCategory(_producerTabList,model)
                    // ),
                    //       ])

                    // ),
                    //     ),

                    );
              }));
        })));
  }
}

//expanded part
class ExpandedSection extends StatefulWidget {
  // final Widget child;
  List<Product> productList, totalProductTabList;
  List<Producer> producerList;
  int index;
  CartModel cartModel;
  bool isConnectedToInternet;
  final bool expand, noData;
  PagingController<int, Product> pagingController;

  ExpandedSection(
      {this.expand = false,
      this.productList,
      this.totalProductTabList,
      this.producerList,
      this.index,
      this.cartModel,
      this.isConnectedToInternet,
      this.pagingController,
      this.noData});

  @override
  _ExpandedSectionState createState() => _ExpandedSectionState();
}

class _ExpandedSectionState extends State<ExpandedSection>
    with TickerProviderStateMixin {
  AnimationController expandController;

  // List<Animation<double>> animation=[];
  Animation<double> animation;

  // List<AnimationController> expandController = [];
  int pos = 0;

  @override
  void initState() {
    super.initState();

    prepareAnimations();
    _runExpandCheck();
  }

  ///Setting up the animation
  void prepareAnimations() {
    // for(int i=0;i<widget.producerList.length;i++){
    //
    //   // expandController.add(AnimationController(vsync: this, duration: Duration(seconds: 500)));
    //   try {
    //     expandController.insert(i,
    //         AnimationController(vsync: this, duration: Duration(seconds: 500)));
    //
    //     expandController[i] =
    //         AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    //     pos=i;
    //
    //     animation.insert(i,CurvedAnimation(parent: expandController[i], curve: Curves.fastOutSlowIn,));
    //
    //     animation[i] = CurvedAnimation(
    //       parent: expandController[i],
    //       curve: Curves.fastOutSlowIn,
    //     );
    //   }catch(e){
    //     print(e);
    //   }
    // }

    expandController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    animation = CurvedAnimation(
      parent: expandController,
      curve: Curves.fastOutSlowIn,
    );
  }

  void _runExpandCheck() {
    // for(int i=0;i<widget.producerList.length;i++){
    //   if (widget.producerList[i].expand==widget.expand) {
    //     expandController[i].reverse();
    //
    //   }else{
    //     expandController[i].forward();
    //
    //   }
    // }
    if (widget.expand) {
      expandController.forward();
    } else {
      expandController.reverse();
    }
  }

  @override
  void didUpdateWidget(ExpandedSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    _runExpandCheck();
  }

  @override
  void dispose() {
    expandController.dispose();
    super.dispose();
  }

  Widget buildListViewItemProd(int index, Product product, CartModel model) {
    if (product == null) {
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
                          height: 80,
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
                          style: Theme.of(context).textTheme.subtitle2.copyWith(
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
                    height: 80,
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
                      height: 80,
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
                      height: 80,
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
                  padding: EdgeInsets.only(left: 10.0, right: 10.0),
                  child: Text(
                    product.productName,
                    style: Theme.of(context).textTheme.caption.copyWith(
                        fontWeight: FontWeight.w400,
                        fontFamily: 'Poppins',
                        color: AppTheme.textColor),
                  )),
              Padding(padding: EdgeInsets.only(top: 2)),
              Text(
                product.ratePerHour.toString() + " "+Utils.getCurrencyPerLocale("en_IN")+"/"+product.unit,
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
                                borderRadius:
                                    BorderRadius.all(Radius.circular(50))),
                          ),
                          // shape: shape,
                          onPressed: () async {
                            // model.addProduct(__productTabList[index]);
                            // Navigator.push(context, MaterialPageRoute(builder: (context)=>ShoppingCart(price:__productTabList[index].ratePerHour.toString(),cartModel:model)));
                            if (widget.isConnectedToInternet == true) {
                              await PsProgressDialog.showProgressWithoutMsg(
                                  context);
                              AddedToCart(
                                  model,
                                  // widget.producerList[widget.index]
                                  //     .producerId.toString(),
                                  widget.totalProductTabList[index].producerid
                                      .toString(), //updated on 4/01/2022
                                  widget.totalProductTabList[index].productId
                                      .toString(),
                                  widget.totalProductTabList[index].qty
                                      .toString(),
                                  widget.totalProductTabList[index].ratePerHour
                                      .toString());
                            } else {
                              CustomDialogs.showDialogCustom(
                                  "Internet",
                                  "Please be online to proceed further!",
                                  context);
                            }
                          },
                          child: index < 0
                              ? Center(child: CircularProgressIndicator())
                              : Stack(
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
                                                  fontWeight: FontWeight.w500,
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
                                ))))
            ],
          ),
        ));
  }

  Future<void> AddedToCart(CartModel model, String producerId, String productId,
      String qty, String price) async {
    Map<String, String> params = {
      'producer_id': producerId,
      'product_id': productId,
      'user_id': Application.user.fbId,
      // 'qty': qty,
      'qty': "1", //updated 0n 4/01/2021
      'rate_per_hour': price
    };

    var response = await http.post(
      Uri.parse(Api.ADD_TO_CART),
      body: params,
    );

    try {
      if (response.statusCode == 200) {
        var resp = json.decode(response.body);
        if (resp['msg'] == "Successed") {
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
          if (model != null) {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ShoppingCart(
                        flagFrom: "0",
                        price: price,
                        cartModel: model,
                        productList: widget.totalProductTabList)));
          }
        } else {
          print('exists');
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ShoppingCart(
                      flagFrom: "0",
                      price: price,
                      cartModel: model,
                      productList: widget.totalProductTabList)));
        }
        // await PsProgressDialog.showProgressWithoutMsg(context);
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizeTransition(
      axisAlignment: 1.0,
      sizeFactor: animation,
      child: widget.noData == false
          ? Container(
              // height: 300,
              height: MediaQuery.of(context).size.height*0.51,
              child: widget.productList != null
                  ? Padding(
                      padding: EdgeInsets.only(
                        top: 10.0,
                      ),
                      child: PagedGridView<int, Product>(
                        // shrinkWrap: true,
                          // physics: NeverScrollableScrollPhysics(),
                          showNewPageProgressIndicatorAsGridChild: false,
                          showNewPageErrorIndicatorAsGridChild: false,
                          showNoMoreItemsIndicatorAsGridChild: false,
                          pagingController: widget.pagingController,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            childAspectRatio: 80 / 80,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                            crossAxisCount: 2,
                          ),
                          builderDelegate: PagedChildBuilderDelegate<Product>(
                              itemBuilder: (context, item, index) =>
                                  buildListViewItemProd(
                                      index, item, widget.cartModel)
                              //     CharacterUpdatedScreen(
                              //   character: item,
                              // ),
                              )),
                    )
                  : Center(child: CircularProgressIndicator()))
          : Center(
              child: Padding(
                  padding: EdgeInsets.only(top: 100.0),
                  child: Text(
                    "No Data Available",
                    style: TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w600,
                        fontSize: 16.0,
                        color: AppTheme.textColor),
                  )),
            ),
    );
  }
}

class Header extends StatelessWidget {
  final VoidCallback onTap;

  Header({@required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        color: Colors.cyan,
        height: 100,
        width: double.infinity,
        child: Center(
          child: Text(
            'Header -- Tap me to expand!',
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
        ),
      ),
    );
  }
}

class Content extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.lightGreen,
      height: 200,
      width: MediaQuery.of(context).size.width,
      child: ListView.builder(
        scrollDirection: Axis.vertical,
        padding: EdgeInsets.only(
          top: 10,
        ),
        itemBuilder: (context, index) {
          return Column(
            children: [
              Text("dgsgg"),
            ],
          );
        },
        itemCount: 50,
      ),
    );
  }
}
