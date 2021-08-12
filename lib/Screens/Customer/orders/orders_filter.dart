import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:orderly/Configs/image.dart';
import 'package:orderly/Configs/theme.dart';
import 'package:orderly/Utils/routes.dart';
import 'package:orderly/Utils/translate.dart';

class OrdersFilter extends StatefulWidget{
  _OrdersFilterState createState()=>_OrdersFilterState();
}

class _OrdersFilterState extends State<OrdersFilter>{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: new AppBar(
        title: Text('Filter',style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
            fontSize: 18.0,
            color: AppTheme.textColor
        ),),
        leading: InkWell(
            onTap: (){
              Navigator.pop(context);
            },
            child:Icon(Icons.arrow_back_ios,color: AppTheme.textColor,)
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        child: Column(

          children: [
            Container(
              color: Colors.white,
              child:
               Column(
                 mainAxisAlignment: MainAxisAlignment.start,
                 crossAxisAlignment: CrossAxisAlignment.start,
                 children: [
                   Padding(padding: EdgeInsets.only(left:15.0,right: 15.0,top: 15.0),
              child:
                 Text(
                     'Order Time Filter',
                     style: TextStyle(
                       color: Theme.of(context).primaryColor,
                       fontSize: 14.0,
                       fontFamily: 'Poppins',
                       fontWeight: FontWeight.w400,
                     ),
                   )),
                   Padding(
                     padding: EdgeInsets.all(10.0),
                     child: Card(
                       elevation: 5.0,
                       child: Column(
                         children: [
                           //orders
                           Row(
                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                             children: [
                               Padding(
                                   padding: EdgeInsets.only(left:15.0),
                                   child:Text(Translate.of(context).translate('my_order'),style: TextStyle(fontWeight:FontWeight.w400,
                                       fontFamily: 'Poppins',color: AppTheme.textColor),
                                   )),

                               IconButton(onPressed: (){},
                                   icon: Image.asset(Images.arrow,height: 15.0,width:15.0)

                               )
                             ],
                           ),
                           Divider(
                             height: 0.5,
                             color: Colors.black26,
                           ),
                           //help
                           Row(
                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                             children: [
                               Padding(
                                   padding: EdgeInsets.only(left:15.0),
                                   child:Text(Translate.of(context).translate('help'),style: TextStyle(fontWeight:FontWeight.w400,
                                       fontFamily: 'Poppins',color: AppTheme.textColor),
                                   )),

                               IconButton(onPressed: (){},
                                   icon: Image.asset(Images.arrow,height: 15.0,width:15.0)

                               )
                             ],
                           ),
                           Divider(
                             height: 0.5,
                             color: Colors.black26,
                           ),
                           //address
                           InkWell(
                               onTap: (){
                                 Navigator.pushNamed(context, Routes.address);

                               },
                               child:
                               Row(
                                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                 children: [
                                   Padding(
                                       padding: EdgeInsets.only(left:15.0),
                                       child:Text(Translate.of(context).translate('address'),style: TextStyle(fontWeight:FontWeight.w400,
                                           fontFamily: 'Poppins',color: AppTheme.textColor),
                                       )),

                                   IconButton(onPressed: (){
                                     Navigator.pushNamed(context, Routes.address);
                                   },
                                       icon: Image.asset(Images.arrow,height: 15.0,width:15.0)

                                   )
                                 ],
                               )),
                           //faq
                           Divider(
                             height: 0.5,
                             color: Colors.black26,
                           ),
                           Row(
                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                             children: [
                               Padding(
                                   padding: EdgeInsets.only(left:15.0),
                                   child:Text(Translate.of(context).translate('faq'),style: TextStyle(fontWeight:FontWeight.w400,
                                       fontFamily: 'Poppins',color: AppTheme.textColor),
                                   )),

                               IconButton(onPressed: (){},
                                   icon: Image.asset(Images.arrow,height: 15.0,width:15.0)

                               )
                             ],
                           ),
                           Divider(
                             height: 0.5,
                             color: Colors.black26,
                           ),
                           //terms
                           Row(
                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                             children: [
                               Padding(
                                   padding: EdgeInsets.only(left:15.0),
                                   child:Text(Translate.of(context).translate('terms_of_use'),style: TextStyle(fontWeight:FontWeight.w400,
                                       fontFamily: 'Poppins',color: AppTheme.textColor),
                                   )),

                               IconButton(onPressed: (){},
                                   icon: Image.asset(Images.arrow,height: 15.0,width:15.0)

                               )
                             ],
                           ),
                           Divider(
                             height: 0.5,
                             color: Colors.black26,
                           ),
                           //privacy
                           Row(
                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                             children: [
                               Padding(
                                   padding: EdgeInsets.only(left:15.0),
                                   child:Text(Translate.of(context).translate('privacy_policy'),style: TextStyle(fontWeight:FontWeight.w400,
                                       fontFamily: 'Poppins',color: AppTheme.textColor),
                                   )),

                               IconButton(onPressed: (){},
                                   icon: Image.asset(Images.arrow,height: 15.0,width:15.0)

                               )
                             ],
                           ),

                         ],
                       ),
                     ),
                   ),
                 ],
               )
            )


          ],
        ),
      ),
    );

  }
  
}