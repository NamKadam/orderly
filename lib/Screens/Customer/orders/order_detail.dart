import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:orderly/Configs/image.dart';
import 'package:orderly/Configs/theme.dart';
import 'package:orderly/Models/Invoice/invoice.dart';
import 'package:orderly/Models/model_myOrders.dart';
import 'package:orderly/Screens/Customer/orders/product_review.dart';
import 'package:orderly/Screens/Customer/orders/return_replace.dart';
import 'package:orderly/Screens/Customer/orders/track_order.dart';
import 'package:orderly/Screens/Customer/orders/track_order.dart';
import 'package:orderly/Screens/mainNavigation.dart';
import 'package:orderly/Utils/Utils.dart';
import 'package:orderly/Utils/translate.dart';
import 'package:orderly/Widgets/app_button.dart';
import 'package:orderly/Widgets/pdf_api.dart';
import 'package:orderly/Widgets/pdf_invoice_api.dart';
import 'package:readmore/readmore.dart';
import 'package:shimmer/shimmer.dart';

class CustOrderDetail extends StatefulWidget{
  Orders orderData;
  CustOrderDetail({Key key,@required this.orderData}):super(key: key);

  _CustOrderDetailState createState()=> _CustOrderDetailState();
}

class _CustOrderDetailState extends State<CustOrderDetail>{
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  String StatusName="";

  Widget getTextStatus(int currentStatus){
    if(widget.orderData.currentStatus==0){
      StatusName="Order Pending";
    }
    else if(widget.orderData.currentStatus==1)
    {
      StatusName="Order Accepted";
    }else if(widget.orderData.currentStatus==2){
      StatusName="Order Shipped";
    }else if(widget.orderData.currentStatus==3){
      StatusName="Order Delivered";
    }
    else if(widget.orderData.currentStatus==4){
      StatusName="Order Returned";
    }
    else if(widget.orderData.currentStatus==5){
      StatusName="Order Replaced";

    }else if(widget.orderData.currentStatus==6)
    {
      StatusName="Order Cancelled";
    }
    else if(widget.orderData.currentStatus==7){
      StatusName="Order Return Confirmed";
    }
    else if(widget.orderData.currentStatus==8){
      StatusName="Order Return Rejected";
    } else if(widget.orderData.currentStatus==9){
      StatusName="Order Return Shipped";
    }else if(widget.orderData.currentStatus==10){
      StatusName="Order Return Delivered";
    }
    else if(widget.orderData.currentStatus==11){
      StatusName="Order Replace Confirmed";
    } else if(widget.orderData.currentStatus==12){
      StatusName="Order Replace Rejected";
    }else if(widget.orderData.currentStatus==13){
      StatusName="Order Replace Shipped";
    }else if(widget.orderData.currentStatus==14){
      StatusName="Order Replace Delivered";
    }

    return  Text(
      StatusName,
      style: TextStyle(
          fontWeight: FontWeight.w600,
          fontFamily: 'Poppins',
          fontSize: 14.0,
          color: Theme.of(context).primaryColor
      ),
    );
  }


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
                            getTextStatus(widget.orderData.currentStatus),
                            //date text
                            Text(
                              'On '+DateFormat('EEEE, d MMM, yyyy').format(DateTime.parse(widget.orderData.orderDate)),
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
                                          Navigator.push(context, MaterialPageRoute(builder: (context)=>ProductReview(order:widget.orderData)));
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
                                          Navigator.push(context, MaterialPageRoute(builder: (context)=>TrackOrderUpdated(orderData: widget.orderData)));
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
                                    if(widget.orderData.currentStatus==3 ||
                                        widget.orderData.currentStatus==10 ||
                                        widget.orderData.currentStatus==14)
                                    Column(
                                      children: [
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
                                              IconButton(onPressed: () async{
                                                Invoice invoice=await Utils.getDownloadInvoice(widget.orderData.orderNumber);
                                                final pdfFile = await PdfInvoiceApi.generate(invoice);
                                                print(pdfFile);
                                                PdfApi.openFile(pdfFile);
                                              },
                                                  icon: Image.asset(Images.arrow,height: 15.0,width:15.0)

                                              )
                                            ],
                                          ),
                                      ],
                                    )
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
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>ReturnReplace(orderData: widget.orderData,)));
                    },
                    child:
                    // widget.orderData.currentStatus!=4&& widget.orderData.currentStatus!=5 && widget.orderData.currentStatus!=7
                    //     && widget.orderData.currentStatus!=9 && widget.orderData.currentStatus!=10 && widget.orderData.currentStatus!=11
                    //     && widget.orderData.currentStatus!=13 && widget.orderData.currentStatus!=14
                    widget.orderData.currentStatus==3 || widget.orderData.currentStatus==10 || widget.orderData.currentStatus==14


                        ?
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
                            mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                Translate.of(context).translate('return_replace'),
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
                        ))
                :
                Container()))),
             //continue shopping
            Padding(
              padding: EdgeInsets.only(top: 35.0,left: 20.0,right: 20.0),
                child:AppButton(
              onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>
                MainNavigation()));
              },
              text: 'Continue Shopping',
              disableTouchWhenLoading: false,
                ))
          ],
        ),
      ),
    );
  }

}