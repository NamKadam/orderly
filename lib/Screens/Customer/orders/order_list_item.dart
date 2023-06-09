import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:orderly/Api/api.dart';
import 'package:orderly/Configs/image.dart';
import 'package:orderly/Configs/theme.dart';
import 'package:orderly/Models/Invoice/customer.dart';
import 'package:orderly/Models/Invoice/invoice.dart';
import 'package:orderly/Models/Invoice/supplier.dart';
import 'package:orderly/Models/model_invoice.dart';
import 'package:orderly/Models/model_myOrders.dart';
import 'package:orderly/Screens/Customer/orders/order_detail.dart';
import 'package:orderly/Screens/Customer/orders/product_review.dart';
import 'package:orderly/Screens/Customer/orders/track_order.dart';
import 'package:orderly/Screens/Customer/orders/track_order.dart';
import 'package:orderly/Screens/Customer/payment/payment.dart';
import 'package:orderly/Utils/Utils.dart';
import 'package:orderly/Utils/application.dart';
import 'package:orderly/Utils/connectivity_check.dart';
import 'package:orderly/Utils/translate.dart';
import 'package:orderly/Widgets/app_dialogs.dart';
import 'package:orderly/Widgets/pdf_api.dart';
import 'package:orderly/Widgets/pdf_invoice_api.dart';
import 'package:readmore/readmore.dart';
import 'package:shimmer/shimmer.dart';
import 'package:http/http.dart' as http;


class OrderListItem extends StatefulWidget{

  List<Orders> orderList;
  int position;
  OrderListItem({Key key,@required this.orderList,@required this.position}):super(key: key);
  _OrderListItemState createState()=>_OrderListItemState();
}



class _OrderListItemState extends State<OrderListItem>{

  var date;
  bool isconnectedToInternet = false;
  List<InvoiceData> mArraylistInvoice=[];
  InvoiceDetails invoiceDet;
  var invoice;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // convertDate(widget.orderList[widget.position].orderDate);
  }

  // void getDownloadInvoice() async {
  //   isconnectedToInternet = await ConnectivityCheck.checkInternetConnectivity();
  //   if (isconnectedToInternet == true) {
  //     Map<String, String> params = {
  //       'order_number': widget.orderList[widget.position].orderNumber
  //     };
  //     var response = await http.post(
  //       Uri.parse(Api.INVOICE),
  //       body: params,
  //     );
  //     try {
  //       if (response.statusCode == 200) {
  //         final resp = json.decode(response.body);
  //         final InvoiceResp invoiceResp = InvoiceResp.fromJson(resp);
  //         final Iterable refactorCategory = invoiceResp.invoiceDetails
  //             .invoiceData ?? [];
  //           invoiceDet=invoiceResp.invoiceDetails;
  //           mArraylistInvoice=refactorCategory.toList();
  //           invoice=Invoice(
  //             // supplier: Supplier(
  //             //   name: "dfdfdf",
  //             //   address: "dfdfdf",
  //             // ),
  //               customer: Customer(
  //                 name: Application.user.firstName+" "+Application.user.lastName,
  //                 address: Application.user.address,
  //               ),
  //               info: InvoiceInfo(
  //                   number: invoiceDet.invoiceNumber,
  //                   totalAmt: invoiceDet.totalAmount,
  //                   date: invoiceDet.orderDate
  //               ),
  //
  //               items: mArraylistInvoice
  //
  //           );
  //
  //         final pdfFile = await PdfInvoiceApi.generate(invoice);
  //         print(pdfFile);
  //         PdfApi.openFile(pdfFile);
  //
  //       }
  //     } catch (e) {
  //       print(e);
  //     }
  //   }else{
  //     CustomDialogs.showDialogCustom(
  //         "Internet", "Please check your Internet Connection!", context);
  //   }
  // }


  void convertDate(String orderDate){
    // print(new DateFormat('yyyy/MM/dd').parse('2020/04/03')); // 2020-04-03 00:00:00.000
    print(DateTime.parse('2021-09-25T13:16:36.000Z')); // 2020-01-02 07:12:50.000Z

    var date = new DateFormat('yyyy/MM/dd').parse('2020/04/03');
    // var dateTime = DateTime.parse('2021-09-25T13:16:36.000Z');
    date = DateTime.parse(orderDate);
    print(date.toString()); // prints something like 2019-12-10 10:02:22.287949
    // print(DateFormat('EEEE').format(date)); // prints Tuesday
    print(DateFormat('EEEE, d MMM, yyyy').format(date)); // prints Tuesday, 10 Dec, 2019
    print(DateFormat('h:mm a').format(date));
  }

  @override
  Widget build(BuildContext context) {
    String StatusName="";

    Widget getTextStatus(int currentStatus){
      if(widget.orderList[widget.position].currentStatus==0){
        StatusName="Order Pending";
      }
      else if(widget.orderList[widget.position].currentStatus==1)
      {
        StatusName="Order Accepted";
      }else if(widget.orderList[widget.position].currentStatus==2){
        StatusName="Order Shipped";
      }else if(widget.orderList[widget.position].currentStatus==3){
        StatusName="Order Delivered";
      }
      else if(widget.orderList[widget.position].currentStatus==4){
        StatusName="Order Returned";
      }
      else if(widget.orderList[widget.position].currentStatus==5){
        StatusName="Order Replaced";

      }else if(widget.orderList[widget.position].currentStatus==6)
        {
          StatusName="Order Cancelled";
        }
      else if(widget.orderList[widget.position].currentStatus==7){
        StatusName="Order Return Confirmed";
      }
      else if(widget.orderList[widget.position].currentStatus==8){
        StatusName="Order Return Rejected";
      } else if(widget.orderList[widget.position].currentStatus==9){
        StatusName="Order Return Shipped";
      }else if(widget.orderList[widget.position].currentStatus==10){
        StatusName="Order Return Delivered";
      }
      else if(widget.orderList[widget.position].currentStatus==11){
        StatusName="Order Replace Confirmed";
      } else if(widget.orderList[widget.position].currentStatus==12){
        StatusName="Order Replace Rejected";
      }else if(widget.orderList[widget.position].currentStatus==13){
        StatusName="Order Replace Shipped";
      }else if(widget.orderList[widget.position].currentStatus==14){
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

    // TODO: implement build
    if(widget.orderList==null){
      return ListView.builder(
          padding: EdgeInsets.all(0),
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            return Padding(
              padding: EdgeInsets.only(bottom: 15),
              child:
              Shimmer.fromColors(
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
          itemCount: 6,
        );
    }

    return Padding(
      padding: const EdgeInsets.only(
        top: 10,
      ),
      child:
     Container(
       color: Colors.white,
       child: Column(
         children: [
           Padding(padding: EdgeInsets.only(left:20.0,right:20.0,top:10.0,bottom: 5.0),
          child:
               Row(
             mainAxisAlignment: MainAxisAlignment.spaceBetween,
             children: [
              getTextStatus(widget.orderList[widget.position].currentStatus),
               //date text
               Text(
                 "On "+DateFormat('EEEE, d MMM, yyyy').format(DateTime.parse(widget.orderList[widget.position].orderDate)),
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
                        Padding(
                            padding: EdgeInsets.all(10.0),
                            child:
                            GestureDetector(
                              onTap: (){
                                if (widget.orderList[widget.position].currentStatus != 6
                                    && widget.orderList[widget.position].currentStatus != 8 &&
                                    widget.orderList[widget.position].currentStatus != 12) {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                          new CustOrderDetail(
                                              orderData:
                                              widget.orderList[
                                              widget.position])));
                                }
                              },
                                child:
                                Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CachedNetworkImage(
                                  filterQuality: FilterQuality.medium,
                                  // imageUrl: Api.PHOTO_URL + widget.users.avatar,
                                  // imageUrl:"https://images.unsplash.com/photo-1438761681033-6461ffad8d80?ixid=MXwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=1050&q=80",
                                  imageUrl: widget.orderList[widget.position].imgPaths == null
                                      ? "https://images.unsplash.com/photo-1438761681033-6461ffad8d80?ixid=MXwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=1050&q=80"
                                      : widget.orderList[widget.position].imgPaths,
                                  placeholder: (context, url) {
                                    return Shimmer.fromColors(
                                      baseColor: Theme.of(context).hoverColor,
                                      highlightColor: Theme.of(context).highlightColor,
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
                                      highlightColor: Theme.of(context).highlightColor,
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
                                    child:
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          widget.orderList[widget.position].productName,
                                          // widget.users.firstName+" "+widget.users.lastName,
                                          style: Theme.of(context).textTheme.caption.copyWith(
                                              fontSize: 14.0,
                                              fontWeight: FontWeight.w500,
                                              color: AppTheme.appColor,
                                              fontFamily: "Poppins"),
                                        ),

                                        ReadMoreText(
                                          widget.orderList[widget.position].productDesc,
                                          style: Theme.of(context).textTheme.button.copyWith(
                                              fontSize: 12.0,
                                              color: AppTheme.textColor,
                                              fontWeight: FontWeight.w600,
                                              fontFamily: "Poppins"),
                                          trimLines: 2,
                                          trimMode: TrimMode.Line,
                                          trimCollapsedText: 'Show more',
                                          trimExpandedText: 'Show less',
                                        ),
                                       SizedBox(height: 5.0,),

                                        Text(
                                         "Quantity: "+widget.orderList[widget.position].qty.toString(),
                                          style: Theme.of(context).textTheme.button.copyWith(
                                              fontSize: 12.0,
                                              color: AppTheme.textColor,
                                              fontWeight: FontWeight.w400,
                                              fontFamily: "Poppins"),
                                        ),
                                      ],
                                    )),
                                 ],
                            ))),
                        widget.orderList[widget.position].currentStatus!=6 &&
                            widget.orderList[widget.position].currentStatus!=8
                        && widget.orderList[widget.position].currentStatus!=12
                        ?
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Divider(
                              height: 1.0,
                              color: Colors.grey,
                            ),
                            //product review
                            if(widget.orderList[widget.position].currentStatus==3 ||
                                widget.orderList[widget.position].currentStatus==10 ||
                                widget.orderList[widget.position].currentStatus==14)
                            Column(
                              children: [
                                GestureDetector(
                                    onTap: (){
                                      Navigator.push(context, MaterialPageRoute(builder: (context)=>ProductReview(
                                          order:widget.orderList[widget.position]
                                      )));
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
                              ],
                            ),

                            //track order
                            GestureDetector(
                                onTap: (){
                                  Navigator.push(context, MaterialPageRoute(builder: (context)=>
                                      TrackOrderUpdated(orderData:widget.orderList[widget.position])));

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

                            //download invoice
                            if(widget.orderList[widget.position].currentStatus==3 ||
                                widget.orderList[widget.position].currentStatus==10 ||
                                widget.orderList[widget.position].currentStatus==14)
                            GestureDetector(
                              onTap: () async{
                                Invoice invoice=await Utils.getDownloadInvoice(widget.orderList[widget.position].orderNumber);
                                final pdfFile = await PdfInvoiceApi.generate(invoice);
                                print(pdfFile);
                                PdfApi.openFile(pdfFile);
                              },
                              child:
                            Column(
                              children: [
                                Divider(
                                  height: 1.0,
                                  color: Colors.grey,
                                ),


                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Padding(
                                          padding: EdgeInsets.only(left:15.0),
                                          child:Text(Translate.of(context).translate( 'invoice'),style: TextStyle(fontWeight:FontWeight.w400,
                                              fontFamily: 'Poppins',color: AppTheme.textColor),
                                          )),

                                      IconButton(
                                        // onPressed: ()
                                      // async {
                                      //   // final date = DateTime.now();
                                      //   // getDownloadInvoice();
                                      //   Invoice invoice=await Utils.getDownloadInvoice(widget.orderList[widget.position].orderNumber);
                                      //   final pdfFile = await PdfInvoiceApi.generate(invoice);
                                      //   print(pdfFile);
                                      //   PdfApi.openFile(pdfFile);
                                      //
                                      //
                                      // },
                                          icon: Image.asset(Images.arrow,height: 15.0,width:15.0)

                                      )
                                    ],
                                  ),
                              ],
                            ))
                          ],
                        )
                            :Container()

                      ],
                    )

                ),
              ),
             )
           ),
         ],
       )
     )
    );

  }
  
}