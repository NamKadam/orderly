import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:orderly/Blocs/myOrders/bloc.dart';
import 'package:orderly/Configs/image.dart';
import 'package:orderly/Configs/theme.dart';
import 'package:orderly/Models/model_myOrders.dart';
import 'package:orderly/Screens/Customer/orders/order_detail.dart';
import 'package:orderly/Screens/Customer/orders/order_list_item.dart';
import 'package:orderly/Screens/Customer/orders/orders_filter.dart';
import 'package:orderly/Utils/application.dart';
import 'package:orderly/Utils/connectivity_check.dart';
import 'package:orderly/Widgets/app_dialogs.dart';

class MyOrders extends StatefulWidget{
  _MyOrdersState createState()=>_MyOrdersState();
}

class _MyOrdersState extends State<MyOrders>{
  final TextEditingController _searchcontroller = TextEditingController();
  ScrollController _scrollController = ScrollController();
  MyOrdersBloc _myOrdersBloc;
  List<Orders> _myOrderList;
  bool isconnectedToInternet = false;
  bool flagNoData=false;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    flagNoData=false;
    _myOrdersBloc=BlocProvider.of<MyOrdersBloc>(context);

    setBlocData();
  }

  void setBlocData() async {
    print(Application.user.fbId);
    isconnectedToInternet = await ConnectivityCheck.checkInternetConnectivity();
    if (isconnectedToInternet == true) {
      _myOrdersBloc.add(OnLoadingOrdersList());
    } else {
      CustomDialogs.showDialogCustom(
          "Internet", "Please check your Internet Connection!", context);
    }
  }


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      // appBar: AppBar(title: Text("My Orders"),),
      body:BlocBuilder<MyOrdersBloc,MyOrdersState>(builder: (context,state){
        if(state is MyOrdersListSuccess){
          _myOrderList=state.orderList;
          flagNoData=false;
        }
        if(state is MyOrdersLoading){
          flagNoData=false;
        }
        if(state is MyOrdersListLoadFail){
          flagNoData=true;
        }
        return Container(
          child:
          flagNoData==false
              ?
          Column(
            children: [
              //search with filter
              Padding(padding: EdgeInsets.only(left: 15.0,right: 15.0,top:10.0,bottom: 10.0),
                  child:Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.white,
                      ),
                      child:
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              IconButton(
                                icon: Image.asset(Images.search,width: 25.0,height: 25.0,),
                                onPressed: () {},
                              ),
                              Container(
                                  margin: EdgeInsets.only(top:5.0),
                                  width: 200.0,
                                  height: 45.0,
                                  child:TextFormField(
                                    controller:_searchcontroller,
                                    style: TextStyle(
                                        fontFamily: 'Poppins',color: AppTheme.textColor,fontSize: 14.0,fontWeight: FontWeight.w400
                                    ),
                                    keyboardType: TextInputType.text,
                                    decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: "Search for all filters",
                                        hintStyle: TextStyle(
                                            color: AppTheme.textColor
                                        )
                                    ),
                                    onChanged: (value) {
                                      // this.phoneNo=value;
                                      print(value);
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
                                    fontFamily: 'Poppins'
                                ),
                              ),
                              IconButton(
                                icon: Image.asset(Images.filter,width: 20.0,height: 20.0,),
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                          new OrdersFilter())
                                  );
                                },
                              ),
                            ],
                          )
                        ],
                      )
                  )
              ),
              //for list of orders

              Expanded(
                child:
                ListView.separated(
                    controller: _scrollController,
                    physics: const AlwaysScrollableScrollPhysics(),
                    separatorBuilder: (context, index) {
                      return SizedBox(
                        height: 0.0,
                      );
                    },

                    itemCount: _myOrderList!=null?_myOrderList.length:6,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                          onTap: (){
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                    new OrderDetail()));

                          },
                          child:
                          // CartListItem(memberlist[index])

                          OrderListItem(orderList:_myOrderList,position:index)
                      );
                    }),
                //   return MembersList(memberlist[index]);
                // }),
              )

            ],
          )
              :
          Center(
            child: Text("No Orders Available",
              style:
              TextStyle(fontWeight: FontWeight.w600,fontFamily: 'Poppins',fontSize: 16.0,color: AppTheme.textColor),),
          )
        );
      })

    );
  }
}