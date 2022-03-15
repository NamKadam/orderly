import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:orderly/Models/model_address.dart';
import 'package:orderly/Models/model_view_cart.dart';
import 'package:orderly/Screens/Customer/address/sourceAddress.dart';
import 'package:orderly/Screens/Customer/payment/payment.dart';
import 'package:orderly/Screens/profile/profAddress/addEditAddress.dart';
import 'package:orderly/Utils/preferences.dart';
import 'package:orderly/Utils/translate.dart';
import 'package:orderly/Utils/util_preferences.dart';
import 'package:orderly/Widgets/app_button.dart';

class CustAddress extends StatefulWidget{
  bool fromProf;
  List<Cart> cartDetails;
  String convFee,total,subTotal;

  CustAddress({Key key,
    @required this.cartDetails, @required this.convFee,
    @required this.total,@required this.subTotal,@required this.fromProf})
      : super(key: key);
  _CustAddressState createState()=>_CustAddressState();
}

class _CustAddressState extends State<CustAddress> with SingleTickerProviderStateMixin{
  TabController _tabcontroller;
  String flagAddEdit = "";


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _tabcontroller =
        TabController(
          length: 2,
          vsync: this,
        );
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _tabcontroller.dispose();
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
              final result=await
              Navigator.push(context, MaterialPageRoute(builder: (context)=>
                  AddEditAddress(flagAddEdit: flagAddEdit)));
              // if(result!=null){
              //   _onRefresh();
              // }

            }),
        appBar: AppBar(
          title: Text(
            Translate.of(context).translate('address'),
            style: TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w600,
            ),
          ),
          bottom: TabBar(
              controller: _tabcontroller,
              indicatorColor: Theme.of(context).primaryColor,
              labelColor: Colors.white,
              // unselectedLabelColor: Colors.grey,
              unselectedLabelColor: Colors.white30,
              isScrollable: false,
              onTap: (index){ //added on 24/12/2020
                // if(index==0){
                //   _bloc.add(IsLoading());
                // }else if(index==1){
                //   _bloc.add( FavouriteListLoading());
                //
                // }else if(index==2){
                //   requestBloc.add(RequestListLoading());
                // }
              },
              tabs:[
                Container(
                    child:Tab(child: Text(
                      "Source",
                      style: TextStyle(fontSize:16.0,fontWeight: FontWeight.w600,fontFamily: 'Popins'),
                    ),)),
                Tab(child: Text(
                  "Destination",
                  style: TextStyle(fontSize:16.0,fontWeight: FontWeight.w600,fontFamily: 'Popins'),
                ),),


              ]
          ),

        ),
        body:
        Stack(
          children: [
            TabBarView(
                controller: _tabcontroller,
                children: [
                  SourceAddress(fromProf: widget.fromProf),
                  SourceAddress(fromProf: widget.fromProf)
                ]),
            if(widget.fromProf!=true)
              Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                      padding: EdgeInsets.only(
                          left: 50.0, right: 100.0,bottom:10.0),
                      child:
                      AppButton(
                        onPressed: () {
                          var addresData = json.decode(UtilPreferences.getString("address"));
                          final addressList = addresData.map((item) {

                            return Address.fromJson(item);
                          }).toList();

                          print(addressList);
                          // if(addressList[0].streetNo=="" && addressList[0].flatNo==""){
                          //   Fluttertoast.showToast(msg: "Please add/edit street and flat No. to proceed");
                          // }else {
                          //   Navigator.push(
                          //       context,
                          //       MaterialPageRoute(
                          //           builder: (context) =>
                          //               Payment(
                          //                 cartDet: widget
                          //                     .cartDetails,
                          //                 total: widget.total,
                          //                 subTotal: widget
                          //                     .subTotal,
                          //                 convFee: widget
                          //                     .convFee,
                          //                 address: addressList[0],
                          //               )));
                          // }
                        },
                        shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                                Radius.circular(50))),
                        text: 'Continue',
                      ))

              ),
          ],
        )
    );
  }

}