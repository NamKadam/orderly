import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:orderly/Blocs/custorderDet/bloc.dart';
import 'package:orderly/Configs/theme.dart';
import 'package:orderly/Models/model_myOrders.dart';
import 'package:orderly/Models/model_return_reason.dart';
import 'package:orderly/Screens/mainNavigation.dart';
import 'package:orderly/Utils/Utils.dart';
import 'package:orderly/Utils/application.dart';
import 'package:orderly/Utils/connectivity_check.dart';
import 'package:orderly/Utils/translate.dart';
import 'package:orderly/Widgets/app_button.dart';
import 'package:orderly/Widgets/app_dialogs.dart';
import 'package:readmore/readmore.dart';
import 'package:shimmer/shimmer.dart';

enum ReturnReasons { peformance, damage, arrivedLate, wrongItem, extraItem }

class ReturnReplace extends StatefulWidget {
  Orders orderData;
  ReturnReplace({Key key,@required this.orderData}):super(key: key);
  _ReturnReplaceState createState() => _ReturnReplaceState();
}

class _ReturnReplaceState extends State<ReturnReplace> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _textAddReviewController = TextEditingController();
  final _focusReview = FocusNode();
  String _validAddReview = "";
  CustOrderDetBloc _custOrderDetBloc;
  List<Reasons> _reasonList;
  bool isconnectedToInternet = false,isFirstTimeChecked=true;
  String radioItem = '';
  int pos=0,id=1,status=4;
  String radioType='Return'; //by default selected


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _custOrderDetBloc = BlocProvider.of<CustOrderDetBloc>(context);
    setBlocData();

  }

  void setBlocData() async {
    isconnectedToInternet = await ConnectivityCheck.checkInternetConnectivity();
    if (isconnectedToInternet == true) {
      _custOrderDetBloc.add(getReturnOrderReason());
    } else {
      CustomDialogs.showDialogCustom(
          "Internet", "Please check your Internet Connection!", context);
    }
  }

  Future<void> _showMessage(String message) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            status==4?"Return Order":"Replace Order",
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
                  "OK"
              ),
              onPressed: () {
               Navigator.push(context, MaterialPageRoute(builder: (context)=>MainNavigation(flagOrder: "1")));
              },
            ),
          ],
        );
      },
    );
  }


  Widget buildReasonList(int index,List<Reasons> _reasonList){
    if(_reasonList==null){
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
                    width: 20,
                    height: 20,
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
        itemCount: 3,
      );
    }

    return Theme(
          data: Theme.of(context).copyWith(
            unselectedWidgetColor:
            Theme.of(context)
                .primaryColor,
          ),
          child: RadioListTile(
            activeColor: Theme.of(context)
                .primaryColor,
            title:
            Text(
             _reasonList[index].reason,
              style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontFamily: 'Poppins',
                  fontSize: 14.0,
                  color: AppTheme.textColor),
            ),
            value:_reasonList[index].reasonId,
            groupValue:id,
            onChanged: (val) {
              setState(() {
                pos=index;
                radioItem = _reasonList[index].reason;
                id = _reasonList[index].reasonId;
                print(radioItem + " " + id.toString());
                isFirstTimeChecked=!isFirstTimeChecked;//for first index checked radio
                _reasonList[index].ischecked=true;
              });
            },
          ),
        );
  }


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return WillPopScope( //willpopscope is used for ios part to disable swipe where back button is used
        onWillPop: () async => false,
    child:
      Scaffold(
      key: _scaffoldKey,
      appBar: new AppBar(
        title: Text(
          Translate.of(context).translate('return_replace'),
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
      BlocBuilder<CustOrderDetBloc,CustOrdersDetState>(builder: (context,order){
        return BlocListener<CustOrderDetBloc,CustOrdersDetState>(listener: (context,state){
          if(state is ReturnReasonSuccess){
            _reasonList=state.reasonList;
          }

          if(state is ReturnReplaceSuccess){
            if(status==4){
              _showMessage("Order returned successfully");
            }else {
              _showMessage("Order replaced successfully");
            }
            // _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text("Order returned successfully"),));

            // Navigator.pop(context);
          }
        },
        child: SafeArea(
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
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CachedNetworkImage(
                                    filterQuality: FilterQuality.medium,
                                    // imageUrl: Api.PHOTO_URL + widget.users.avatar,
                                    // imageUrl:
                                    // "https://images.unsplash.com/photo-1438761681033-6461ffad8d80?ixid=MXwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=1050&q=80",
                                    imageUrl: widget.orderData.imgPaths == null
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
                                            borderRadius:
                                            BorderRadius.circular(8),
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
                                          borderRadius:
                                          BorderRadius.circular(8),
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
                                            borderRadius:
                                            BorderRadius.circular(8),
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
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            widget.orderData.productName,
                                            style: Theme.of(context)
                                                .textTheme
                                                .caption
                                                .copyWith(
                                                fontSize: 14.0,
                                                fontWeight: FontWeight.w600,
                                                color: Theme.of(context)
                                                    .primaryColor,
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
                                                fontSize: 12.0,
                                                color: AppTheme.textColor,
                                                fontWeight: FontWeight.w500,
                                                fontFamily: "Poppins"),
                                          ),
                                          Text(
                                            // widget.users.address != null
                                            //     ? widget.users.address
                                            //     : "",
                                            "Quantity: "+widget.orderData.qty.toString(),
                                            style: Theme.of(context)
                                                .textTheme
                                                .button
                                                .copyWith(
                                                fontSize: 10.0,
                                                color: AppTheme.textColor,
                                                fontWeight: FontWeight.w300,
                                                fontFamily: "Poppins"),
                                          ),
                                        ],
                                      )),
                                ],
                              )),
                        )),
                  ),
                )),
            SizedBox(height: 5.0,),
            //return reason
            Card(
                elevation: 0.0,
                color: Colors.white,
                child:Padding(
                    padding: EdgeInsets.only(left:10.0,top:5.0,bottom:5.0),
                    child:
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'What type you want to perform?',
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontSize: 14.0,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Row(
                          children: [
                            Expanded(
                              child:
                              Theme(
                                  data: Theme.of(context).copyWith(
                                    unselectedWidgetColor: Theme.of(context).primaryColor,
                                  ),
                                  child:RadioListTile(
                                    activeColor: Theme.of(context).primaryColor,
                                    groupValue: radioType,
                                    title: Text('Return',
                                      style: Theme.of(context)
                                          .textTheme
                                          .subtitle2
                                          .copyWith(fontWeight: FontWeight.w500,fontFamily:'Poppins',color: AppTheme.textColor),),
                                    value: 'Return',
                                    onChanged: (val) {

                                      setState(() {
                                        radioType = val;
                                        status=4;
                                      });
                                    },
                                  )),
                            ),

                            Expanded(
                              child:
                              Theme(
                                  data: Theme.of(context).copyWith(
                                    unselectedWidgetColor: Theme.of(context).primaryColor,
                                  ),
                                  child:RadioListTile(
                                    activeColor: Theme.of(context).primaryColor,
                                    groupValue: radioType,
                                    title: Text('Replace',
                                      style: Theme.of(context)
                                          .textTheme
                                          .subtitle2
                                          .copyWith(fontWeight: FontWeight.w500,fontFamily:'Poppins',color: AppTheme.textColor),),
                                    value: 'Replace',
                                    onChanged: (val) {
                                      setState(() {
                                        radioType = val;
                                        status=5;
                                      });
                                    },
                                  )),
                            )
                          ],
                        ),
                      ],
                    )


                )),
            SizedBox(height: 5.0,),
            Container(
                color: Colors.white,
                child: Card(
                    color: Colors.white,
                    elevation: 0.0,
                    child:
                    Padding(
                        padding: EdgeInsets.all(10.0),
                        child:
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [


                            Padding(
                                padding: EdgeInsets.only(left:10.0,bottom: 10.0),
                                child: Text(
                                  'Why are you returning this?',
                                  style: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                    fontSize: 14.0,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w500,
                                  ),
                                )),
                            Card(
                                elevation: 5.0,
                                child: ListView.builder(
                                    physics: NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: _reasonList!=null?_reasonList.length:3,
                                    itemBuilder: (context, index) {
                                      return buildReasonList(index, _reasonList);
                                    }))
                          ],
                        )
                    ))),
            // ReturnReason(reasons: _reasonList,index: index,),
            SizedBox(height: 5.0,),
            Container(
              color: Colors.white,
              child: Padding(
                padding: EdgeInsets.all(15.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      Translate.of(context).translate('writen_review'),
                      style: TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Poppins',
                          color: Theme.of(context).primaryColor),
                    ),
                    SizedBox(
                      height: 8.0,
                    ),
                    Container(
                        decoration: BoxDecoration(
                          border:
                          Border.all(color: Colors.grey.withOpacity(0.4)),
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: TextField(
                          textAlignVertical: TextAlignVertical.center,
                          controller: _textAddReviewController,
                          focusNode: _focusReview,
                          keyboardType: TextInputType.text,
                          maxLines: 4,
                          style: TextStyle(
                              fontSize: 12.0,
                              fontFamily: 'Poppins',
                              color: AppTheme.textColor,
                              fontWeight: FontWeight.w400),
                          decoration: InputDecoration(
                            counterText: "",
                            hintText:
                            Translate.of(context).translate('hint_review'),
                            hintStyle: TextStyle(color: AppTheme.textColor),
                            border: InputBorder.none,
                          ),
                        )),



                  ],
                ),
              ),
            ),
            SizedBox(height: 5.0,),

            //submit
            Container(

                color: Colors.white,
                child:
                Padding(
                    padding: EdgeInsets.all(15.0),
                    child: AppButton(
                      disableTouchWhenLoading: false,
                      loading: order is CustOrdersDetLoading,
                      shape: const RoundedRectangleBorder(
                          borderRadius:
                          BorderRadius.all(Radius.circular(50))),
                      text: "SUBMIT",
                      onPressed: () {
                        _custOrderDetBloc.add(sendReturnReplace(
                            orderNum: widget.orderData.orderNumber,
                            returnType: _reasonList[pos].reasonId.toString(),
                            returnTitle: _reasonList[pos].reason,
                            review: _textAddReviewController.text,
                            orderdetailsId: widget.orderData.orderDetailsId.toString(),
                            prodId: widget.orderData.productId.toString(),
                            fbId: Application.user.fbId,
                            status: status.toString()
                        ));
                      },
                    )))
          ],
        ),
        ),
        )
          );




      })

    ));
  }
}

class ReturnReason extends StatefulWidget {
  List<Reasons> reasons;
  int index;
  ReturnReason({Key key,@required this.reasons,@required this.index}):super(key: key);
  _ReturnReasonState createState() => _ReturnReasonState();
}

class _ReturnReasonState extends State<ReturnReason> {
  ReturnReasons _returnReason = ReturnReasons.peformance;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return
      Container(
        color: Colors.white,
        child: Card(
            color: Colors.white,
            elevation: 0.0,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                      padding: EdgeInsets.only(left: 15.0, right: 15.0, top: 10.0),
                      child: Text(
                        'Why are you returning this?',
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 14.0,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w400,
                        ),
                      )),
                  Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Card(
                      elevation: 5.0,
                      child: Column(
                        children: [
                          // OrderList.map((data) =>
                          //     Theme(
                          //   data: Theme.of(context).copyWith(
                          //     unselectedWidgetColor:
                          //     Theme.of(context).primaryColor,
                          //   ),
                          //   child: RadioListTile(
                          //     activeColor: Theme.of(context).primaryColor,
                          //     title: Text(
                          //       "${data.name}",
                          //       style: TextStyle(
                          //           fontWeight: FontWeight.w400,
                          //           fontSize: 14.0,
                          //           fontFamily: 'Poppins',
                          //           color: AppTheme.textColor),
                          //       // )
                          //     ),
                          //     secondary: IconButton(
                          //         onPressed: () {},
                          //         icon: Image.asset(Images.arrow,
                          //             height: 15.0, width: 15.0)),
                          //     //for trailing icon
                          //     value: data.index,
                          //     groupValue: id,
                          //     onChanged: (val) {
                          //       setState(() {
                          //         radioItem = data.name;
                          //         id = data.index;
                          //       });
                          //     },
                          //   ),
                          // )).toList(),

                          // radio 1
                          // Theme(
                          //     data: Theme.of(context).copyWith(
                          //       unselectedWidgetColor:
                          //       Theme.of(context).primaryColor,
                          //     ),
                          //     child: RadioListTile<ReturnReason>(
                          //       activeColor: Theme.of(context).primaryColor,
                          //       title: Text(
                          //         Translate.of(context).translate('performance'),
                          //         style: TextStyle(
                          //             fontWeight: FontWeight.w400,
                          //             fontFamily: 'Poppins',
                          //             fontSize: 14.0,
                          //             color: AppTheme.textColor),
                          //         // )
                          //       ),
                          //
                          //       value: widget.reasons,
                          //       groupValue: _returnReason,
                          //       onChanged: (ReturnReasons value) {
                          //         setState(() {
                          //           _returnReason = value;
                          //         });
                          //       },
                          //     )),
                          // Divider(
                          //   height: 0.5,
                          //   color: Colors.black26,
                          // ),
                          // //radio 2
                          // Theme(
                          //     data: Theme.of(context).copyWith(
                          //       unselectedWidgetColor:
                          //       Theme.of(context).primaryColor,
                          //     ),
                          //     child: RadioListTile<ReturnReasons>(
                          //       activeColor: Theme.of(context).primaryColor,
                          //       title: Text(
                          //         Translate.of(context).translate('damage'),
                          //         style: TextStyle(
                          //             fontWeight: FontWeight.w400,
                          //             fontSize: 14.0,
                          //             fontFamily: 'Poppins',
                          //             color: AppTheme.textColor),
                          //         // )
                          //       ),
                          //
                          //       value: ReturnReasons.damage,
                          //       groupValue: _returnReason,
                          //       onChanged: (ReturnReasons value) {
                          //         setState(() {
                          //           _returnReason = value;
                          //           print("value" + _returnReason.toString());
                          //         });
                          //       },
                          //     )),
                          // Divider(
                          //   height: 0.5,
                          //   color: Colors.black26,
                          // ),
                          // //radio 3
                          // Theme(
                          //     data: Theme.of(context).copyWith(
                          //       unselectedWidgetColor:
                          //       Theme.of(context).primaryColor,
                          //     ),
                          //     child: RadioListTile<ReturnReasons>(
                          //       activeColor: Theme.of(context).primaryColor,
                          //       title: Text(
                          //         Translate.of(context).translate('item_arrived'),
                          //         style: TextStyle(
                          //             fontWeight: FontWeight.w400,
                          //             fontSize: 14.0,
                          //             fontFamily: 'Poppins',
                          //             color: AppTheme.textColor),
                          //         // )
                          //       ),
                          //       value: ReturnReasons.arrivedLate,
                          //       groupValue: _returnReason,
                          //       onChanged: (ReturnReasons value) {
                          //         setState(() {
                          //           _returnReason = value;
                          //           print("value" + _returnReason.toString());
                          //         });
                          //       },
                          //     )),
                          // Divider(
                          //   height: 0.5,
                          //   color: Colors.black26,
                          // ),
                          // //radio 4
                          // Theme(
                          //     data: Theme.of(context).copyWith(
                          //       unselectedWidgetColor:
                          //       Theme.of(context).primaryColor,
                          //     ),
                          //     child: RadioListTile<ReturnReasons>(
                          //       activeColor: Theme.of(context).primaryColor,
                          //       title: Text(
                          //         Translate.of(context).translate('wrong_item'),
                          //         style: TextStyle(
                          //             fontWeight: FontWeight.w400,
                          //             fontSize: 14.0,
                          //             fontFamily: 'Poppins',
                          //             color: AppTheme.textColor),
                          //         // )
                          //       ),
                          //       //for trailing icon
                          //       value: ReturnReasons.wrongItem,
                          //       groupValue: _returnReason,
                          //       onChanged: (ReturnReasons value) {
                          //         setState(() {
                          //           _returnReason = value;
                          //           print("value" + _returnReason.toString());
                          //         });
                          //       },
                          //     )),
                          //
                          // Divider(
                          //   height: 0.5,
                          //   color: Colors.black26,
                          // ),
                          // //radio 5
                          // Theme(
                          //     data: Theme.of(context).copyWith(
                          //       unselectedWidgetColor:
                          //       Theme.of(context).primaryColor,
                          //     ),
                          //     child: RadioListTile<ReturnReasons>(
                          //       activeColor: Theme.of(context).primaryColor,
                          //       title: Text(
                          //         Translate.of(context).translate('extra_item'),
                          //         style: TextStyle(
                          //             fontWeight: FontWeight.w400,
                          //             fontSize: 14.0,
                          //             fontFamily: 'Poppins',
                          //             color: AppTheme.textColor),
                          //         // )
                          //       ),
                          //       //for trailing icon
                          //       value: ReturnReasons.wrongItem,
                          //       groupValue: _returnReason,
                          //       onChanged: (ReturnReasons value) {
                          //         setState(() {
                          //           _returnReason = value;
                          //           print("value:-" + value.toString());
                          //         });
                          //       },
                          //     )),
                        ],
                      ),
                    ),
                  ),

                ]))
      );
  }
}
