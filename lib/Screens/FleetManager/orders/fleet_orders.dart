import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:orderly/Configs/image.dart';
import 'package:orderly/Configs/theme.dart';
import 'package:orderly/Models/model_fleet_orders.dart';
import 'package:orderly/Utils/translate.dart';
import 'package:shimmer/shimmer.dart';

class FleetOrders extends StatefulWidget {
  _FleetOrdersState createState() => _FleetOrdersState();
}

class _FleetOrdersState extends State<FleetOrders> {
  List<FleetOrderModel> orderList = [];
  ScrollController _scrollController = ScrollController();
  List<int> selectedIndexList = []; //for selected index


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getOrders();
  }

  void getOrders() {
    for (int i = 0; i < 3; i++) {
      FleetOrderModel fleetOrders = new FleetOrderModel(
          id: i,
          orderNumber: "Order Number",
          date: "12 July 2021",
          noOfItems: "4",
          orderStatus: "Shipped",
          isSelected:false);

      orderList.add(fleetOrders);
    }
  }

  Widget changeColourOnClick(int index)
  {
    if(orderList[index].isSelected==true)
    {
      orderList[index].isSelected=!orderList[index].isSelected;
      return Container(
        height: 30.0,
        width: 100.0,
        child: Padding(
            padding: EdgeInsets.all(10.0),
            child: Center(
                child: Text("Shipped",
                    style: TextStyle(color: Colors.white)))),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(25)),
            color: Theme.of(context).primaryColor
        ),
      );
    }else{
      return Container(
        height: 30.0,
        width: 100.0,
        child: Padding(
            padding: EdgeInsets.all(10.0),
            child: Center(
                child: Text("Shipped",
                    style: TextStyle(color: AppTheme.textColor)))),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(25)),
            color: Colors.white
        ),
      );
    }
  }

  Widget buildCategory(List<FleetOrderModel> orderList) {
    if (orderList == null) {
      return ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.only(left: 5, right: 20, top: 10, bottom: 15),
        itemBuilder: (context, index) {
          return Shimmer.fromColors(
            baseColor: Theme.of(context).hoverColor,
            highlightColor: Theme.of(context).highlightColor,
            enabled: true,
            child: Padding(
                padding: EdgeInsets.only(left: 15),
                child: GestureDetector(
                  onTap: () {
                    print('clicked category');

                  },
                  child: Container(
                    height: 30.0,
                    width: 100.0,
                    child: Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Center(
                            child: Text("Shipped",
                                style: TextStyle(color: AppTheme.textColor)))),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(25)),
                        color: Colors.white),
                  ),
                )),
          );
        },
        itemCount: List.generate(8, (index) => index).length,
      );
    }

    return ListView.builder(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.only(left: 5, right: 20, top: 10, bottom: 15),
      itemBuilder: (context, index) {
        final item = orderList[index];
        return Padding(
            padding: EdgeInsets.only(left: 15),
            child: GestureDetector(
              onTap: ()
              {
                setState(() {
                  orderList[index].isSelected=true;
                });
              },
              child:changeColourOnClick(index)
            ));
      },
      itemCount: orderList.length,
    );
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

    return Padding(
      padding: const EdgeInsets.only(
        top: 5,
      ),
      child: Stack(
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
                                      _orderLists[index].orderNumber,
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
                                      _orderLists[index].date,
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
                                      _orderLists[index].noOfItems,
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
                    Text(_orderLists[index].orderStatus,
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontFamily: 'Poppins',
                      fontSize: 14.0,
                      color: AppTheme.appColor
                    ),),
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
    );
  }


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: Container(
        child: Column(
          children: [
            Container(
              height: 70,
              child: buildCategory(orderList),
            ),
            Expanded(child:
            ListView.separated(
                controller: _scrollController,
                physics: const AlwaysScrollableScrollPhysics(),
                separatorBuilder: (context, index) {
                  return SizedBox(
                    height: 0.0,
                  );
                },
                itemCount: orderList!=null?orderList.length:6,
                itemBuilder: (context, index) {
                  return GestureDetector(
                      onTap: ()
                      {

                      },
                      child: buildOrdersList(index, orderList)
                   );
                })),
          ],
        ),
      ),
    );
  }
}
