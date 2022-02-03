import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:orderly/Api/api.dart';
import 'package:orderly/Blocs/authentication/bloc.dart';
import 'package:orderly/Configs/image.dart';
import 'package:orderly/Configs/theme.dart';
import 'package:orderly/Models/model_product_List.dart';
import 'package:orderly/Models/model_scoped_cart.dart';
import 'package:orderly/Models/model_view_cart.dart';
import 'package:orderly/Screens/Customer/cart/shopping_cart.dart';
import 'package:orderly/Utils/Utils.dart';
import 'package:orderly/Utils/application.dart';
import 'package:orderly/Widgets/app_button.dart';
import 'package:shimmer/shimmer.dart';
import 'package:http/http.dart' as http;


import '../../../app_bloc.dart';

class HomeItemDetail extends StatefulWidget {
  List<Product> productList;
  int index;
  CartModel cartModel;

  HomeItemDetail({Key key, @required this.productList,@required this.index,@required this.cartModel}) : super(key: key);

  _HomeItemDetailState createState() => _HomeItemDetailState();
}

class _HomeItemDetailState extends State<HomeItemDetail> {
  final _controller = SwiperController();
  final _listController = ScrollController();
  int _index = 0;

  ///On Process index change
  void _onChange(int index) {
    setState(() {
      _index = index;
    });
    final currentOffset = (index + 1) * 94.0;
    final widthDevice = MediaQuery.of(context).size.width;

    ///Animate scroll to Overflow offset
    if (currentOffset > widthDevice) {
      _listController.animateTo(
        currentOffset - widthDevice,
        duration: Duration(milliseconds: 250),
        curve: Curves.easeOut,
      );
    } else {
      ///Move to Start offset when index not overflow
      _listController.animateTo(
        0.0,
        duration: Duration(milliseconds: 250),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
        appBar: new AppBar(
          leading: InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Icon(
                Icons.arrow_back_ios,
                color: AppTheme.textColor,
              )),
          backgroundColor: Colors.white,
          elevation: 0,
          // actions: [
          //   Row(
          //     children: [
          //       InkWell(
          //           onTap: (){
          //
          //           },
          //           child:Stack(children: [
          //             // IconButton(
          //             //   icon:
          //             Image.asset(
          //               Images.notiIcon,
          //               width: 37.0,
          //               height: 37.0,
          //             ),
          //             // tooltip: "Save Todo and Retrun to List",
          //             //   onPressed: () {},
          //             // ),
          //             Positioned(
          //               right: 5,
          //               top:1,
          //               child: new Container(
          //                 padding: EdgeInsets.all(1),
          //                 decoration: new BoxDecoration(
          //                   color: Colors.red,
          //                   borderRadius: BorderRadius.circular(8.5),
          //                 ),
          //                 constraints: BoxConstraints(
          //                   minWidth: 17,
          //                   minHeight: 4,
          //                 ),
          //                 child: Text(
          //                   "0",
          //                   style: new TextStyle(
          //                       color: Colors.white,
          //                       fontSize: 10,
          //                       fontWeight: FontWeight.w400,
          //                       fontFamily: 'Poppins'
          //                   ),
          //                   textAlign: TextAlign.center,
          //                 ),
          //               ),
          //             ),
          //             // if(Application.user.userType=="1")//for fleet
          //             // Positioned(
          //             //   right: 5,
          //             //   top: 5,
          //             //   child: new Container(
          //             //     padding: EdgeInsets.all(1),
          //             //     decoration: new BoxDecoration(
          //             //       color: Colors.red,
          //             //       borderRadius: BorderRadius.circular(8.5),
          //             //     ),
          //             //     constraints: BoxConstraints(
          //             //       minWidth: 17,
          //             //       minHeight: 17,
          //             //     ),
          //             //     child: Text(
          //             //       "0",
          //             //       style: new TextStyle(
          //             //           color: Colors.white,
          //             //           fontSize: 10,
          //             //           fontWeight: FontWeight.w400,
          //             //           fontFamily: 'Poppins'
          //             //       ),
          //             //       textAlign: TextAlign.center,
          //             //     ),
          //             //   ),
          //             // )
          //           ],
          //           )),
          //       InkWell(
          //         onTap: (){
          //           // CartModel cartmodel=await
          //           Navigator.push(context, MaterialPageRoute(
          //               builder: (context)=>
          //                   ShoppingCart(productList: widget.productList,conveyanceFee: Application.preferences.getString("convFee"),)
          //           ));
          //           // if(cartmodel!=null){
          //           //   setState(() {
          //           //     Application.cartModel=cartModel;
          //           //
          //           //   });
          //           // }
          //         },
          //         child: Stack(
          //           children: [
          //             Image.asset(
          //               Images.cart,
          //               width: 37.0,
          //               height: 37.0,
          //             ),
          //             // tooltip: "Save Todo and Retrun to List",
          //             // onPressed: () {
          //             //   // Navigator.push(context, MaterialPageRoute(
          //             //   //     builder: (context)=> ShoppingCart()
          //             //   // ));
          //             // },
          //             // ),
          //             Positioned(
          //               right: 2,
          //               top:1,
          //               child: new Container(
          //                 padding: EdgeInsets.all(1),
          //                 decoration: new BoxDecoration(
          //                   color: Colors.red,
          //                   borderRadius: BorderRadius.circular(8.5),
          //                 ),
          //                 constraints: BoxConstraints(
          //                   minWidth: 17,
          //                   minHeight: 2,
          //                 ),
          //                 child: Text(
          //                   Application.cartModel!=null?Application.cartModel.cart.length.toString():"0",
          //                   style: new TextStyle(
          //                       color: Colors.white,
          //                       fontSize: 10,
          //                       fontWeight: FontWeight.w400,
          //                       fontFamily: 'Poppins'
          //                   ),
          //                   textAlign: TextAlign.center,
          //                 ),
          //               ),
          //             )
          //           ],
          //         ),
          //       )
          //     ],
          //   )
          // ],
        ),
        body: SafeArea(
            child: Container(
                child: new Column(
          children: <Widget>[
            //for viewpager
            Expanded(child: SwiperPage(productData: widget.productList[widget.index])),
            Expanded(
              flex: 2,
              child: ItemDetailView(productData: widget.productList,pos: widget.index,model:widget.cartModel),
            )
          ],
        ))));
  }
}

//for viewpager
class SwiperPage extends StatefulWidget {
  Product productData;

  SwiperPage({Key key, @required this.productData}) : super(key: key);

  _SwiperPageState createState() => _SwiperPageState();
}

class _SwiperPageState extends State<SwiperPage> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Swiper(
      itemBuilder: (BuildContext context, int index) {
        // return
        //   new Image.asset(
        //   Images.truckFull,
        //   fit: BoxFit.fill,
        // );
        return CachedNetworkImage(
          imageUrl: widget.productData.productImage,
          imageBuilder: (context, imageProvider) {
            return Container(
              decoration: BoxDecoration(
                // border: Border.all(
                //     color: index == _index
                //         ? Theme.of(context).primaryColor
                //         : Theme.of(context).dividerColor),
                // borderRadius: BorderRadius.all(
                //   Radius.circular(8),
                // ),
                image: DecorationImage(
                  image: imageProvider,
                  fit: BoxFit.fill,
                ),
              ),
            );
          },
          placeholder: (context, url) {
            return Shimmer.fromColors(
              baseColor: Theme.of(context).hoverColor,
              highlightColor: Theme.of(context).highlightColor,
              enabled: true,
              child: Container(
                  // decoration: BoxDecoration(
                  //   border: Border.all(
                  //       color: index == _index
                  //           ? Theme.of(context).primaryColor
                  //           : Theme.of(context).dividerColor),
                  //   borderRadius: BorderRadius.all(
                  //     Radius.circular(8),
                  //   ),
                  // ),
                  ),
            );
          },
          errorWidget: (context, url, error) {
            return Shimmer.fromColors(
              baseColor: Theme.of(context).hoverColor,
              highlightColor: Theme.of(context).highlightColor,
              enabled: true,
              child: Container(
                // decoration: BoxDecoration(
                //   border: Border.all(
                //       color: index == _index
                //           ? Theme.of(context).primaryColor
                //           : Theme.of(context).dividerColor),
                //   borderRadius: BorderRadius.all(
                //     Radius.circular(8),
                //   ),
                // ),
                child: Icon(Icons.error),
              ),
            );
          },
        );
      },
      autoplay: false,
      itemCount: 1,
      scrollDirection: Axis.horizontal,
      pagination: new SwiperPagination(
          alignment: Alignment.bottomCenter, builder: SwiperPagination.dots
          // SwiperCustomPagination(builder:
          //     (BuildContext context, SwiperPluginConfig config) {
          //   return Container(
          //     padding: EdgeInsets.only(bottom: 10),
          //     child: config.activeIndex==0?Text.rich(
          //         TextSpan(text: "",style: TextStyle(color: Colors.white54),children: [
          //           TextSpan(text: "First   ",style: TextStyle(fontSize: 25.0,fontWeight: FontWeight.bold),),
          //           TextSpan(
          //             text: "   Second ",
          //             recognizer: TapGestureRecognizer()..onTap=(){_controller.next();},
          //
          //             //added recognizer over here
          //
          //             style: TextStyle(fontSize: 17.0,),)
          //         ])
          //     ):Text.rich(
          //         TextSpan(text: "",style: TextStyle(color: Colors.white54),children: [
          //           TextSpan(
          //             text: "First   ",
          //             recognizer: TapGestureRecognizer()..onTap=(){_controller.next();},
          //
          //             //added recognizer over here
          //
          //             style: TextStyle(fontSize: 17.0,),
          //           ),
          //           TextSpan(text: "    Second ",style: TextStyle(fontSize: 25.0,fontWeight: FontWeight.bold),)
          //         ])
          //     ),
          //   );
          // })
          ),
    );
  }
}

//for other view
class ItemDetailView extends StatefulWidget {
  List<Product> productData;
  int pos;
  CartModel model;

  ItemDetailView({Key key, @required this.productData,@required this.pos,@required this.model}) : super(key: key);

  _ItemDetailViewState createState() => _ItemDetailViewState();
}

class _ItemDetailViewState extends State<ItemDetailView> {
  int count ;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
     setCount();

  }

  void setCount(){
    if(Application.cartModel!=null && Application.cartModel.cart.length>0)
    {
      count=Application.cartModel.cart[widget.pos].qty;
      print(count);
    }else{
      count=1;
    }
  }

  Future<void> AddedToCart(CartModel model,String producerId,String productId,String qty,String price) async {
    Map<String,String> params={
      'producer_id':producerId,
      'product_id':productId,
      'user_id':Application.user.fbId,
      // 'qty':qty,
      'qty':qty, //updated on 4/01/2022 by default set to 1
      'rate_per_hour':price
    };

    var response = await http.post(Uri.parse(Api.ADD_TO_CART),
      body: params,
    );

    try{
      if (response.statusCode == 200) {
        var resp = json.decode(response.body);

        if(resp['msg']=="Successed"){
          final Iterable refactorCategory = resp['cart'] ?? [];
          final listCategory = refactorCategory.map((item) {
            return Cart.fromJson(item);
          }).toList();
          // //
          model.addProduct(listCategory[0]);
          AppBloc.authBloc.add(OnSaveCart(model));

          if(model!=null){
            CartModel cartmodel=await
            Navigator.push(context, MaterialPageRoute(builder: (context)=>
                ShoppingCart(flagFrom:"0",productList:widget.productData,price:price,cartModel:model,
                    conveyanceFee:Application.preferences.getString("convFee"))));
            if(cartmodel!=null){
              Application.cartModel=cartmodel;
              setCount();
            }
          }
        }else{
          print('exists');
          CartModel cartmodel=await
          Navigator.push(context, MaterialPageRoute(builder: (context)=>
              ShoppingCart(flagFrom:"0",productList:widget.productData,price:price,cartModel:model,conveyanceFee:Application.preferences.getString("convFee"))));
          if(cartmodel!=null){
            Application.cartModel=cartmodel;
            setCount();
          }
        }
        setState(() {

        });
        // await PsProgressDialog.showProgressWithoutMsg(context);
      }
    }catch(e){
      print(e);
    }
  }


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return SingleChildScrollView(
      child: Padding(
          padding: EdgeInsets.all(15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.productData[widget.pos].productName,
                    style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Poppins',
                        color: AppTheme.textColor),
                  ),
                  Text(
                    widget.productData[widget.pos].ratePerHour +
                        " " +
                        Utils.getCurrencyPerLocale(
                            widget.productData[widget.pos].currency) +
                        "/" +
                        widget.productData[widget.pos].unit,
                    style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'Poppins',
                        color: Theme.of(context).primaryColor),
                  )
                ],
              ),
              Padding(
                  padding: EdgeInsets.only(top: 10.0),
                  child: Text(
                    'Description',
                    style: TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Poppins',
                        color: AppTheme.textColor),
                  )),
              //desc
              Text(
                widget.productData[widget.pos].productDesc,
                style: TextStyle(
                    fontSize: 12.0,
                    fontWeight: FontWeight.w400,
                    fontFamily: 'Poppins',
                    color: AppTheme.textColor),
              ),

              //quantity
              Container(
                  margin: EdgeInsets.only(top: 50.0),
                  decoration: BoxDecoration(
                    border: Border.all(color: Theme.of(context).dividerColor),
                    borderRadius: BorderRadius.all(
                      Radius.circular(45.0),
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(15.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Quantity',
                          style: TextStyle(
                              fontSize: 14.0,
                              fontWeight: FontWeight.w400,
                              fontFamily: 'Poppins',
                              color: AppTheme.textColor),
                        ),
                        Row(
                          children: [
                            Padding(
                                padding: EdgeInsets.only(right: 15.0),
                                child: InkWell(
                                    onTap: () {
                                      if (count != 1) {
                                        setState(() {
                                          count -= 1;
                                        });
                                      }
                                    },
                                    child: Image.asset(Images.minus,
                                        height: 22.0, width: 22.0))),
                            Text(
                              '${count}',
                              style: TextStyle(
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'Poppins',
                                  color: Theme.of(context).primaryColor),
                            ),
                            Padding(
                                padding: EdgeInsets.only(left: 15.0),
                                child: InkWell(
                                    onTap: () {
                                      setState(() {
                                        print(widget.productData[widget.pos].qty);
                                        if (count +1> widget.productData[widget.pos].qty) {
                                          //updated on 4/01/2022 for out of stock part
                                          Fluttertoast.showToast(
                                              msg: "Out Of stock");
                                        } else {
                                          count += 1;
                                        }
                                      });
                                    },
                                    child: Image.asset(
                                      Images.plus,
                                      height: 22.0,
                                      width: 22.0,
                                    ))),
                          ],
                        )
                      ],
                    ),
                  )),

              //buy now,add to cart
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Expanded(
                  //     child:Padding(padding: EdgeInsets.only(left:20.0,right:20.0,top:50.0),
                  //         child:
                  //         ElevatedButton(
                  //           style: ElevatedButton.styleFrom(
                  //               side: BorderSide(color: Theme.of(context).primaryColor, width: 1),
                  //               primary: Colors.white,
                  //               shape: RoundedRectangleBorder(
                  //                   borderRadius: BorderRadius.circular(50.0)
                  //               )
                  //           ),
                  //           // shape: shape,
                  //           onPressed: (){
                  //             Navigator.push(
                  //                 context,
                  //                 MaterialPageRoute(
                  //                     builder: (context) =>
                  //                     ShoppingCart()));
                  //           },
                  //           child: Row(
                  //             crossAxisAlignment: CrossAxisAlignment.center,
                  //             mainAxisAlignment: MainAxisAlignment.center,
                  //             children: <Widget>[
                  //               Padding(padding: EdgeInsets.all(10.0),child:Text(
                  //                 'Add To Cart',
                  //                 style: Theme.of(context)
                  //                     .textTheme
                  //                     .button
                  //                     .copyWith(color: AppTheme.textColor, fontSize:14.0,fontWeight: FontWeight.w500),
                  //               )
                  //               ),
                  //             ],
                  //           ),
                  //         )
                  //     )),
                  //save
                  Expanded(
                      child: Padding(
                          padding: EdgeInsets.only(
                              left: 20.0, right: 20.0, top: 50.0),
                          child: AppButton(
                            onPressed: () {
                              AddedToCart(widget.model, widget.productData[widget.pos].producerid.toString(),
                                 widget.productData[widget.pos].productId.toString(),
                                 count.toString(), widget.productData[widget.pos].ratePerHour) ;
                            },
                            shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(50))),
                            text: 'Add To Cart',
                            // loading: login is LoginLoading,
                            // disableTouchWhenLoading: true,
                          )))
                ],
              )
            ],
          )),
    );
  }
}
