import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';
import 'package:orderly/Configs/image.dart';
import 'package:orderly/Configs/theme.dart';
import 'package:orderly/Screens/Customer/cart/shopping_cart.dart';
import 'package:orderly/Widgets/app_button.dart';
import 'package:shimmer/shimmer.dart';

class HomeItemDetail extends StatefulWidget{
  _HomeItemDetailState createState()=>_HomeItemDetailState();

}
class _HomeItemDetailState extends State<HomeItemDetail>{
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
            onTap: (){
              Navigator.pop(context);
            },
        child:Icon(Icons.arrow_back_ios,color: AppTheme.textColor,)
          ),
          backgroundColor: Colors.white,
          elevation: 0,
          actions: [
            Row(
              children: [
                // IconButton(
                //   icon: Image.asset(Images.search,width: 30.0,height: 30.0,),
                //   onPressed: () {
                //
                //   },
                // ),
                IconButton(
                  icon: Image.asset(Images.notiIcon,width: 30.0,height: 30.0,),
                  // tooltip: "Save Todo and Retrun to List",
                  onPressed: () {

                  },
                ),
                IconButton(
                  icon: Image.asset(Images.cart,width: 30.0,height: 30.0,),
                  // tooltip: "Save Todo and Retrun to List",
                  onPressed: () {

                  },
                )
              ],
            )

          ],
        ),
        body:SafeArea(
          child:Container(
            child:
            new Column(

          children: <Widget>[
            //for viewpager
            Expanded(
            child:
            SwiperPage()
            ),
            Expanded(
              flex:2,
              child:
              ItemDetailView(),
            )
             ],
        ))));
  }

}
//for viewpager
class SwiperPage extends StatefulWidget{
  _SwiperPageState createState()=>_SwiperPageState();
}

class _SwiperPageState extends State<SwiperPage>{
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
            return  CachedNetworkImage(
              imageUrl: "http://via.placeholder.com/350x150",
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
          itemCount: 3,
          scrollDirection: Axis.horizontal,
          pagination: new SwiperPagination(
              alignment: Alignment.bottomCenter,
              builder:
              SwiperPagination.dots
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
class ItemDetailView extends StatefulWidget{
  _ItemDetailViewState createState()=>_ItemDetailViewState();
}

class _ItemDetailViewState extends State<ItemDetailView>{
  int count=1;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return SingleChildScrollView(
      child: Padding(
          padding: EdgeInsets.all(15.0),
          child:
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Prime Roof Truck',style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Poppins',
                      color: AppTheme.textColor
                  ),),

                  Text('25 \$/hr',style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.w800,
                      fontFamily: 'Poppins',
                      color: Theme.of(context).primaryColor
                  ),)
                ],
              ),
              Padding(padding: EdgeInsets.only(top:10.0),child:
              Text('Description',style: TextStyle(
                  fontSize: 14.0,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Poppins',
                  color: AppTheme.textColor
              ),)),
              //desc
              Text('Loading,transporting and delivering items to clients of business in a safe timely manner...',
                style: TextStyle(
                    fontSize: 12.0,
                    fontWeight: FontWeight.w400,
                    fontFamily: 'Poppins',
                    color: AppTheme.textColor
                ),),

              //quantity
              Container(
                  margin: EdgeInsets.only(top:50.0),
                  decoration: BoxDecoration(
                    border: Border.all(
                        color:Theme.of(context).dividerColor),
                    borderRadius: BorderRadius.all(
                      Radius.circular(45.0),
                    ),

                  ),
                  child:
                  Padding(
                    padding: EdgeInsets.all(15.0),
                    child:
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Quantity',
                          style: TextStyle(
                              fontSize: 14.0,
                              fontWeight: FontWeight.w400,
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
                                      if(count!=1){
                                        setState(() {
                                          count-=1;
                                        });
                                      }
                                    },
                                    child:
                                    Image.asset(Images.minus,height: 22.0,width:22.0)
                                )),
                            Text('${count}',
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
                                      setState(() {
                                        count+=1;

                                      });
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

              //buy now,add to cart
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  //cancel
                  Expanded(
                      child:Padding(padding: EdgeInsets.only(left:20.0,right:20.0,top:50.0),
                          child:
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                side: BorderSide(color: Theme.of(context).primaryColor, width: 1),
                                primary: Colors.white,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(50.0)
                                )
                            ),
                            // shape: shape,
                            onPressed: (){
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                      ShoppingCart()));
                            },
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Padding(padding: EdgeInsets.all(10.0),child:Text(
                                  'Add To Cart',
                                  style: Theme.of(context)
                                      .textTheme
                                      .button
                                      .copyWith(color: AppTheme.textColor, fontSize:14.0,fontWeight: FontWeight.w500),
                                )
                                ),
                              ],
                            ),
                          )
                      )),
                  //save
                  Expanded(
                      child:Padding(padding: EdgeInsets.only(left:20.0,right:20.0,top:50.0),
                          child:
                          AppButton(
                            onPressed: (){
                              // _signUp();
                              // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MainNavigation()));
                            },
                            shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(50))),
                            text: 'Buy Now',
                            // loading: login is LoginLoading,
                            // disableTouchWhenLoading: true,
                          )
                      )
                  )
                ],
              )

            ],
          )),
    );
  }

}
