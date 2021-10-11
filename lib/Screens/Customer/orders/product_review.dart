import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:orderly/Configs/image.dart';
import 'package:orderly/Configs/theme.dart';
import 'package:orderly/Models/model_myOrders.dart';
import 'package:orderly/Screens/Customer/orders/return_replace.dart';
import 'package:orderly/Utils/translate.dart';
import 'package:orderly/Utils/validate.dart';
import 'package:orderly/Widgets/app_button.dart';
import 'package:orderly/Widgets/app_star_rating.dart';
import 'package:orderly/Widgets/app_text_input.dart';
import 'package:readmore/readmore.dart';
import 'package:shimmer/shimmer.dart';

class ProductReview extends StatefulWidget {
  Orders order;
  ProductReview({Key key,@required this.order}):super(key: key);

  _ProductReviewState createState() => _ProductReviewState();
}

class _ProductReviewState extends State<ProductReview> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  double _rateApp = 0;
  double _rateVehicle = 0;
  double _rateDrive = 0;
  double _ratePay = 0;
  double _rateOverall = 0;
  final _textAddReviewController = TextEditingController();
  final _focusReview = FocusNode();
  String _validAddReview = "";

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      key: _scaffoldKey,
      appBar: new AppBar(
        title: Text(
          Translate.of(context).translate('product_review'),
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
          child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //for produce info
            Container(
                color: Colors.white,
                child: Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Card(
                    elevation: 5.0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        side: BorderSide(
                          color: Colors.white,
                          width: 0.5,
                        )),
                    borderOnForeground: true,
                    child: Container(
                        color: Colors.transparent,
                        child: Card(
                          elevation: 0.0,
                          child: Padding(
                              padding: EdgeInsets.all(10.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CachedNetworkImage(
                                    filterQuality: FilterQuality.medium,
                                    // imageUrl: Api.PHOTO_URL + widget.users.avatar,
                                    // imageUrl:
                                    //     "https://images.unsplash.com/photo-1438761681033-6461ffad8d80?ixid=MXwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=1050&q=80",
                                    imageUrl: widget.order.imgPaths == null
                                        ? "https://images.unsplash.com/photo-1438761681033-6461ffad8d80?ixid=MXwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=1050&q=80"
                                        : widget.order.imgPaths,
                                    placeholder: (context, url) {
                                      return Shimmer.fromColors(
                                        baseColor: Theme.of(context).hoverColor,
                                        highlightColor:
                                            Theme.of(context).highlightColor,
                                        enabled: true,
                                        child: Container(
                                          height: 80,
                                          width: 80,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(8),
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
                                          borderRadius:
                                              BorderRadius.circular(8),
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
                                          height: 80,
                                          width: 80,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(8),
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
                                      child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        widget.order.producerName,
                                        style: Theme.of(context)
                                            .textTheme
                                            .caption
                                            .copyWith(
                                                fontSize: 14.0,
                                                fontWeight: FontWeight.w600,
                                                color: Theme.of(context)
                                                    .primaryColor,
                                                fontFamily: "Poppins"),
                                      ),

                                      ReadMoreText(
                                        widget.order.productDesc.toString(),
                                        style: Theme.of(context).textTheme.button.copyWith(
                                            fontSize: 12.0,
                                            color: AppTheme.textColor,
                                            fontWeight: FontWeight.w500,
                                            fontFamily: "Poppins"),
                                        trimLines: 2,
                                        trimMode: TrimMode.Line,
                                        trimCollapsedText: 'Show more',
                                        trimExpandedText: 'Show less',
                                      ),
                                      Text(
                                        // widget.users.address != null
                                        //     ? widget.users.address
                                        //     : "",
                                        "Quantity: "+widget.order.qty.toString(),
                                        style: Theme.of(context)
                                            .textTheme
                                            .button
                                            .copyWith(
                                                fontSize: 10.0,
                                                color: AppTheme.textColor,
                                                fontWeight: FontWeight.w300,
                                                fontFamily: "Poppins"),
                                      ),
                                    ],
                                  )),
                                ],
                              )),
                        )),
                  ),
                )),
            //rating
            SizedBox(
              height: 8.0,
            ),
            //for ratings
            Container(
                color: Colors.white,
                child: Padding(
                  padding: EdgeInsets.all(15.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        Translate.of(context).translate('rating'),
                        style: TextStyle(
                            fontSize: 14.0,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Poppins',
                            color: Theme.of(context).primaryColor),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      //app experience
                      RatingExperience(
                          title: Translate.of(context).translate('app_exp'),
                          rate: _rateApp),
                      SizedBox(
                        height: 5.0,
                      ),
                      //vehicle
                      RatingExperience(
                          title: Translate.of(context)
                              .translate('vehicle_quality'),
                          rate: _rateVehicle),
                      SizedBox(
                        height: 5.0,
                      ),
                      //drive
                      RatingExperience(
                          title: Translate.of(context).translate('drive_exp'),
                          rate: _rateDrive),
                      SizedBox(
                        height: 5.0,
                      ),
                      //payment
                      RatingExperience(
                          title: Translate.of(context).translate('pay_exp'),
                          rate: _ratePay),
                      SizedBox(
                        height: 5.0,
                      ),
                      //overall
                      RatingExperience(
                          title: Translate.of(context).translate('overall'),
                          rate: _rateOverall),
                    ],
                  ),
                )),

            SizedBox(
              height: 8.0,
            ),
            //add written review
            Container(
              color: Colors.white,
              child: Padding(
                padding: EdgeInsets.all(15.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      Translate.of(context).translate('writen_review'),
                      style: TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Poppins',
                          color: Theme.of(context).primaryColor),
                    ),
                    SizedBox(
                      height: 8.0,
                    ),
                    Container(
                        decoration: BoxDecoration(
                          border:
                              Border.all(color: Colors.grey.withOpacity(0.4)),
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: TextField(
                          textAlignVertical: TextAlignVertical.center,
                          controller: _textAddReviewController,
                          focusNode: _focusReview,
                          keyboardType: TextInputType.text,
                          maxLines: 4,
                          style: TextStyle(
                              fontSize: 12.0,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w400),
                          decoration: InputDecoration(
                            counterText: "",
                            hintText:
                                Translate.of(context).translate('hint_review'),
                            hintStyle: TextStyle(color: AppTheme.textColor),
                            border: InputBorder.none,
                          ),
                        )),
                    SizedBox(
                      height: 20.0,
                    ),
                    //add review
                    GestureDetector(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>ReturnReplace(orderData:widget.order)));
                        },
                        child: Card(
                            elevation: 5.0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              side: BorderSide(
                                color: Colors.white,
                                width: 0.5,
                              ),
                            ),
                            child:
                            Padding(
                              padding: EdgeInsets.only(left: 10.0, right: 10.0),
                              child:

                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    Translate.of(context)
                                        .translate('return_replace'),
                                    style: TextStyle(
                                        fontSize: 12.0,
                                        fontWeight: FontWeight.w400,
                                        fontFamily: 'Poppins',
                                        color: AppTheme.textColor),
                                  ),
                                  IconButton(
                                      icon: Image.asset(Images.arrow,
                                          height: 15.0, width: 15.0))
                                ],
                              ),
                            ))),


                  ],
                ),
              ),
            ),

            //submit
            Container(
              color: Colors.white,
              child:
              Padding(
                padding: EdgeInsets.all(15.0),
                child: AppButton(
                  shape: const RoundedRectangleBorder(
                      borderRadius:
                      BorderRadius.all(Radius.circular(50))),
                  text: "SUBMIT",
                  onPressed: () {},
                )))
          ],
        ),
      )),
    );
  }
}

class RatingExperience extends StatefulWidget {
  String title;
  double rate;

  RatingExperience({Key key, @required this.title, @required this.rate})
      : super(key: key);

  _RatingExpState createState() => _RatingExpState();
}

class _RatingExpState extends State<RatingExperience> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Card(
        elevation: 5.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
          side: BorderSide(
            color: Colors.white,
            width: 0.5,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.title,
                style: TextStyle(
                    fontSize: 12.0,
                    fontWeight: FontWeight.w400,
                    fontFamily: 'Poppins',
                    color: AppTheme.textColor),
              ),
              StarRating(
                rating: widget.rate,
                size: 25.0,
                color: AppTheme.appColor,
                borderColor: AppTheme.appColor,
                onRatingChanged: (value) {
                  // _onReview(state.product);
                  setState(() {
                    widget.rate = value;
                  });
                },
              ),
            ],
          ),
        ));
  }
}
