import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:orderly/Blocs/fleetOrders/fleetOrders_bloc.dart';
import 'package:orderly/Blocs/fleetOrders/fleetOrders_event.dart';
import 'package:orderly/Blocs/fleetOrders/fleetOrders_state.dart';
import 'package:orderly/Configs/image.dart';
import 'package:orderly/Configs/theme.dart';
import 'package:orderly/Models/model_fleetOrder_det.dart';
import 'package:orderly/Screens/Customer/orders/order_list_item.dart';
import 'package:orderly/Screens/Customer/orders/orders_filter.dart';
import 'package:orderly/Screens/FleetManager/orders/fleet_orders.dart';
import 'package:orderly/Screens/mainNavigation.dart';
import 'package:orderly/Utils/connectivity_check.dart';
import 'package:orderly/Utils/other.dart';
import 'package:orderly/Utils/routes.dart';
import 'package:orderly/Utils/translate.dart';
import 'package:orderly/Utils/validate.dart';
import 'package:orderly/Widgets/app_button.dart';
import 'package:orderly/Widgets/app_dialogs.dart';
import 'package:orderly/Widgets/app_text_input.dart';
import 'package:readmore/readmore.dart';
import 'package:shimmer/shimmer.dart';

class OrderDetails extends StatefulWidget {
  String orderId,producerId,statusName;
  int status;
  OrderDetails({Key key,@required this.orderId,@required this.status,@required this.producerId,@required this.statusName}):super(key: key);

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
  UserData _fleetUserData;
  int offset = 0, Orderstatus = 0;
  String formattedString="",_validCancel="";
  final _textCancelController = TextEditingController();
  final _focusCancel = FocusNode();


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    flagNoData = false;
    // _fleetUserData=new UserData();
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

  //show CancelledPopup
  Future<void> _showCancelledPopUp(int orderstatus) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
              "Cancel Reason",
              style:TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w400,
                  color: AppTheme.textColor
              )
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
              AppTextInput(
              enabled: true,
                hintText: Translate.of(context).translate('input_reason'),
                // errorText: Translate.of(context).translate(_validCancel),
              icon: Icon(Icons.clear),
              controller: _textCancelController,
              focusNode: _focusCancel,
              textInputAction: TextInputAction.next,
              onChanged: (text) {
                setState(() {
                  _validCancel = UtilValidator.validate(
                    data: _textCancelController.text,
                  );
                });
              },
                onTapIcon: () async {
                  await Future.delayed(Duration(milliseconds: 100));
                  _textCancelController.clear();
                },
              ),

          ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              height: 30.0,
              minWidth: 60.0,
              color: AppTheme.appColor,
              child: Text(
                "OK",
                style: TextStyle(fontSize: 14.0,fontWeight: FontWeight.w500,fontFamily: "Poppins",
                color: Colors.white),
              ),
              onPressed: () {
        UtilOther.hiddenKeyboard(context);
        if(_textCancelController.text.isEmpty){
          Fluttertoast.showToast(msg: "Please enter reason");
        }else {
          _fleetOrdersBloc.add(
              UpdateFleetOrdersStatus(
                  orderid: formattedString,
                  status: orderstatus.toString(),
                rejectReason:_textCancelController.text
              ));
        }

        },
            ),
          ],
        );
      },
    );
  }


  void getDataAsPerStatus(int status){
    print(widget.status);
    if(widget.status==0){

      dropdownValue='Ready';
      spinnerItems= [
        'Ready',
        'Shipped',
        'Delivered',
        'Cancel'
      ];
    }else if(widget.status==1){
      dropdownValue='Shipped';
      spinnerItems= [
        'Shipped',
        'Delivered',
        'Cancel'

      ];
    }else if(widget.status==2){
      dropdownValue='Delivered';
      spinnerItems= [
        'Delivered',
        'Cancel'
      ];
    }else if(widget.status==4){ //Return
      dropdownValue='Return Confirmed';
      spinnerItems= [
        'Return Confirmed',
        'Return Rejected'
      ];
    }else if(widget.status==5){ //Replace
      dropdownValue='Replace Confirmed';
      spinnerItems= [
        'Replace Confirmed',
        'Replace Rejected'
      ];
    }else if(widget.status==7){ //Return from ready(same as below)
      dropdownValue='Return Shipped';
      spinnerItems= [
        'Return Shipped',
        'Return Delivered',
        'Return Rejected'
      ];
    }else if(widget.status==9){ //Replace from ready(once it is confirmed from return and replace list)
      dropdownValue='Return Delivered';
      spinnerItems= [
        'Return Delivered',
      ];
    }
    else if(widget.status==11){ //Replace from ready(once it is confirmed from return and replace list)
      dropdownValue='Replace Shipped';
      spinnerItems= [
        'Replace Shipped',
        'Replace Delivered',
        'Replace Rejected'
      ];
    }else if(widget.status==13){ //Replace from ready(once it is confirmed from return and replace list)
      dropdownValue='Replace Delivered';
      spinnerItems= [
        'Replace Delivered',
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
              widget.status==3 || widget.status==10||widget.status==14 ||widget.status==6
              ||widget.status==8 ||widget.status==12
            ?
              Padding(
                  padding: EdgeInsets.all(5.0),
                  child:Column(
                    children: [
                      Row(
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
                                    fleetOrderDetList[index].ratePerHour.toString()+" \u{20B9} hr",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 13.0,
                                        fontFamily: 'Poppins',
                                        color: AppTheme.appColor),
                                    // )
                                  ),
                                  //quantity
                                  Text(
                                      "Quantity: "+fleetOrderDetList[index].qty.toString(),
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 13.0,
                                        fontFamily: 'Poppins',
                                        color: AppTheme.textColor),
                                    // )
                                  ),
                                ],
                              )),
                        ],
                      ),
                      if(widget.status==6 ||widget.status==8 || widget.status==12)
                        Column(
                          children: [
                            //for order type
                            Card(
                                elevation: 2.0,
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
                                        "Order Type : ",
                                        style: TextStyle(
                                            fontSize: 14.0,
                                            fontWeight: FontWeight.w400,
                                            fontFamily: 'Poppins',
                                            color: AppTheme.textColor),
                                      ),
                                      Expanded(child:Text(
                                        widget.statusName,
                                        style: TextStyle(
                                            fontSize: 14.0,
                                            fontWeight: FontWeight.w400,
                                            fontFamily: 'Poppins',
                                            color: AppTheme.appColor),
                                      )),
                                    ],
                                  ),
                                )),
                            SizedBox(height: 0.5,),
                            //for cancel reason
                            Card(
                                elevation: 2.0,
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
                                        "Cancel Reason : ",
                                        style: TextStyle(
                                            fontSize: 14.0,
                                            fontWeight: FontWeight.w400,
                                            fontFamily: 'Poppins',
                                            color: AppTheme.textColor),
                                      ),
                                      Expanded(child:Text(
                                        fleetOrderDetList[index].rejectReason==null?"":fleetOrderDetList[index].rejectReason,
                                        style: TextStyle(
                                            fontSize: 14.0,
                                            fontWeight: FontWeight.w400,
                                            fontFamily: 'Poppins',
                                            color: AppTheme.appColor),
                                      )),
                                    ],
                                  ),
                                ))
                          ],
                        )
                    ],
                  )
                )
              :
          CheckboxListTile(
            activeColor: Theme.of(context).primaryColor,
            title:
            Padding(
                padding: EdgeInsets.all(5.0),
                child:
                    Column(
                      children: [
                        Row(
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
                                      fleetOrderDetList[index].ratePerHour.toString()+" \u{20B9} hr",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 13.0,
                                          fontFamily: 'Poppins',
                                          color: AppTheme.appColor),
                                      // )
                                    ),
                                    //quantity
                                    Text(
                                      "Quantity: "+fleetOrderDetList[index].qty.toString(),
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 13.0,
                                          fontFamily: 'Poppins',
                                          color: AppTheme.textColor),
                                      // )
                                    ),
                                  ],
                                )),
                          ],
                        ),
                        if(widget.status==4 ||widget.status==5)
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
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
                                  fleetOrderDetList[index].returnTitle,
                                  style: TextStyle(
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.w400,
                                      fontFamily: 'Poppins',
                                      color: AppTheme.appColor),
                                )),
                              ],
                            ),
                            SizedBox(height: 5.0,),
                            Row(
                              children: [
                                Text(
                                  "Reviews : ",
                                  style: TextStyle(
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.w400,
                                      fontFamily: 'Poppins',
                                      color: AppTheme.textColor),
                                ),
                                Expanded(child:ReadMoreText(
                                  fleetOrderDetList[index].review==""?"No Reviews Found":fleetOrderDetList[index].review,
                                  trimLines: 2,
                                  trimMode: TrimMode.Line,
                                  trimCollapsedText: 'Show more',
                                  trimExpandedText: 'Show less',
                                  style: TextStyle(
                                      fontSize: 12.0,
                                      fontFamily: 'Poppins',
                                      color: AppTheme.textColor,
                                      fontWeight: FontWeight.w400),

                                ))
                              ],
                            )
                          ],
                        )

                      ],
                    )

            ),
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
    print("buildStatus:-"+widget.status.toString());
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
                  _fleetUserData=state.fleetUserData;
                  print(_fleetUserData);
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
                  if(Orderstatus!=6 && Orderstatus!=12 && Orderstatus!=8){
                    _showMessage("Order Status Updated successfully.");

                  }else{
                    Navigator.pop(context);
                    Fluttertoast.showToast(msg: "Order Status Updated successfully.");
                    Navigator.pushNamed(context, Routes.mainNavi);
                  }
                }
                if(state is FleetOrdersStatusLoadFail){
                  _showMessage("Order Status Failed.");
                }
              },
              child:
              Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child:
                widget.status!=3 && widget.status!=10 && widget.status!=14 && widget.status!=6
                && widget.status!=8 && widget.status!=12
                  ?
            Stack(
              children: [
                Padding(
                    padding: EdgeInsets.only(bottom: 150.0),
                    child:
                    Column(
                        children: [
                        //for customer info
                          if(_fleetUserData!=null)
                        Card(
                        elevation: 5.0,
                        child:
                        Theme(
                            data: Theme.of(context).copyWith(
                              unselectedWidgetColor: Theme.of(context).primaryColor, // here for close state
                              // colorScheme: ColorScheme.light(
                              //   primary: Theme.of(context).primaryColor,
                              // ), // here for open state in replacement of deprecated accentColor
                              // dividerColor: Colors.transparent, // if you want to remove the border
                            ),child:ExpansionTile(
                          // trailing:Icon(
                          //   Icons.keyboard_arrow_down,
                          //   color: Theme.of(context).primaryColor,
                          // ),
                          title: Padding(
                            padding: const EdgeInsets.only(
                              top: 5,
                            ),
                            child:
                            Row(
                              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text( "Customer Info ",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 14.0,
                                            fontFamily: 'Poppins',
                                            color: AppTheme.appColor),
                                      ),
                            // IconButton(
                            //     icon: Image.asset(Images.arrow,height: 15.0,width:15.0)
                            // )
                              ]
                          )),
                          children: [
                          Padding(
                            padding:EdgeInsets.only(left: 15.0,bottom: 10.0,right:10.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      //name
                                      Text(
                                        "Name: ",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 14.0,
                                            fontFamily: 'Poppins',
                                            color: AppTheme.textColor),
                                        // )
                                      ),
                                      Text(
                                        _fleetUserData.userName,
                                        style: TextStyle(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 13.0,
                                            fontFamily: 'Poppins',
                                            color: AppTheme.textColor),
                                        // )
                                      ),
                                    ]),
                                SizedBox(height: 5.0,),
                                //address
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Address: ",
                                      // softWrap: true,
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 13.0,
                                          fontFamily: 'Poppins',
                                          color: AppTheme.textColor),
                                      // )
                                    ),
                                    Flexible(child:Text(
                                      _fleetUserData.streetNo+","+_fleetUserData.flatNo+","+_fleetUserData.address+","+_fleetUserData.city,
                                      // softWrap: true,

                                      style: TextStyle(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 13.0,
                                          fontFamily: 'Poppins',
                                          color: AppTheme.textColor),
                                    )
                                    ),
                                  ],
                                ),
                                SizedBox(height: 5.0,),
                                //mobile
                                Row(
                                  children: [
                                    Text(
                                      "Mobile: ",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 13.0,
                                          fontFamily: 'Poppins',
                                          color: AppTheme.textColor),
                                      // )
                                    ),
                                    Text(
                                      _fleetUserData.mobile,
                                      style: TextStyle(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 13.0,
                                          fontFamily: 'Poppins',
                                          color: AppTheme.textColor),
                                      // )
                                    ),
                                  ],
                                ),
                                SizedBox(height:5.0,),
                                //email
                                Row(
                                  children: [
                                    Text(
                                      "Email: ",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 13.0,
                                          fontFamily: 'Poppins',
                                          color: AppTheme.textColor),
                                      // )
                                    ),
                                    Text(
                                      _fleetUserData.emailId,
                                      style: TextStyle(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 13.0,
                                          fontFamily: 'Poppins',
                                          color: AppTheme.textColor),
                                      // )
                                    ),
                                  ],
                                )
                              ],
                            ),
                          )
                                ],
                        ))
                        ),
                    SizedBox(height: 8.0,),
                    Expanded(child:ListView.builder(
                        itemCount:_fleetOrderDetList!=null?_fleetOrderDetList.length:6,
                        itemBuilder: (context, index) {
                          return buildOrderList(index,_fleetOrderDetList);
                        }))
              ])),

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
                                  }else if(dropdownValue=="Cancel"){
                                    Orderstatus=6;
                                  }
                                  else if(dropdownValue=="Return Confirmed"){
                                    Orderstatus=7;

                                  }else if(dropdownValue=="Return Shipped"){
                                    Orderstatus=9;

                                  }
                                  else if(dropdownValue=="Return Rejected"){
                                    Orderstatus=8;

                                  }else if(dropdownValue=="Return Delivered"){
                                    Orderstatus=10;

                                  }else if(dropdownValue=="Replace Confirmed"){
                                    Orderstatus=11;

                                  }
                                  else if(dropdownValue=="Replace Rejected"){
                                    Orderstatus=12;

                                  }else if(dropdownValue=="Replace Shipped"){
                                    Orderstatus=13;

                                  }else if(dropdownValue=="Replace Delivered"){
                                    Orderstatus=14;

                                  }
                                  if(Orderstatus==6 || Orderstatus==8 ||Orderstatus==12){
                                    _showCancelledPopUp(Orderstatus);
                                  }else {
                                    _fleetOrdersBloc.add(
                                        UpdateFleetOrdersStatus(
                                            orderid: formattedString,
                                            status: Orderstatus.toString(),
                                          rejectReason:""
                                        ));
                                  }
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
            )
                    :
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //for customer info
                        if(_fleetUserData!=null)
                          Card(
                              elevation: 5.0,
                              child:
                              Theme(
                                  data: Theme.of(context).copyWith(
                                    unselectedWidgetColor: Theme.of(context).primaryColor, // here for close state
                                    // colorScheme: ColorScheme.light(
                                    //   primary: Theme.of(context).primaryColor,
                                    // ), // here for open state in replacement of deprecated accentColor
                                    // dividerColor: Colors.transparent, // if you want to remove the border
                                  ),child:ExpansionTile(
                                // trailing:Icon(
                                //   Icons.keyboard_arrow_down,
                                //   color: Theme.of(context).primaryColor,
                                // ),
                                title: Padding(
                                    padding: const EdgeInsets.only(
                                      top: 5,
                                    ),
                                    child:
                                    Row(
                                      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text( "Customer Info ",
                                            style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 14.0,
                                                fontFamily: 'Poppins',
                                                color: AppTheme.appColor),
                                          ),
                                          // IconButton(
                                          //     icon: Image.asset(Images.arrow,height: 15.0,width:15.0)
                                          // )
                                        ]
                                    )),
                                children: [
                                  Padding(
                                    padding:EdgeInsets.only(left: 15.0,bottom: 10.0,right:10.0),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Row(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              //name
                                              Text(
                                                "Name: ",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 14.0,
                                                    fontFamily: 'Poppins',
                                                    color: AppTheme.textColor),
                                                // )
                                              ),
                                              Text(
                                                _fleetUserData.userName,
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 13.0,
                                                    fontFamily: 'Poppins',
                                                    color: AppTheme.textColor),
                                                // )
                                              ),
                                            ]),
                                        SizedBox(height: 5.0,),
                                        //address
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Address: ",
                                              // softWrap: true,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 13.0,
                                                  fontFamily: 'Poppins',
                                                  color: AppTheme.textColor),
                                              // )
                                            ),
                                            Flexible(child:Text(
                                              _fleetUserData.streetNo+","+_fleetUserData.flatNo+","+_fleetUserData.address+","+_fleetUserData.city,
                                              // softWrap: true,

                                              style: TextStyle(
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 13.0,
                                                  fontFamily: 'Poppins',
                                                  color: AppTheme.textColor),
                                            )
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 5.0,),
                                        //mobile
                                        Row(
                                          children: [
                                            Text(
                                              "Mobile: ",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 13.0,
                                                  fontFamily: 'Poppins',
                                                  color: AppTheme.textColor),
                                              // )
                                            ),
                                            Text(
                                              _fleetUserData.mobile,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 13.0,
                                                  fontFamily: 'Poppins',
                                                  color: AppTheme.textColor),
                                              // )
                                            ),
                                          ],
                                        ),
                                        SizedBox(height:5.0,),
                                        //email
                                        Row(
                                          children: [
                                            Text(
                                              "Email: ",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 13.0,
                                                  fontFamily: 'Poppins',
                                                  color: AppTheme.textColor),
                                              // )
                                            ),
                                            Text(
                                              _fleetUserData.emailId,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 13.0,
                                                  fontFamily: 'Poppins',
                                                  color: AppTheme.textColor),
                                              // )
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ))
                          ),
                        SizedBox(height: 8.0,),
                        Expanded(child:ListView.builder(
                            itemCount:_fleetOrderDetList!=null?_fleetOrderDetList.length:6,
                            itemBuilder: (context, index) {
                              return buildOrderList(index,_fleetOrderDetList);
                            })),
                      ],
                    )

          ));
        }));
  }
}
