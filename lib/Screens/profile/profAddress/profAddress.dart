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
import 'package:orderly/Widgets/app_button.dart';
import 'package:orderly/Widgets/app_dialogs.dart';
import 'package:orderly/Widgets/app_text_input.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shimmer/shimmer.dart';

class ProfAddress extends StatefulWidget {
  bool fromProf;
  // List<Cart> cartDetails;
  // String convFee,total,subTotal;

  ProfAddress({Key key,@required this.fromProf})
      : super(key: key);
  _ProfAddressState createState() => _ProfAddressState();

}

class _ProfAddressState extends State<ProfAddress> {
  String flagAddEdit = "";
  List<OrderStatusTimeFilter> OrderList = [];
  int id;
  String radioItem = '';
  AddressBloc _addressBloc;
  bool isconnectedToInternet = false,isFirstTimeChecked=true;
  List<Address> addressList;
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
    // getAddress();
  }

  void getAddress() {
    for (int i = 1; i <= 5; i++) {
      OrderStatusTimeFilter orderListItem = new OrderStatusTimeFilter();
      orderListItem.index = i;
      orderListItem.name = "namrata";
      OrderList.add(orderListItem);
    }
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
    addressList=null;
    await Future.delayed(Duration(milliseconds: 1000));
    _addressBloc.add(OnLoadingAddressList());
    _controller.refreshCompleted();
  }


  //fromprofile
  Widget buildAddressList(int index,List<Address> addressList){

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

    return Card(
        elevation: 5.0,
        child: Theme(
          data: Theme.of(context).copyWith(
            unselectedWidgetColor:
            Theme.of(context)
                .primaryColor,
          ),
          child:
          Padding(
              padding:
              EdgeInsets.all(15.0),
              child:
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
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child:
                          //for  update button
                          setUpdateButton(index, addressList),
                        ),
                        SizedBox(width: 15,),
                        //for remove button
                        Expanded(
                            child:AppButton(
                              onPressed: (){
                                _addressBloc.add(OnDeleteAddress(addressId: addressList[index].uaId.toString()));
                                print('deleted');
                                setState(() {
                                  addressList.removeAt(index);
                                });                  },
                              shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(50))),
                              text: 'Remove',
                            ))
                      ])
                ],
              )),
        ));
  }


  Widget setUpdateButton(int index,List<Address> addressList){
    if(widget.fromProf==true){
      return ElevatedButton(
        style: ElevatedButton.styleFrom(
          side: BorderSide(color: Theme.of(context).primaryColor, width: 1),
          primary: Colors.white,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                  Radius.circular(50))),
        ),
        child:Text("Update",style: TextStyle(fontWeight: FontWeight.w500,
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
        },
      );

    } else{
      return Container();
    }

  }





  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
          title: Text(
            Translate.of(context).translate('address'),
            style: TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
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
        body: BlocBuilder<AddressBloc, AddressState>(builder: (context, state) {
          if (state is AddressListSuccess) {
            addressList = state.addressList;
            if(pos==0) { //to have for first time only
              id = state.addressList[0].uaId;
            }
            flagNoDataAvail=false;
          }
          if(state is AddressLoading){
            flagNoDataAvail=false;
          }
          if (state is AddressListLoadFail) {
            flagNoDataAvail=true;
          }

          if (state is AddressDeleteSuccess) {
            if(addressList.length<=0)
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
                        child:
                            Padding(
                                padding: EdgeInsets.only(bottom: 55.0),
                                child: ListView.builder(
                                    itemCount: addressList!=null?addressList.length:6,
                                    itemBuilder: (context, index) {
                                        return buildAddressList(index, addressList);

                                    })),

                    )
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
