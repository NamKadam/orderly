import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:orderly/Blocs/fleetOrders/fleetOrders_bloc.dart';
import 'package:orderly/Blocs/fleetOrders/fleetOrders_event.dart';
import 'package:orderly/Blocs/fleetOrders/fleetOrders_state.dart';
import 'package:orderly/Configs/theme.dart';
import 'package:orderly/Models/model_fleetOrder_det.dart';
import 'package:orderly/Screens/Customer/orders/order_list_item.dart';
import 'package:orderly/Screens/Customer/orders/orders_filter.dart';
import 'package:orderly/Screens/FleetManager/orders/fleet_orders.dart';
import 'package:orderly/Screens/mainNavigation.dart';
import 'package:orderly/Utils/connectivity_check.dart';
import 'package:orderly/Widgets/app_button.dart';
import 'package:orderly/Widgets/app_dialogs.dart';
import 'package:readmore/readmore.dart';
import 'package:shimmer/shimmer.dart';

class OrderDetails extends StatefulWidget {
  String orderId,producerId;
  int status;
  OrderDetails({Key key,@required this.orderId,@required this.status,@required this.producerId}):super(key: key);

  _OrderDetailsState createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  List<OrderStatusTimeFilter> OrderList = [];
  String dropdownValue = '';
  List<String> spinnerItems ;

  ScrollController _scrollController = ScrollController();
  List<int> selectedIndexList = []; //for selected index
  FleetOrdersBloc _fleetOrdersBloc;
  bool isconnectedToInternet = false;
  bool flagNoData = false;
  List<FleetOrdersDet> _fleetOrderDetList;
  int offset = 0, Orderstatus = 0;
  String formattedString="";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    flagNoData = false;
    _fleetOrdersBloc = BlocProvider.of<FleetOrdersBloc>(context);
    getDataAsPerStatus(widget.status);

    setBlocData();

    _scrollController.addListener(() {
      if (_scrollController.position.maxScrollExtent ==
          _scrollController.offset) {
        print('Controller at bottom');
        offset += 10;
        _fleetOrdersBloc.add(
            OnLoadingFleetOrdersDet(orderid: widget.orderId, status: widget.status.toString(),producerId:widget.producerId));
      }
    });

    // orderDet();
  }

  Future<void> _showMessage(String message) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
              "Order Status",
              style:TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w400,
                  color: AppTheme.textColor
              )
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  message,
                  style: Theme.of(context).textTheme.bodyText1,
                ),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text(
                "OK",
              ),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context)=>MainNavigation()));
              },
            ),
          ],
        );
      },
    );
  }

  void getDataAsPerStatus(int status){
    if(widget.status==0){

      dropdownValue='Ready';
      spinnerItems= [
        'Ready',
        'Shipped',
        'Delivered',
      ];
    }else if(widget.status==1){
      dropdownValue='Shipped';
      spinnerItems= [
        'Shipped',
        'Delivered',
      ];
    }else if(widget.status==2){
      dropdownValue='Delivered';
      spinnerItems= [
        'Delivered',
      ];
    }
    setState(() {

    });

  }

  void setBlocData() async {
    isconnectedToInternet = await ConnectivityCheck.checkInternetConnectivity();
    if (isconnectedToInternet == true) {
      _fleetOrdersBloc.add(
          OnLoadingFleetOrdersDet(orderid: widget.orderId, status: widget.status.toString(),producerId:widget.producerId));
    } else {
      CustomDialogs.showDialogCustom(
          "Internet", "Please check your Internet Connection!", context);
    }
  }

  void orderDet() {
    for (int i = 0; i <= 5; i++) {
      OrderStatusTimeFilter orderListItem = new OrderStatusTimeFilter();
      orderListItem.index = i;
      orderListItem.name = "namrata";
      orderListItem.isChecked = false;
      OrderList.add(orderListItem);
      print("orderList:-" + OrderList.toString());
    }
  }

  Widget buildOrderList(int index, List<FleetOrdersDet> fleetOrderDetList) {
    if (fleetOrderDetList == null) {
      return ListView.builder(
        padding: EdgeInsets.all(0),
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.only(bottom: 15),
            child: Shimmer.fromColors(
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
    return Card(
        elevation: 0.0,
        child: Theme(
          data: Theme.of(context).copyWith(
            unselectedWidgetColor: Theme.of(context).primaryColor,
          ),
          child:
              widget.status==3
            ?
              Padding(
                  padding: EdgeInsets.all(5.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CachedNetworkImage(
                        filterQuality: FilterQuality.medium,
                        // imageUrl: Api.PHOTO_URL + widget.users.avatar,
                        // imageUrl:
                        //     "https://images.unsplash.com/photo-1438761681033-6461ffad8d80?ixid=MXwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=1050&q=80",
                        imageUrl: fleetOrderDetList[index].imgPaths == null
                            ? "https://images.unsplash.com/photo-1438761681033-6461ffad8d80?ixid=MXwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=1050&q=80"
                            : fleetOrderDetList[index].imgPaths,
                        placeholder: (context, url) {
                          return Shimmer.fromColors(
                            baseColor: Theme.of(context).hoverColor,
                            highlightColor: Theme.of(context).highlightColor,
                            enabled: true,
                            child: Container(
                              height: 100,
                              width: 100,
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
                            highlightColor: Theme.of(context).highlightColor,
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
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${fleetOrderDetList[index].productName}",
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14.0,
                                    fontFamily: 'Poppins',
                                    color: AppTheme.textColor),
                                // )
                              ),
                              ReadMoreText(
                                  fleetOrderDetList[index].productDesc,
                                  style: Theme.of(context).textTheme.button.copyWith(
                                      fontSize: 12.0,
                                      color: AppTheme.textColor,
                                      fontWeight: FontWeight.w400,
                                      fontFamily: "Poppins"),
                                  trimLines: 2,
                                  trimMode: TrimMode.Line,
                                  trimCollapsedText: 'Show more',
                                  trimExpandedText: 'Show less'),
                              Text(
                                fleetOrderDetList[index].ratePerHour.toString()+" \$ hr",
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 13.0,
                                    fontFamily: 'Poppins',
                                    color: AppTheme.appColor),
                                // )
                              ),
                            ],
                          )),
                    ],
                  ))
              :
          CheckboxListTile(
            activeColor: Theme.of(context).primaryColor,
            title:
            Padding(
                padding: EdgeInsets.all(5.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CachedNetworkImage(
                      filterQuality: FilterQuality.medium,
                      // imageUrl: Api.PHOTO_URL + widget.users.avatar,
                      // imageUrl:
                      //     "https://images.unsplash.com/photo-1438761681033-6461ffad8d80?ixid=MXwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=1050&q=80",
                      imageUrl: fleetOrderDetList[index].imgPaths == null
                          ? "https://images.unsplash.com/photo-1438761681033-6461ffad8d80?ixid=MXwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=1050&q=80"
                          : fleetOrderDetList[index].imgPaths,
                      placeholder: (context, url) {
                        return Shimmer.fromColors(
                          baseColor: Theme.of(context).hoverColor,
                          highlightColor: Theme.of(context).highlightColor,
                          enabled: true,
                          child: Container(
                            height: 100,
                            width: 100,
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
                          highlightColor: Theme.of(context).highlightColor,
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
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${fleetOrderDetList[index].productName}",
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14.0,
                              fontFamily: 'Poppins',
                              color: AppTheme.textColor),
                          // )
                        ),
                        ReadMoreText(
                            fleetOrderDetList[index].productDesc,
                            style: Theme.of(context).textTheme.button.copyWith(
                                fontSize: 12.0,
                                color: AppTheme.textColor,
                                fontWeight: FontWeight.w400,
                                fontFamily: "Poppins"),
                            trimLines: 2,
                            trimMode: TrimMode.Line,
                            trimCollapsedText: 'Show more',
                            trimExpandedText: 'Show less'),
                        Text(
                          fleetOrderDetList[index].ratePerHour.toString()+" \$ hr",
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 13.0,
                              fontFamily: 'Poppins',
                              color: AppTheme.appColor),
                          // )
                        ),
                      ],
                    )),
                  ],
                )),
            // secondary:setDeleteButton(index, _addressList),
            // IconButton(
            //  onPressed: () {},
            //  icon: Image.asset(Images.delete,
            //      height: 18.0, width:18.0)),
            value: _fleetOrderDetList[index].isChecked,
            onChanged: (val) {
              String orderId=_fleetOrderDetList[index].orderDetailsId.toString();
              formattedString += "$orderId,";
              print(formattedString);
              setState(() {
                _fleetOrderDetList[index].isChecked = val;

              });
            },
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        key: _scaffoldKey,
        appBar: new AppBar(
          title: Text(
            'Order Details',
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
          backgroundColor: Colors.white,
          elevation: 0,
        ),
        body: BlocBuilder<FleetOrdersBloc, FleetOrdersState>(
            builder: (context, status) {
              return BlocListener<FleetOrdersBloc,FleetOrdersState>(listener: (context,state){
                if(state is FleetOrdersDetListSuccess){
                  _fleetOrderDetList=state.fleetOrderDetList;
                  flagNoData=false;
                }

                if(state is FleetOrdersLoading){
                  flagNoData=false;
                }

                if(state is FleetOrdersDetLoadFail){
                  flagNoData=true;
                }
                //for update status
                if(state is FleetOrdersDetStatusSuccess){
                  _showMessage("Order Status Updated successfully.");
                }
                if(state is FleetOrdersStatusLoadFail){
                  _showMessage("Order Status Failed.");
                }
              },
              child:
              Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Stack(
              children: [
                Padding(
                    padding: EdgeInsets.only(bottom: 150.0),
                    child: ListView.builder(
                        itemCount:_fleetOrderDetList!=null?_fleetOrderDetList.length:6,
                        itemBuilder: (context, index) {
                          return buildOrderList(index,_fleetOrderDetList);
                        })),
                if(widget.status!=3)
                Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                        height: 200.0,
                        margin: EdgeInsets.all(20.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                                padding: EdgeInsets.all(10.0),
                                child: DropdownButtonHideUnderline(
                                    child: Container(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        decoration: BoxDecoration(
                                          // color: Theme.of(context).dividerColor,
                                          color: Color(0xFFFFD8BC)
                                              .withOpacity(0.6),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: Padding(
                                            padding: EdgeInsets.only(
                                                left: 8.0,
                                                top: 0.0,
                                                right: 5.0,
                                                bottom: 0.0),
                                            child:
                                                //updated on 15/06/2021
                                                new Theme(
                                                    data: Theme.of(context)
                                                        .copyWith(
                                                      canvasColor:
                                                          Color(0xFFFFD8BC),
                                                    ), //custom color
                                                    child:
                                                        DropdownButton<String>(
                                                      value: dropdownValue,
                                                      icon: Icon(Icons
                                                          .arrow_drop_down),
                                                      iconSize: 28,
                                                      elevation: 16,
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 16,
                                                          fontFamily: 'Poppins',
                                                          fontWeight:
                                                              FontWeight.w400),
                                                      // underline: Container(
                                                      //   height: 2,
                                                      //   color: Colors.deepPurpleAccent,
                                                      // ),
                                                      onChanged: (String data) {
                                                        setState(() {
                                                          dropdownValue = data;
                                                        });
                                                      },
                                                      items: spinnerItems.map<
                                                              DropdownMenuItem<
                                                                  String>>(
                                                          (String value) {
                                                        return DropdownMenuItem<
                                                            String>(
                                                          value: value,
                                                          child: Text(value),
                                                        );
                                                      }).toList(),
                                                    )))))),

                            //for app button
                           AppButton(
                                  onPressed: () {
                                if(formattedString==""){
                                  _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text('Please check atleast one order')));
                                }else
                                {
                                  if(dropdownValue=="Ready"){
                                    Orderstatus=1;
                                  }else if(dropdownValue=="Shipped"){
                                    Orderstatus=2;
                                  }else if(dropdownValue=="Delivered"){
                                    Orderstatus=3;
                                  }
                                  _fleetOrdersBloc.add(UpdateFleetOrdersStatus(
                                      orderid: formattedString,
                                      status: Orderstatus.toString()
                                  ));
                                }

                              },
                              shape: const RoundedRectangleBorder(
                              borderRadius:
                              BorderRadius.all(Radius.circular(50))),
                              text: 'Submit',
                              disableTouchWhenLoading: false,
                              loading: status is FleetOrdersStatusLoading,
              ),


                          ],
                        ))),
              ],
            ),
          ));
        }));
  }
}
