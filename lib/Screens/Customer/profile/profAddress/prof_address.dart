import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
import 'package:orderly/Screens/Customer/profile/profAddress/addEditAddress.dart';
import 'package:orderly/Utils/application.dart';
import 'package:orderly/Utils/connectivity_check.dart';
import 'package:orderly/Utils/translate.dart';
import 'package:orderly/Widgets/app_button.dart';
import 'package:orderly/Widgets/app_dialogs.dart';
import 'package:orderly/Widgets/app_text_input.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shimmer/shimmer.dart';

class ProfAddress extends StatefulWidget {
  AddTimeData addTimeData;
  List<Cart> cartDetails;
  String convFee,total,subTotal;

  ProfAddress({Key key, @required this.addTimeData,
    @required this.cartDetails, @required this.convFee,
    @required this.total,@required this.subTotal})
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
  List<Address> _addressList;
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
    _addressList=null;
    await Future.delayed(Duration(milliseconds: 1000));
    _addressBloc.add(OnLoadingAddressList());
    _controller.refreshCompleted();
  }

  Widget buildAddressList(int index,List<Address> _addressList){
    if(_addressList==null){
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

    if(isFirstTimeChecked==true) {
      _addressList[0].ischecked=true;
    }else{
      _addressList[0].ischecked=false;

    }

    return Card(
        elevation: 5.0,
        child: Theme(
          data: Theme.of(context).copyWith(
            unselectedWidgetColor:
            Theme.of(context)
                .primaryColor,
          ),
          child: RadioListTile(
            activeColor: Theme.of(context)
                .primaryColor,
            title:
            Padding(
                padding:
                EdgeInsets.all(10.0),
                child: Row(
                  children: [
                    Expanded(
                        child:Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${_addressList[index].userName}",
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
                          _addressList[index].address+","+_addressList[index].state+","+_addressList[index].country,
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
                              _addressList[
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
                        setUpdateButton(index, _addressList),
                        // if(_addressList[index].ischecked==true)
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
                    )),
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
                  ],
                )
               ),
           // secondary:setDeleteButton(index, _addressList),
           // IconButton(
           //  onPressed: () {},
           //  icon: Image.asset(Images.delete,
           //      height: 18.0, width:18.0)),
            value:_addressList[index].uaId,
            groupValue:id,
            onChanged: (val) {
              setState(() {
                pos=index;
                radioItem = _addressList[index].userName;
                id = _addressList[index].uaId;
                print(radioItem + " " + id.toString());
                 isFirstTimeChecked=!isFirstTimeChecked;//for first index checked radio
                _addressList[index].ischecked=true;
              });
            },
          ),
        ));
  }

  Widget setUpdateButton(int index,List<Address> _addressList){
      if(_addressList[index].ischecked==true)
       {
         _addressList[index].ischecked=false;
        return ElevatedButton(
          style: ElevatedButton.styleFrom(
            side: BorderSide(color: Theme.of(context).disabledColor, width: 1),
            primary: Theme.of(context).primaryColor,
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                    Radius.circular(50))),
          ),
          child:Text("Update",style: TextStyle(fontWeight: FontWeight.w400,
              fontFamily: 'Poppins',
              fontSize: 14.0,
              color: Colors.white),),
          onPressed: () async{
            flagAddEdit = "1"; //for edit
            final result=await Navigator.push(context, MaterialPageRoute(builder: (context)=>
                AddEditAddress(flagAddEdit: flagAddEdit,addressData:_addressList[index])));
            if(result!=null){
              _onRefresh();
            }
          },);
    }else{
        return Container();
      }

  }

  //for delete
  Widget setDeleteButton(int index,List<Address> _addressList){
    if(_addressList[index].ischecked==true)
    {
      _addressList[index].ischecked=false;
       return IconButton(
          onPressed: () {

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
            _addressList = state.addressList;
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
                                      itemCount: _addressList!=null?_addressList.length:6,
                                      itemBuilder: (context, index) {
                                        return buildAddressList(index, _addressList);
                                      })),
                              Align(
                                  alignment: Alignment.bottomCenter,
                                  child: Padding(
                                      padding: EdgeInsets.only(
                                          left: 50.0, right: 100.0),
                                      child:
                                      AppButton(
                                        onPressed: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) => Payment(
                                                        addTimeData: widget.addTimeData,
                                                        cartDet: widget.cartDetails,
                                                        total: widget.total,
                                                    subTotal:widget.subTotal,
                                                    convFee: widget.convFee,
                                                    address: _addressList[pos],
                                                  )));
                                        },
                                        shape: const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(50))),
                                        text: 'Continue',
                                      ))
                                  // Container(
                                  //   // margin: EdgeInsets.symmetric(horizontal: 20, vertical: 40),
                                  //   margin: EdgeInsets.only(right:70,left:70.0),
                                  //   width: double.infinity,
                                  //   child: FlatButton(
                                  //     child: Text('Continue', style: TextStyle(fontSize: 24)),
                                  //     onPressed: () => {},
                                  //     color: Colors.green,
                                  //     textColor: Colors.white,
                                  //   ),
                                  // ),
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
