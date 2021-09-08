import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:orderly/Configs/image.dart';
import 'package:orderly/Configs/theme.dart';
import 'package:orderly/Screens/Customer/cart/addTime.dart';
import 'package:orderly/Utils/translate.dart';
import 'package:orderly/Widgets/app_button.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class Payment extends StatefulWidget{
  AddTimeData addTimeData;
  String cartDet;

  Payment({Key key,@required this.addTimeData,@required this.cartDet}):super(key:key);
  _PaymentState createState()=>_PaymentState();
}

class _PaymentState extends State<Payment>{
  final _scaffoldKey=GlobalKey<ScaffoldState>();
  String radioPay="RazorPay";
  static const platform=const MethodChannel("razorpay_flutter");
  Razorpay _razorpay = Razorpay();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }



  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    Fluttertoast.showToast(
        msg: "SUCCESS: " + response.paymentId, toastLength: Toast.LENGTH_SHORT);
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
    var options = {
      'key': 'rzp_test_1DP5mmOlF5G5ag',
      'amount': 2000,
      'name': 'Acme Corp.',
      'description': 'Fine T-Shirt',
      'prefill': {'contact': '8888888888', 'email': 'test@razorpay.com'},
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
                        openCheckout();

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
            //to place button at bottom.expanded widget is used in Column
            Expanded(child:Container()),

            //submit
            Padding(
                padding: EdgeInsets.all(25.0),
                child: AppButton(
                  onPressed: () {},
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(50))),
                  text: 'SUBMIT',
                  // loading: login is LoginLoading,
                  // disableTouchWhenLoading: true,
                )
            )


          ],
        )),
      ),
    );
  }
  
}