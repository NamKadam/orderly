import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:orderly/Api/api.dart';
import 'package:orderly/Blocs/myOrders/myOrders_bloc.dart';
import 'package:orderly/Blocs/myOrders/myOrders_event.dart';
import 'package:orderly/Blocs/myOrders/myOrders_state.dart';
import 'package:orderly/Configs/image.dart';
import 'package:orderly/Configs/theme.dart';
import 'package:orderly/Models/model_myOrders.dart';
import 'package:orderly/Models/model_trackOrder.dart';
import 'package:orderly/Screens/Customer/orders/return_replace.dart';
import 'package:orderly/Utils/Utils.dart';
import 'package:orderly/Utils/connectivity_check.dart';
import 'package:orderly/Utils/translate.dart';
import 'package:orderly/Widgets/app_dialogs.dart';
import 'package:orderly/Widgets/timeline_widget.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:readmore/readmore.dart';
import 'package:shimmer/shimmer.dart';
import 'package:http/http.dart' as http;
import 'package:timeline_tile/timeline_tile.dart';


class TrackOrderUpdated extends StatefulWidget{
  Orders orderData;
  TrackOrderUpdated({Key key,@required this.orderData}):super(key: key);

  _TrackOrderUpdatedState createState()=>_TrackOrderUpdatedState();
}

class _TrackOrderUpdatedState extends State<TrackOrderUpdated> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  MyOrdersBloc _myOrdersBloc;
  List<TrackData> _trackOrderList = [];
  List<TrackOrderList> statictrackOrderList = [];
  bool isconnectedToInternet = false;
  final _controller = RefreshController(initialRefresh: false);
  String currentStatus = "";
  bool visibility = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchData();
  }

  void getTrackList(String currentStatus, int size,int lastIndex)
  {
    if(currentStatus==""){ //for original flow
      statictrackOrderList.add(TrackOrderList(
          id: 0, trackStatusName: "Order Pending", orderStatus: 0,isActiveColor: false,date: ""));
      statictrackOrderList.add(TrackOrderList(
          id: 1, trackStatusName: "Order Accepted", orderStatus: 1,isActiveColor: false,date: ""));
      statictrackOrderList.add(TrackOrderList(
          id: 2, trackStatusName: "Order Shipped", orderStatus: 2,isActiveColor: false,date: ""));
      statictrackOrderList.add(TrackOrderList(
          id: 3, trackStatusName: "Order Delivered", orderStatus: 3,isActiveColor: false,date: ""));
      // statictrackOrderList.add(TrackOrderList(
      //   id: 4, trackStatusName: "Order Cancelled", orderStatus: 6,isActiveColor: false,date: ""));

      //for new
      for(int i=0;i<=size;i++){
        statictrackOrderList[i].isActiveColor=true;
        for(int j=0;j<_trackOrderList.length;j++)
          {
            try{
              if(_trackOrderList[j].ohStatus==i.toString()){
                statictrackOrderList[i].date=_trackOrderList[j].orderDate;
              }else{
                statictrackOrderList[i].date=_trackOrderList[0].orderDate;
              }
            }catch(e){
              // statictrackOrderList[i].date="";
              statictrackOrderList[i].date=_trackOrderList[0].orderDate;

            }
          }
      }
    }else if(currentStatus=="4"){ //for return part
      statictrackOrderList.add(TrackOrderList(
          id: 0, trackStatusName: "Return Order Pending", orderStatus: 4,isActiveColor: false,date: ""));
      statictrackOrderList.add(TrackOrderList(
          id: 1, trackStatusName: "Return Order Confirmed", orderStatus: 7,isActiveColor: false,date: ""));
      statictrackOrderList.add(TrackOrderList(
          id: 2, trackStatusName: "Return Order Shipped", orderStatus: 9,isActiveColor: false,date: ""));
      statictrackOrderList.add(TrackOrderList(
          id: 3, trackStatusName: "Return Order Delivered", orderStatus: 10,isActiveColor: false,date: ""));
      // statictrackOrderList.add(TrackOrderList(
      //   id: 4, trackStatusName: "Return Order Cancelled", orderStatus: 8,isActiveColor: false,date: ""));

      //for return
      for(int i=0;i<=statictrackOrderList.length-1;i++){
        if(statictrackOrderList[i].orderStatus==int.parse(_trackOrderList[lastIndex].ohStatus.toString())){
          int size=statictrackOrderList[i].id;
          for(int j=0;j<=size;j++){
            statictrackOrderList[j].isActiveColor=true;
            try{
              if(_trackOrderList[j].ohStatus==i.toString()){
                statictrackOrderList[i].date=_trackOrderList[j].orderDate;
              }else{
                statictrackOrderList[i].date=_trackOrderList[0].orderDate;

              }
            }catch(e){
              // statictrackOrderList[j].date="";
              statictrackOrderList[j].date=_trackOrderList[0].orderDate;
            }
          }
        }
      }
    }
    else if(currentStatus=="5"){ //for replace
      statictrackOrderList.add(TrackOrderList(
          id: 0, trackStatusName: "Replace Order Pending", orderStatus: 5,isActiveColor: false,date: ""));
      statictrackOrderList.add(TrackOrderList(
          id: 1, trackStatusName: "Replace Order Confirmed", orderStatus: 11,isActiveColor: false,date: ""));
      statictrackOrderList.add(TrackOrderList(
          id: 2, trackStatusName: "Replace Order Shipped", orderStatus: 13,isActiveColor: false,date: ""));
      statictrackOrderList.add(TrackOrderList(
          id: 3, trackStatusName: "Replace Order Delivered", orderStatus: 14,isActiveColor: false,date: ""));
      // statictrackOrderList.add(TrackOrderList(
      //   id: 4, trackStatusName: "Replace Order Cancelled", orderStatus: 12,isActiveColor: false,date: ""));

      //for replace
      for(int i=0;i<=statictrackOrderList.length-1;i++){
        if(statictrackOrderList[i].orderStatus==int.parse(_trackOrderList[lastIndex].ohStatus.toString())){
          int size=statictrackOrderList[i].id;
          for(int j=0;j<=size;j++){
            statictrackOrderList[j].isActiveColor=true;
            try{
              if(_trackOrderList[j].ohStatus==i.toString()){
                statictrackOrderList[i].date=_trackOrderList[j].orderDate;
              }else{
                statictrackOrderList[i].date=_trackOrderList[0].orderDate;

              }
            }catch(e){
              // statictrackOrderList[j].date="";
              statictrackOrderList[i].date=_trackOrderList[0].orderDate;

            }
          }
        }

      }
    }
    //to highligh specific range
    setState(() {
    });
  }

  void fetchData() async {
    isconnectedToInternet = await ConnectivityCheck.checkInternetConnectivity();
    if (isconnectedToInternet == true) {
      Map<String, String> params = {
        'order_details_id': widget.orderData.orderDetailsId.toString()
      };
      var response = await http.post(
        Uri.parse(Api.GET_TRACK_ORDER),
        body: params,
      );
      try {
        if (response.statusCode == 200) {
          final resp = json.decode(response.body);
          final TrackOrderResp trackOrderResp = TrackOrderResp.fromJson(resp);
          final Iterable refactorCategory = trackOrderResp.trackOrder
              .trackData ?? [];
          currentStatus = trackOrderResp.trackOrder.retRplc;
          _trackOrderList = refactorCategory.toList();
          int lastIndex=_trackOrderList.length-1;
          int size=int.parse(_trackOrderList[lastIndex].ohStatus.toString());
          getTrackList(currentStatus,size,lastIndex);
        }
      } catch (e) {
        print(e);
      }
    }else{
      CustomDialogs.showDialogCustom(
          "Internet", "Please check your Internet Connection!", context);
    }
  }

  Future<void> _onRefresh() async {
    await Future.delayed(Duration(milliseconds: 1000));
    _trackOrderList = [];
    fetchData();
    _controller.refreshCompleted();
  }


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        key: _scaffoldKey,
        appBar: new AppBar(
          title: Text(
            Translate.of(context).translate('track_order'),
            style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
                fontSize: 18.0,
                color: AppTheme.textColor),
          ),
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
        body:
        SafeArea(
            child:
            SmartRefresher(
                enablePullDown: true,
                onRefresh: _onRefresh,
                controller: _controller,
                child:
                Container(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        //for produce info
                        Container(
                            color: Colors.white,
                            child: Padding(
                              padding: EdgeInsets.all(10.0),
                              child: Card(
                                elevation: 5.0,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                    side: BorderSide(
                                      color: Colors.white,
                                      width: 0.5,
                                    )),
                                borderOnForeground: true,
                                child: Container(
                                    color: Colors.transparent,
                                    child: Card(
                                      elevation: 0.0,
                                      child: Padding(
                                          padding: EdgeInsets.all(10.0),
                                          child: Row(
                                            crossAxisAlignment: CrossAxisAlignment
                                                .start,
                                            children: [
                                              CachedNetworkImage(
                                                filterQuality: FilterQuality
                                                    .medium,
                                                // imageUrl: Api.PHOTO_URL + widget.users.avatar,
                                                // imageUrl:
                                                // "https://images.unsplash.com/photo-1438761681033-6461ffad8d80?ixid=MXwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=1050&q=80",
                                                imageUrl: widget.orderData
                                                    .imgPaths ==
                                                    null
                                                    ? "https://images.unsplash.com/photo-1438761681033-6461ffad8d80?ixid=MXwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=1050&q=80"
                                                    : widget.orderData
                                                    .imgPaths,
                                                placeholder: (context, url) {
                                                  return Shimmer.fromColors(
                                                    baseColor: Theme
                                                        .of(context)
                                                        .hoverColor,
                                                    highlightColor:
                                                    Theme
                                                        .of(context)
                                                        .highlightColor,
                                                    enabled: true,
                                                    child: Container(
                                                      height: 80,
                                                      width: 80,
                                                      decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                      ),
                                                    ),
                                                  );
                                                },
                                                imageBuilder: (context,
                                                    imageProvider) {
                                                  return Container(
                                                    height: 80,
                                                    width: 80,
                                                    decoration: BoxDecoration(
                                                      image: DecorationImage(
                                                        image: imageProvider,
                                                        fit: BoxFit.cover,
                                                      ),
                                                      borderRadius:
                                                      BorderRadius.circular(
                                                          8),
                                                    ),
                                                  );
                                                },
                                                errorWidget: (context, url,
                                                    error) {
                                                  return Shimmer.fromColors(
                                                    baseColor: Theme
                                                        .of(context)
                                                        .hoverColor,
                                                    highlightColor:
                                                    Theme
                                                        .of(context)
                                                        .highlightColor,
                                                    enabled: true,
                                                    child: Container(
                                                      height: 80,
                                                      width: 80,
                                                      decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                      ),
                                                      child: Icon(
                                                          Icons.error),
                                                    ),
                                                  );
                                                },
                                              ),
                                              SizedBox(
                                                width: 10.0,
                                              ),
                                              Expanded(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        widget.orderData
                                                            .producerName,
                                                        style: Theme
                                                            .of(context)
                                                            .textTheme
                                                            .caption
                                                            .copyWith(
                                                            fontSize: 14.0,
                                                            fontWeight: FontWeight
                                                                .w600,
                                                            color: Theme
                                                                .of(context)
                                                                .primaryColor,
                                                            fontFamily: "Poppins"),
                                                      ),
                                                      ReadMoreText(

                                                          widget.orderData
                                                              .productDesc,
                                                          style: Theme
                                                              .of(context)
                                                              .textTheme
                                                              .button
                                                              .copyWith(
                                                              fontSize: 12.0,
                                                              color: AppTheme
                                                                  .textColor,
                                                              fontWeight: FontWeight
                                                                  .w400,
                                                              fontFamily: "Poppins"),
                                                          trimLines: 2,
                                                          trimMode: TrimMode
                                                              .Line,
                                                          trimCollapsedText: 'Show more',
                                                          trimExpandedText: 'Show less'
                                                      ),
                                                      Text(
                                                        // widget.users.address != null
                                                        //     ? widget.users.address
                                                        //     : "",
                                                        "Quantity: " +
                                                            widget.orderData
                                                                .qty
                                                                .toString(),
                                                        style: Theme
                                                            .of(context)
                                                            .textTheme
                                                            .button
                                                            .copyWith(
                                                            fontSize: 11.0,
                                                            color: AppTheme
                                                                .textColor,
                                                            fontWeight: FontWeight
                                                                .w500,
                                                            fontFamily: "Poppins"),
                                                      ),
                                                    ],
                                                  )),
                                            ],
                                          )),
                                    )),
                              ),
                            )),
                        SizedBox(
                          height: 8.0,
                        ),
                        //for stepper timeline is used
                        Container(
                            height: 300.0,
                            color: Colors.white,
                            child: Padding(
                                padding: EdgeInsets.only(
                                    left: 25.0, top: 10.0),
                                child:
                                statictrackOrderList.length > 0
                                    ?
                                TimeLineWidget(
                                    trackOrderList: statictrackOrderList
                                )
                                    :
                                ListView.builder(
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
                                )

                            )
                          // ListView.builder(
                          //     scrollDirection: Axis.vertical,
                          //     shrinkWrap: true,
                          //     itemCount: _trackOrderList!=null?_trackOrderList.length:4,
                          //     itemBuilder: (context,index){
                          //      return buildTrackOrderList(_trackOrderList,index);
                          // })

                          // ListView(
                          //   shrinkWrap: true,
                          //   children: <Widget>[
                          //
                          //     TimelineTile(
                          //       alignment: TimelineAlign.manual,
                          //       lineXY: 0.1,
                          //       isFirst: true,
                          //       indicatorStyle: IndicatorStyle(
                          //         width: 20,
                          //         color: Theme
                          //             .of(context)
                          //             .primaryColor,
                          //         padding: EdgeInsets.all(6),
                          //       ),
                          //       endChild: _RightChild(
                          //         // asset: 'assets/images/cart.png',
                          //         title: 'Order Pending',
                          //         message: _trackOrderList[0].orderDate,
                          //       ),
                          //       beforeLineStyle: LineStyle(
                          //         thickness: 3,
                          //         color: Theme
                          //             .of(context)
                          //             .primaryColor,
                          //       ),
                          //     ),
                          //
                          //     TimelineTile(
                          //       alignment: TimelineAlign.manual,
                          //       lineXY: 0.1,
                          //
                          //       indicatorStyle: IndicatorStyle(
                          //         width: 20,
                          //         color: Theme
                          //             .of(context)
                          //             .primaryColor,
                          //         padding: EdgeInsets.all(6),
                          //       ),
                          //       endChild: _RightChild(
                          //         // asset: 'assets/images/cart.png',
                          //         title: 'Order Accepted',
                          //         message: _trackOrderList[1].orderDate,
                          //       ),
                          //       beforeLineStyle: LineStyle(
                          //         thickness: 3,
                          //         color: Theme
                          //             .of(context)
                          //             .primaryColor,
                          //       ),
                          //     ),
                          //     TimelineTile(
                          //       alignment: TimelineAlign.manual,
                          //       lineXY: 0.1,
                          //       indicatorStyle: IndicatorStyle(
                          //         width: 20,
                          //         color: Theme
                          //             .of(context)
                          //             .primaryColor,
                          //         padding: EdgeInsets.all(6),
                          //       ),
                          //       endChild: _RightChild(
                          //         // asset: 'assets/images/cart.png',
                          //         title: 'Order Shipped',
                          //         message: _trackOrderList[2].orderDate,
                          //       ),
                          //       beforeLineStyle: LineStyle(
                          //         thickness: 3,
                          //         color: Theme
                          //             .of(context)
                          //             .primaryColor,
                          //       ),
                          //     ),
                          //     TimelineTile(
                          //       alignment: TimelineAlign.manual,
                          //       lineXY: 0.1,
                          //       indicatorStyle: IndicatorStyle(
                          //         width: 20,
                          //         color: Theme
                          //             .of(context)
                          //             .primaryColor,
                          //         padding: EdgeInsets.all(6),
                          //       ),
                          //       endChild: _RightChild(
                          //         disabled: true,
                          //
                          //         // asset: 'assets/images/cart.png',
                          //         title: 'Order Delivered',
                          //         message: _trackOrderList[3].orderDate,
                          //       ),
                          //       beforeLineStyle: LineStyle(
                          //         thickness: 3,
                          //
                          //         color:
                          //         Theme
                          //             .of(context)
                          //             .primaryColor,
                          //       ),
                          //       afterLineStyle: const LineStyle(
                          //         thickness: 3,
                          //         color: Color(0xFFDADADA),
                          //       ),
                          //     ),
                          //     TimelineTile(
                          //       alignment: TimelineAlign.manual,
                          //       lineXY: 0.1,
                          //       isLast: true,
                          //       indicatorStyle: const IndicatorStyle(
                          //         width: 20,
                          //         color: Color(0xFFDADADA),
                          //         padding: EdgeInsets.all(6),
                          //       ),
                          //       endChild: _RightChild(
                          //         disabled: true,
                          //         // asset: 'assets/images/cart.png',
                          //         title: 'Order Cancelled',
                          //         message: ' ',
                          //       ),
                          //       beforeLineStyle: const LineStyle(
                          //         thickness: 3,
                          //
                          //         color: Color(0xFFDADADA),
                          //       ),
                          //     ),
                          //   ],
                          // ),
                        ),
                        SizedBox(
                          height: 8.0,
                        ),
                        //tracking Id
                        Container(
                          color: Colors.white,
                          child: Padding(
                              padding: EdgeInsets.all(15.0),
                              child:
                              Row(
                                mainAxisAlignment: MainAxisAlignment
                                    .spaceBetween,
                                children: [
                                  Text(
                                    "Tracking ID",
                                    // widget.users.firstName+" "+widget.users.lastName,
                                    style: Theme
                                        .of(context)
                                        .textTheme
                                        .caption
                                        .copyWith(
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.w600,
                                        color: Theme
                                            .of(context)
                                            .primaryColor,
                                        fontFamily: "Poppins"),
                                  ),
                                  Text(
                                    _trackOrderList.length>0?_trackOrderList[0].orderNum:"",
                                    style: Theme
                                        .of(context)
                                        .textTheme
                                        .button
                                        .copyWith(
                                        fontSize: 12.0,
                                        color: AppTheme.textColor,
                                        fontWeight: FontWeight.w500,
                                        fontFamily: "Poppins"),
                                  ),
                                ],
                              )),
                        ),

                        SizedBox(
                          height: 8.0,
                        ),
                        //add review
                        Container(
                          color: Colors.white,
                          child: Padding(
                              padding: EdgeInsets.all(15.0),
                              child: GestureDetector(
                                  onTap: () {
                                    Navigator.push(context, MaterialPageRoute(builder: (context)=>ReturnReplace(orderData: widget.orderData,)));
                                  },
                                  child:
                                  // widget.orderData.currentStatus != 4 &&
                                  //     widget.orderData.currentStatus != 5 &&
                                  //     widget.orderData.currentStatus != 7
                                  //     &&
                                  //     widget.orderData.currentStatus != 9 &&
                                  //     widget.orderData.currentStatus != 10 &&
                                  //     widget.orderData.currentStatus != 11
                                  //     &&
                                  //     widget.orderData.currentStatus != 13 &&
                                  //     widget.orderData.currentStatus != 14
                                  widget.orderData.currentStatus==3 || widget.orderData.currentStatus==10 || widget.orderData.currentStatus==14
                                      ?
                                  Card(
                                      elevation: 5.0,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                            10.0),
                                        side: BorderSide(
                                          color: Colors.white,
                                          width: 0.5,
                                        ),
                                      ),
                                      child: Padding(
                                        padding: EdgeInsets.only(
                                            left: 10.0, right: 10.0),
                                        child:

                                        Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              Translate.of(context).translate(
                                                  'return_replace'),
                                              style: TextStyle(
                                                  fontSize: 12.0,
                                                  fontWeight: FontWeight.w400,
                                                  fontFamily: 'Poppins',
                                                  color: AppTheme.textColor),
                                            ),
                                            IconButton(
                                                icon: Image.asset(
                                                    Images.arrow,
                                                    height: 15.0,
                                                    width: 15.0))
                                          ],
                                        ),
                                      ))
                                      :
                                  Container())

                          ),
                        )

                      ],
                    ),
                  ),
                )))


    );
  }
}


class _RightChild extends StatelessWidget {
  const _RightChild({
    Key key,
    // this.asset,
    this.title,
    this.message,
    this.disabled = false,
  }) : super(key: key);

  //final String asset;
  final String title;
  final String message;
  final bool disabled;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: <Widget>[
          // Opacity(
          //   child: Image.asset(asset, height: 50),
          //   opacity: disabled ? 0.5 : 1,
          // ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                title,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  color: disabled
                      ? const Color(0xFFBABABA)
                      : Theme.of(context).primaryColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                message,
                style: TextStyle(
                  color: disabled
                      ? const Color(0xFFD5D5D5)
                      : AppTheme.textColor,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class TrackOrderList {
  int id;
  String trackStatusName;
  int orderStatus;
  String date;
  bool isActiveColor=false;

  TrackOrderList({this.id,
    this.trackStatusName,
    this.orderStatus,
    this.date,
    this.isActiveColor
  });


}

