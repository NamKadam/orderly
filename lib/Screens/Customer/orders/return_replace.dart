import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:orderly/Configs/theme.dart';
import 'package:orderly/Utils/translate.dart';
import 'package:orderly/Widgets/app_button.dart';
import 'package:shimmer/shimmer.dart';

enum ReturnReasons { peformance, damage, arrivedLate, wrongItem, extraItem }

class ReturnReplace extends StatefulWidget {
  _ReturnReplaceState createState() => _ReturnReplaceState();
}

class _ReturnReplaceState extends State<ReturnReplace> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
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
          Translate.of(context).translate('retur_replace'),
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
      body:Container(
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
              SizedBox(height: 5.0,),
              //return reason
              ReturnReason(),
              SizedBox(height: 5.0,),
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



                    ],
                  ),
                ),
              ),
              SizedBox(height: 5.0,),

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
        ),
      )
    );
  }
}

class ReturnReason extends StatefulWidget {
  _ReturnReasonState createState() => _ReturnReasonState();
}

class _ReturnReasonState extends State<ReturnReason> {
  ReturnReasons _returnReason = ReturnReasons.peformance;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return
      Container(
        color: Colors.white,
        child: Card(
            color: Colors.white,
            elevation: 0.0,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                      padding: EdgeInsets.only(left: 15.0, right: 15.0, top: 10.0),
                      child: Text(
                        'Why are you returning this?',
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
                          // OrderList.map((data) =>
                          //     Theme(
                          //   data: Theme.of(context).copyWith(
                          //     unselectedWidgetColor:
                          //     Theme.of(context).primaryColor,
                          //   ),
                          //   child: RadioListTile(
                          //     activeColor: Theme.of(context).primaryColor,
                          //     title: Text(
                          //       "${data.name}",
                          //       style: TextStyle(
                          //           fontWeight: FontWeight.w400,
                          //           fontSize: 14.0,
                          //           fontFamily: 'Poppins',
                          //           color: AppTheme.textColor),
                          //       // )
                          //     ),
                          //     secondary: IconButton(
                          //         onPressed: () {},
                          //         icon: Image.asset(Images.arrow,
                          //             height: 15.0, width: 15.0)),
                          //     //for trailing icon
                          //     value: data.index,
                          //     groupValue: id,
                          //     onChanged: (val) {
                          //       setState(() {
                          //         radioItem = data.name;
                          //         id = data.index;
                          //       });
                          //     },
                          //   ),
                          // )).toList(),

                          // radio 1
                          Theme(
                              data: Theme.of(context).copyWith(
                                unselectedWidgetColor:
                                Theme.of(context).primaryColor,
                              ),
                              child: RadioListTile<ReturnReasons>(
                                activeColor: Theme.of(context).primaryColor,
                                title: Text(
                                  Translate.of(context).translate('performance'),
                                  style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontFamily: 'Poppins',
                                      fontSize: 14.0,
                                      color: AppTheme.textColor),
                                  // )
                                ),

                                value: ReturnReasons.peformance,
                                groupValue: _returnReason,
                                onChanged: (ReturnReasons value) {
                                  setState(() {
                                    _returnReason = value;
                                  });
                                },
                              )),
                          Divider(
                            height: 0.5,
                            color: Colors.black26,
                          ),
                          //radio 2
                          Theme(
                              data: Theme.of(context).copyWith(
                                unselectedWidgetColor:
                                Theme.of(context).primaryColor,
                              ),
                              child: RadioListTile<ReturnReasons>(
                                activeColor: Theme.of(context).primaryColor,
                                title: Text(
                                  Translate.of(context).translate('damage'),
                                  style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 14.0,
                                      fontFamily: 'Poppins',
                                      color: AppTheme.textColor),
                                  // )
                                ),

                                value: ReturnReasons.damage,
                                groupValue: _returnReason,
                                onChanged: (ReturnReasons value) {
                                  setState(() {
                                    _returnReason = value;
                                    print("value" + _returnReason.toString());
                                  });
                                },
                              )),
                          Divider(
                            height: 0.5,
                            color: Colors.black26,
                          ),
                          //radio 3
                          Theme(
                              data: Theme.of(context).copyWith(
                                unselectedWidgetColor:
                                Theme.of(context).primaryColor,
                              ),
                              child: RadioListTile<ReturnReasons>(
                                activeColor: Theme.of(context).primaryColor,
                                title: Text(
                                  Translate.of(context).translate('item_arrived'),
                                  style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 14.0,
                                      fontFamily: 'Poppins',
                                      color: AppTheme.textColor),
                                  // )
                                ),
                                value: ReturnReasons.arrivedLate,
                                groupValue: _returnReason,
                                onChanged: (ReturnReasons value) {
                                  setState(() {
                                    _returnReason = value;
                                    print("value" + _returnReason.toString());
                                  });
                                },
                              )),
                          Divider(
                            height: 0.5,
                            color: Colors.black26,
                          ),
                          //radio 4
                          Theme(
                              data: Theme.of(context).copyWith(
                                unselectedWidgetColor:
                                Theme.of(context).primaryColor,
                              ),
                              child: RadioListTile<ReturnReasons>(
                                activeColor: Theme.of(context).primaryColor,
                                title: Text(
                                  Translate.of(context).translate('wrong_item'),
                                  style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 14.0,
                                      fontFamily: 'Poppins',
                                      color: AppTheme.textColor),
                                  // )
                                ),
                                //for trailing icon
                                value: ReturnReasons.wrongItem,
                                groupValue: _returnReason,
                                onChanged: (ReturnReasons value) {
                                  setState(() {
                                    _returnReason = value;
                                    print("value" + _returnReason.toString());
                                  });
                                },
                              )),

                          Divider(
                            height: 0.5,
                            color: Colors.black26,
                          ),
                          //radio 5
                          Theme(
                              data: Theme.of(context).copyWith(
                                unselectedWidgetColor:
                                Theme.of(context).primaryColor,
                              ),
                              child: RadioListTile<ReturnReasons>(
                                activeColor: Theme.of(context).primaryColor,
                                title: Text(
                                  Translate.of(context).translate('extra_item'),
                                  style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 14.0,
                                      fontFamily: 'Poppins',
                                      color: AppTheme.textColor),
                                  // )
                                ),
                                //for trailing icon
                                value: ReturnReasons.wrongItem,
                                groupValue: _returnReason,
                                onChanged: (ReturnReasons value) {
                                  setState(() {
                                    _returnReason = value;
                                    print("value:-" + value.toString());
                                  });
                                },
                              )),
                        ],
                      ),
                    ),
                  ),

                ]))
      );
  }
}
