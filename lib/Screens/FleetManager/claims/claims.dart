import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:orderly/Blocs/claim/bloc.dart';
import 'package:orderly/Configs/image.dart';
import 'package:orderly/Configs/theme.dart';
import 'package:orderly/Models/model_claim.dart';
import 'package:orderly/Screens/Customer/orders/orders_filter.dart';
import 'package:orderly/Utils/application.dart';
import 'package:orderly/Utils/connectivity_check.dart';
import 'package:orderly/Widgets/app_dialogs.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shimmer/shimmer.dart';

import 'claims_filter.dart';

class Claims extends StatefulWidget {
  _ClaimsState createState() => _ClaimsState();
}

class _ClaimsState extends State<Claims> {
  String OrderNumber = 'OrderNumber';
  String date = '12 July 2021';
  String itemNumber = '04';
  String amount = '\u{20B9}1500';
  List<ClaimData> mArraylistClaim;
  List<ClaimData> searchClaimresult=[];

  bool flagNoData=false;
  ClaimOrdersBloc _claimOrdersBloc;
  bool isconnectedToInternet = false;
  String claimType="",receivedAmt="",refundedAmt="";
  final TextEditingController _searchcontroller = TextEditingController();
  bool _isSearching = false;
  final _controller = RefreshController(initialRefresh: false);



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    flagNoData=false;
    claimType="1";//for both recieved and refunded
    _claimOrdersBloc=BlocProvider.of<ClaimOrdersBloc>(context);
    setBlocData(claimType);
  }

  void setBlocData(String claimType) async {
    isconnectedToInternet = await ConnectivityCheck.checkInternetConnectivity();
    if (isconnectedToInternet == true) {
      _claimOrdersBloc.add(OnLoadingClaimOrdersList(producerId: Application.user.producerid,claimType:claimType ));
    } else {
      CustomDialogs.showDialogCustom(
          "Internet", "Please check your Internet Connection!", context);
    }
  }

  ///On Refresh List
  Future<void> _onRefresh() async {
    await Future.delayed(Duration(milliseconds: 1000));

    mArraylistClaim=null;
    searchClaimresult=[];
    setBlocData(claimType);
    _controller.refreshCompleted();
  }

  void _handleSearchStart() {
    setState(() {
      _isSearching = true;
    });
  }

  void searchOperation(String searchText) {
    searchClaimresult.clear();
    if (_isSearching != null && _searchcontroller.text.isNotEmpty) {
      for (int i = 0; i < mArraylistClaim.length; i++) {
        ClaimData claimData=new ClaimData();
        claimData.orderNumber=mArraylistClaim[i].orderNumber.toString();
        claimData.orderDetailsId=mArraylistClaim[i].orderDetailsId.toString();
        claimData.orderId=mArraylistClaim[i].orderId.toString();
        claimData.qty=mArraylistClaim[i].qty;
        claimData.total=mArraylistClaim[i].total;
        claimData.imgPaths=mArraylistClaim[i].imgPaths;
        claimData.orderDate=mArraylistClaim[i].orderDate;
        claimData.currentStatus=mArraylistClaim[i].currentStatus;


        if (claimData.orderNumber.toString().toLowerCase().contains(searchText.toLowerCase())
            ||claimData.qty.toString().toLowerCase().contains(searchText.toLowerCase())
            ||claimData.total.toString().toLowerCase().contains(searchText.toLowerCase())
            ||claimData.orderDate.toString().toLowerCase().contains(searchText.toLowerCase()) )
        {
          searchClaimresult.add(claimData);
        }
      }
      setState(() {

      });
    }else{
      _onRefresh();
    }

  }


  Widget buildClaimList(int index,List<ClaimData> _claimList){
    if(_claimList==null){
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

    return Container(
      padding: EdgeInsets.only(top: 2, bottom: 2),
      height: 170,
      width: double.infinity,
      child: Card(
        elevation: 0,
        child:
        Padding(
          padding: const EdgeInsets.all(20.0),
          child:
          Row(
            children: [
              Expanded(
                  flex: 1,
                  child:
                  CachedNetworkImage(
                    filterQuality: FilterQuality.medium,
                    // imageUrl: Api.PHOTO_URL + widget.users.avatar,
                    // imageUrl:
                    //     "https://images.unsplash.com/photo-1438761681033-6461ffad8d80?ixid=MXwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=1050&q=80",
                    imageUrl: _claimList[index].imgPaths == null
                        ? "https://images.unsplash.com/photo-1438761681033-6461ffad8d80?ixid=MXwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=1050&q=80"
                        : _claimList[index].imgPaths,
                    placeholder: (context, url) {
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
              ),
              Expanded(
                  flex: 2,
                  child: Padding(
                    padding:
                    const EdgeInsets.only(left: 20),
                    child: Column(
                      mainAxisAlignment:
                      MainAxisAlignment.start,
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children: [
                        Text(_claimList[index].orderNumber,
                            style: TextStyle(
                                fontSize: 14.0,
                                fontFamily: "Poppins",
                                fontWeight:
                                FontWeight.bold,
                                color:
                                AppTheme.textColor)),
                        Text(
                            // DateFormat('d MMM yyyy').format(DateTime.parse( _claimList[index].orderDate)),
                             _claimList[index].orderDate,
                            style: TextStyle(
                                fontSize: 14.0,
                                fontFamily: "Poppins",
                                fontWeight:
                                FontWeight.w500,
                                color:
                                AppTheme.textColor)),
                        Spacer(),
                        Text('No of items',
                            style: TextStyle(
                                fontSize: 14.0,
                                fontFamily: "Poppins",
                                fontWeight:
                                FontWeight.bold,
                                color:
                                AppTheme.textColor)),
                        Text(_claimList[index].qty,
                            style: TextStyle(
                                fontSize: 14.0,
                                fontFamily: "Poppins",
                                fontWeight:
                                FontWeight.w500,
                                color:
                                AppTheme.textColor))
                      ],
                    ),
                  )),
              Expanded(
                  flex: 1,
                  child: Column(
                    children: [
                      Text("\u{20B9} "+_claimList[index].total.toString(),
                          style: TextStyle(
                              fontSize: 14.0,
                              fontFamily: "Poppins",
                              fontWeight: FontWeight.w500,
                              color: AppTheme.textColor)),
                      Text(
                      _claimList[index].currentStatus==6 &&
                          _claimList[index].currentStatus==8 && _claimList[index].currentStatus==12
                          ?
                          "Refunded"
                      :"Recieved",
                          style: TextStyle(
                              fontSize: 14.0,
                              fontFamily: "Poppins",
                              fontWeight: FontWeight.bold,
                              color: AppTheme.textColor)),
                    ],
                  ))
            ],
          ),
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<ClaimOrdersBloc,ClaimOrdersState>(builder: (context,state){
        if(state is ClaimOrdersListSuccess){
          mArraylistClaim=state.claimList;
          receivedAmt=state.receivedAmt;
          refundedAmt=state.refundedAmt;
          flagNoData=false;
        }

        if(state is ClaimOrdersLoading){
          flagNoData=false;

        }

        if(state is ClaimOrdersListLoadFail){
          flagNoData=true;
        }
            return SafeArea(
                child:
            //     SmartRefresher(
            // enablePullDown: true,
            // onRefresh: _onRefresh,
            // controller: _controller,
            // child:
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    //for search and filter
                    Padding(
                        padding: EdgeInsets.only(
                            left: 15.0, right: 15.0, top: 10.0, bottom: 10.0),
                        child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: Colors.white,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    IconButton(
                                      icon: Image.asset(
                                        Images.search,
                                        width: 25.0,
                                        height: 25.0,
                                      ),
                                      onPressed: () {
                                        _handleSearchStart();

                                      },
                                    ),
                                    Container(
                                        margin: EdgeInsets.only(top: 5.0),
                                        width: 200.0,
                                        height: 45.0,
                                        child: TextFormField(
                                          controller: _searchcontroller,
                                          style: TextStyle(
                                              fontFamily: 'Poppins',
                                              color: AppTheme.textColor,
                                              fontSize: 14.0,
                                              fontWeight: FontWeight.w400),
                                          keyboardType: TextInputType.text,
                                          decoration: InputDecoration(
                                              border: InputBorder.none,
                                              hintText: "Search for all filters",
                                              hintStyle:
                                              TextStyle(color: AppTheme.textColor)),
                                          onChanged: (value) {
                                            print(value);
                                            searchOperation(value);

                                          },
                                        )),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Container(
                                      margin: EdgeInsets.only(right: 10.0),
                                      width: 1,
                                      height: 20.0,
                                      color: AppTheme.textColor,
                                    ),
                                    Text(
                                      'Filters',
                                      style: TextStyle(
                                          color: AppTheme.textColor,
                                          fontSize: 14.0,
                                          fontWeight: FontWeight.w400,
                                          fontFamily: 'Poppins'),
                                    ),
                                    IconButton(
                                      icon: Image.asset(
                                        Images.filter,
                                        width: 20.0,
                                        height: 20.0,
                                      ),
                                      onPressed: () async{
                                        final result=await Navigator.push(context, MaterialPageRoute(
                                                builder: (context) => ClaimsFilter()));
                                        if(result!=null){
                                          claimType=result;
                                          setBlocData(claimType);
                                        }
                                      },
                                    ),
                                  ],
                                )
                              ],
                            ))),
                    flagNoData==false
                        ?
                    Expanded(child:Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children:[
                    Container(
                      color: Colors.transparent,
                      height: 150,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Text('\$'+receivedAmt.toString(),
                          //     style: TextStyle(
                          //         fontSize: 20.0,
                          //         fontFamily: "Poppins",
                          //         fontWeight: FontWeight.bold,
                          //         color: AppTheme.textColor)),
                          // SizedBox(
                          //   height: 10.0,
                          // ),
                          // Text('Total Transaction last 30 Days',
                          //     style: TextStyle(
                          //         fontSize: 14.0,
                          //         fontFamily: "Poppins",
                          //         fontWeight: FontWeight.normal,
                          //         color: AppTheme.textColor)),
                          // SizedBox(
                          //   height: 20.0,
                          // ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width * 0.3,
                                height: 70.0,
                                decoration: BoxDecoration(
                                  color: Colors.white70,
                                  borderRadius: BorderRadius.circular(6.0),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text('\u{20B9}'+receivedAmt.toString(),
                                        style: TextStyle(
                                            fontSize: 14.0,
                                            fontFamily: "Poppins",
                                            fontWeight: FontWeight.w500,
                                            color: AppTheme.textColor)),
                                    Text('Recieved',
                                        style: TextStyle(
                                            fontSize: 14.0,
                                            fontFamily: "Poppins",
                                            fontWeight: FontWeight.w500,
                                            color: AppTheme.pinkColor))
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: 50.0,
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width * 0.3,
                                height: 70.0,
                                decoration: BoxDecoration(
                                  color: Colors.white70,
                                  borderRadius: BorderRadius.circular(6.0),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text('\u{20B9}'+refundedAmt.toString(),
                                        style: TextStyle(
                                            fontSize: 14.0,
                                            fontFamily: "Poppins",
                                            fontWeight: FontWeight.w500,
                                            color: AppTheme.textColor)),
                                    Text('Refunded',
                                        style: TextStyle(
                                            fontSize: 14.0,
                                            fontFamily: "Poppins",
                                            fontWeight: FontWeight.w500,
                                            color: AppTheme.appColor))
                                  ],
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                    Flexible(
                        child:Container(
                          // height: MediaQuery.of(context).size.height * 0.518,
                          child: searchClaimresult.length != 0 || _searchcontroller.text.isNotEmpty
                              ?
                          ListView.builder(
                              // scrollDirection: Axis.vertical,
                              // shrinkWrap: true,
                              itemCount: searchClaimresult!=null?searchClaimresult.length:6,
                              itemBuilder: (context, index) {
                                return buildClaimList(index,searchClaimresult);
                                // return Container(
                                //   padding: EdgeInsets.only(top: 2, bottom: 2),
                                //   height: 170,
                                //   width: double.infinity,
                                //   child: Card(
                                //     elevation: 0,
                                //     child:
                                //     Padding(
                                //       padding: const EdgeInsets.all(20.0),
                                //       child:
                                //       Row(
                                //         children: [
                                //           Expanded(
                                //               flex: 1,
                                //               child: ClipRRect(
                                //                   borderRadius:
                                //                       BorderRadius.circular(6),
                                //                   child: Image.asset(
                                //                     'assets/images/truck-img-square.png',
                                //                   ))),
                                //           Expanded(
                                //               flex: 2,
                                //               child: Padding(
                                //                 padding:
                                //                     const EdgeInsets.only(left: 20),
                                //                 child: Column(
                                //                   mainAxisAlignment:
                                //                       MainAxisAlignment.start,
                                //                   crossAxisAlignment:
                                //                       CrossAxisAlignment.start,
                                //                   children: [
                                //                     Text(OrderNumber,
                                //                         style: TextStyle(
                                //                             fontSize: 14.0,
                                //                             fontFamily: "Poppins",
                                //                             fontWeight:
                                //                                 FontWeight.bold,
                                //                             color:
                                //                                 AppTheme.textColor)),
                                //                     Text(date,
                                //                         style: TextStyle(
                                //                             fontSize: 14.0,
                                //                             fontFamily: "Poppins",
                                //                             fontWeight:
                                //                                 FontWeight.w500,
                                //                             color:
                                //                                 AppTheme.textColor)),
                                //                     Spacer(),
                                //                     Text('No of items',
                                //                         style: TextStyle(
                                //                             fontSize: 14.0,
                                //                             fontFamily: "Poppins",
                                //                             fontWeight:
                                //                                 FontWeight.bold,
                                //                             color:
                                //                                 AppTheme.textColor)),
                                //                     Text(itemNumber,
                                //                         style: TextStyle(
                                //                             fontSize: 14.0,
                                //                             fontFamily: "Poppins",
                                //                             fontWeight:
                                //                                 FontWeight.w500,
                                //                             color:
                                //                                 AppTheme.textColor))
                                //                   ],
                                //                 ),
                                //               )),
                                //           Expanded(
                                //               flex: 1,
                                //               child: Column(
                                //                 children: [
                                //                   Text(amount,
                                //                       style: TextStyle(
                                //                           fontSize: 14.0,
                                //                           fontFamily: "Poppins",
                                //                           fontWeight: FontWeight.w500,
                                //                           color: AppTheme.textColor)),
                                //                   Text('Received',
                                //                       style: TextStyle(
                                //                           fontSize: 14.0,
                                //                           fontFamily: "Poppins",
                                //                           fontWeight: FontWeight.bold,
                                //                           color: AppTheme.textColor)),
                                //                 ],
                                //               ))
                                //         ],
                                //       ),
                                //     ),
                                //   ),
                                // );
                              })
                              :
                          ListView.builder(
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              itemCount: mArraylistClaim!=null?mArraylistClaim.length:6,
                              itemBuilder: (context, index) {
                                return buildClaimList(index,mArraylistClaim);
                              })

                        ))
                   ]
                    ))
                        :
                    Container(
                        margin: EdgeInsets.only(top:220.0),
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
                )

              // )
            );

      })

    );
  }
}
