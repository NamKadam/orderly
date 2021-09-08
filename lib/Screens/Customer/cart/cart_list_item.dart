import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:orderly/Configs/image.dart';
import 'package:orderly/Configs/theme.dart';
import 'package:orderly/Models/model_scoped_cart.dart';
import 'package:orderly/Models/model_view_cart.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shimmer/shimmer.dart';

class CartListItem extends StatefulWidget{
  Products cartItem;
  int index;
  CartModel model;
  double totalCartValue;
  CartListItem({Key key,@required this.cartItem,@required this.index,@required this.model,@required this.totalCartValue}):super(key:key);
  _CartListItemState createState()=>_CartListItemState();
}

class _CartListItemState extends State<CartListItem>{
  double totalCartValue = 0;
  int quantity = 0;

   void initState() {
     super.initState();
   }

   void calculateTotal(List<Cart> cartList) {
     // totalCartValue = 0;
     quantity = 0;
     String json = jsonEncode(cartList);
     // var json1 = jsonEncode(cartList.map((e) => e.toJson()).toList());
     print("cartList:-"+json);
     cartList.forEach((f) {
       widget.totalCartValue += f.ratePerHour * f.qty;
       quantity += f.qty;
       print('total cart value:-' + totalCartValue.toString());
       print('quantity:-' + quantity.toString());
     });
     setState(() {

     });
   }


   @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ScopedModel<CartModel>(
        model: widget.model,
        child:ScopedModelDescendant<CartModel>(
          builder: (context, child, model){
            return  Padding(
              padding: const EdgeInsets.only(
                top: 5,
              ),
              child:
              Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    color: Colors.transparent,
                    // height: MediaQuery.of(context).size.height * 0.15,
                    // width: MediaQuery.of(context).size.width ,
                    // decoration: BoxDecoration(
                    //   borderRadius: BorderRadius.circular(10.0),
                    // ),
                    child: Card(
                        elevation: 0.0,
                        // shape: RoundedRectangleBorder(
                        //     borderRadius: BorderRadius.circular(5.0),
                        //     side: BorderSide(
                        //       color: Colors.grey,
                        //       width: 0.5,
                        //     )),
                        // borderOnForeground: true,
                        child:
                        Column(
                          children: [
                            Padding(
                                padding: EdgeInsets.all(10.0),
                                child:
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [

                                    CachedNetworkImage(
                                      filterQuality: FilterQuality.medium,
                                      // imageUrl: Api.PHOTO_URL + widget.users.avatar,
                                      // imageUrl:"https://images.unsplash.com/photo-1438761681033-6461ffad8d80?ixid=MXwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=1050&q=80",
                                      imageUrl: widget.cartItem.productImage == null
                                          ? "https://images.unsplash.com/photo-1438761681033-6461ffad8d80?ixid=MXwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=1050&q=80"
                                          : widget.cartItem.productImage,
                                      placeholder: (context, url) {
                                        return Shimmer.fromColors(
                                          baseColor: Theme.of(context).hoverColor,
                                          highlightColor: Theme.of(context).highlightColor,
                                          enabled: true,
                                          child: Container(
                                            height: 80,
                                            width: 80,
                                            decoration: BoxDecoration(
                                              color: Colors.white,

                                              borderRadius: BorderRadius.circular(8),
                                            ),

                                          ),
                                        );
                                      },
                                      imageBuilder: (context, imageProvider) {
                                        return Container(
                                          height: 80,
                                          width: 80,
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                              image: imageProvider,
                                              fit: BoxFit.cover,

                                            ),
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                        );
                                      },
                                      errorWidget: (context, url, error) {
                                        return Shimmer.fromColors(
                                          baseColor: Theme.of(context).hoverColor,
                                          highlightColor: Theme.of(context).highlightColor,
                                          enabled: true,
                                          child: Container(
                                            height: 80,
                                            width: 80,
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                            child: Icon(Icons.error),
                                          ),
                                        );
                                      },
                                    ),

                                    SizedBox(
                                      width: 10.0,
                                    ),
                                    Expanded(
                                        child:
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              widget.cartItem.productName,
                                              // widget.users.firstName+" "+widget.users.lastName,
                                              style: Theme.of(context).textTheme.caption.copyWith(
                                                  fontSize: 14.0,
                                                  fontWeight: FontWeight.w600,
                                                  color: AppTheme.textColor,
                                                  fontFamily: "Poppins"),
                                            ),

                                            Text(
                                              widget.cartItem.productDesc==null?"":widget.cartItem.productDesc,
                                              style: Theme.of(context).textTheme.button.copyWith(
                                                  fontSize: 13.0,
                                                  color: AppTheme.textColor,
                                                  fontWeight: FontWeight.w400,
                                                  fontFamily: "Poppins"),
                                            ),
                                            Text(
                                              widget.cartItem.truckName==null?"sold by: ":"sold by: "+widget.cartItem.truckName,
                                              style: Theme.of(context).textTheme.button.copyWith(
                                                  fontSize: 12.0,
                                                  color: AppTheme.textColor,
                                                  fontWeight: FontWeight.w300,
                                                  fontFamily: "Poppins"),
                                            ),

                                            Text(
                                              // widget.users.address != null
                                              //     ? widget.users.address
                                              //     : "",
                                              widget.cartItem.ratePerHour.toString()+" \$/Hr",
                                              style: Theme.of(context).textTheme.button.copyWith(
                                                  fontSize: 13.0,
                                                  color: Theme.of(context).primaryColor,
                                                  fontWeight: FontWeight.w600,
                                                  fontFamily: "Poppins"),
                                            ),
                                          ],
                                        )),


                                  ],
                                )),
                            //quantity
                            Container(
                                margin: EdgeInsets.all(15.0),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color:Theme.of(context).dividerColor),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(45.0),
                                  ),

                                ),
                                child:
                                Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child:
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('Quantity',
                                        style: TextStyle(
                                            fontSize: 14.0,
                                            fontWeight: FontWeight.w500,
                                            fontFamily: 'Poppins',
                                            color: AppTheme.textColor
                                        ),
                                      ),


                                      Row(
                                        children: [
                                          Padding(
                                              padding: EdgeInsets.only(right:15.0),
                                              child:
                                              InkWell(
                                                  onTap: (){
                                                    model.updateProduct(model.cart[widget.index], model.cart[widget.index].qty - 1);
                                                    // if (model.cart[widget.index].qty== 0) {
                                                    //   // cartList.removeAt(index);
                                                    //   removeProduct(cartList,model.cart[index]);
                                                    // }
                                                    // calculateTotal(cartList);
                                                  },
                                                  child:
                                                  Image.asset(Images.minus,height: 22.0,width:22.0)
                                              )),
                                          Text(
                                            widget.cartItem.qty.toString(),
                                            style: TextStyle(
                                                fontSize: 15.0,
                                                fontWeight: FontWeight.w600,
                                                fontFamily: 'Poppins',
                                                color: Theme.of(context).primaryColor
                                            ),
                                          ),

                                          Padding(
                                              padding: EdgeInsets.only(left:15.0),
                                              child:InkWell(
                                                  onTap: (){
                                                    model.updateProduct(model.cart[widget.index], model.cart[widget.index].qty + 1);
                                                    calculateTotal(widget.model.cart);

                                                  },
                                                  child:
                                                  Image.asset(Images.plus,height: 22.0,width: 22.0,)
                                              )
                                          ),
                                        ],
                                      )

                                    ],
                                  ),
                                )
                            ),
                          ],
                        )

                    ),
                  ),
                  Positioned(
                    right: 0.0,
                    top: 5.0,
                    child: Container(
                      // width:30.0,height:30.0,
                      decoration: BoxDecoration(
                        // color: Colors.greenAccent,
                        // borderRadius: BorderRadius.circular(20.0),
                      ),
                      margin: const EdgeInsets.symmetric(horizontal: 4.0),
                      child:
                      // CircleAvatar(
                      // child:
                      IconButton(
                        // hoverColor: Theme.of(context).primaryColor,
                        splashColor: Colors.white,
                        icon:
                        Image.asset(Images.delete,width:15.0,height:15.0,),

                        onPressed: () {
                          // if (_formKey.currentState.validate()) {
                          // sendMessage();
                          // }
                          // Navigator.push(
                          //     context,
                          //     MaterialPageRoute(
                          //         builder: (context) =>
                          //         new MemberDetails(userListData:widget.users))
                          // );

                        },
                      ),
                      // backgroundColor: Colors.black,
                      // )


                    ),
                  ),
                ],
              ),
            );
          },
        )
    );

  }
  
}