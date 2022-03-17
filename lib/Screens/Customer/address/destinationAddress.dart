import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:orderly/Blocs/address/address_bloc.dart';
import 'package:orderly/Blocs/address/address_event.dart';
import 'package:orderly/Blocs/address/address_state.dart';
import 'package:orderly/Configs/image.dart';
import 'package:orderly/Configs/theme.dart';
import 'package:orderly/Models/model_address.dart';
import 'package:orderly/Models/model_scoped_cart.dart';
import 'package:orderly/Models/model_view_cart.dart';
import 'package:orderly/Screens/Customer/cart/addTime.dart';
import 'package:orderly/Screens/Customer/orders/order_list_item.dart';
import 'package:orderly/Screens/Customer/orders/orders_filter.dart';
import 'package:orderly/Screens/Customer/payment/payment.dart';
import 'package:orderly/Screens/profile/profAddress/addEditAddress.dart';
import 'package:orderly/Utils/Utils.dart';
import 'package:orderly/Utils/application.dart';
import 'package:orderly/Utils/connectivity_check.dart';
import 'package:orderly/Utils/translate.dart';
import 'package:orderly/Utils/util_preferences.dart';
import 'package:orderly/Widgets/app_button.dart';
import 'package:orderly/Widgets/app_dialogs.dart';
import 'package:orderly/Widgets/app_text_input.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shimmer/shimmer.dart';

class DestAddress extends StatefulWidget {
  bool fromProf;
  List<Cart> cartDetails;
  String convFee,total,subTotal;
  Address sourceAddress;
  var radioSelectedSourceId;
  int clickedPos;

  DestAddress({Key key,@required this.fromProf,@required this.cartDetails,@required this.convFee,@required this.total,
  @required this.subTotal,@required this.sourceAddress,@required this.radioSelectedSourceId,
  @required this.clickedPos})
      : super(key: key);
  _DestAddressState createState() => _DestAddressState();

}

class _DestAddressState extends State<DestAddress> {
  String flagAddEdit = "";
  List<OrderStatusTimeFilter> OrderList = [];
  var iddest=null;
  String radioItem = '';
  AddressBloc _addressBloc;
  bool isconnectedToInternet = false;
  static bool isDestFirstTimeChecked=false;
  List<Address> destaddressList;
  bool flagNoDataAvail=false;
  final _controller = RefreshController(initialRefresh: false);
  int pos=0;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("called initState");
    _addressBloc = BlocProvider.of<AddressBloc>(context);
    setBlocData();
  }

  void setBlocData() async {
    isconnectedToInternet = await ConnectivityCheck.checkInternetConnectivity();
    if (isconnectedToInternet == true) {
      _addressBloc.add(OnLoadingAddressList());
    } else {
      CustomDialogs.showDialogCustom(
          "Internet", "Please check your Internet Connection!", context);
    }
  }

  ///On Refresh List
  Future<void> _onRefresh() async {
    destaddressList=null;
    await Future.delayed(Duration(milliseconds: 1000));
    if (isconnectedToInternet == true) {
      _addressBloc.add(OnLoadingAddressList());
    } else {
      CustomDialogs.showDialogCustom(
          "Internet", "Please check your Internet Connection!", context);
    }
    _controller.refreshCompleted();
  }

  Widget buildAddressListRadio(int index,List<Address> addressList){
    // print(addressList);
    if(addressList==null){
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

    // if(isDestFirstTimeChecked==true) {
    //   addressList[0].ischecked=true;
    // }else{
    //   addressList[0].ischecked=false;
    //
    // }

    return Card(
        elevation: 5.0,
        child: Theme(
            data: Theme.of(context).copyWith(
              unselectedWidgetColor:
              Theme.of(context)
                  .primaryColor,
            ),
            child:ListTileTheme( //used to remove internal padding between Radio button and title
              horizontalTitleGap: 3,
              //used to remove horizantal spacing between radio icon and text
              child: RadioListTile(
                activeColor: Theme.of(context)
                    .primaryColor,
                dense: true,

                title:
                Padding(
                    padding:
                    EdgeInsets.only(top:10.0),
                    child:
                    // Row(
                    //   children: [
                    // Expanded(
                    //     child:
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${addressList[index].userName}",
                          style: TextStyle(
                              fontWeight:
                              FontWeight
                                  .w600,
                              fontSize: 14.0,
                              fontFamily:
                              'Poppins',
                              color: AppTheme
                                  .textColor),
                          // )
                        ),
                        Text(
                          addressList[index].address,
                          style: TextStyle(
                              fontWeight:
                              FontWeight
                                  .w400,
                              fontSize: 12.0,
                              fontFamily:
                              'Poppins',
                              color: AppTheme
                                  .textColor),
                          // )
                        ),
                        Text(
                          "Mobile: " +
                              addressList[
                              index]
                                  .mobile,
                          style: TextStyle(
                              fontWeight:
                              FontWeight
                                  .w400,
                              fontSize: 12.0,
                              fontFamily:
                              'Poppins',
                              color: AppTheme
                                  .textColor),
                          // )
                        ),
                        SizedBox(height: 8.0,),
                        //for  update button
                        setUpdateButton(index, addressList),
                        // if(addressList[index].ischecked==true)
                        //
                        //   ElevatedButton(
                        //   style: ElevatedButton.styleFrom(
                        //     side: BorderSide(color: Theme.of(context).disabledColor, width: 1),
                        //     primary: Theme.of(context).primaryColor,
                        //     shape: const RoundedRectangleBorder(
                        //         borderRadius: BorderRadius.all(
                        //             Radius.circular(50))),
                        //   ),
                        //     child:Text("Update",style: TextStyle(fontWeight: FontWeight.w400,
                        //     fontFamily: 'Poppins',
                        //     fontSize: 14.0,
                        //     color: Colors.white),),
                        // onPressed: (){
                        //   flagAddEdit = "1"; //for edit
                        //   Navigator.push(context, MaterialPageRoute(builder: (context)=>AddEditAddress(flagAddEdit: flagAddEdit)));
                        // },),

                      ],
                    )
                  // ),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.end,
                  //    children: [
                  //      //edit
                  //      IconButton(
                  //          onPressed: () {},
                  //          icon: Image.asset(Images.edit,
                  //              height: 25.0, width:25.0)),
                  //      //delete
                  //      IconButton(
                  //          onPressed: () {},
                  //          icon: Image.asset(Images.delete,
                  //              height: 18.0, width:18.0)),
                  //    ],
                  //  )
                  //   ],
                  // )
                ),
                secondary:setDeleteButton(index, addressList),
                // IconButton(
                //  onPressed: () {},
                //  icon: Image.asset(Images.delete,
                //      height: 18.0, width:18.0)),
                value:addressList[index].uaId,
                groupValue:iddest,
                onChanged: (val) {

                    setState(() {
                      pos = index;
                      // widget.clickedDestPos=index;
                      radioItem = addressList[index].userName;
                      iddest = addressList[index].uaId;
                      print(radioItem + " " + iddest.toString());
                      isDestFirstTimeChecked =
                      !isDestFirstTimeChecked; //for first index checked radio
                      addressList[index].ischecked = true;
                    });



                },
              ),
            )));
  }



  Widget setUpdateButton(int index,List<Address> addressList){
    if(addressList[index].ischecked==true)
    {
      // addressList[index].ischecked=false;
      return Container(
          width: 240.0,
          child:  ElevatedButton(
            style: ElevatedButton.styleFrom(
              side: BorderSide(color: Theme.of(context).primaryColor, width: 1),
              primary: Colors.white,
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                      Radius.circular(50))),
            ),
            child:Text("Update Address",style: TextStyle(fontWeight: FontWeight.w500,
                fontFamily: 'Poppins',
                fontSize: 14.0,
                color: AppTheme.textColor),),
            onPressed: () async{
              flagAddEdit = "1"; //for edit
              final result=await Navigator.push(context, MaterialPageRoute(builder: (context)=>
                  AddEditAddress(flagAddEdit: flagAddEdit,addressData:addressList[index])));
              if(result!=null){
                _onRefresh();
              }
            },));
    }else{
      return Container();
    }

  }

  //for delete
  Widget setDeleteButton(int index,List<Address> addressList){
    if(addressList[index].ischecked==true)
    {
      addressList[index].ischecked=false;
      return IconButton(
          onPressed: () {
            _addressBloc.add(OnDeleteAddress(addressId: addressList[index].uaId.toString()));
            print('deleted');
            setState(() {
              addressList.removeAt(index);
            });
          },
          icon: Image.asset(Images.delete,
              height: 16.0, width:16.0));
    }else{

      return SizedBox();
    }

  }


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        backgroundColor: Colors.white,
        floatingActionButton: FloatingActionButton(
            elevation: 0.0,
            child: new Icon(
              Icons.add,
              color: Colors.white,
              size: 30.0,
            ),
            backgroundColor: Theme.of(context).primaryColor,
            onPressed: () async{
              flagAddEdit = "0"; //for add
              final result=await Navigator.push(context, MaterialPageRoute(builder: (context)=>
                  AddEditAddress(flagAddEdit: flagAddEdit)));
              if(result!=null){
                _onRefresh();
              }

            }),
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              InkWell(
                  onTap: () {
                    Navigator.pop(context,{"id":widget.radioSelectedSourceId,
                    "clickedPos":widget.clickedPos});
                  },
                  child: Icon(
                    Icons.arrow_back_ios,
                    color: AppTheme.textColor,
                    size: 25.0,
                  )),
              Text(
                'Destination Address',
                style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500,
                    fontSize: 18.0,
                    color: AppTheme.textColor),
              ),
              // Your widgets here
            ],
          ),
          backgroundColor: Colors.white,
          elevation: 0,
          automaticallyImplyLeading:false,

        ),
        body: BlocBuilder<AddressBloc, AddressState>(builder: (context, state) {
          if (state is AddressListSuccess) {
            destaddressList = state.addressList;
            // if(pos==0) { //to have for first time only
            //   id = state.addressList[0].uaId;
            // }
            flagNoDataAvail=false;
          }
          if(state is AddressLoading){
            flagNoDataAvail=false;
          }
          if (state is AddressListLoadFail) {
            flagNoDataAvail=true;
          }

          if (state is AddressDeleteSuccess) {
            if(destaddressList.length<=0)
            {
              flagNoDataAvail=true;
            }
          }
          return SafeArea(
              child: SmartRefresher(
                  enablePullDown: true,
                  onRefresh: _onRefresh,
                  controller: _controller,
                  child:
                  Container(
                    // height: 250.0,
                    color: Colors.white,
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.only(top: 20.0),
                    child:
                    flagNoDataAvail==false
                        ?
                    Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Stack(
                          children: [
                            Padding(
                                padding: EdgeInsets.only(bottom: 55.0),
                                child: ListView.builder(
                                    itemCount: destaddressList!=null?destaddressList.length:6,
                                    itemBuilder: (context, index) {

                                      return buildAddressListRadio(index, destaddressList);

                                    })),
                            if(widget.fromProf!=true)
                            Align(
                                alignment: Alignment.bottomCenter,
                                child: Padding(
                                    padding: EdgeInsets.only(
                                        left: 50.0, right: 100.0),
                                    child:
                                    AppButton(
                                      onPressed: () {
                                        if(destaddressList[pos].streetNo=="" && destaddressList[pos].flatNo==""){
                                          Fluttertoast.showToast(msg: "Please add/edit street and flat No. to proceed");
                                        }else if(widget.sourceAddress.uaId==destaddressList[pos].uaId ){
                                         Fluttertoast.showToast(msg: "This address is been selected as Source,so please selct another address");

                                         }
                                        else {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      Payment(
                                                        cartDet: widget
                                                            .cartDetails,
                                                        total: widget.total,
                                                        subTotal: widget
                                                            .subTotal,
                                                        convFee: widget
                                                            .convFee,
                                                        destAddress: destaddressList[pos],
                                                        sourceAddress:widget.sourceAddress
                                                      )));
                                        }
                                      },
                                      shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(50))),
                                      text: 'Continue',
                                    ))

                                ),
                          ],
                        ))
                        :
                    Center(
                        child:Text(
                          "No Data Available",
                          style: TextStyle(
                              fontSize: 16.0,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w600,
                              color: AppTheme.textColor),
                        )),
                  )
              )
          );
        }));
  }
}
