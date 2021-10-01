import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:orderly/Configs/image.dart';
import 'package:orderly/Configs/theme.dart';
import 'package:orderly/Screens/Customer/orders/product_review.dart';
import 'package:orderly/Screens/Customer/orders/return_replace.dart';
import 'package:orderly/Screens/Customer/orders/track_order.dart';
import 'package:orderly/Utils/translate.dart';
import 'package:orderly/Widgets/app_button.dart';
import 'package:shimmer/shimmer.dart';

class OrderDetail extends StatefulWidget{
  _OrderDetailState createState()=> _OrderDetailState();
}

class _OrderDetailState extends State<OrderDetail>{
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  children: [
                    CachedNetworkImage(
                      filterQuality: FilterQuality.medium,
                      // imageUrl: Api.PHOTO_URL + widget.users.avatar,
                      imageUrl:
                          "https://images.unsplash.com/photo-1438761681033-6461ffad8d80?ixid=MXwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=1050&q=80",
                      // imageUrl: model.cart[index].productImg == null
                      //     ? "https://images.unsplash.com/photo-1438761681033-6461ffad8d80?ixid=MXwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=1050&q=80"
                      //     : model.cart[index].productImg,
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
                              "Producer one",
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
                              "50 tonnes",
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
                             "Quantity: 05",
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
            SizedBox(height: 5.0,),
            //for order info
            Container(
                color: Colors.white,
                child: Column(
                  children: [
                    Padding(padding: EdgeInsets.only(left:20.0,right:20.0,top:10.0,bottom: 5.0),
                        child:
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Order Accepted',
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'Poppins',
                                  fontSize: 14.0,
                                  color: Theme.of(context).primaryColor
                              ),
                            ),
                            //date text
                            Text(
                              'On Thu,8 July 2021',
                              style: TextStyle(
                                  fontWeight: FontWeight.w300,
                                  fontFamily: 'Poppins',
                                  fontSize: 12.0,
                                  color: AppTheme.textColor
                              ),
                            )
                          ],
                        )),
                    //for card
                    Padding(padding: EdgeInsets.only(left:15.0,right:15.0,top:10.0,bottom: 10.0),
                        child:
                        Card(
                          elevation: 5.0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              side: BorderSide(
                                color: Colors.white,
                                width: 0.5,
                              )),
                          borderOnForeground: true,
                          child:
                          Container(
                            color: Colors.transparent,
                            child: Card(
                                elevation: 0.0,
                                child:
                                Column(
                                  children: [
                                    //product review
                                    GestureDetector(
                                        onTap: (){
                                          Navigator.push(context, MaterialPageRoute(builder: (context)=>ProductReview()));
                                        },
                                        child:Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Padding(
                                                padding: EdgeInsets.only(left:15.0),
                                                child:Text(Translate.of(context).translate('product_review'),style: TextStyle(fontWeight:FontWeight.w400,
                                                    fontFamily: 'Poppins',color: AppTheme.textColor),
                                                )),

                                            IconButton(
                                                icon: Image.asset(Images.arrow,height: 15.0,width:15.0)

                                            )
                                          ],
                                        )),
                                    Divider(
                                      height: 1.0,
                                      color: Colors.grey,
                                    ),

                                    //track order
                                    GestureDetector(
                                        onTap: (){
                                          Navigator.push(context, MaterialPageRoute(builder: (context)=>TrackOrder()));
                                          // Navigator.push(context, MaterialPageRoute(builder: (context)=>Payment()));
                                        },
                                        child:Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Padding(
                                                padding: EdgeInsets.only(left:15.0),
                                                child:Text(Translate.of(context).translate('track_order'),style: TextStyle(fontWeight:FontWeight.w400,
                                                    fontFamily: 'Poppins',color: AppTheme.textColor),
                                                )),

                                            IconButton(
                                                icon: Image.asset(Images.arrow,height: 15.0,width:15.0)

                                            )
                                          ],
                                        )),
                                    Divider(
                                      height: 1.0,
                                      color: Colors.grey,
                                    ),
                                    //download invoice
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Padding(
                                            padding: EdgeInsets.only(left:15.0),
                                            child:Text(Translate.of(context).translate('invoice'),style: TextStyle(fontWeight:FontWeight.w400,
                                                fontFamily: 'Poppins',color: AppTheme.textColor),
                                            )),

                                        IconButton(onPressed: (){},
                                            icon: Image.asset(Images.arrow,height: 15.0,width:15.0)

                                        )
                                      ],
                                    ),

                                  ],
                                )

                            ),
                          ),
                        )
                    ),



                  ],
                )
            ),
            //return replace
            SizedBox(height: 10.0,),
            //for return replace
            Container(
              color: Colors.white,
                child:Padding(
                  padding: EdgeInsets.all(15.0),
                    child:
                GestureDetector(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>ReturnReplace()));
                    },
                    child: Card(
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
                            mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                Translate.of(context)
                                    .translate('return_replace'),
                                style: TextStyle(
                                    fontSize: 12.0,
                                    fontWeight: FontWeight.w400,
                                    fontFamily: 'Poppins',
                                    color: AppTheme.textColor),
                              ),
                              IconButton(
                                  icon: Image.asset(Images.arrow,
                                      height: 15.0, width: 15.0))
                            ],
                          ),
                        ))))),
             //continue shopping
            Padding(
              padding: EdgeInsets.only(top: 35.0,left: 20.0,right: 20.0),
                child:AppButton(
              onPressed: (){},
              text: 'Continue Shopping',
              disableTouchWhenLoading: false,
            ))
          ],
        ),
      ),
    );
  }

}