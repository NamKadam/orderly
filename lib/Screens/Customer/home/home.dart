import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:orderly/Configs/image.dart';
import 'package:orderly/Configs/theme.dart';
import 'package:orderly/Models/cart_model.dart';
import 'package:orderly/Screens/Customer/home/home_item_detail.dart';
import 'package:orderly/Utils/routes.dart';
import 'package:orderly/Utils/translate.dart';
import 'package:orderly/Widgets/app_button.dart';
import 'package:shimmer/shimmer.dart';
import 'package:scoped_model/scoped_model.dart';

class Home extends StatefulWidget {
  CartModel model;

  Home({Key key, @required this.model}) : super(key: key);

  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  List<int> selectedIndexList = []; //for selected index
  List<Product> productLists = [];
  List<Product> cartList = []; //added as per total calculate count
  double totalCartValue = 0;
  int quantity=0;


  // List<Product> _products = [
  //   Product(
  //       id: 1,
  //       title: "Apple",
  //       price: 20.0,
  //       imgUrl: "http://via.placeholder.com/350x150",
  //       qty: 1),
  //   Product(
  //       id: 2,
  //       title: "Banana",
  //       price: 40.0,
  //       imgUrl: "http://via.placeholder.com/350x150",
  //       qty: 1),
  //   Product(
  //       id: 3,
  //       title: "Orange",
  //       price: 20.0,
  //       imgUrl: "http://via.placeholder.com/350x150",
  //       qty: 1),
  //   Product(
  //       id: 4,
  //       title: "Melon",
  //       price: 40.0,
  //       imgUrl: "http://via.placeholder.com/350x150",
  //       qty: 1),
  //   Product(
  //       id: 5,
  //       title: "Avocado",
  //       price: 25.0,
  //       imgUrl: "http://via.placeholder.com/350x150",
  //       qty: 1),
  // ];

  void getProducts() {
    for (int i = 0; i < 10; i++) {
      Product product = new Product(
          id: i,
          title: "Prime Roof Truck",
          price: 25,
          qty: 1,
          imgUrl: "http://via.placeholder.com/350x150");
      productLists.add(product);
    }
  }

  void initState() {
    super.initState();
    getProducts();
    // widget.model.cart.addAll(productLists);
  }

  void calculateTotal(List<Product> cartList) {
    totalCartValue = 0;
    quantity=0;
    cartList.forEach((f) {
      totalCartValue += f.price * f.qty;
      quantity+=f.qty;
      print('total cart value:-'+totalCartValue.toString());
      print('quantity:-'+quantity.toString());
    });
    setState(() {

    });

  }


  @override
  Widget build(BuildContext context) {
    // Widget buildCategory(List<CategoryModel> location) {
    Widget buildCategory() {
      // if (location == null) {
      //   return ListView.builder(
      //     scrollDirection: Axis.horizontal,
      //     padding: EdgeInsets.only(left: 5, right: 20, top: 10, bottom: 15),
      //     itemBuilder: (context, index) {
      //       return Padding(
      //         padding: EdgeInsets.only(left: 15),
      //         child: AppCategory(
      //           type: CategoryView.cardLarge,
      //         ),
      //       );
      //     },
      //     itemCount: List.generate(8, (index) => index).length,
      //   );
      // }

      return ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.only(left: 5, right: 20, top: 10, bottom: 15),
        itemBuilder: (context, index) {
          // final item = location[index];
          return Padding(
              padding: EdgeInsets.only(left: 15),
              child:
              // AppCategory(
              //   item: item,
              //   type: CategoryView.cardLarge,
              //   onPressed: (item) {
              //     Navigator.pushNamed(
              //       context,
              //       Routes.listProduct,
              //       arguments: item,
              //     );
              //   },
              // ),
              GestureDetector(
                  onTap: () {
                    print('clicked category');
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      CachedNetworkImage(
                        imageUrl: "http://via.placeholder.com/350x150",
                        imageBuilder: (context, imageProvider) {
                          return Container(
                            height: 70.0,
                            width: 70.0,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(
                                Radius.circular(35),
                              ),
                              image: DecorationImage(
                                image: imageProvider,
                                fit: BoxFit.cover,
                              ),
                            ),
                            child: Container(
                              padding: EdgeInsets.all(8),
                            ),
                          );
                        },
                        placeholder: (context, url) {
                          return Shimmer.fromColors(
                            baseColor: Theme.of(context).hoverColor,
                            highlightColor:
                            Theme.of(context).highlightColor,
                            enabled: true,
                            child: Container(
                              height: 70.0,
                              width: 70.0,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(35),
                                ),
                              ),
                            ),
                          );
                        },
                        errorWidget: (context, url, error) {
                          return Shimmer.fromColors(
                            baseColor: Theme.of(context).hoverColor,
                            highlightColor:
                            Theme.of(context).highlightColor,
                            enabled: true,
                            child: Container(
                              height: 70.0,
                              width: 70.0,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(35),
                                ),
                              ),
                              child: Icon(Icons.error),
                            ),
                          );
                        },
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 8, right: 8),
                        child: Text(
                          'Producers',
                          style: TextStyle(
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w600,
                              fontSize: 12.0,
                              color: AppTheme.textColor),
                        ),
                      )
                    ],
                  )));
        },
        itemCount: 10,
      );
    }

    Widget buildListViewItemProd(index, CartModel model) {
      // if (location == null) {
      //   return ListView.builder(
      //     scrollDirection: Axis.horizontal,
      //     padding: EdgeInsets.only(left: 5, right: 20, top: 10, bottom: 15),
      //     itemBuilder: (context, index) {
      //       return Padding(
      //         padding: EdgeInsets.only(left: 15),
      //         child: AppCategory(
      //           type: CategoryView.cardLarge,
      //         ),
      //       );
      //     },
      //     itemCount: List.generate(8, (index) => index).length,
      //   );
      // }

      // return ListView.builder(
      //   itemCount: 10,
      //   scrollDirection: Axis.vertical,
      //   padding: EdgeInsets.only(left: 5, right: 20, top: 10, bottom: 15),
      //   itemBuilder: (context, index) {

      return FractionallySizedBox(
          widthFactor: 0.5,
          child: Container(
              padding: EdgeInsets.only(left: 8),
              child: Card(
                elevation: 3.0,
                shape: RoundedRectangleBorder(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    CachedNetworkImage(
                      imageUrl: productLists[index].imgUrl,
                      imageBuilder: (context, imageProvider) {
                        return Container(
                          height: 110,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.zero,
                            image: DecorationImage(
                              image: imageProvider,
                              fit: BoxFit.cover,
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
                            height: 110,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.zero,
                              color: Colors.white,
                            ),
                          ),
                        );
                      },
                      errorWidget: (context, url, error) {
                        return Shimmer.fromColors(
                          baseColor: Theme.of(context).hoverColor,
                          highlightColor: Theme.of(context).highlightColor,
                          enabled: true,
                          child: Container(
                            height: 110,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.zero,
                            ),
                            child: Icon(Icons.error),
                          ),
                        );
                      },
                    ),
                    Padding(padding: EdgeInsets.only(top: 3)),
                    Text(
                      productLists[index].title,
                      style: Theme.of(context).textTheme.caption.copyWith(
                          fontWeight: FontWeight.w400,
                          fontFamily: 'Poppins',
                          color: AppTheme.textColor),
                    ),
                    Padding(padding: EdgeInsets.only(top: 2)),
                    Text(
                      productLists[index].price.toString() + " \$/hr",
                      maxLines: 1,
                      style: Theme.of(context).textTheme.subtitle2.copyWith(
                          fontWeight: FontWeight.w600,
                          fontFamily: "Poppins",
                          color: Theme.of(context).primaryColor),
                    ),
                    Padding(
                        padding: EdgeInsets.all(15.0),
                        child: SizedBox(
                            height: 25.0,
                            width: MediaQuery.of(context).size.width,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                side: BorderSide(
                                    color: Theme.of(context).primaryColor,
                                    width: 1),
                                primary: selectedIndexList.contains(index)
                                    ? Theme.of(context).primaryColor
                                    : AppTheme.verifyPhone,
                                shape: const RoundedRectangleBorder(
                                    borderRadius:
                                    BorderRadius.all(Radius.circular(50))),
                              ),
                              // shape: shape,
                              onPressed: () {
                                // Navigator.push(context, MaterialPageRoute(builder: (context) => HomeItemDetail()));
                              },
                              child: !selectedIndexList.contains(index)
                                  ? GestureDetector(
                                  onTap: () {
                                    if (!selectedIndexList
                                        .contains(index)) {
                                      selectedIndexList.add(index);
                                    }
                                    // else {
                                    //   selectedIndexList.remove(index);
                                    // }
                                    cartList.add(productLists[index]);
                                    calculateTotal(cartList);
                                    setState(() {});
                                  },
                                  child: Stack(
                                    // mainAxisAlignment: MainAxisAlignment.center,
                                    // crossAxisAlignment: CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Align(
                                          alignment: Alignment.center,
                                          child: Text(
                                            'ADD',
                                            style: Theme.of(context)
                                                .textTheme
                                                .button
                                                .copyWith(
                                                color: Colors.black,
                                                fontWeight:
                                                FontWeight.w500,
                                                fontSize: 12.0),
                                          )),
                                      Align(
                                          alignment: Alignment.centerRight,
                                          //    child: InkWell(
                                          // onTap: (){
                                          //   setState(() {
                                          //     // flagClickDisableAdd=true;
                                          //
                                          //   });
                                          // },
                                          child: Icon(Icons.add,
                                              size: 20.0,
                                              color: Colors.black)
                                        // )
                                      )
                                    ],
                                  ))
                                  : index < 0
                                  ? Center(
                                  child: CircularProgressIndicator())
                                  : Row(
                                crossAxisAlignment:
                                CrossAxisAlignment.center,
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  InkWell(
                                      onTap: () {
                                        // setState(() {

                                        model.updateProduct(
                                            model.cart[index],
                                            model.cart[index].qty -
                                                1);

                                        if((model.cart[index].qty - 1)==0){
                                          cartList.removeAt(index);
                                          selectedIndexList.removeAt(index);
                                        }
                                        calculateTotal(cartList);







                                        // });
                                      },
                                      child: Icon(
                                        Icons.remove,
                                        color: Colors.white,
                                        size: 20.0,
                                      )),
                                  Text(
                                    model.cart[index].qty.toString(),
                                    style: Theme.of(context)
                                        .textTheme
                                        .button
                                        .copyWith(
                                        color: Colors.white,
                                        fontWeight:
                                        FontWeight.w400,
                                        fontSize: 12.0),
                                  ),
                                  InkWell(
                                      onTap: () {
                                        // setState(() {
                                        model.updateProduct(
                                            model.cart[index],
                                            model.cart[index].qty +
                                                1);
                                        calculateTotal(cartList);
                                        // });
                                      },
                                      child: Icon(
                                        Icons.add,
                                        color: Colors.white,
                                        size: 20.0,
                                      ))
                                ],
                              ),
                            )))
                  ],
                ),
              ))
        // }
      );
    }

    // TODO: implement build
    return Scaffold(
      // appBar: AppBar(title: Text("Home"),
      //   automaticallyImplyLeading:false,
      // ),
      body: Container(
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: [
              //for producer category
              // Expanded(
              //     child:
              Container(
                height: 120,
                child: buildCategory(),
                // )
              ),

              // for producer listview items
              Expanded(
                  flex: 3,
                  child: SingleChildScrollView(
                      child: Column(
                        children: [
                          // Expanded(
                          //     flex: 1,
                          //     child:
                          Container(
                            // height: 180,
                            child: CachedNetworkImage(
                              imageUrl: "http://via.placeholder.com/350x150",
                              imageBuilder: (context, imageProvider) {
                                return Container(
                                  height: 180,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.zero,
                                    image: DecorationImage(
                                      image: imageProvider,
                                      fit: BoxFit.cover,
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
                                    height: 120,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.zero,
                                      color: Colors.white,
                                    ),
                                  ),
                                );
                              },
                              errorWidget: (context, url, error) {
                                return Shimmer.fromColors(
                                  baseColor: Theme.of(context).hoverColor,
                                  highlightColor: Theme.of(context).highlightColor,
                                  enabled: true,
                                  child: Container(
                                    height: 120,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.zero,
                                    ),
                                    child: Icon(Icons.error),
                                  ),
                                );
                              },
                            ),
                          ),
                          // ),
                          // buildListViewItemProd()

                          // Expanded(
                          //   flex: 1,
                          //     child:
                          Padding(
                              padding: EdgeInsets.only(
                                  left: 15, right: 15, top: 15.0,
                                  bottom:
                                  selectedIndexList.length>0
                                      ?10.0:80.0),
                              child: Wrap(
                                runSpacing: 10,
                                alignment: WrapAlignment.spaceBetween,
                                children: List.generate(
                                    productLists.length, (index) => index)
                                    .map((item) {
                                  // return buildListViewItemProd(item);
                                  return ScopedModel<CartModel>(
                                      model: widget.model,
                                      child:
                                      ScopedModelDescendant<CartModel>(
                                          builder: (context, child, model) {
                                            widget.model=model;
                                            if (widget.model.cart.length == 0) {
                                              widget.model.cart.addAll(productLists);
                                            }

                                            return buildListViewItemProd(item, widget.model);
                                          })
                                  )
                                  ;
                                }).toList(),
                              )
                            //updated on 7/08/2021
                            // GridView.builder(
                            //   padding: EdgeInsets.all(8.0),
                            //   itemCount: productLists.length,
                            //   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount( crossAxisCount: 2, mainAxisSpacing: 8, crossAxisSpacing: 8, childAspectRatio: 0.8),
                            //   itemBuilder: (context, index){
                            //     return ScopedModel<CartModel>(
                            //         model: widget.model,
                            //         child:
                            //         ScopedModelDescendant<CartModel>(
                            //             builder: (context, child, model) {
                            //               model=widget.model;
                            //               if(model.cart.length==0)
                            //                 {
                            //                   model.cart.addAll(productLists);
                            //
                            //                 }
                            //               // return Card( child: Column( children: <Widget>[
                            //               //   Image.network(productLists[index].imgUrl, height: 120, width: 120,),
                            //               //   Text(productLists[index].title, style: TextStyle(fontWeight: FontWeight.bold),),
                            //               //   Text("\$"+productLists[index].price.toString()),
                            //               //   OutlineButton(
                            //               //       child: Text("Add"),
                            //               //       onPressed: () {
                            //               //         model.addProduct(productLists[index]);
                            //               //
                            //               //       }
                            //               //       )
                            //               // ]));
                            //               return Container(
                            //                   padding: EdgeInsets.only(left: 8),
                            //
                            //                   child:
                            //                   Card(
                            //                     elevation: 3.0,
                            //                     shape: RoundedRectangleBorder(
                            //
                            //                     ),
                            //                     child:
                            //
                            //                     Column(
                            //                       crossAxisAlignment: CrossAxisAlignment.center,
                            //                       children: <Widget>[
                            //                         CachedNetworkImage(
                            //                           imageUrl: productLists[index].imgUrl,
                            //                           imageBuilder: (context, imageProvider) {
                            //                             return Container(
                            //                               height: 110,
                            //                               decoration: BoxDecoration(
                            //                                 borderRadius: BorderRadius.zero,
                            //                                 image: DecorationImage(
                            //                                   image: imageProvider,
                            //                                   fit: BoxFit.cover,
                            //                                 ),
                            //                               ),
                            //
                            //                             );
                            //                           },
                            //                           placeholder: (context, url) {
                            //                             return Shimmer.fromColors(
                            //                               baseColor: Theme
                            //                                   .of(context)
                            //                                   .hoverColor,
                            //                               highlightColor: Theme
                            //                                   .of(context)
                            //                                   .highlightColor,
                            //                               enabled: true,
                            //                               child: Container(
                            //                                 height: 110,
                            //                                 decoration: BoxDecoration(
                            //                                   borderRadius: BorderRadius.zero,
                            //                                   color: Colors.white,
                            //                                 ),
                            //                               ),
                            //                             );
                            //                           },
                            //                           errorWidget: (context, url, error) {
                            //                             return Shimmer.fromColors(
                            //                               baseColor: Theme
                            //                                   .of(context)
                            //                                   .hoverColor,
                            //                               highlightColor: Theme
                            //                                   .of(context)
                            //                                   .highlightColor,
                            //                               enabled: true,
                            //                               child: Container(
                            //                                 height: 110,
                            //                                 decoration: BoxDecoration(
                            //                                   color: Colors.white,
                            //                                   borderRadius: BorderRadius.zero,
                            //                                 ),
                            //                                 child: Icon(Icons.error),
                            //                               ),
                            //                             );
                            //                           },
                            //                         ),
                            //                         Padding(padding: EdgeInsets.only(top: 3)),
                            //                         Text(
                            //                           productLists[index].title,
                            //                           style: Theme
                            //                               .of(context)
                            //                               .textTheme
                            //                               .caption!
                            //                               .copyWith(fontWeight: FontWeight.w400,fontFamily: 'Poppins',color: AppTheme.textColor),
                            //                         ),
                            //                         Padding(padding: EdgeInsets.only(top: 2)),
                            //                         Text(
                            //                           productLists[index].price.toString()+" \$/hr",
                            //                           maxLines: 1,
                            //                           style: Theme
                            //                               .of(context)
                            //                               .textTheme
                            //                               .subtitle2!
                            //                               .copyWith(fontWeight: FontWeight.w600,fontFamily: "Poppins",color: Theme.of(context).primaryColor),
                            //                         ),
                            //
                            //                         Padding(padding: EdgeInsets.all(15.0),
                            //                             child:
                            //                             SizedBox(
                            //                                 height: 25.0,
                            //                                 width: MediaQuery.of(context).size.width,
                            //                                 child:
                            //                                 ElevatedButton(
                            //                                   style: ElevatedButton.styleFrom(
                            //                                     side: BorderSide(color: Theme.of(context).primaryColor, width: 1),
                            //                                     primary: selectedIndexList.contains(index)?Theme.of(context).primaryColor:AppTheme.verifyPhone,
                            //
                            //                                     shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(50))),
                            //                                   ),
                            //                                   // shape: shape,
                            //                                   onPressed: (){
                            //                                     // Navigator.push(context, MaterialPageRoute(builder: (context) => HomeItemDetail()));
                            //
                            //                                   },
                            //                                   child:
                            //                                   !selectedIndexList.contains(index)
                            //                                       ?
                            //                                   GestureDetector(
                            //                                       onTap: (){
                            //                                         if (!selectedIndexList.contains(index)) {
                            //                                           selectedIndexList.add(index);
                            //                                         }
                            //                                         // else {
                            //                                         //   selectedIndexList.remove(index);
                            //                                         // }
                            //                                         // model.addProduct(productLists[index]);
                            //                                         setState(() {
                            //
                            //                                         });
                            //                                       },
                            //                                       child:
                            //                                       Stack(
                            //                                         // mainAxisAlignment: MainAxisAlignment.center,
                            //                                         // crossAxisAlignment: CrossAxisAlignment.center,
                            //                                         children: <Widget>[
                            //                                           Align(
                            //                                               alignment: Alignment.center,
                            //                                               child:
                            //                                               Text(
                            //                                                 'ADD',
                            //                                                 style: Theme.of(context)
                            //                                                     .textTheme
                            //                                                     .button!
                            //                                                     .copyWith(color: Colors.black, fontWeight: FontWeight.w500,fontSize: 12.0),
                            //                                               )),
                            //
                            //                                           Align(
                            //                                               alignment: Alignment.centerRight,
                            //                                               //    child: InkWell(
                            //                                               // onTap: (){
                            //                                               //   setState(() {
                            //                                               //     // flagClickDisableAdd=true;
                            //                                               //
                            //                                               //   });
                            //                                               // },
                            //                                               child: Icon(Icons.add,size: 20.0,color:Colors.black)
                            //                                             // )
                            //                                           )
                            //
                            //
                            //                                         ],
                            //                                       ))
                            //                                       :
                            //                                   index<0
                            //                                   ?
                            //                                   Center(child:CircularProgressIndicator())
                            //                                   :
                            //                                   Row(
                            //                                     crossAxisAlignment: CrossAxisAlignment.center,
                            //                                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            //                                     children: <Widget>[
                            //                                       InkWell(
                            //                                           onTap: (){
                            //                                             // setState(() {
                            //                                               model.updateProduct(model.cart[index],
                            //                                                   model.cart[index].qty - 1);
                            //                                             // });
                            //
                            //                                           },
                            //                                           child: Icon(Icons.remove,color: Colors.white,size: 20.0,)),
                            //                                       Text(
                            //                                         model.cart[index].qty.toString(),
                            //                                         style: Theme.of(context)
                            //                                             .textTheme
                            //                                             .button!
                            //                                             .copyWith(color: Colors.white, fontWeight: FontWeight.w400,fontSize: 12.0),
                            //                                       ),
                            //                                       InkWell(
                            //                                           onTap: (){
                            //                                             // setState(() {
                            //                                               model.updateProduct(model.cart[index],
                            //                                                   model.cart[index].qty + 1);
                            //                                             // });
                            //                                           },
                            //                                           child: Icon(Icons.add,color: Colors.white,size: 20.0,))
                            //                                     ],
                            //                                   ),
                            //
                            //                                 )
                            //                             )
                            //                         )
                            //                       ],
                            //                     ),
                            //                   )
                            //               );
                            //             }));
                            //   },
                            // ),
                          )
                          // ),
                        ],
                      ))),

              if (selectedIndexList.length > 0)
                Expanded(
                  flex: 1,
                  child: Container(
                      height: 40.0,
                      child: Padding(
                          padding: EdgeInsets.only(
                              left: 15.0, right: 15.0,top:10.0, bottom: 95.0),
                          child:
                          // SizedBox(
                          //     height: 40.0,
                          //     width: MediaQuery
                          //         .of(context)
                          //         .size
                          //         .width,
                          //     child:
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              side: BorderSide(
                                  color: Theme.of(context).primaryColor,
                                  width: 1),
                              primary: Theme.of(context).primaryColor,
                              shape: const RoundedRectangleBorder(
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(50))),
                            ),
                            // shape: shape,
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => HomeItemDetail()));
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Padding(
                                  padding:
                                  EdgeInsets.only(top: 5.0, left: 10.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        quantity.toString()+" Items",
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1
                                            .copyWith(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w300,
                                            fontSize: 12.0),
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            '\$ '+ totalCartValue.toString(),
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyText1
                                                .copyWith(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w600,
                                                fontSize: 14.0),
                                          ),
                                          Text(
                                            ' +plus taxes',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyText1
                                                .copyWith(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w300,
                                                fontSize: 12.0),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                                GestureDetector(
                                    onTap: ()=>Navigator.pushNamed(context, Routes.cart),
                                    child:Text(
                                      'VIEW CART',
                                      style: Theme.of(context)
                                          .textTheme
                                          .button
                                          .copyWith(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600),
                                    )),
                              ],
                            ),
                          )
                        // )
                      )),
                )
            ],
          )),
    );
  }
}



// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:orderly/Configs/image.dart';
// import 'package:orderly/Configs/theme.dart';
// import 'package:orderly/Models/cart_model.dart';
// import 'package:orderly/Screens/Customer/home/home_item_detail.dart';
// import 'package:orderly/Utils/translate.dart';
// import 'package:orderly/Widgets/app_button.dart';
// import 'package:shimmer/shimmer.dart';
//
//
// class Home extends StatefulWidget{
//   final CartModel model;
//
//   const Home({Key? key, required this.model}) : super(key: key);
//
//   _HomeState createState()=>_HomeState();
// }
//
// class _HomeState extends State<Home>{
//   List<int> selectedIndexList = []; //for selected index
//   List<Product> productLists=[];
//
//   void getProducts(){
//     for(int i=0;i<10;i++){
//       Product product=new Product(id: i, title: "Prime Roof Truck", price: 25, qty: 1, imgUrl: "http://via.placeholder.com/350x150");
//       productLists.add(product);
//     }
//   }
//
//   void initState() {
//     super.initState();
//     getProducts();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//
//     // Widget buildCategory(List<CategoryModel> location) {
//     Widget buildCategory() {
//       // if (location == null) {
//       //   return ListView.builder(
//       //     scrollDirection: Axis.horizontal,
//       //     padding: EdgeInsets.only(left: 5, right: 20, top: 10, bottom: 15),
//       //     itemBuilder: (context, index) {
//       //       return Padding(
//       //         padding: EdgeInsets.only(left: 15),
//       //         child: AppCategory(
//       //           type: CategoryView.cardLarge,
//       //         ),
//       //       );
//       //     },
//       //     itemCount: List.generate(8, (index) => index).length,
//       //   );
//       // }
//
//       return ListView.builder(
//         scrollDirection: Axis.horizontal,
//         padding: EdgeInsets.only(left: 5, right: 20, top: 10, bottom: 15),
//         itemBuilder: (context, index) {
//           // final item = location[index];
//           return Padding(
//               padding: EdgeInsets.only(left: 15),
//               child:
//               // AppCategory(
//               //   item: item,
//               //   type: CategoryView.cardLarge,
//               //   onPressed: (item) {
//               //     Navigator.pushNamed(
//               //       context,
//               //       Routes.listProduct,
//               //       arguments: item,
//               //     );
//               //   },
//               // ),
//               GestureDetector(
//                   onTap: (){
//                     print('clicked category');
//                   },
//                   child:
//                   Column(
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     children: [
//                       CachedNetworkImage(
//                         imageUrl: "http://via.placeholder.com/350x150",
//                         imageBuilder: (context, imageProvider) {
//                           return Container(
//                             height: 70.0,
//                             width: 70.0,
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.all(
//                                 Radius.circular(35),
//                               ),
//                               image: DecorationImage(
//                                 image: imageProvider,
//                                 fit: BoxFit.cover,
//                               ),
//                             ),
//                             child: Container(
//                               padding: EdgeInsets.all(8),
//
//                             ),
//                           );
//                         },
//                         placeholder: (context, url) {
//                           return Shimmer.fromColors(
//                             baseColor: Theme.of(context).hoverColor,
//                             highlightColor: Theme.of(context).highlightColor,
//                             enabled: true,
//                             child: Container(
//                               height: 70.0,
//                               width: 70.0,
//                               decoration: BoxDecoration(
//                                 borderRadius: BorderRadius.all(
//                                   Radius.circular(35),
//                                 ),
//                               ),
//                             ),
//                           );
//                         },
//                         errorWidget: (context, url, error) {
//                           return Shimmer.fromColors(
//                             baseColor: Theme.of(context).hoverColor,
//                             highlightColor: Theme.of(context).highlightColor,
//                             enabled: true,
//                             child: Container(
//                               height: 70.0,
//                               width: 70.0,
//                               decoration: BoxDecoration(
//                                 borderRadius: BorderRadius.all(
//                                   Radius.circular(35),
//                                 ),
//                               ),
//                               child: Icon(Icons.error),
//                             ),
//                           );
//                         },
//                       ),
//
//                       Padding(
//                         padding: EdgeInsets.only(left: 8, right: 8),
//
//                         child: Text(
//                           'Producers',
//                           style: TextStyle(
//                               fontFamily: 'Poppins',
//                               fontWeight: FontWeight.w600,
//                               fontSize: 12.0,
//                               color: AppTheme.textColor
//                           ),
//                         ),
//
//                       )
//
//                     ],
//                   )
//               )
//
//           );
//         },
//         itemCount: 10,
//       );
//     }
//
//     Widget buildListViewItemProd(index) {
//       // if (location == null) {
//       //   return ListView.builder(
//       //     scrollDirection: Axis.horizontal,
//       //     padding: EdgeInsets.only(left: 5, right: 20, top: 10, bottom: 15),
//       //     itemBuilder: (context, index) {
//       //       return Padding(
//       //         padding: EdgeInsets.only(left: 15),
//       //         child: AppCategory(
//       //           type: CategoryView.cardLarge,
//       //         ),
//       //       );
//       //     },
//       //     itemCount: List.generate(8, (index) => index).length,
//       //   );
//       // }
//
//       // return ListView.builder(
//       //   itemCount: 10,
//       //   scrollDirection: Axis.vertical,
//       //   padding: EdgeInsets.only(left: 5, right: 20, top: 10, bottom: 15),
//       //   itemBuilder: (context, index) {
//
//
//       return FractionallySizedBox(
//           widthFactor: 0.5,
//           child:
//           Container(
//               padding: EdgeInsets.only(left: 8),
//
//               child: Card(
//                 elevation: 3.0,
//                 shape: RoundedRectangleBorder(
//
//                 ),
//                 child:
//
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: <Widget>[
//                     CachedNetworkImage(
//                       imageUrl: "http://via.placeholder.com/350x150",
//                       imageBuilder: (context, imageProvider) {
//                         return Container(
//                           height: 120,
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.zero,
//                             image: DecorationImage(
//                               image: imageProvider,
//                               fit: BoxFit.cover,
//                             ),
//                           ),
//
//                         );
//                       },
//                       placeholder: (context, url) {
//                         return Shimmer.fromColors(
//                           baseColor: Theme
//                               .of(context)
//                               .hoverColor,
//                           highlightColor: Theme
//                               .of(context)
//                               .highlightColor,
//                           enabled: true,
//                           child: Container(
//                             height: 120,
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.zero,
//                               color: Colors.white,
//                             ),
//                           ),
//                         );
//                       },
//                       errorWidget: (context, url, error) {
//                         return Shimmer.fromColors(
//                           baseColor: Theme
//                               .of(context)
//                               .hoverColor,
//                           highlightColor: Theme
//                               .of(context)
//                               .highlightColor,
//                           enabled: true,
//                           child: Container(
//                             height: 120,
//                             decoration: BoxDecoration(
//                               color: Colors.white,
//                               borderRadius: BorderRadius.zero,
//                             ),
//                             child: Icon(Icons.error),
//                           ),
//                         );
//                       },
//                     ),
//                     Padding(padding: EdgeInsets.only(top: 3)),
//                     Text(
//                       "Prime Roof truck ",
//                       style: Theme
//                           .of(context)
//                           .textTheme
//                           .caption!
//                           .copyWith(fontWeight: FontWeight.w400,fontFamily: 'Poppins',color: AppTheme.textColor),
//                     ),
//                     Padding(padding: EdgeInsets.only(top: 2)),
//                     Text(
//                       "25 \$/hr",
//                       maxLines: 1,
//                       style: Theme
//                           .of(context)
//                           .textTheme
//                           .subtitle2!
//                           .copyWith(fontWeight: FontWeight.w600,fontFamily: "Poppins",color: Theme.of(context).primaryColor),
//                     ),
//
//                     Padding(padding: EdgeInsets.all(15.0),
//                         child:
//                         SizedBox(
//                             height: 25.0,
//                             width: MediaQuery.of(context).size.width,
//                             child:
//                             ElevatedButton(
//                               style: ElevatedButton.styleFrom(
//                                 side: BorderSide(color: Theme.of(context).primaryColor, width: 1),
//                                 primary: selectedIndexList.contains(index)?Theme.of(context).primaryColor:AppTheme.verifyPhone,
//
//                                 shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(50))),
//                               ),
//                               // shape: shape,
//                               onPressed: (){
//                                 Navigator.push(context, MaterialPageRoute(builder: (context) => HomeItemDetail()));
//
//                               },
//                               child:
//                               !selectedIndexList.contains(index)
//                                   ?
//                               GestureDetector(
//                                 onTap: (){
//                                   if (!selectedIndexList.contains(index)) {
//                                     selectedIndexList.add(index);
//                                   } else {
//                                     selectedIndexList.remove(index);
//                                   }
//                                   setState(() {
//
//                                   });
//                                 },
//                                 child:
//                               Stack(
//                                 // mainAxisAlignment: MainAxisAlignment.center,
//                                 // crossAxisAlignment: CrossAxisAlignment.center,
//                                 children: <Widget>[
//                                   Align(
//                                       alignment: Alignment.center,
//                                       child:
//                                       Text(
//                                         'ADD',
//                                         style: Theme.of(context)
//                                             .textTheme
//                                             .button!
//                                             .copyWith(color: Colors.black, fontWeight: FontWeight.w500,fontSize: 12.0),
//                                       )),
//
//                                   Align(
//                                       alignment: Alignment.centerRight,
//                                        child:Icon(Icons.add,size: 20.0,color:Colors.black)
//
//                                   )
//
//
//                                 ],
//                               ))
//                                   :
//                               Row(
//                                 crossAxisAlignment: CrossAxisAlignment.center,
//                                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                 children: <Widget>[
//                                   InkWell(
//                                       onTap: (){
//                                         setState(() {
//                                         });
//
//                                       },
//                                       child: Icon(Icons.remove,color: Colors.white,size: 20.0,)),
//                                   Text(
//                                     "_counter.toString()",
//                                     style: Theme.of(context)
//                                         .textTheme
//                                         .button!
//                                         .copyWith(color: Colors.white, fontWeight: FontWeight.w400,fontSize: 12.0),
//                                   ),
//                                   InkWell(
//                                       onTap: (){
//                                         setState(() {
//
//                                         });
//                                       },
//                                       child: Icon(Icons.add,color: Colors.white,size: 20.0,))
//                                 ],
//                               ),
//
//                             )
//                         )
//                     )
//                   ],
//                 ),
//               )
//           )
//         // }
//       );
//     }
//
//     // TODO: implement build
//     return Scaffold(
//       // appBar: AppBar(title: Text("Home"),
//       //   automaticallyImplyLeading:false,
//       // ),
//       body: Container(
//           child:Column(
//             children: [
//               //for producer category
//               Container(
//                 height: 120,
//                 child:
//                 buildCategory(),
//               ),
//
//               //for producer listview items
//               Expanded(
//                   flex: 3,
//                   child:SingleChildScrollView(
//                     child: Column(
//                       children: [
//                         Container(
//                           height: 180,
//                           child: CachedNetworkImage(
//                             imageUrl: "http://via.placeholder.com/350x150",
//                             imageBuilder: (context, imageProvider) {
//                               return Container(
//                                 height: 180,
//                                 decoration: BoxDecoration(
//                                   borderRadius: BorderRadius.zero,
//                                   image: DecorationImage(
//                                     image: imageProvider,
//                                     fit: BoxFit.cover,
//                                   ),
//                                 ),
//
//                               );
//                             },
//                             placeholder: (context, url) {
//                               return Shimmer.fromColors(
//                                 baseColor: Theme
//                                     .of(context)
//                                     .hoverColor,
//                                 highlightColor: Theme
//                                     .of(context)
//                                     .highlightColor,
//                                 enabled: true,
//                                 child: Container(
//                                   height: 120,
//                                   decoration: BoxDecoration(
//                                     borderRadius: BorderRadius.zero,
//                                     color: Colors.white,
//                                   ),
//                                 ),
//                               );
//                             },
//                             errorWidget: (context, url, error) {
//                               return Shimmer.fromColors(
//                                 baseColor: Theme
//                                     .of(context)
//                                     .hoverColor,
//                                 highlightColor: Theme
//                                     .of(context)
//                                     .highlightColor,
//                                 enabled: true,
//                                 child: Container(
//                                   height: 120,
//                                   decoration: BoxDecoration(
//                                     color: Colors.white,
//                                     borderRadius: BorderRadius.zero,
//                                   ),
//                                   child: Icon(Icons.error),
//                                 ),
//                               );
//                             },
//                           ),
//                         ),
//                         // buildListViewItemProd()
//                         Padding(
//                             padding: EdgeInsets.only(left: 15,right: 15,
//                                 top:15.0,bottom: 30.0),
//                             child:
//                             Wrap(
//                               runSpacing: 10,
//                               alignment: WrapAlignment.spaceBetween,
//                               children: List.generate(8, (index) => index).map((item) {
//                                 return buildListViewItemProd(item);
//                                 print(item);
//                               }).toList(),
//                             )
//                         ),
//
//
//                       ],
//                     ),
//                   )),
//               if(selectedIndexList.length>0)
//                 Expanded(child:
//                 Container(
//                     child:
//                     Padding(padding: EdgeInsets.only(left:15.0,right:15.0,top:15.0,bottom:95.0),
//                         child:
//                         SizedBox(
//                             height: 45.0,
//                             width: MediaQuery
//                                 .of(context)
//                                 .size
//                                 .width,
//                             child:
//                             ElevatedButton(
//                               style: ElevatedButton.styleFrom(
//                                 side: BorderSide(color: Theme
//                                     .of(context)
//                                     .primaryColor, width: 1),
//                                 primary: Theme.of(context).primaryColor,
//                                 shape: const RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.all(Radius.circular(
//                                         50))),
//                               ),
//                               // shape: shape,
//                               onPressed: () {
//                                 Navigator.push(context, MaterialPageRoute(builder: (
//                                     context) => HomeItemDetail()));
//                               },
//                               child:
//                               Row(
//                                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                 children: <Widget>[
//                                   Padding(padding: EdgeInsets.only(top:5.0,left:10.0),
//                                     child:
//                                     Column(
//                                       mainAxisAlignment: MainAxisAlignment.start,
//                                       crossAxisAlignment: CrossAxisAlignment.start,
//                                       children: [
//                                         Text(
//                                           'Items',
//                                           style: Theme
//                                               .of(context)
//                                               .textTheme
//                                               .bodyText1!
//                                               .copyWith(color: Colors.white,
//                                               fontWeight: FontWeight.w300,fontSize: 12.0),
//                                         ),
//                                         Row(
//                                           children: [
//                                             Text(
//                                               '\$ 25',
//                                               style: Theme
//                                                   .of(context)
//                                                   .textTheme
//                                                   .bodyText1!
//                                                   .copyWith(color: Colors.white,
//                                                   fontWeight: FontWeight.w600,fontSize: 14.0),
//                                             ),
//                                             Text(
//                                               ' +plus taxes',
//                                               style: Theme
//                                                   .of(context)
//                                                   .textTheme
//                                                   .bodyText1!
//                                                   .copyWith(color: Colors.white,
//                                                   fontWeight: FontWeight.w300,fontSize: 12.0),
//                                             ),
//                                           ],
//                                         )
//
//                                       ],
//                                     ),
//                                   ),
//
//                                   Text(
//                                     'VIEW CART',
//                                     style: Theme
//                                         .of(context)
//                                         .textTheme
//                                         .button!
//                                         .copyWith(color: Colors.white,
//                                         fontWeight: FontWeight.w600),
//                                   ),
//
//                                 ],
//                               ),
//
//                             )
//                         )
//                     )
//                 ),
//                 )
//
//
//             ],
//           )
//
//       ),
//     );
//   }
//
// }