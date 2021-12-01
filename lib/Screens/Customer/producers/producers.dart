import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:expandable/expandable.dart';
import 'package:orderly/Configs/image.dart';
import 'package:orderly/Configs/theme.dart';
import 'package:orderly/Models/model_scoped_cart.dart';
import 'package:shimmer/shimmer.dart';


class Producers extends StatefulWidget{
  CartModel model;

  Producers({Key key, @required this.model}) : super(key: key);

  _ProducersState createState()=>_ProducersState();
}

class _ProducersState extends State<Producers>{
  bool isExpand=false;


  List<Products> productLists = [];
  List<Products> cartList = []; //added as per total calculate count
  double totalCartValue = 0;
  int quantity=0;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isExpand=false;
  }





  Widget buildListViewItemProd() {
    // if (location == null) {
    //   return ListView.builder(
    //     scrollDirection: Axis.horizontal,
    //     padding: EdgeInsets.only(left: 5, right: 20, top: 10, bottom: 15),
    //     itemBuilder: (context, index) {
    //       return Padding(
    //         padding: EdgeInsets.only(left: 15),
    //         child: AppCategory(
    //           type: CategoryView.cardLarge,
    //         ),
    //       );
    //     },
    //     itemCount: List.generate(8, (index) => index).length,
    //   );
    // }

    // return ListView.builder(
    //   itemCount: 10,
    //   scrollDirection: Axis.vertical,
    //   padding: EdgeInsets.only(left: 5, right: 20, top: 10, bottom: 15),
    //   itemBuilder: (context, index) {
    return FractionallySizedBox(
        widthFactor: 0.5,
        child:
        Container(
            padding: EdgeInsets.only(left: 8),

            child: Card(
              elevation: 3.0,
              shape: RoundedRectangleBorder(

              ),
              child:

              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  CachedNetworkImage(
                    imageUrl: "http://via.placeholder.com/350x150",
                    imageBuilder: (context, imageProvider) {
                      return Container(
                        height: 120,
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
                        baseColor: Theme
                            .of(context)
                            .hoverColor,
                        highlightColor: Theme
                            .of(context)
                            .highlightColor,
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
                        baseColor: Theme
                            .of(context)
                            .hoverColor,
                        highlightColor: Theme
                            .of(context)
                            .highlightColor,
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
                  Padding(padding: EdgeInsets.only(top: 3)),
                  Text(
                    "Prime Roof truck ",
                    style: Theme
                        .of(context)
                        .textTheme
                        .caption
                        .copyWith(fontWeight: FontWeight.w400,fontFamily: 'Poppins',color: AppTheme.textColor),
                  ),
                  Padding(padding: EdgeInsets.only(top: 2)),
                  Text(
                    "25 \$/hr",
                    maxLines: 1,
                    style: Theme
                        .of(context)
                        .textTheme
                        .subtitle2
                        .copyWith(fontWeight: FontWeight.w600,fontFamily: "Poppins",color: Theme.of(context).primaryColor),
                  ),

                  Padding(padding: EdgeInsets.all(15.0),
                      child:
                      SizedBox(
                          height: 25.0,
                          width: MediaQuery.of(context).size.width,
                          child:

                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              side: BorderSide(color: Theme.of(context).primaryColor, width: 1),
                              primary: Theme.of(context).primaryColor,

                              shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(50))),
                            ),
                            // shape: shape,
                            onPressed: (){},
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  'More Info',
                                  style: Theme.of(context)
                                      .textTheme
                                      .button
                                      .copyWith(color: Colors.white, fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                          )
                      )
                  )
                ],
              ),
            )
        )
      // }
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      // appBar: AppBar(title: Text("Producers"),),
      body:
      ExpandableTheme(
          data: const ExpandableThemeData(
            iconColor: Colors.blue,
            useInkWell: true,
          ),
          child:
          // ListView(
          //   physics: const BouncingScrollPhysics(),
          //   children: <Widget>[
          //     Card1(),
          //     Card2(),
          //     // Card3(),
          //   ],
          // ),
          ListView.builder(
            scrollDirection: Axis.vertical,
            padding: EdgeInsets.only( top: 10,),
            itemBuilder: (context, index) {
              // final item = location[index];
              // return Padding(
              //     padding: EdgeInsets.all(5.0),
              //     child:

              return ExpandableItems();

              // );

              // return  Padding(
              //   padding: (isExpand==true)?const EdgeInsets.all(8.0):const EdgeInsets.all(12.0),
              //   child: Container(
              //       decoration:BoxDecoration(
              //           color: Colors.white,
              //           borderRadius: (isExpand!=true)?BorderRadius.all(Radius.circular(8)):BorderRadius.all(Radius.circular(22)),
              //           border: Border.all(color: Colors.pink)
              //       ),
              //       child: Stack(
              //         alignment: Alignment.bottomCenter,
              //         children: [
              //           ExpansionTile(
              //             key: PageStorageKey<String>("hi"),
              //             title: Container(
              //                 width: double.infinity,
              //
              //                 child: Text("hi",style: TextStyle(fontSize: (isExpand!=true)?18:22),)),
              //             trailing:SizedBox.shrink(),
              //
              //             // (isExpand==true)?Icon(Icons.arrow_drop_down,size: 32,color: Colors.pink,):Icon(Icons.arrow_drop_up,size: 32,color: Colors.pink),
              //             onExpansionChanged: (value){
              //               setState(() {
              //                 isExpand=value;
              //               });
              //             },
              //             children: [
              //
              //               Padding(
              //                   padding: EdgeInsets.only(left: 15,right: 15,
              //                       top:15.0,bottom: 90.0),
              //                   child:
              //                   Wrap(
              //                     runSpacing: 10,
              //                     alignment: WrapAlignment.spaceBetween,
              //                     children: List.generate(20, (index) => index).map((item) {
              //                       return buildListViewItemProd();
              //                     }).toList(),
              //                   )
              //               )
              //
              //               // for(final item in listItem)
              //               //   Padding(
              //               //     padding: const EdgeInsets.all(8.0),
              //               //     child: InkWell(
              //               //       onTap: (){
              //               //         Scaffold.of(context).showSnackBar(SnackBar(backgroundColor: Colors.pink,duration:Duration(microseconds: 500),content: Text("Selected Item $item "+this.widget.headerTitle )));
              //               //       },
              //               //       child: Container(
              //               //           width: double.infinity,
              //               //           decoration:BoxDecoration(
              //               //               color: Colors.grey,
              //               //               borderRadius: BorderRadius.all(Radius.circular(4)),
              //               //               border: Border.all(color: Colors.pinkAccent)
              //               //           ),
              //               //           child: Padding(
              //               //             padding: const EdgeInsets.all(8.0),
              //               //             child: Text(item,style: TextStyle(color: Colors.white),),
              //               //           )),
              //               //     ),
              //               //   )
              //
              //
              //
              //             ],
              //
              //           ),
              //           Positioned(
              //               top: 30.0,
              //               bottom: 0.0,
              //               child:Icon(Icons.arrow_drop_down,size: 50.0,))
              //         ],
              //       )
              //   ),
              // );
            },
            itemCount: 10,
          )

      ),
    );
  }

}

class ExpandableItems extends StatefulWidget {
  _ExpandableItemsState createState()=>_ExpandableItemsState();
}
class _ExpandableItemsState extends State<ExpandableItems>{

  var loremIpsum =
      "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.";

  Widget buildListViewItemProd(BuildContext context) {
    // if (location == null) {
    //   return ListView.builder(
    //     scrollDirection: Axis.horizontal,
    //     padding: EdgeInsets.only(left: 5, right: 20, top: 10, bottom: 15),
    //     itemBuilder: (context, index) {
    //       return Padding(
    //         padding: EdgeInsets.only(left: 15),
    //         child: AppCategory(
    //           type: CategoryView.cardLarge,
    //         ),
    //       );
    //     },
    //     itemCount: List.generate(8, (index) => index).length,
    //   );
    // }

    // return ListView.builder(
    //   itemCount: 10,
    //   scrollDirection: Axis.vertical,
    //   padding: EdgeInsets.only(left: 5, right: 20, top: 10, bottom: 15),
    //   itemBuilder: (context, index) {
    return FractionallySizedBox(
        widthFactor: 0.5,
        child:
        Container(
            padding: EdgeInsets.only(left: 8,right:8.0),

            child: Card(
              elevation: 3.0,
              shape: RoundedRectangleBorder(

              ),
              child:

              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  CachedNetworkImage(
                    imageUrl: "http://via.placeholder.com/350x150",
                    imageBuilder: (context, imageProvider) {
                      return Container(
                        height: 100,
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
                        baseColor: Theme
                            .of(context)
                            .hoverColor,
                        highlightColor: Theme
                            .of(context)
                            .highlightColor,
                        enabled: true,
                        child: Container(
                          height: 100,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.zero,
                            color: Colors.white,
                          ),
                        ),
                      );
                    },
                    errorWidget: (context, url, error) {
                      return Shimmer.fromColors(
                        baseColor: Theme
                            .of(context)
                            .hoverColor,
                        highlightColor: Theme
                            .of(context)
                            .highlightColor,
                        enabled: true,
                        child: Container(
                          height: 100,
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
                    "Prime Roof truck ",
                    style: Theme
                        .of(context)
                        .textTheme
                        .caption
                        .copyWith(fontWeight: FontWeight.w400,fontFamily: 'Poppins',color: AppTheme.textColor),
                  ),
                  Padding(padding: EdgeInsets.only(top: 2)),
                  Text(
                    "25 \$/hr",
                    maxLines: 1,
                    style: Theme
                        .of(context)
                        .textTheme
                        .subtitle2
                        .copyWith(fontWeight: FontWeight.w600,fontFamily: "Poppins",color: Theme.of(context).primaryColor),
                  ),

                  Padding(padding: EdgeInsets.all(15.0),
                      child:
                      SizedBox(
                          height: 25.0,
                          width: 160.0,
                          child:

                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              side: BorderSide(color: Theme.of(context).primaryColor, width: 1),
                              primary: Theme.of(context).primaryColor,

                              shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(50))),
                            ),
                            // shape: shape,
                            onPressed: (){},
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  'More Info',
                                  style: Theme.of(context)
                                      .textTheme
                                      .button
                                      .copyWith(color: Colors.white, fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                          )
                      )
                  )
                ],
              ),
            )
        )
      // }
    );
  }


  @override
  Widget build(BuildContext context) {
    return ExpandableNotifier(


      // child: Padding(
      //   padding: const EdgeInsets.all(2),
      child:
      Container(

        // clipBehavior: Clip.antiAlias,
        child:
        // Column(
        //   children: <Widget>[
        //   SizedBox(
        //   height: 150,
        //   child:
        //   Container(
        //     decoration: BoxDecoration(
        //       color: Colors.orange,
        //       shape: BoxShape.rectangle,
        //     ),
        //   ),
        // ),
        ScrollOnExpand(
          scrollOnExpand: true,
          scrollOnCollapse: false,
          child:
          ExpandablePanel(

            theme: const ExpandableThemeData(
                headerAlignment: ExpandablePanelHeaderAlignment.bottom,
                tapBodyToCollapse: true,
                // iconColor: Colors.white,
                hasIcon: false //for disability of icon
            ),
            header:
            // Padding(
            //     padding: EdgeInsets.all(10),
            //     child: Text(
            //       "ExpandablePanel",
            //       style: Theme.of(context).textTheme.body2,
            //     )),

            SizedBox(
              height: 200,
              child:
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.rectangle,

                ),
                child: Image.asset(Images.truckFull,fit: BoxFit.fill,),

              ),
            ),
            collapsed:
            Text(
              "",
              // softWrap: true,
              // maxLines: 1,
              // overflow: TextOverflow.ellipsis,
            ),

            expanded:
            // Column(
            //   crossAxisAlignment: CrossAxisAlignment.start,
            //   children: <Widget>[
            // for (var _ in Iterable.generate(5))
            // Padding(
            //     padding: EdgeInsets.only(bottom: 10),
            //     child: Text(
            //       loremIpsum,
            //       softWrap: true,
            //       overflow: TextOverflow.fade,
            //     )),
            Padding(
                padding: EdgeInsets.only(left:10.0,right:15.0,
                    top:15.0,bottom: 70.0),
                child:
                Wrap(
                  runSpacing: 5,
                  alignment: WrapAlignment.spaceBetween,
                  children: List.generate(5, (index) => index).map((item) {
                    return buildListViewItemProd(context);
                  }).toList(),
                )
              //           )
              // ],
            ),
            builder: (_, collapsed, expanded) {
              // return Padding(
              //   padding: EdgeInsets.only(left: 5, right: 5,),
              //   child:
              return Expandable(
                collapsed: collapsed,
                expanded: expanded,
                theme: const ExpandableThemeData(crossFadePoint: 0),
                // ),
              );
            },
          ),
        ),
        //   ],
        // ),
      ),
      // )
    );
  }
}

class Card2 extends StatelessWidget {

  var loremIpsum =
      "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.";

  @override
  Widget build(BuildContext context) {
    buildImg(Color color, double height) {
      return SizedBox(
          height: height,
          child: Container(
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.rectangle,
            ),
          ));
    }

    buildCollapsed1() {
      return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Expandable",
                    style: Theme.of(context).textTheme.body1,
                  ),
                ],
              ),
            ),
          ]);
    }

    buildCollapsed2() {
      return buildImg(Colors.lightGreenAccent, 150);
    }

    buildCollapsed3() {
      return Container();
    }

    buildExpanded1() {
      return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Expandable",
                    style: Theme.of(context).textTheme.body1,
                  ),
                  Text(
                    "3 Expandable widgets",
                    style: Theme.of(context).textTheme.caption,
                  ),
                ],
              ),
            ),
          ]);
    }

    buildExpanded2() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(child: buildImg(Colors.lightGreenAccent, 100)),
              Expanded(child: buildImg(Colors.orange, 100)),
            ],
          ),
          Row(
            children: <Widget>[
              Expanded(child: buildImg(Colors.lightBlue, 100)),
              Expanded(child: buildImg(Colors.cyan, 100)),
            ],
          ),
        ],
      );
    }

    buildExpanded3() {
      return Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              loremIpsum,
              softWrap: true,
            ),
          ],
        ),
      );
    }

    return ExpandableNotifier(
        child: Padding(
          padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
          child: ScrollOnExpand(
            child: Card(
              clipBehavior: Clip.antiAlias,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expandable(
                    collapsed: buildCollapsed1(),
                    expanded: buildExpanded1(),
                  ),
                  Expandable(
                    collapsed: buildCollapsed2(),
                    expanded: buildExpanded2(),
                  ),
                  Expandable(
                    collapsed: buildCollapsed3(),
                    expanded: buildExpanded3(),
                  ),
                  Divider(
                    height: 1,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Builder(
                        builder: (context) {
                          var controller =
                          ExpandableController.of(context, required: true);
                          return TextButton(
                            child: Text(
                              controller.expanded ? "COLLAPSE" : "EXPAND",
                              style: Theme.of(context)
                                  .textTheme
                                  .button
                                  .copyWith(color: Colors.deepPurple),
                            ),
                            onPressed: () {
                              controller.toggle();
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}



//updated one
// import 'dart:convert';
//
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:expandable/expandable.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
// import 'package:orderly/Api/api.dart';
// import 'package:orderly/Blocs/authentication/authentication_event.dart';
// import 'package:orderly/Blocs/home/home_bloc.dart';
// import 'package:orderly/Blocs/home/home_event.dart';
// import 'package:orderly/Blocs/home/home_state.dart';
// import 'package:orderly/Configs/image.dart';
// import 'package:orderly/Configs/theme.dart';
// import 'package:orderly/Models/model_producer_list.dart';
// import 'package:orderly/Models/model_product_List.dart';
// import 'package:orderly/Models/model_scoped_cart.dart';
// import 'package:orderly/Models/model_view_cart.dart';
// import 'package:orderly/Screens/Customer/cart/shopping_cart.dart';
// import 'package:orderly/Utils/application.dart';
// import 'package:orderly/Utils/connectivity_check.dart';
// import 'package:orderly/Utils/preferences.dart';
// import 'package:orderly/Utils/progressDialog.dart';
// import 'package:orderly/Utils/routes.dart';
// import 'package:orderly/Utils/translate.dart';
// import 'package:orderly/Utils/util_preferences.dart';
// import 'package:orderly/Widgets/app_dialogs.dart';
// import 'package:orderly/app_bloc.dart';
// import 'package:pull_to_refresh/pull_to_refresh.dart';
// import 'package:scoped_model/scoped_model.dart';
// import 'package:shimmer/shimmer.dart';
// import 'package:http/http.dart' as http;
//
//
// class Producers extends StatefulWidget {
//   CartModel model;
//
//   Producers({Key key, @required this.model}) : super(key: key);
//
//   _ProducersState createState() => _ProducersState();
// }
//
// class _ProducersState extends State<Producers> {
//   bool isExpand = false;
//   List<Producer> _producerList;
//   List<Product> _productList, totalProductList;
//
//   bool isconnectedToInternet = false;
//   String type = "ALL";
//   HomeBloc _homeBloc;
//   bool flagDataNotAvailable = false;
//   CartModel cartModel;
//   PagingController<int, Product> _pagingController;
//   int _pageSize;
//   int offset = 0,
//       producerListIndex = 0;
//   final _controller = RefreshController(initialRefresh: false);
//   final _scaffoldKey = new GlobalKey<ScaffoldState>();
//
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     isExpand = false;
//     cartModel = new CartModel();
//     _homeBloc = BlocProvider.of<HomeBloc>(context);
//     totalProductList = [];
//     paginationCall(_producerList);
//     getData();
//   }
//
//   void paginationCall(List<Producer> producerList) {
//     _pageSize = 10;
//     _pagingController = PagingController(firstPageKey: 0);
//     //updated on 15/11/2021 for pagination
//     _pagingController.addPageRequestListener((pageKey) {
//       offset = pageKey;
//       print("pageKey:-" + pageKey.toString());
//       _homeBloc.add(OnLoadingProductList(
//         producerId: producerList[producerListIndex].producerId.toString(),
//         type: type,
//         offset: offset.toString(),
//       ));
//     });
//   }
//
//   void getData() {
//     final String cartString = UtilPreferences.getString(Preferences.cart);
//     if (cartString != null) {
//       var _cart = jsonDecode(cartString).toList();
//       List<dynamic> _cartList = _cart.map((cartJson) => Cart.fromJson(cartJson))
//           .toList();
//       cartModel.addAllProduct(_cartList.cast<Cart>());
//       Application.cartModel = cartModel;
//       print(_cartList);
//     }
//     setBlocData();
//   }
//
//
//   void setBlocData() async {
//     isconnectedToInternet = await ConnectivityCheck.checkInternetConnectivity();
//     if (isconnectedToInternet == true) {
//       _homeBloc.add(OnLoadingProducerList());
//     } else {
//       CustomDialogs.showDialogCustom(
//           "Internet", "Please check your Internet Connection!", context);
//     }
//   }
//
//   ///On Refresh List
//   Future<void> _onRefresh() async {
//     _producerList = null;
//     totalProductList = [];
//     offset = 0;
//     _pageSize = 10;
//     await Future.delayed(Duration(milliseconds: 1000));
//     setBlocData();
//     _controller.refreshCompleted();
//   }
//
//   Future<void> AddedToCart(CartModel model, String producerId, String productId,
//       String qty, String price) async {
//     Map<String, String> params = {
//       'producer_id': producerId,
//       'product_id': productId,
//       'user_id': Application.user.fbId,
//       'qty': qty,
//       'rate_per_hour': price
//     };
//
//     var response = await http.post(Uri.parse(Api.ADD_TO_CART),
//       body: params,
//     );
//
//     try {
//       if (response.statusCode == 200) {
//         var resp = json.decode(response.body);
//         if (resp['msg'] == "Successed") {
//           final Iterable refactorCategory = resp['cart'] ?? [];
//           final listCategory = refactorCategory.map((item) {
//             return Cart.fromJson(item);
//           }).toList();
//           // //
//           model.addProduct(listCategory[0]);
//           AppBloc.authBloc.add(OnSaveCart(model));
//           //for offline db
//           // OrderlyDatabase.database.add(listCategory[0]);
//           // print(OrderlyDatabase.database.toString());
//           if (model != null) {
//             Navigator.push(context, MaterialPageRoute(builder: (context) =>
//                 ShoppingCart(price: price, cartModel: model)));
//           }
//         } else {
//           print('exists');
//           Navigator.push(context, MaterialPageRoute(builder: (context) =>
//               ShoppingCart(price: price, cartModel: model)));
//         }
//         // await PsProgressDialog.showProgressWithoutMsg(context);
//       }
//     } catch (e) {
//       print(e);
//     }
//   }
//
//   Widget buildCategory(List<Producer> producerList) {
//     if (producerList == null) {
//       return ListView.builder(
//         scrollDirection: Axis.vertical,
//         padding: EdgeInsets.only(left: 5, right: 20, top: 10, bottom: 15),
//         itemBuilder: (context, index) {
//           return Shimmer.fromColors(
//             baseColor: Theme.of(context).hoverColor,
//             highlightColor: Theme.of(context).highlightColor,
//             enabled: true,
//             child: Container(
//               width: MediaQuery.of(context).size.width * 0.21,
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: <Widget>[
//                   Container(
//                     width: 50,
//                     height: 50,
//                     alignment: Alignment.center,
//                     decoration: BoxDecoration(
//                       shape: BoxShape.circle,
//                       color: Colors.white,
//                     ),
//                   ),
//                   Padding(
//                     padding: EdgeInsets.only(top: 3),
//                     child: Text(
//                       Translate.of(context).translate('loading'),
//                       style: Theme.of(context)
//                           .textTheme
//                           .caption
//                           .copyWith(fontWeight: FontWeight.bold),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           );
//         },
//         itemCount: List.generate(8, (index) => index).length,
//       );
//     }
//
//     return ListView.builder(
//       scrollDirection: Axis.vertical,
//       padding: EdgeInsets.only(left: 5, right: 20, top: 10, bottom: 15),
//       itemBuilder: (context, index) {
//         final item = producerList[index];
//         return Padding(
//             padding: EdgeInsets.only(left: 15),
//             child:
//             GestureDetector(
//                 onTap: () async{
//                   print('clicked category');
//                   // WidgetsBinding.instance.addPostFrameCallback((_)
//                   //     {
//                   //       if(mounted) {
//                   //         setState(() {
//                   offset=0;
//                   totalProductList=[];
//                   producerListIndex = index;
//                   type = index == 0 ? "ALL" : "";
//                   flagDataNotAvailable = false;
//                   // });
//                   paginationCall(producerList);
//                   _homeBloc.add(OnLoadingProductList(
//                       producerId: producerList[producerListIndex]
//                           .producerId
//                           .toString(),
//                       type: type,
//                       offset: offset.toString()));
//                   },
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   children: [
//                     CachedNetworkImage(
//                       imageUrl: item.producerIconUrl,
//                       imageBuilder: (context, imageProvider) {
//                         return Container(
//                           height: 70.0,
//                           width: 70.0,
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.all(
//                               Radius.circular(35),
//                             ),
//                             image: DecorationImage(
//                               image: imageProvider,
//                               fit: BoxFit.cover,
//                             ),
//                           ),
//                           child: Container(
//                             padding: EdgeInsets.all(8),
//                           ),
//                         );
//                       },
//                       placeholder: (context, url) {
//                         return Shimmer.fromColors(
//                           baseColor: Theme.of(context).hoverColor,
//                           highlightColor: Theme.of(context).highlightColor,
//                           enabled: true,
//                           child: Container(
//                             height: 70.0,
//                             width: 70.0,
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.all(
//                                 Radius.circular(35),
//                               ),
//                             ),
//                           ),
//                         );
//                       },
//                       errorWidget: (context, url, error) {
//                         return Shimmer.fromColors(
//                           baseColor: Theme.of(context).hoverColor,
//                           highlightColor: Theme.of(context).highlightColor,
//                           enabled: true,
//                           child: Container(
//                             height: 70.0,
//                             width: 70.0,
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.all(
//                                 Radius.circular(35),
//                               ),
//                             ),
//                             child: Icon(Icons.error),
//                           ),
//                         );
//                       },
//                     ),
//                     Padding(
//                       padding: EdgeInsets.only(left: 8, right: 8),
//                       child: Text(
//                         item.producerName,
//                         style: TextStyle(
//                             fontFamily: 'Poppins',
//                             fontWeight: FontWeight.w600,
//                             fontSize: 12.0,
//                             color: AppTheme.textColor),
//                       ),
//                     )
//                   ],
//                 )));
//       },
//       itemCount: producerList.length,
//     );
//   }
//
//
//   Widget buildListViewItemProd(int index, Product product, CartModel model) {
//     if (product == null) {
//       return FractionallySizedBox(
//           widthFactor: 0.5,
//           child:
//           Container(
//               padding: EdgeInsets.only(left: 8),
//               child: Card(
//                   elevation: 3.0,
//                   shape: RoundedRectangleBorder(),
//                   child: Shimmer.fromColors(
//                     baseColor: Theme
//                         .of(context)
//                         .hoverColor,
//                     highlightColor: Theme
//                         .of(context)
//                         .highlightColor,
//                     enabled: true,
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       children: <Widget>[
//                         Container(
//                           height: 110,
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.zero,
//                             color: Colors.white,
//                           ),
//                         ),
//                         Padding(padding: EdgeInsets.only(top: 3)),
//                         Text(
//                           "Loading",
//                           style: Theme
//                               .of(context)
//                               .textTheme
//                               .caption
//                               .copyWith(
//                               fontWeight: FontWeight.w400,
//                               fontFamily: 'Poppins',
//                               color: AppTheme.textColor),
//                         ),
//                         Padding(padding: EdgeInsets.only(top: 2)),
//                         Text(
//                           "Loading...",
//                           maxLines: 1,
//                           style: Theme
//                               .of(context)
//                               .textTheme
//                               .subtitle2
//                               .copyWith(
//                               fontWeight: FontWeight.w600,
//                               fontFamily: "Poppins",
//                               color: Theme
//                                   .of(context)
//                                   .primaryColor),
//                         ),
//                       ],
//                     ),
//                   ))));
//     }
//     return Container(
//         padding: EdgeInsets.only(left: 8),
//         child: Card(
//           elevation: 3.0,
//           shape: RoundedRectangleBorder(),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             // mainAxisAlignment: MainAxisAlignment.center,
//             children: <Widget>[
//               CachedNetworkImage(
//                 imageUrl: product.productImage,
//                 imageBuilder: (context, imageProvider) {
//                   return Container(
//                     height: 110,
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.zero,
//                       image: DecorationImage(
//                         image: imageProvider,
//                         fit: BoxFit.cover,
//                       ),
//                     ),
//                   );
//                 },
//                 placeholder: (context, url) {
//                   return Shimmer.fromColors(
//                     baseColor: Theme
//                         .of(context)
//                         .hoverColor,
//                     highlightColor: Theme
//                         .of(context)
//                         .highlightColor,
//                     enabled: true,
//                     child: Container(
//                       height: 110,
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.zero,
//                         color: Colors.white,
//                       ),
//                     ),
//                   );
//                 },
//                 errorWidget: (context, url, error) {
//                   return Shimmer.fromColors(
//                     baseColor: Theme
//                         .of(context)
//                         .hoverColor,
//                     highlightColor: Theme
//                         .of(context)
//                         .highlightColor,
//                     enabled: true,
//                     child: Container(
//                       height: 110,
//                       decoration: BoxDecoration(
//                         color: Colors.white,
//                         borderRadius: BorderRadius.zero,
//                       ),
//                       child: Icon(Icons.error),
//                     ),
//                   );
//                 },
//               ),
//               Padding(padding: EdgeInsets.only(top: 3)),
//               Padding(
//                   padding: EdgeInsets.only(left: 10.0, right: 10.0),
//                   child: Text(
//                     product.productName,
//                     style: Theme
//                         .of(context)
//                         .textTheme
//                         .caption
//                         .copyWith(
//                         fontWeight: FontWeight.w400,
//                         fontFamily: 'Poppins',
//                         color: AppTheme.textColor),
//                   )),
//               Padding(padding: EdgeInsets.only(top: 2)),
//               Text(
//                 product.ratePerHour.toString() + " \$/hr",
//                 maxLines: 1,
//                 style: Theme
//                     .of(context)
//                     .textTheme
//                     .subtitle2
//                     .copyWith(
//                     fontWeight: FontWeight.w600,
//                     fontFamily: "Poppins",
//                     color: Theme
//                         .of(context)
//                         .primaryColor),
//               ),
//               //updated on 2/09/2021
//               Padding(
//                   padding: EdgeInsets.all(15.0),
//                   child: SizedBox(
//                       height: 25.0,
//                       width: MediaQuery
//                           .of(context)
//                           .size
//                           .width,
//                       child: ElevatedButton(
//                           style: ElevatedButton.styleFrom(
//                             side: BorderSide(
//                                 color: Theme
//                                     .of(context)
//                                     .primaryColor,
//                                 width: 1),
//                             primary: AppTheme.verifyPhone,
//                             shape: const RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.all(
//                                     Radius.circular(50))),
//                           ),
//                           // shape: shape,
//                           onPressed: () async {
//                             // model.addProduct(_productList[index]);
//                             // Navigator.push(context, MaterialPageRoute(builder: (context)=>ShoppingCart(price:_productList[index].ratePerHour.toString(),cartModel:model)));
//                             if (isconnectedToInternet == true) {
//                               await PsProgressDialog
//                                   .showProgressWithoutMsg(context);
//                               AddedToCart(model,
//                                   _producerList[producerListIndex]
//                                       .producerId.toString(),
//                                   totalProductList[index].productId
//                                       .toString(),
//                                   totalProductList[index].qty
//                                       .toString(),
//                                   totalProductList[index].ratePerHour
//                                       .toString());
//                             } else {
//                               CustomDialogs.showDialogCustom(
//                                   "Internet",
//                                   "Please be online to proceed further!",
//                                   context);
//                             }
//                           },
//                           child: index < 0
//                               ? Center(child: CircularProgressIndicator())
//                               :
//                           Stack(
//                             // mainAxisAlignment: MainAxisAlignment.center,
//                             // crossAxisAlignment: CrossAxisAlignment.center,
//                             children: <Widget>[
//                               Align(
//                                   alignment: Alignment.center,
//                                   child: Text(
//                                     'ADD',
//                                     style: Theme
//                                         .of(context)
//                                         .textTheme
//                                         .button
//                                         .copyWith(
//                                         color: Colors.black,
//                                         fontWeight:
//                                         FontWeight.w500,
//                                         fontSize: 12.0),
//                                   )),
//                               // Align(
//                               //     alignment: Alignment.centerRight,
//                               //     //    child: InkWell(
//                               //     // onTap: (){
//                               //     //   setState(() {
//                               //     //     // flagClickDisableAdd=true;
//                               //     //
//                               //     //   });
//                               //     // },
//                               //     child: Icon(Icons.add,
//                               //         size: 20.0,
//                               //         color: Colors.black)
//                               //   // )
//                               // )
//                             ],
//                           )
//                       )
//                   )
//               )
//
//
//             ],
//           ),
//         ));
//   }
//
//   //for category
//   Widget buildExpandableItems(CartModel model, List<Producer> producerList) {
//     return ExpandableNotifier(
//       child:
//       Container(
//         // clipBehavior: Clip.antiAlias,
//         child:
//         // Column(
//         //   children: <Widget>[
//         //   SizedBox(
//         //   height: 150,
//         //   child:
//         //   Container(
//         //     decoration: BoxDecoration(
//         //       color: Colors.orange,
//         //       shape: BoxShape.rectangle,
//         //     ),
//         //   ),
//         // ),
//         ScrollOnExpand(
//           scrollOnExpand: true,
//           scrollOnCollapse: false,
//           child:
//           ExpandablePanel(
//             theme: const ExpandableThemeData(
//                 headerAlignment: ExpandablePanelHeaderAlignment.bottom,
//                 tapBodyToCollapse: true,
//                 // iconColor: Colors.white,
//                 hasIcon: false //for disability of icon
//             ),
//             header:
//             // Padding(
//             //     padding: EdgeInsets.all(10),
//             //     child: Text(
//             //       "ExpandablePanel",
//             //       style: Theme.of(context).textTheme.body2,
//             //     )),
//
//             // SizedBox(
//             //   height: 200,
//             //   child:
//             //   Container(
//             //     decoration: BoxDecoration(
//             //       color: Colors.white,
//             //       shape: BoxShape.rectangle,
//             //
//             //     ),
//             //     child: Image.asset(Images.truckFull, fit: BoxFit.fill,),
//             //
//             //   ),
//             // ),
//             buildCategory(producerList),
//             collapsed:
//             Text(
//               "",
//               // softWrap: true,
//               // maxLines: 1,
//               // overflow: TextOverflow.ellipsis,
//             ),
//
//             expanded:
//             flagDataNotAvailable == false
//                 ?
//             Container(
//               height: MediaQuery.of(context).size.height,
//                 child:
//
//                 _productList != null
//                     ?
//                     Padding(
//                       padding: EdgeInsets.only(top:10.0,bottom: 120.0),
//                       child:
//
//                 PagedGridView<int, Product>(
//                   showNewPageProgressIndicatorAsGridChild: false,
//                   showNewPageErrorIndicatorAsGridChild: false,
//                   showNoMoreItemsIndicatorAsGridChild: false,
//                   pagingController: _pagingController,
//                   gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                     childAspectRatio: 80 / 90,
//                     crossAxisSpacing: 10,
//                     mainAxisSpacing: 10,
//                     crossAxisCount: 2,
//                   ),
//                   builderDelegate: PagedChildBuilderDelegate<Product>(
//                       itemBuilder: (context, item, index) =>
//                           buildListViewItemProd(index, item, model)
//                     //     CharacterUpdatedScreen(
//                     //   character: item,
//                     // ),
//                   )),
//                 )
//                     :
//                 Center(child: CircularProgressIndicator())
//               // Wrap(
//               //   runSpacing: 10,
//               //   alignment:
//               //   WrapAlignment.spaceBetween,
//               //   children: List.generate(
//               //       6, (index) => index).map((item) {
//               //             return buildListViewItemProd(
//               //                 item, null,model);
//               //           }).toList(),
//               // ))
//             )
//                 :
//             Center(
//               child: Padding(
//                   padding:
//                   EdgeInsets.only(top: 100.0),
//                   child: Text(
//                     "No Data Available",
//                     style: TextStyle(
//                         fontFamily: 'Poppins',
//                         fontWeight: FontWeight.w600,
//                         fontSize: 16.0,
//                         color: AppTheme.textColor),
//                   )),
//             ),
//
//             builder: (_, collapsed, expanded) {
//               // return Padding(
//               //   padding: EdgeInsets.only(left: 5, right: 5,),
//               //   child:
//               return Expandable(
//                 collapsed: collapsed,
//                 expanded: expanded,
//                 theme: const ExpandableThemeData(crossFadePoint: 0),
//                 // ),
//               );
//             },
//           ),
//         ),
//         //   ],
//         // ),
//       ),
//       // )
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     // TODO: implement build
//     return Scaffold(
//         key: _scaffoldKey,
//         body:
//         BlocListener<HomeBloc, HomeState>(listener: (context, state)
//     {
//       if (state is ProducerListLoadFail) {}
//     }, child:
//     BlocBuilder<HomeBloc, HomeState>(builder: (context, state) {
//
//     if (state is ProducerListSuccess) {
//     // _producerList = state.producerList;
//     // offset=0;
//     // paginationCall(_producerList);
//     // _homeBloc.add(OnLoadingProductList(
//     // producerId:
//     // _producerList[producerListIndex].producerId.toString(),
//     // type: type,
//     // offset: offset.toString()));
//     }
//
//     if (state is ProductListSuccess) {
//     if(_productList==null){
//     _productList = state.productList;
//     totalProductList.addAll(_productList);
//     if (_productList.length>0 ) {
//     //for pagination
//     final isLastPage = _productList.length < _pageSize;
//     if (isLastPage) {
//     _pagingController.appendLastPage(_productList);
//     } else {
//     final nextPageKey = offset + _productList.length;
//     _pagingController.appendPage(_productList, nextPageKey);
//     }
//     }else {
//     flagDataNotAvailable = true;
//     }
//     }else{
//     _onRefresh();
//     }
//     }
//
//     if(state is ProductLoading){
//     _productList=null;
//     }
//
//     //for addto cart
//     if(state is AddToCartSuccess){
//
//     Navigator.pushNamed(context, Routes.cart);
//     }
//     return
//     ScopedModel<CartModel>(
//     model:cartModel,
//     child:ScopedModelDescendant<CartModel>(
//     builder: (context, child, model) {
//     return SafeArea(
//
//     child:
//     SmartRefresher(
//     enablePullDown: true,
//     onRefresh: _onRefresh,
//     controller: _controller,
//     child:
//     ExpandableTheme(
//     data: const ExpandableThemeData(
//     iconColor: Colors.blue,
//     useInkWell: true,
//     ),
//     child:
//     ListView.builder(
//     scrollDirection: Axis.vertical,
//     padding: EdgeInsets.only( top: 10,),
//     itemBuilder: (context, index) {
//     //for producer category
//     //  return ExpandableItems();
//     return buildExpandableItems(model,_producerList);
//     },
//     itemCount: 10,
//     )
//
//     ),
//
//
//     )
//     );
//     }));
//
//
//     })
//     ));
//   }
//
// }
//
