import 'dart:convert';

import 'package:dio/dio.dart';
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
import 'package:orderly/Models/model_view_cart.dart';
import 'package:orderly/Screens/Customer/cart/addTime.dart';
import 'package:orderly/Screens/Customer/orders/myOrders.dart';
import 'package:orderly/Screens/Customer/payment/StripeService.dart';
import 'package:orderly/Screens/mainNavigation.dart';
import 'package:orderly/Utils/Utils.dart';
import 'package:orderly/Utils/application.dart';
import 'package:orderly/Utils/preferences.dart';
import 'package:orderly/Utils/progressDialog.dart';
import 'package:orderly/Utils/translate.dart';
import 'package:orderly/Utils/util_preferences.dart';
import 'package:orderly/Widgets/app_button.dart';
import 'package:orderly/app_bloc.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_stripe/flutter_stripe.dart' as stripepay;


class Payment extends StatefulWidget{
  List<Cart> cartDet;
  String convFee,total,subTotal;
  Address destAddress,sourceAddress;

  Payment({Key key,
    @required this.cartDet,@required this.convFee,
    @required this.total,@required this.destAddress,@required this.sourceAddress,@required this.subTotal}):super(key:key);

  _PaymentState createState()=>_PaymentState();
}

class _PaymentState extends State<Payment>{
  final _scaffoldKey=GlobalKey<ScaffoldState>();
  String radioPay="COD";
  static const platform=const MethodChannel("razorpay_flutter");
  Razorpay _razorpay ;
  // var razorPayKey='rzp_test_2UuUOV1rGmCSEg',razorPaySecretKey='gR8mI6DRPj5i0jLcLO3JJMwR'; //account of  destek used
  var razorPayKey='rzp_live_TXhZMyuTJ2hlFe',  //test:-rzp_test_xaIitfKWJUnhNw
      razorPaySecretKey='bN7b4z4jEpnPYM4SywN7E8Wu'; //account of  orderly used
  CartBloc _cartBloc;
  String cartList="",paymentId="";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _cartBloc=BlocProvider.of<CartBloc>(context);
     cartList= jsonEncode(widget.cartDet.map((i) => Cart.toJson(i)).toList()).toString();
      print("cartList:-"+cartList);
     _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);

    // StripeService.init();
  }



  //   JSONObject orderRequest = new JSONObject();
  //   orderRequest.put("amount", 50000); // amount in the smallest currency unit
  //   orderRequest.put("currency", "INR");
  //   orderRequest.put("receipt", "order_rcptid_11");

  // void creatOrder(){
  //   RazorpayClient razorpay = new RazorpayClient(razorPayKey, razorPaySecretKey);

  //   Order order = razorpay.Orders.create(orderRequest);
  // }


  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    // Fluttertoast.showToast(
    //     msg: "SUCCESS: " + response.paymentId, toastLength: Toast.LENGTH_SHORT);
    paymentId=response.paymentId.toString();
    doPayment();
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    Fluttertoast.showToast(
        msg: "ERROR: " + response.code.toString() + " - " + response.message,
        toastLength: Toast.LENGTH_SHORT);
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
    double amt=double.parse(widget.total)*100;
    print("amt:-"+amt.toString());
    var options = {
      'key': razorPayKey,
      'amount':amt,
      // 'amount':100,
      'name': 'Orderly',
      // 'order_ID':'order_HxKUd8b3dI9ZKl',
      // 'description': widget.cartDet[0].producerName,
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

  //for Stripe payment
  Map<String, dynamic> paymentIntentData;
  //for stripe
  Future<void> makePayment() async {
    final url = Uri.parse('https://api.stripe.com/');
    final response =
    await http.get(url, headers: {'Content-Type': 'application/json'});
    print('------$response----');
    paymentIntentData = json.decode(response.body);
    print(response.body);

    await stripepay.Stripe.instance.initPaymentSheet(
        paymentSheetParameters: stripepay.SetupPaymentSheetParameters(
            paymentIntentClientSecret: paymentIntentData['paymentIntent'],
            applePay: true,
            googlePay: true,
            style: ThemeMode.dark,
            merchantCountryCode: 'US',
            merchantDisplayName: 'Aditi'));
    setState(() {});
    displayPaymentSheet();
  }

  //without cloud firestore for stripe
  // payViaNewCard(BuildContext context) async {
  //   PsProgressDialog.showProgressWithoutMsg(context);
  //   // var response = await StripeService.payWithNewCard(amount: '15000', currency: 'USD');
  //
  //   var response = await StripeService.payWithNewCard(amount: widget.total, currency: 'INR');
  //   Scaffold.of(context).showSnackBar(SnackBar(
  //     content: Text(response.message),
  //     duration: new Duration(milliseconds: response.success == true ? 1200 : 3000),
  //   ));
  // }


  Future<void> displayPaymentSheet() async {
    try {
      await stripepay.Stripe.instance.presentPaymentSheet(
          parameters: stripepay.$PresentPaymentSheetParameters(
              clientSecret: paymentIntentData['paymentIntent'],
              confirmPayment: true));
      setState(() {
        paymentIntentData = null;
      });
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Payment Successful...')));
    } catch (e) {
      //If the payment is not done then this will come to catch block
      print(e);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Payment Failed...')));
    }
  }


  //called method for payment
  void doPayment()
  {
    _cartBloc.add(PlaceOrder(
        deliveryType: AddTime.deliveryType,
        deliveryDate: AddTime.isCheckedCharged==true?AddTime.currentDate:AddTime.dateTime,
        deliverySlot: AddTime.deliveryType=="0"
            ?"9"
            :AddTime.deliverySlot,
        convFee: widget.convFee,
        amount: AddTime.chargedAmt==null?"0":AddTime.chargedAmt,
        subTotal: widget.subTotal,
        total: widget.total.toString(),
        addressId: widget.sourceAddress.uaId.toString(),
        cartDetails: cartList,
        paymentId:paymentId,
        paymentMode: radioPay,
      dest_address: widget.destAddress.uaId.toString()
    ));
  }

  void clearData(){
    AddTime.isCheckedfree=false;
    AddTime.isCheckedCharged=false;
    AddTime.radioDay='';
    AddTime.dateTime="";
    AddTime.deliveryType='';
    AddTime.deliverySlot='';
    AddTime.chargedAmt=null;
    AddTime.currentDate=null;
    AddTime.selectedDate=null;
    AddTime.selectedDate=null;
    AddTime.time=null;
  }

  Future<void> _showMessage(String message) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
           "Payment",
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
            ElevatedButton(
              child: Text(
                'OK',
              ),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder:
                    (context)=> MainNavigation(flagOrder:"1")));
              },
            ),
          ],
        );
      },
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
          "Payment",
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
            // Card(
            //   elevation: 5.0,
            //   child:  Theme(
            //     data: Theme.of(context).copyWith(
            //       unselectedWidgetColor:
            //       Theme.of(context).primaryColor,
            //     ),
            //     child: RadioListTile(
            //       activeColor: AppTheme.appColor,
            //           groupValue: radioPay,
            //           secondary: IconButton(
            //               icon:Image.asset(Images.stripe,height: 80.0,width: 80.0,)),
            //           title: Text('Stripe',
            //             style: Theme.of(context)
            //                 .textTheme
            //                 .subtitle2
            //                 .copyWith(fontWeight: FontWeight.w600,color: AppTheme.textColor),),
            //           value: 'Stripe',
            //           onChanged: (val) {
            //
            //             setState(() {
            //               radioPay = val;
            //             });
            //           },
            //         )),
            //
            //
            //
            // ),
            //temperoray for COD
            Card(
              elevation: 5.0,
              child:Theme(
                  data: Theme.of(context).copyWith(
                    unselectedWidgetColor:
                    Theme.of(context).primaryColor,
                  ),
                  child:RadioListTile(
                    activeColor: AppTheme.appColor,
                    groupValue: radioPay,
                    // secondary: IconButton(
                    //     icon:Image.asset(Images.stripe,height: 80.0,width: 80.0,)),
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
                  )
              ),
            ),
            //to place button at bottom.expanded widget is used in Column
            Expanded(child:Container()),

            //submit
            BlocBuilder<CartBloc,CartState>(builder: (context,order){
              return BlocListener<CartBloc,CartState>(listener: (context,state){
                  if(state is PlaceOrderSuccess){
                    clearData();
                    UtilPreferences.remove(Preferences.cart);
                    Application.cartModel = null;
                    _showMessage("Order Placed Successfully");
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
                            doPayment();
                            // placeOrder();
                          }else if(radioPay=="RazorPay"){
                            openCheckout();
                            // _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text("Funcionality Under development")));
                          }else if(radioPay=="Stripe")
                            {
                              makePayment();
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
    ));
  }

}