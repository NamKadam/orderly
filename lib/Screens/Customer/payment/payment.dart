import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:orderly/Api/api.dart';
import 'package:orderly/Blocs/authentication/authentication_event.dart';
import 'package:orderly/Blocs/mycart/bloc.dart';
import 'package:orderly/Configs/image.dart';
import 'package:orderly/Configs/theme.dart';
import 'package:orderly/Models/model_address.dart';
import 'package:orderly/Models/model_scoped_cart.dart';
import 'package:orderly/Screens/Customer/cart/addTime.dart';
import 'package:orderly/Screens/mainNavigation.dart';
import 'package:orderly/Utils/application.dart';
import 'package:orderly/Utils/preferences.dart';
import 'package:orderly/Utils/translate.dart';
import 'package:orderly/Utils/util_preferences.dart';
import 'package:orderly/Widgets/app_button.dart';
import 'package:orderly/app_bloc.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:http/http.dart' as http;


class Payment extends StatefulWidget{
  AddTimeData addTimeData;
  String cartDet;
  String convFee,total,subTotal;
  Address address;

  Payment({Key key,@required this.addTimeData,
    @required this.cartDet,@required this.convFee,
    @required this.total,@required this.address,@required this.subTotal}):super(key:key);

  _PaymentState createState()=>_PaymentState();
}

class _PaymentState extends State<Payment>{
  final _scaffoldKey=GlobalKey<ScaffoldState>();
  String radioPay="COD";
  static const platform=const MethodChannel("razorpay_flutter");
  Razorpay _razorpay ;
  // var razorPayKey='rzp_test_2UuUOV1rGmCSEg',razorPaySecretKey='gR8mI6DRPj5i0jLcLO3JJMwR'; //account of  destek used
  var razorPayKey='rzp_test_xaIitfKWJUnhNw',razorPaySecretKey='bN7b4z4jEpnPYM4SywN7E8Wu'; //account of  orderly used
  CartBloc _cartBloc;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _cartBloc=BlocProvider.of<CartBloc>(context);
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);

  }
  //
  //   JSONObject orderRequest = new JSONObject();
  //   orderRequest.put("amount", 50000); // amount in the smallest currency unit
  //   orderRequest.put("currency", "INR");
  //   orderRequest.put("receipt", "order_rcptid_11");

  // void creatOrder(){
  //   RazorpayClient razorpay = new RazorpayClient(razorPayKey, razorPaySecretKey);
  //
  //   Order order = razorpay.Orders.create(orderRequest);
  // }



  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    Fluttertoast.showToast(
        msg: "SUCCESS: " + response.paymentId, toastLength: Toast.LENGTH_SHORT);
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    // Fluttertoast.showToast(
    //     msg: "ERROR: " + response.code.toString() + " - " + response.message,
    //     toastLength: Toast.LENGTH_SHORT);
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    Fluttertoast.showToast(
        msg: "EXTERNAL_WALLET: " + response.walletName, toastLength: Toast.LENGTH_SHORT);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _razorpay.clear();
  }

  //for checkout optios
  void openCheckout() async {
    int amt=int.parse(widget.total)*100;
    print("amt:-"+amt.toString());
    var options = {
      'key': razorPayKey,
      'amount':amt,
      'name': 'Orderly',
      // 'order_ID':'order_HxKUd8b3dI9ZKl',
      'description': 'Producer 1',
      'prefill': {'contact': Application.user.mobile, 'email': Application.user.emailId},
      'external': {
        'wallets': ['paytm']
      }
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint('Error: e');
    }
  }

  Future<void> placeOrder() async{
    Uri url=Uri.parse(Api.PLACE_ORDER);
    String data=widget.cartDet.replaceAll('"\"', "");

    Map<String,String> params={
      'product_array':data,
      'user_id':Application.user.fbId,
      'delivery_type':widget.addTimeData.deliveryType,
      'delivery_date':widget.addTimeData.date,
      'delivery_slot':widget.addTimeData.deliverySlot,
      'urgent_amount':widget.addTimeData.chargeAmt,
      'sub_total':widget.subTotal,
      'convinience_fee':widget.convFee,
      'grand_total':widget.total,
      'discount':'',
      'order_status_id':'1',
      'address':widget.address.uaId.toString()
    };

    try {
      var response = await http.post(url, body: params,);
      if (response.statusCode == 200) {
        var resp = json.decode(response.body); //for dio dont need to convert to json.decode
        UtilPreferences.remove(Preferences.cart);
        Navigator.push(context, MaterialPageRoute(builder: (context)=>
            MainNavigation()));
      }
    }catch(e){
      print("error:-"+e.toString());
    }


  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      key: _scaffoldKey,
      appBar: new AppBar(
        title: Text(
          Translate.of(context).translate('track_order'),
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
      body: Container(
        color:Colors.white,
        child:
            Padding(
              padding: EdgeInsets.all(15.0),
        child:
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
               Translate.of(context).translate('pay_option'),
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontFamily: 'Poppins',
                fontSize: 16.0,
                color: AppTheme.textColor
              ),
            ),
            SizedBox(height: 10.0,),
            //for RazorPay
            Card(
              elevation: 5.0,
              child:
              Theme(
                data: Theme.of(context).copyWith(
                  unselectedWidgetColor:
                  Theme.of(context).primaryColor,
                ),
                child:
                RadioListTile(
                     activeColor: AppTheme.appColor,
                      groupValue: radioPay,
                      secondary: IconButton(
                          icon:Image.asset(Images.razorpay,height: 70.0,width: 70.0,)),
                      title: Text('RazorPay',
                        style: Theme.of(context)
                            .textTheme
                            .subtitle2
                            .copyWith(fontWeight: FontWeight.w600,color: AppTheme.textColor),),
                      value: 'RazorPay',
                      onChanged: (val) {
                        // openCheckout();

                        setState(() {
                          radioPay = val;
                        });
                      },
                    )),



            ),

            //for stripe
            Card(
              elevation: 5.0,
              child:  Theme(
                data: Theme.of(context).copyWith(
                  unselectedWidgetColor:
                  Theme.of(context).primaryColor,
                ),
                child: RadioListTile(
                  activeColor: AppTheme.appColor,
                      groupValue: radioPay,
                      secondary: IconButton(
                          icon:Image.asset(Images.stripe,height: 80.0,width: 80.0,)),
                      title: Text('Stripe',
                        style: Theme.of(context)
                            .textTheme
                            .subtitle2
                            .copyWith(fontWeight: FontWeight.w600,color: AppTheme.textColor),),
                      value: 'Stripe',
                      onChanged: (val) {

                        setState(() {
                          radioPay = val;
                        });
                      },
                    )),



            ),
            //temperoray for COD
            Card(
              elevation: 5.0,
              child:  Theme(
                  data: Theme.of(context).copyWith(
                    unselectedWidgetColor:
                    Theme.of(context).primaryColor,
                  ),
                  child: RadioListTile(
                    activeColor: AppTheme.appColor,
                    groupValue: radioPay,
                    secondary: IconButton(
                        icon:Image.asset(Images.stripe,height: 80.0,width: 80.0,)),
                    title: Text('COD',
                      style: Theme.of(context)
                          .textTheme
                          .subtitle2
                          .copyWith(fontWeight: FontWeight.w600,color: AppTheme.textColor),),
                    value: 'COD',
                    onChanged: (val) {
                      setState(() {
                        radioPay = val;
                      });
                    },
                  )),



            ),
            //to place button at bottom.expanded widget is used in Column
            Expanded(child:Container()),

            //submit
            BlocBuilder<CartBloc,CartState>(builder: (context,order){
              return BlocListener<CartBloc,CartState>(listener: (context,state){
                  if(state is PlaceOrderSuccess){
                    UtilPreferences.remove(Preferences.cart);
                     Navigator.push(context, MaterialPageRoute(builder: (context)=>
                         MainNavigation()));
                  }

                  if(state is PlaceOrderFail){
                    _scaffoldKey.currentState.showSnackBar(SnackBar(content:Text("failed")));
                  }
              },
                  child:Padding(
                      padding: EdgeInsets.all(25.0),
                      child: AppButton(
                        onPressed: () {
                          if(radioPay=="COD")
                          {
                            // _cartBloc.add(PlaceOrder(
                            //     deliveryType: widget.addTimeData.deliveryType,
                            //     deliveryDate: widget.addTimeData.date,
                            //     deliverySlot: widget.addTimeData.deliverySlot,
                            //     convFee: widget.convFee,
                            //     amount: widget.addTimeData.chargeAmt,
                            //     subTotal: widget.subTotal,
                            //     total: widget.total.toString(),
                            //     addressId: widget.address.uaId.toString(),
                            //     cartDetails: widget.cartDet
                            // ));
                            placeOrder();
                          }else if(radioPay=="RazorPay"){
                            openCheckout();
                          }
                        },
                        shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(50))),
                        text: 'SUBMIT',
                        loading: order is PlaceOrderLoading,
                        disableTouchWhenLoading: true,
                      )
                  )
              );
            },

            )
          ],
        )),
      ),
    );
  }

}