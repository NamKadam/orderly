import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:orderly/Configs/image.dart';
import 'package:orderly/Configs/theme.dart';
import 'package:orderly/Models/model_fleetOrder_det.dart';
import 'package:orderly/Models/model_fleet_orders.dart';
import 'package:orderly/Models/model_myOrders.dart';
import 'package:orderly/Screens/Customer/orders/product_review.dart';
import 'package:orderly/Screens/Customer/orders/return_replace.dart';
import 'package:orderly/Screens/Customer/orders/track_order.dart';
import 'package:orderly/Screens/mainNavigation.dart';
import 'package:orderly/Utils/translate.dart';
import 'package:orderly/Widgets/app_button.dart';
import 'package:readmore/readmore.dart';
import 'package:shimmer/shimmer.dart';

class FleetOrderDetRetReplace extends StatefulWidget{
  FleetOrdersDet orderData;
  FleetOrderDetRetReplace({Key key,@required this.orderData}):super(key: key);

  _FleetOrderDetRetReplaceState createState()=> _FleetOrderDetRetReplaceState();
}

class _FleetOrderDetRetReplaceState extends State<FleetOrderDetRetReplace>{
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return WillPopScope( //willpopscope is used for ios part to disable swipe where back button is used
        onWillPop: () async => false,
    child:
      Scaffold(
      key: _scaffoldKey,
      appBar: new AppBar(
        leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(
              Icons.arrow_back_ios,
              color: AppTheme.textColor,
            )),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            //for producer one
            Container(
                color: Colors.white,
                child:
                Padding(
                    padding: EdgeInsets.all(15.0),
                    child:
                    Card(
                        elevation: 5.0,
                        child:
                        Padding(
                            padding: EdgeInsets.all(15.0),
                            child:
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                CachedNetworkImage(
                                  filterQuality: FilterQuality.medium,
                                  // imageUrl: Api.PHOTO_URL + widget.users.avatar,
                                  // imageUrl:
                                  //     "https://images.unsplash.com/photo-1438761681033-6461ffad8d80?ixid=MXwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=1050&q=80",
                                  imageUrl:widget.orderData.imgPaths == null
                                      ? "https://images.unsplash.com/photo-1438761681033-6461ffad8d80?ixid=MXwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=1050&q=80"
                                      : widget.orderData.imgPaths,
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
                                          widget.orderData.productName,
                                          style: Theme.of(context)
                                              .textTheme
                                              .caption
                                              .copyWith(
                                              fontSize: 14.0,
                                              fontWeight: FontWeight.w500,
                                              color: AppTheme.appColor,
                                              fontFamily: "Poppins"),
                                        ),
                                        ReadMoreText(
                                          widget.orderData.productDesc,
                                          trimLines: 2,
                                          trimMode: TrimMode.Line,
                                          trimCollapsedText: 'Show more',
                                          trimExpandedText: 'Show less',
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
                                          widget.orderData.ratePerHour.toString()+" \u{20B9}hr",
                                          style: Theme.of(context)
                                              .textTheme
                                              .button
                                              .copyWith(
                                              fontSize: 12.0,
                                              color: AppTheme.appColor,
                                              fontWeight: FontWeight.w400,
                                              fontFamily: "Poppins"),
                                        ),
                                        Text(
                                          "Quantity: "+widget.orderData.qty.toString(),
                                          style: Theme.of(context)
                                              .textTheme
                                              .button
                                              .copyWith(
                                              fontSize: 12.0,
                                              color: AppTheme.textColor,
                                              fontWeight: FontWeight.w300,
                                              fontFamily: "Poppins"),
                                        ),


                                      ],
                                    )),
                              ],
                            ))))),
            SizedBox(height: 10.0,),
            //for type
            Container(
              height: 80.0,
                color: Colors.white,
                child:Padding(
                    padding: EdgeInsets.all(15.0),
                    child:
                    Card(
                        elevation: 5.0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          side: BorderSide(
                            color: Colors.white,
                            width: 0.5,
                          ),
                        ),
                        child:
                        Padding(
                          padding: EdgeInsets.only(left: 10.0, right: 10.0),
                          child:

                          Row(

                            children: [
                              Text(
                                "Order Type :    ",
                                style: TextStyle(
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.w400,
                                    fontFamily: 'Poppins',
                                    color: AppTheme.textColor),
                              ),
                              Text(
                                widget.orderData.returnId==4?"Return":"Replace",
                                style: TextStyle(
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.w400,
                                    fontFamily: 'Poppins',
                                    color: AppTheme.appColor),
                              ),
                            ],
                          ),
                        )))),
            SizedBox(height: 10.0,),

            //for reason
            Container(
                width: MediaQuery.of(context).size.width,
                color: Colors.white,
                child:Padding(
                    padding: EdgeInsets.all(15.0),
                    child:
                    Card(
                        elevation: 5.0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          side: BorderSide(
                            color: Colors.white,
                            width: 0.5,
                          ),
                        ),
                        child:
                        Padding(
                          padding: EdgeInsets.all(12.0),
                          child:
                          Row(
                            children: [
                              Text(
                                "Order Reason : ",
                                style: TextStyle(
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.w400,
                                    fontFamily: 'Poppins',
                                    color: AppTheme.textColor),
                              ),
                              Expanded(child:Text(
                                widget.orderData.returnTitle,
                                style: TextStyle(
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.w400,
                                    fontFamily: 'Poppins',
                                    color: AppTheme.appColor),
                              )),
                            ],
                          ),
                        )))),
            SizedBox(height: 10.0,),

            //for review

            Container(
              // height: widget.orderData.review==""?80:200,
              width: MediaQuery.of(context).size.width,
              color: Colors.white,
              child: Padding(
                padding: EdgeInsets.all(15.0),
                child: Card(
                    elevation: 5.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      side: BorderSide(
                        color: Colors.white,
                        width: 0.5,
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(10.0),
                    child:Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                    ReadMoreText(
                    widget.orderData.review==""?"No reviews found":widget.orderData.review,
                      trimLines: 2,
                      trimMode: TrimMode.Line,
                      trimCollapsedText: 'Show more',
                      trimExpandedText: 'Show less',
                      style: TextStyle(
                          fontSize: 12.0,
                          fontFamily: 'Poppins',
                          color: AppTheme.textColor,
                          fontWeight: FontWeight.w400),

                    )

                      ],
                    )

              ),
              ),
            ),
            )

          ],
        ),
      ),
    ));
  }

}