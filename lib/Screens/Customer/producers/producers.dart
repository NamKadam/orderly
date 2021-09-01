import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:expandable/expandable.dart';
import 'package:orderly/Configs/image.dart';
import 'package:orderly/Configs/theme.dart';
import 'package:orderly/Models/cart_model.dart';
import 'package:shimmer/shimmer.dart';


class Producers extends StatefulWidget{
  CartModel model;

  Producers({Key key, @required this.model}) : super(key: key);

  _ProducersState createState()=>_ProducersState();
}

class _ProducersState extends State<Producers>{
  bool isExpand=false;

  //updated on 10/08/2021 for cart incr and decr
  List<int> selectedIndexList = []; //for selected index
  List<Products> productLists = [];
  List<Products> cartList = []; //added as per total calculate count
  double totalCartValue = 0;
  int quantity=0;

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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isExpand=false;
    // getProducts();
  }

  // void calculateTotal(List<Products> cartList) {
  //   totalCartValue = 0;
  //   quantity=0;
  //   cartList.forEach((f) {
  //     totalCartValue += f.price * f.qty;
  //     quantity+=f.qty;
  //     print('total cart value:-'+totalCartValue.toString());
  //     print('quantity:-'+quantity.toString());
  //   });
  //   setState(() {
  //
  //   });
  //
  // }


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