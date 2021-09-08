import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:orderly/Configs/theme.dart';
import 'package:orderly/Screens/Customer/cart/addTime.dart';
import 'package:orderly/Screens/Customer/orders/order_list_item.dart';
import 'package:orderly/Screens/Customer/orders/orders_filter.dart';
import 'package:orderly/Screens/Customer/payment/payment.dart';
import 'package:orderly/Screens/Customer/profile/profAddress/addEditAddress.dart';
import 'package:orderly/Utils/application.dart';
import 'package:orderly/Utils/translate.dart';
import 'package:orderly/Widgets/app_button.dart';
import 'package:orderly/Widgets/app_text_input.dart';

class ProfAddress extends StatefulWidget{
   AddTimeData addTimeData;
   String cartDetails;

   ProfAddress({Key key,@required this.addTimeData,@required this.cartDetails}):super(key: key);

   _ProfAddressState createState()=>_ProfAddressState();
}

class _ProfAddressState extends State<ProfAddress>{
  String flagAddEdit="";
  List<OrderStatusTimeFilter> OrderList = [];
  int id = 1;
  String radioItem = '';


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("called initState");
    getAddress();
  }

  void getAddress(){
    for(int i=1;i<=5;i++){
      OrderStatusTimeFilter orderListItem=new OrderStatusTimeFilter();
      orderListItem.index=i;
      orderListItem.name="namrata";
      OrderList.add(orderListItem);
    }
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
        title: Text(Translate.of(context).translate('address')
          ,style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
          elevation: 0.0,
          child: new Icon(Icons.add,color: Colors.white,size: 20.0,),
          backgroundColor:Theme.of(context).primaryColor,
          onPressed: (){
            flagAddEdit="0";//for add
        Navigator.push(context, MaterialPageRoute(builder: (context)=>AddEditAddress(flagAddEdit:flagAddEdit)));
          }
      ),
      body:
      Container(
        // height: 250.0,
        color: Colors.white,
        width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.only(top:8.0),
            child:
                Padding(
                  padding: EdgeInsets.all(10.0),
            child:
           Stack(
             children: [
               Padding(
                 padding: EdgeInsets.only(bottom: 55.0),
                 child:
    ListView.builder(
    itemCount: OrderList.length,
    itemBuilder: (context, index) {
      // return Container(
      //   height: 30,
      //   padding: EdgeInsets.symmetric(horizontal: 20),
      //   child: Text('$index'),
      // );
      return Card(
          elevation: 5.0,
                  child:
                  Theme(
                    data: Theme.of(context).copyWith(
                      unselectedWidgetColor:
                      Theme.of(context).primaryColor,
                    ),
                    child:
                    RadioListTile(
                      activeColor: Theme.of(context).primaryColor,
                      title:
                      Padding(
                          padding: EdgeInsets.all(10.0),
                          child:
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${OrderList[index].name}",
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14.0,
                                    fontFamily: 'Poppins',
                                    color: AppTheme.textColor),
                                // )
                              ),
                              Text(
                                Application.user.address,
                                style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 12.0,
                                    fontFamily: 'Poppins',
                                    color: AppTheme.textColor),
                                // )
                              ),

                              Text(
                                "Mobile: "+Application.user.mobile,
                                style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 12.0,
                                    fontFamily: 'Poppins',
                                    color: AppTheme.textColor),
                                // )
                              ),
                            ],
                          ) ),

                      // secondary: IconButton(
                      //     onPressed: () {},
                      //     icon: Image.asset(Images.arrow,
                      //         height: 15.0, width: 15.0)),
                      //for trailing icon
                      value: OrderList[index].index,
                      groupValue: id,
                      onChanged: (val) {
                        setState(() {
                          radioItem = OrderList[index].name;
                          id = OrderList[index].index;
                          print(radioItem+" "+id.toString());
                        });
                      },
                    ),
                  ));

          })),
             // Column(
             // crossAxisAlignment: CrossAxisAlignment.start,
             // children:
             // OrderList.map((data) =>
             //     Card(
             //         elevation: 5.0,
             //         child:Theme(
             //           data: Theme.of(context).copyWith(
             //             unselectedWidgetColor:
             //             Theme.of(context).primaryColor,
             //           ),
             //           child: RadioListTile(
             //             activeColor: Theme.of(context).primaryColor,
             //             title:
             //             Padding(
             //                 padding: EdgeInsets.all(10.0),
             //                 child:
             //                 Column(
             //                   mainAxisAlignment: MainAxisAlignment.start,
             //                   crossAxisAlignment: CrossAxisAlignment.start,
             //                   children: [
             //                     Text(
             //                       "${data.name}",
             //                       style: TextStyle(
             //                           fontWeight: FontWeight.w600,
             //                           fontSize: 14.0,
             //                           fontFamily: 'Poppins',
             //                           color: AppTheme.textColor),
             //                       // )
             //                     ),
             //                     Text(
             //                       Application.user.address,
             //                       style: TextStyle(
             //                           fontWeight: FontWeight.w400,
             //                           fontSize: 12.0,
             //                           fontFamily: 'Poppins',
             //                           color: AppTheme.textColor),
             //                       // )
             //                     ),
             //
             //                     Text(
             //                       "Mobile: "+Application.user.mobile,
             //                       style: TextStyle(
             //                           fontWeight: FontWeight.w400,
             //                           fontSize: 12.0,
             //                           fontFamily: 'Poppins',
             //                           color: AppTheme.textColor),
             //                       // )
             //                     ),
             //                   ],
             //                 ) ),
             //
             //             // secondary: IconButton(
             //             //     onPressed: () {},
             //             //     icon: Image.asset(Images.arrow,
             //             //         height: 15.0, width: 15.0)),
             //             //for trailing icon
             //             value: data.index,
             //             groupValue: id,
             //             onChanged: (val) {
             //               setState(() {
             //                 radioItem = data.name;
             //                 id = data.index;
             //                 print(radioItem);
             //               });
             //             },
             //           ),
             //         ))).toList(),),

             // [
             //   Text(
             //     'Namrata kadam',
             //     style: TextStyle(fontFamily: 'Poppins',fontWeight: FontWeight.w600,
             //         fontSize: 16.0,
             //         color:AppTheme.textColor),
             //   ),
             //   //email
             //   Text(
             //     '244,somwar peth,near khadiche maidan,pune-411011',
             //     style: TextStyle(fontFamily: 'Poppins',fontWeight: FontWeight.w400,
             //         fontSize: 12.0,
             //         color:AppTheme.textColor),
             //   ),
             //   //mobile
             //   Padding(
             //       padding:EdgeInsets.only(top:2.0,bottom: 15.0),child:Text(
             //     'Mobile:- +91 9730259440',
             //     style: TextStyle(fontFamily: 'Poppins',fontWeight: FontWeight.w400,
             //         fontSize: 12.0,
             //         color:AppTheme.textColor),
             //   )),
             //
             //   Row(
             //     mainAxisAlignment: MainAxisAlignment.center,
             //     crossAxisAlignment: CrossAxisAlignment.center,
             //     children: [
             //       //cancel
             //       Expanded(
             //           child:
             //           Padding(padding: EdgeInsets.only(left:20.0,right:20.0,top:30.0),
             //
             //               child:ElevatedButton(
             //                 style: ElevatedButton.styleFrom(
             //                     side: BorderSide(color: Theme.of(context).primaryColor, width: 1),
             //                     primary: Colors.white,
             //                     shape: RoundedRectangleBorder(
             //                         borderRadius: BorderRadius.circular(50.0)
             //                     )
             //                 ),
             //                 // shape: shape,
             //                 onPressed: (){
             //                   flagAddEdit="1";//for add
             //                   Navigator.push(context, MaterialPageRoute(builder: (context)=>AddEditAddress(flagAddEdit:flagAddEdit)));
             //                 },
             //                 child: Row(
             //                   crossAxisAlignment: CrossAxisAlignment.center,
             //                   mainAxisAlignment: MainAxisAlignment.center,
             //                   children: <Widget>[
             //                     Padding(padding: EdgeInsets.all(10.0),child:Text(
             //                       'Edit',
             //                       style: Theme.of(context)
             //                           .textTheme
             //                           .button
             //                           .copyWith(color: AppTheme.textColor, fontWeight: FontWeight.w600),
             //                     )
             //                     ),
             //                   ],
             //                 ),
             //               )
             //           )),
             //       //save
             //       Expanded(
             //           child:
             //           Padding(padding: EdgeInsets.only(left:20.0,right:20.0,top:30.0),
             //               child:
             //               AppButton(
             //                 onPressed: (){
             //                   // _signUp();
             //                   // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MainNavigation()));
             //                 },
             //                 shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(50))),
             //                 text: 'Remove',
             //                 // loading: login is LoginLoading,
             //                 // disableTouchWhenLoading: true,
             //               )
             //           )
             //       )
             //     ],
             //   )
             //
             //   ],
             // ),
             // ),
               Align(
                 alignment: Alignment.bottomCenter,
                 child:
                     Padding(
                       padding: EdgeInsets.only(left:40.0,right:65.0),
                       child:
                   AppButton(
                     onPressed: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>Payment(addTimeData: widget.addTimeData,cartDet: widget.cartDetails,)));
                     },
                     shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(50))),
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
           )



    )));
  }
  
}