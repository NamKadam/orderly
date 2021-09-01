import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:orderly/Configs/image.dart';
import 'package:orderly/Configs/theme.dart';
import 'package:orderly/Screens/Customer/orders/return_replace.dart';
import 'package:orderly/Utils/translate.dart';
import 'package:shimmer/shimmer.dart';

class TrackOrder extends StatefulWidget{
  _TrackOrderState createState()=>_TrackOrderState();
}

class _TrackOrderState extends State<TrackOrder>{
  final _scaffoldKey=GlobalKey<ScaffoldState>();
  int current_step = 0;
  List<Step> steps = [
    Step(
      title: Text('Step 1'),
      content: Text('Hello!'),
      isActive: true,
    ),
    Step(
      title: Text('Step 2'),
      content: Text('World!'),
      isActive: true,

    ),
    Step(
      title: Text('Step 3'),
      content: Text('Hello World!'),
      state: StepState.complete,
      isActive: true,
    ),
  ];

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
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
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
                                      imageUrl:
                                      "https://images.unsplash.com/photo-1438761681033-6461ffad8d80?ixid=MXwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=1050&q=80",
                                      // imageUrl: widget.users.avatar == null
                                      //     ? "https://images.unsplash.com/photo-1438761681033-6461ffad8d80?ixid=MXwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=1050&q=80"
                                      //     : Api.PHOTO_URL + widget.users.avatar,
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
                                              "Producer one",
                                              // widget.users.firstName+" "+widget.users.lastName,
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
                                            Text(
                                              // widget.users.address != null
                                              //     ? widget.users.address
                                              //     : "",
                                              "50 tonnes Vanilla Icecream",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .button
                                                  .copyWith(
                                                  fontSize: 12.0,
                                                  color: AppTheme.textColor,
                                                  fontWeight: FontWeight.w500,
                                                  fontFamily: "Poppins"),
                                            ),
                                            Text(
                                              // widget.users.address != null
                                              //     ? widget.users.address
                                              //     : "",
                                              "Quantity: 05",
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
              SizedBox(
                height: 8.0,
              ),
              //order track
              // Container(
              //   child: Stepper(
              //     currentStep: this.current_step,
              //     steps: steps,
              //     type: StepperType.vertical,
              //     onStepTapped: (step) {
              //       setState(() {
              //         current_step = step;
              //       });
              //     },
              //     // onStepContinue: () {
              //     //   setState(() {
              //     //     if (current_step < steps.length - 1) {
              //     //       current_step = current_step + 1;
              //     //     } else {
              //     //       current_step = 0;
              //     //     }
              //     //   });
              //     // },
              //     onStepCancel: () {
              //       setState(() {
              //         if (current_step > 0) {
              //           current_step = current_step - 1;
              //         } else {
              //           current_step = 0;
              //         }
              //       });
              //     },
              //   ),
              // ),
              SizedBox(
                height: 8.0,
              ),
              //tracking Id
              Container(
                color: Colors.white,
                child: Padding(
                  padding: EdgeInsets.all(15.0),
                    child:
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Tracking ID",
                      // widget.users.firstName+" "+widget.users.lastName,
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
                    Text(

                      "321DSCADE34567",
                      style: Theme.of(context)
                          .textTheme
                          .button
                          .copyWith(
                          fontSize: 12.0,
                          color: AppTheme.textColor,
                          fontWeight: FontWeight.w500,
                          fontFamily: "Poppins"),
                    ),
                  ],
                )),
              ),

              SizedBox(
                height: 8.0,
              ),
              //add review
              Container(
                color: Colors.white,
                child: Padding(
                  padding: EdgeInsets.all(15.0),
                  child: GestureDetector(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>ReturnReplace()));
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
                          child: Padding(
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
                ),
              )
              
            ],
          ),
        ),
      ),
    );
  }
  
}