import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:orderly/Blocs/fleetOrders/bloc.dart';
import 'package:orderly/Configs/image.dart';
import 'package:orderly/Configs/theme.dart';
import 'package:orderly/Models/model_fleetOrder_det.dart';
import 'package:orderly/Models/model_fleet_orders.dart';
import 'package:orderly/Screens/FleetManager/orders/fleet_order_det_retReplace.dart';
import 'package:orderly/Screens/FleetManager/orders/order_details.dart';
import 'package:orderly/Utils/application.dart';
import 'package:orderly/Utils/connectivity_check.dart';
import 'package:orderly/Utils/translate.dart';
import 'package:orderly/Widgets/app_dialogs.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shimmer/shimmer.dart';

class FleetOrders extends StatefulWidget {
  _FleetOrdersState createState() => _FleetOrdersState();
}

class _FleetOrdersState extends State<FleetOrders> {
  ScrollController _scrollController = ScrollController();
  FleetOrdersBloc _fleetOrdersBloc;
  bool isconnectedToInternet = false;
  bool flagNoData=false;
  List<FleetOrderModel> _fleetOrderList;
  List<FleetOrdersDet> _fleetRetReplaceList;
  int offset=0,status=0;
  List <Map> orderCat;
  final _controller = RefreshController(initialRefresh: false);
  String StatusName="";


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    flagNoData=false;
    StatusName="New";
    _fleetOrdersBloc=BlocProvider.of<FleetOrdersBloc>(context);
    getOrdersCat();

    Future.delayed(const Duration(milliseconds: 300), () {
      setState(() {
        _fleetOrdersBloc.add(OnLoadingFleetOrdersList(producerId:Application.user.producerid,status: status.toString()));
      });
    });

    // setBlocData();

    // _scrollController.addListener(() {
    //   if (_scrollController.position.maxScrollExtent ==
    //       _scrollController.offset) {
    //     print('Controller at bottom');
    //     offset += 10;
    //     _fleetOrdersBloc.add(OnLoadingFleetOrdersList(producerId: "1",status: status.toString()));
    //   }
    // });


  }

  void setBlocData() async {
    print(Application.user.producerid);
    isconnectedToInternet = await ConnectivityCheck.checkInternetConnectivity();
    if (isconnectedToInternet == true) {
      _fleetOrdersBloc.add(OnLoadingFleetOrdersList(producerId: Application.user.producerid,status: status.toString()));
    } else {
      CustomDialogs.showDialogCustom(
          "Internet", "Please check your Internet Connection!", context);
    }
  }


  void getOrdersCat() {
    // for (int i = 0; i < 3; i++) {
    //   FleetOrderModel fleetOrders = new FleetOrderModel(
    //       id: i,
    //       orderNumber: "Order Number",
    //       date: "12 July 2021",
    //       noOfItems: "4",
    //       orderStatus: "Shipped",
    //       isSelected:false);
    //
    //   orderList.add(fleetOrders);
    // }
    orderCat = [
      {
        "name": "New",
        "isSelected": true
      },
      {
        "name": "Ready",
        "isSelected": false
      },
      {
        "name": "Shipped",
        "isSelected": false,
      },
      {
        "name": "Delivered",
        "isSelected": false
      },
      {
        "name": "Return & Replace",
        "isSelected": false
      },
      {
        "name": "Cancelled",
        "isSelected": false
      },
    ];


  }

  Widget changeColourOnClick(int index)
  {

    if(orderCat[index]['isSelected']==true)
    {
      orderCat[index]['isSelected']=!orderCat[index]['isSelected'];
      return Container(
        height: 30.0,
        width: 90.0,
        child: Center(
                child: Text(orderCat[index]['name'],
                    style: TextStyle(color: Colors.white))),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(25)),
            color: Theme.of(context).primaryColor

      ));
    }else{
      return Container(
        height: 30.0,
        width: 90.0,
        child: Center(
            child: Text(orderCat[index]['name'],
                style: TextStyle(color: AppTheme.textColor))),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(25)),
            color: Colors.white
        ),
      );
    }
  }

  Widget buildCategory(List<Map> orderCat) {
    if (orderCat == null) {
      return ListView.builder(
        scrollDirection: Axis.horizontal,
        // padding: EdgeInsets.only(left: 5, right: 20, top: 10, bottom: 15),
        itemBuilder: (context, index) {
          return Shimmer.fromColors(
            baseColor: Theme.of(context).hoverColor,
            highlightColor: Theme.of(context).highlightColor,
            enabled: true,
            child:
                GestureDetector(
                  onTap: () {
                    print('clicked category');
                    },
                  child: Container(
                    height: 30.0,
                    width: 120.0,
                    child: Padding(
                        padding: EdgeInsets.all(5.0),
                        child: Center(
                            child: Text(orderCat[index]['name'],
                                style: TextStyle(color: AppTheme.textColor,fontSize: 12.0)))),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        color: Colors.white),
                  ),
                ));

        },
        itemCount: List.generate(8, (index) => index).length,
      );
    }

    return ListView.builder(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.only( top: 10, bottom: 15),
      itemBuilder: (context, index) {
        // final item = orderList[index];
        return Padding(
            padding: EdgeInsets.only(left: 5,right: 5),
            child: GestureDetector(
              onTap: ()
              {
                // setBlocData();

                // setState(() {
                  orderCat[index]['isSelected']=true;
                  if(index==5)
                    {
                      status=6;
                    }else{
                    status=index;
                  }

                  _fleetOrderList=null;
                // if(status!=4 && status!=5){
                  _fleetOrdersBloc.add(OnLoadingFleetOrdersList(producerId: Application.user.producerid,status: status.toString()));

                // }else{ //for return replace
                //   _fleetOrdersBloc.add(FleetOrdersReturnReplace(producerId: Application.user.producerid.toString()));
                //   print("status:-"+status.toString());
                //   print("producerId:-"+Application.user.producerid.toString());
                //
                // }
                // });
              },
              child:
              // changeColourOnClick(index)
                Container(
                height: 30.0,
                width: 120.0,
                child: Center(
                    child: Text(orderCat[index]['name'],
                        style: TextStyle(color: status==index?Colors.white:AppTheme.textColor,fontSize: 12.0))),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(25)),
                    color: status==index?Theme.of(context).primaryColor:Colors.white

                ))
            ));
      },
      itemCount: orderCat.length,
    );
  }


  // to build widget as per status
  Widget buildListAsPerStatus(int status){
    // if(status!=4 && status !=5){
      return Expanded(child:
      ListView.separated(
          controller: _scrollController,
          physics: const AlwaysScrollableScrollPhysics(),
          separatorBuilder: (context, index) {
            return SizedBox(
              height: 0.0,
            );
          },
          itemCount: _fleetOrderList!=null?_fleetOrderList.length:6,
          itemBuilder: (context, index) {
            return GestureDetector(
                onTap: ()
                {

                },
                child: buildOrdersList(index, _fleetOrderList)
            );
          }));
    // }
    // else{ //for return replace
    //   return
    //     Expanded(child:
    //       Column(
    //         crossAxisAlignment: CrossAxisAlignment.start,
    //         children: [
    //           // Container(
    //           //   color: Colors.white,
    //           //     child:
    //           //     Row(
    //           //   mainAxisAlignment: MainAxisAlignment.end,
    //           //   children: [
    //           //     Text(
    //           //       'Filter',
    //           //       style: TextStyle(
    //           //           color: AppTheme.textColor,
    //           //           fontSize: 14.0,
    //           //           fontWeight: FontWeight.w400,
    //           //           fontFamily: 'Poppins'
    //           //       ),
    //           //     ),
    //           //     IconButton(
    //           //       icon: Image.asset(Images.filter,width: 20.0,height: 20.0,),
    //           //       onPressed: () {
    //           //
    //           //       },
    //           //     ),
    //           //   ],
    //           // )),
    //
    //           Expanded(
    //             child: ListView.separated(
    //                 controller: _scrollController,
    //                 physics: const AlwaysScrollableScrollPhysics(),
    //                 separatorBuilder: (context, index) {
    //                   return SizedBox(
    //                     height: 0.0,
    //                   );
    //                 },
    //                 itemCount: _fleetRetReplaceList!=null?_fleetRetReplaceList.length:6,
    //                 itemBuilder: (context, index) {
    //                   return GestureDetector(
    //                       onTap: ()
    //                       {
    //                         Navigator.push(context, MaterialPageRoute(builder: (context)=>
    //                             FleetOrderDetRetReplace(orderData: _fleetRetReplaceList[index])));
    //                         // print("clicked");
    //                       },
    //                       child: buildReturnReplaceList(index, _fleetRetReplaceList)
    //                   );
    //                 }),
    //           )
    //         ],
    //       )
    //
    // );
    // }
  }

  Widget getTextStatusName(int index, List<FleetOrderModel> _fleetOrderList){
    if(_fleetOrderList[index].currentStatus==0){
      StatusName="New";
    }
    else if(_fleetOrderList[index].currentStatus==1){
      StatusName="Ready";
    }else if(_fleetOrderList[index].currentStatus==2){
      StatusName="Shipped";
    }else if(_fleetOrderList[index].currentStatus==3){
      StatusName="Delivered";
    }else if(_fleetOrderList[index].currentStatus==4){
      StatusName="Return";
    }else if(_fleetOrderList[index].currentStatus==5){
      StatusName="Replace";
    }else if(_fleetOrderList[index].currentStatus==6){
      StatusName="Cancelled";
    }else if(_fleetOrderList[index].currentStatus==7){
      StatusName="Ready Return";
    }else if(_fleetOrderList[index].currentStatus==8){
      StatusName="Cancelled Return";
    }else if(_fleetOrderList[index].currentStatus==9){
      StatusName="Shipped Return";
    }else if(_fleetOrderList[index].currentStatus==10){
      StatusName="Delivered Return";
    }else if(_fleetOrderList[index].currentStatus==11){
      StatusName="Ready Replacement";
    }else if(_fleetOrderList[index].currentStatus==12){
      StatusName="Cancelled Replacement";
    }else if(_fleetOrderList[index].currentStatus==13){
      StatusName="Shipped Replacement";
    }else if(_fleetOrderList[index].currentStatus==14){
      StatusName="Delivered Replacement";
    }
    return Text(StatusName,
      style: TextStyle(
          fontWeight: FontWeight.w400,
          fontFamily: 'Poppins',
          fontSize: 14.0,
          color: AppTheme.appColor
      ),);
  }

  //order list
  Widget buildOrdersList(int index,List<FleetOrderModel> _orderLists){
    if(_orderLists==null){
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

    return
     Padding(
        padding: const EdgeInsets.only(
          top: 5,
        ),
        child:
        GestureDetector(
          onTap: (){
            print(status);
            Navigator.push(context, MaterialPageRoute(builder: (context)=>
                OrderDetails(orderId:_fleetOrderList[index].orderNumber,status:_fleetOrderList[index].currentStatus,
                    statusName:StatusName, producerId:_fleetOrderList[index].producerId.toString())));
            // print("clicked");
          },
          child:Stack(
          alignment: Alignment.center,
          children: [
            Container(
              color: Colors.transparent,
              child: Card(
                  elevation: 0.0,
                  child: Column(
                      children: [
                        Padding(
                            padding: EdgeInsets.all(10.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CachedNetworkImage(
                                  filterQuality: FilterQuality.medium,
                                  // imageUrl: Api.PHOTO_URL + widget.users.avatar,
                                  // imageUrl:
                                  //     "https://images.unsplash.com/photo-1438761681033-6461ffad8d80?ixid=MXwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=1050&q=80",
                                  imageUrl: _orderLists[index].orderImage == null
                                      ? "https://images.unsplash.com/photo-1438761681033-6461ffad8d80?ixid=MXwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=1050&q=80"
                                      : _orderLists[index].orderImage,
                                  placeholder: (context, url) {
                                    return Shimmer.fromColors(
                                      baseColor: Theme.of(context).hoverColor,
                                      highlightColor:
                                      Theme.of(context).highlightColor,
                                      enabled: true,
                                      child: Container(
                                        height: 90,
                                        width: 90,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                      ),
                                    );
                                  },
                                  imageBuilder: (context, imageProvider) {
                                    return Container(
                                      height: 100,
                                      width: 100,
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
                                        height: 100,
                                        width: 100,
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
                                          _orderLists[index].orderNumber.toString(),
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
                                            // DateFormat('EEEE, d MMM, yyyy').format(DateTime.parse( _fleetOrderList[index].date)),
                                            "",
                                          style: Theme.of(context)
                                              .textTheme
                                              .button
                                              .copyWith(
                                              fontSize: 12.0,
                                              color: AppTheme.textColor,
                                              fontWeight: FontWeight.w400,
                                              fontFamily: "Poppins"),
                                        ),
                                        SizedBox(height: 15.0,),
                                        Text(
                                          "No.Of Items",
                                          style: Theme.of(context)
                                              .textTheme
                                              .button
                                              .copyWith(
                                              fontSize: 14.0,
                                              color: AppTheme.textColor,
                                              fontWeight: FontWeight.w600,
                                              fontFamily: "Poppins"),
                                        ),
                                        Text(
                                            _orderLists[index].noOfItems.toString(),
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
                            )),

                      ]
                  )


              ),
            ),
            Positioned(
              right: 5.0,
              top: 10.0,
              child: Container(
                // width:30.0,height:30.0,
                  decoration: BoxDecoration(
                    // color: Colors.greenAccent,
                    // borderRadius: BorderRadius.circular(20.0),
                  ),
                  margin: const EdgeInsets.symmetric(horizontal: 10.0),
                  child:
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      getTextStatusName(index,_orderLists),

                      Text("Order",
                        style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontFamily: 'Poppins',
                            fontSize: 12.0,
                            color: AppTheme.textColor
                        ),)
                    ],
                  )
              ),
            ),
          ],
        ),
      )
    );
  }

//for return replace list
  Widget buildReturnReplaceList(int index,List<FleetOrdersDet> _fleetRetReplaceList){
    if(_fleetRetReplaceList==null){
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
    return
      Padding(
          padding: const EdgeInsets.only(
            top: 5,
          ),
          child:
          GestureDetector(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>
                  FleetOrderDetRetReplace(orderData: _fleetRetReplaceList[index])));
              // print("clicked");
            },
            child:Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  color: Colors.transparent,
                  child: Card(
                      elevation: 0.0,
                      child: Column(
                          children: [
                            Padding(
                                padding: EdgeInsets.all(10.0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CachedNetworkImage(
                                      filterQuality: FilterQuality.medium,
                                      // imageUrl: Api.PHOTO_URL + widget.users.avatar,
                                      // imageUrl:
                                      //     "https://images.unsplash.com/photo-1438761681033-6461ffad8d80?ixid=MXwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=1050&q=80",
                                      imageUrl: _fleetRetReplaceList[index].imgPaths == null
                                          ? "https://images.unsplash.com/photo-1438761681033-6461ffad8d80?ixid=MXwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=1050&q=80"
                                          : _fleetRetReplaceList[index].imgPaths,
                                      placeholder: (context, url) {
                                        return Shimmer.fromColors(
                                          baseColor: Theme.of(context).hoverColor,
                                          highlightColor:
                                          Theme.of(context).highlightColor,
                                          enabled: true,
                                          child: Container(
                                            height: 90,
                                            width: 90,
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                          ),
                                        );
                                      },
                                      imageBuilder: (context, imageProvider) {
                                        return Container(
                                          height: 100,
                                          width: 100,
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
                                            height: 100,
                                            width: 100,
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
                                              _fleetRetReplaceList[index].orderNumber.toString(),
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
                                              DateFormat('d MMM yyyy').format(DateTime.parse( _fleetRetReplaceList[index].orderDate)),
                                                style: Theme.of(context)
                                                  .textTheme
                                                  .button
                                                  .copyWith(
                                                  fontSize: 13.0,
                                                  color: AppTheme.textColor,
                                                  fontWeight: FontWeight.w400,
                                                  fontFamily: "Poppins"),
                                            ),
                                            // Text(
                                            //   _fleetRetReplaceList[index].productName.toString(),
                                            //   style: Theme.of(context)
                                            //       .textTheme
                                            //       .button
                                            //       .copyWith(
                                            //       fontSize: 13.0,
                                            //       color: AppTheme.textColor,
                                            //       fontWeight: FontWeight.w400,
                                            //       fontFamily: "Poppins"),
                                            // ),
                                            // Text(
                                            //   _fleetRetReplaceList[index].ratePerHour.toString()+" \$hr",
                                            //   style: Theme.of(context)
                                            //       .textTheme
                                            //       .button
                                            //       .copyWith(
                                            //       fontSize: 13.0,
                                            //       color: AppTheme.appColor,
                                            //       fontWeight: FontWeight.w400,
                                            //       fontFamily: "Poppins"),
                                            // ),
                                            SizedBox(height: 10.0,),
                                            Text(
                                              "No.Of Items",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .button
                                                  .copyWith(
                                                  fontSize: 14.0,
                                                  color: AppTheme.textColor,
                                                  fontWeight: FontWeight.w600,
                                                  fontFamily: "Poppins"),
                                            ),
                                            Text(
                                              _fleetRetReplaceList[index].qty.toString(),
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
                                )),

                          ]
                      )


                  ),
                ),
                // Positioned(
                //   right: 5.0,
                //   top: 10.0,
                //   child: Container(
                //     // width:30.0,height:30.0,
                //       decoration: BoxDecoration(
                //         // color: Colors.greenAccent,
                //         // borderRadius: BorderRadius.circular(20.0),
                //       ),
                //       margin: const EdgeInsets.symmetric(horizontal: 10.0),
                //       child:
                //       Column(
                //         mainAxisAlignment: MainAxisAlignment.start,
                //         crossAxisAlignment: CrossAxisAlignment.start,
                //         children: [
                //           Text(DateFormat('d MMM yyyy').format(DateTime.parse( _fleetRetReplaceList[index].orderDate)),
                //             style: TextStyle(
                //                 fontWeight: FontWeight.w400,
                //                 fontFamily: 'Poppins',
                //                 fontSize: 14.0,
                //                 color: AppTheme.textColor
                //             ),),
                //           // Text("Order",
                //           //   style: TextStyle(
                //           //       fontWeight: FontWeight.w400,
                //           //       fontFamily: 'Poppins',
                //           //       fontSize: 12.0,
                //           //       color: AppTheme.textColor
                //           //   ),)
                //         ],
                //       )
                //   ),
                // ),
              ],
            ),
          )
      );
  }

  ///On Refresh List
  Future<void> _onRefresh() async {
    await Future.delayed(Duration(milliseconds: 1000));
     // if(status!=4 && status!=5)
     // {
       _fleetOrderList=null;
       _fleetOrdersBloc.add(OnLoadingFleetOrdersList(producerId:Application.user.producerid,status: status.toString()));
     // }else{
     //   _fleetRetReplaceList=null;
     //   _fleetOrdersBloc.add(FleetOrdersReturnReplace(producerId: Application.user.producerid.toString()));
     // }
     _controller.refreshCompleted();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body:BlocBuilder<FleetOrdersBloc,FleetOrdersState>(builder: (context,state){
        if(state is FleetOrdersListSuccess){
          _fleetOrderList=state.fleetOrderList;
          flagNoData=false;
        }

        if(state is FleetOrdersLoading){
        flagNoData=false;
        }

        if(state is FleetOrdersRetReplaceSuccess){
          _fleetRetReplaceList=state.fleetOrderRetReplaceList;
          flagNoData=false;
        }

        if(state is FleetOrdersListLoadFail){
          flagNoData=true;
        }
        if(state is FleetOrdersRetReplaceFail){
          flagNoData=true;
        }

        return SafeArea(
            child: SmartRefresher(
              enablePullDown: true,
              onRefresh: _onRefresh,
              controller: _controller,
                child:Container(
                  child: Column(
                    children: [
                      Container(
                        height: 70,
                        child: buildCategory(orderCat),
                      ),
                      flagNoData==false
                          ?
                      buildListAsPerStatus(status)
                          :
                      Container(
                          margin: EdgeInsets.only(top:200.0),
                          child:Align(
                            alignment: Alignment.center,
                            child: Text(
                              "No Data Available",
                              style: TextStyle(fontWeight: FontWeight.w600,
                                  fontFamily: 'Poppins',
                                  fontSize: 18.0,
                                  color: AppTheme.textColor),
                            ),
                          ))
                    ],
                  ),
                )
            ));
      })

    );
  }
}
