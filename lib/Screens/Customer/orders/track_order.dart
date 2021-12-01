import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:orderly/Configs/image.dart';
import 'package:orderly/Configs/theme.dart';
import 'package:orderly/Models/model_myOrders.dart';
import 'package:orderly/Screens/Customer/orders/return_replace.dart';
import 'package:orderly/Utils/translate.dart';
import 'package:shimmer/shimmer.dart';
import 'package:timeline_tile/timeline_tile.dart';

class TrackOrder extends StatefulWidget{
  Orders orderData;
  TrackOrder({Key key,@required this.orderData}):super(key: key);

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
              // order track
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
              // Container(
              //   height: MediaQuery.of(context).size.height*0.615,
              //   child:PackageDeliveryTrackingPage(),
              // ),
              Container(
              height: 460,
              color: Colors.white,
              child: ListView(
              shrinkWrap: true,
              children: <Widget>[
                TimelineTile(
                  alignment: TimelineAlign.manual,
                  lineXY: 0.1,
                  isFirst: true,
                  indicatorStyle:  IndicatorStyle(
                    width: 20,
                    color: Theme.of(context)
                        .primaryColor,
                    padding: EdgeInsets.all(6),
                  ),
                  endChild: _RightChild(
                    // asset: 'assets/images/cart.png',
                    title: 'Order Accepted',
                    message: 'On Thu, 8 July 2021',
                  ),
                  beforeLineStyle: LineStyle(
                    thickness: 3,
                    color: Theme.of(context)
                        .primaryColor,
                  ),
                ),
                TimelineTile(
                  alignment: TimelineAlign.manual,
                  lineXY: 0.1,
                  indicatorStyle:  IndicatorStyle(
                    width: 20,
                    color:Theme.of(context)
                        .primaryColor,
                    padding: EdgeInsets.all(6),
                  ),
                  endChild:  _RightChild(
                    // asset: 'assets/images/cart.png',
                    title: 'Producer notified',
                    message: 'On Thu, 8 July 2021',
                  ),
                  beforeLineStyle:  LineStyle(
                    thickness: 3,
                    color: Theme.of(context)
                        .primaryColor,
                  ),
                ),
                TimelineTile(
                  alignment: TimelineAlign.manual,
                  lineXY: 0.1,
                  indicatorStyle:  IndicatorStyle(
                    width: 20,
                    color: Theme.of(context).primaryColor,
                    padding: EdgeInsets.all(6),
                  ),
                  endChild: _RightChild(
                    disabled: true,

                    // asset: 'assets/images/cart.png',
                    title: 'Vehicle reserved',
                    message: ' ',
                  ),
                  beforeLineStyle:  LineStyle(
                    thickness: 3,

                    color:
                    Theme.of(context)
                        .primaryColor,
                  ),
                  afterLineStyle: const LineStyle(
                    thickness: 3,
                    color: Color(0xFFDADADA),
                  ),
                ),
                TimelineTile(
                  alignment: TimelineAlign.manual,
                  lineXY: 0.1,
                  //isLast: true,
                  indicatorStyle: const IndicatorStyle(
                    width: 20,
                    color: Color(0xFFDADADA),
                    padding: EdgeInsets.all(6),
                  ),
                  endChild:  _RightChild(
                    disabled: true,
                    // asset: 'assets/images/cart.png',
                    title: 'Vehicle is on its way',
                    message: ' ',
                  ),
                  beforeLineStyle: const LineStyle(
                    thickness: 3,

                    color: Color(0xFFDADADA),
                  ),
                  afterLineStyle: const LineStyle(
                    thickness: 3,

                    color: Color(0xFFDADADA),
                  ),
                ),
                TimelineTile(
                  alignment: TimelineAlign.manual,
                  lineXY: 0.1,
                  isLast: true,
                  indicatorStyle: const IndicatorStyle(
                    width: 20,
                    color: Color(0xFFDADADA),
                    padding: EdgeInsets.all(6),
                  ),
                  endChild:  _RightChild(
                    disabled: true,
                    // asset: 'assets/images/cart.png',
                    title: 'Job Completed',
                    message: ' ',
                  ),
                  beforeLineStyle: const LineStyle(
                    thickness: 3,

                    color: Color(0xFFDADADA),
                  ),
                ),
              ],
            ),
          ),
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
                      child:
                      widget.orderData.currentStatus!=4&& widget.orderData.currentStatus!=5 && widget.orderData.currentStatus!=7
                          && widget.orderData.currentStatus!=9 && widget.orderData.currentStatus!=10 && widget.orderData.currentStatus!=11
                          && widget.orderData.currentStatus!=13 && widget.orderData.currentStatus!=14

                          ?
                      Card(
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
                          ))
                  :
                      Container())

                ),
              )

            ],
          ),
        ),
      ),
    );
  }

}

class _RightChild extends StatelessWidget {
  const _RightChild({
    Key key,
    // this.asset,
    this.title,
    this.message,
    this.disabled = false,
  }) : super(key: key);

  //final String asset;
  final String title;
  final String message;
  final bool disabled;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: <Widget>[
          // Opacity(
          //   child: Image.asset(asset, height: 50),
          //   opacity: disabled ? 0.5 : 1,
          // ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                title,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  color: disabled
                      ? const Color(0xFFBABABA)
                      : Theme.of(context).primaryColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                message,
                style: TextStyle(
                  color: disabled
                      ? const Color(0xFFD5D5D5)
                      : AppTheme.textColor,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}



//
// const kTileHeight = 50.0;
//
// class PackageDeliveryTrackingPage extends StatelessWidget {
//   final data = _data(1);
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       // appBar: TitleAppBar('Package Delivery Tracking'),
//       body: Container(
//         width: double.maxFinite,
//         child: Card(
//           margin: EdgeInsets.all(20.0),
//           child: Column(
//             mainAxisSize: MainAxisSize.max,
//             children: [
//               // Padding(
//               //   padding: const EdgeInsets.all(20.0),
//               //   // child: _OrderTitle(
//               //   //   orderInfo: data,
//               //   // ),
//               // ),
//               // Divider(height: 1.0),
//               _DeliveryProcesses(processes: data.deliveryProcesses),
//               // Divider(height: 1.0),
//               // Padding(
//               //   padding: const EdgeInsets.all(20.0),
//               //   child: _OnTimeBar(driver: data.driverInfo),
//               // ),
//             ],
//           ),
//         ),
//       )
//       // ListView.builder(
//       //   itemCount: 2,
//       //   itemBuilder: (context, index) {
//       //     final data = _data(index + 1);
//       //     return Container(
//       //       width: 360.0,
//       //       child: Card(
//       //         margin: EdgeInsets.all(20.0),
//       //         child: Column(
//       //           mainAxisSize: MainAxisSize.min,
//       //           children: [
//       //             Padding(
//       //               padding: const EdgeInsets.all(20.0),
//       //               child: _OrderTitle(
//       //                 orderInfo: data,
//       //               ),
//       //             ),
//       //             Divider(height: 1.0),
//       //             _DeliveryProcesses(processes: data.deliveryProcesses),
//       //             Divider(height: 1.0),
//       //             Padding(
//       //               padding: const EdgeInsets.all(20.0),
//       //               child: _OnTimeBar(driver: data.driverInfo),
//       //             ),
//       //           ],
//       //         ),
//       //       ),
//       //     );
//       //   },
//       // ),
//     );
//   }
// }
//
// class _OrderTitle extends StatelessWidget {
//   const _OrderTitle({
//     Key key,
//     @required this.orderInfo,
//   }) : super(key: key);
//
//   final _OrderInfo orderInfo;
//
//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       children: [
//         Text(
//           'Delivery #${orderInfo.id}',
//           style: TextStyle(
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         Spacer(),
//         Text(
//           '${orderInfo.date.day}/${orderInfo.date.month}/${orderInfo.date.year}',
//           style: TextStyle(
//             color: Color(0xffb6b2b2),
//           ),
//         ),
//       ],
//     );
//   }
// }
//
// class _InnerTimeline extends StatelessWidget {
//   const _InnerTimeline({
//     @required this.messages,
//   });
//
//   final List<_DeliveryMessage> messages;
//
//   @override
//   Widget build(BuildContext context) {
//     bool isEdgeIndex(int index) {
//       return index == 0 || index == messages.length + 1;
//     }
//
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8.0),
//       child: FixedTimeline.tileBuilder(
//         theme: TimelineTheme.of(context).copyWith(
//           nodePosition: 0,
//           connectorTheme: TimelineTheme.of(context).connectorTheme.copyWith(
//             thickness: 1.0,
//           ),
//           indicatorTheme: TimelineTheme.of(context).indicatorTheme.copyWith(
//             size: 10.0,
//             position: 0.5,
//           ),
//         ),
//         builder: TimelineTileBuilder(
//           indicatorBuilder: (_, index) =>
//           !isEdgeIndex(index) ? Indicator.outlined(borderWidth: 1.0) : null,
//           startConnectorBuilder: (_, index) => Connector.dashedLine(),
//           endConnectorBuilder: (_, index) => Connector.dashedLine(),
//           contentsBuilder: (_, index) {
//             if (isEdgeIndex(index)) {
//               return null;
//             }
//
//             return Padding(
//               padding: EdgeInsets.only(left: 8.0),
//               child: Text(messages[index - 1].toString()),
//             );
//           },
//           itemExtentBuilder: (_, index) => isEdgeIndex(index) ? 10.0 : 30.0,
//           nodeItemOverlapBuilder: (_, index) =>
//           isEdgeIndex(index) ? true : null,
//           itemCount: messages.length + 2,
//         ),
//       ),
//     );
//   }
// }
//
// class _DeliveryProcesses extends StatelessWidget {
//   const _DeliveryProcesses({Key key, @required this.processes})
//       : super(key: key);
//
//   final List<_DeliveryProcess> processes;
//   @override
//   Widget build(BuildContext context) {
//     return DefaultTextStyle(
//       style: TextStyle(
//         color: Color(0xff9b9b9b),
//         fontSize: 12.5,
//       ),
//       child: Padding(
//         padding: const EdgeInsets.all(20.0),
//         child: FixedTimeline.tileBuilder(
//           theme: TimelineThemeData(
//             nodePosition: 0,
//             color: Color(0xff989898),
//             indicatorTheme: IndicatorThemeData(
//               position: 0,
//               size: 20.0,
//             ),
//             connectorTheme: ConnectorThemeData(
//               thickness: 2.5,
//             ),
//           ),
//           builder: TimelineTileBuilder.connected(
//             connectionDirection: ConnectionDirection.before,
//             itemCount: processes.length,
//             contentsBuilder: (_, index) {
//               if (processes[index].isCompleted) return null;
//
//               return Padding(
//                 padding: EdgeInsets.only(left: 8.0),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     Text(
//                       processes[index].name,
//                       style: DefaultTextStyle.of(context).style.copyWith(
//                         fontSize: 18.0,
//                       ),
//                     ),
//                     _InnerTimeline(messages: processes[index].messages),
//                     // Text(processes[index].messages.toString())
//                   ],
//                 ),
//               );
//             },
//             indicatorBuilder: (_, index) {
//               if (processes[index].isCompleted) {
//                 return DotIndicator(
//                   color: Theme.of(context).primaryColor,
//                   // child: Icon(
//                   //   Icons.check,
//                   //   color: Colors.white,
//                   //   size: 12.0,
//                   // ),
//                 );
//               } else {
//                 return OutlinedDotIndicator(
//                   borderWidth: 2.5,
//                 );
//               }
//             },
//             connectorBuilder: (_, index, ___) => SolidLineConnector(
//               color: processes[index].isCompleted ? Theme.of(context).primaryColor : Colors.blue,
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// class _OnTimeBar extends StatelessWidget {
//   const _OnTimeBar({Key key, @required this.driver}) : super(key: key);
//
//   final _DriverInfo driver;
//
//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       children: [
//         MaterialButton(
//           onPressed: () {
//             ScaffoldMessenger.of(context).showSnackBar(
//               SnackBar(
//                 content: Text('On-time!'),
//               ),
//             );
//           },
//           elevation: 0,
//           shape: StadiumBorder(),
//           color: Color(0xff66c97f),
//           textColor: Colors.white,
//           child: Text('On-time'),
//         ),
//         Spacer(),
//         Text(
//           'Driver\n${driver.name}',
//           textAlign: TextAlign.center,
//         ),
//         SizedBox(width: 12.0),
//         Container(
//           width: 40.0,
//           height: 40.0,
//           decoration: BoxDecoration(
//             shape: BoxShape.circle,
//             image: DecorationImage(
//               fit: BoxFit.fitWidth,
//               image: NetworkImage(
//                 driver.thumbnailUrl,
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }
//
// _OrderInfo _data(int id) => _OrderInfo(
//   id: id,
//   date: DateTime.now(),
//   driverInfo: _DriverInfo(
//     name: 'Philipe',
//     thumbnailUrl:
//     'https://i.pinimg.com/originals/08/45/81/084581e3155d339376bf1d0e17979dc6.jpg',
//   ),
//   deliveryProcesses: [
//     _DeliveryProcess(
//       'Order Accepted',
//       messages: [
//         _DeliveryMessage('On Thu, 8 July 2021'),
//         // _DeliveryMessage('11:30am', 'Reached halfway mark'),
//       ],
//     ),
//     _DeliveryProcess(
//       'Producer notified',
//       messages: [
//         _DeliveryMessage('On Thu, 8 July 2021'),
//         // _DeliveryMessage('11:35am', 'Package delivered by m.vassiliades'),
//       ],
//     ),
//     _DeliveryProcess(
//       'Vehicle reserved',
//       messages: [
//         _DeliveryMessage(' '),// delivery message will come from API
//       ],
//     ),
//     _DeliveryProcess(
//       'Vehicle is on its way',
//       messages: [
//         _DeliveryMessage(' '),// delivery message will come from API
//       ],
//     ),
//     _DeliveryProcess(
//       'Job Complete',
//       messages: [
//         _DeliveryMessage(' '),// delivery message will come from API
//       ],
//     ),
//     _DeliveryProcess.complete(),
//   ],
// );
//
// class _OrderInfo {
//   const _OrderInfo({
//     @required this.id,
//     @required this.date,
//     @required this.driverInfo,
//     @required this.deliveryProcesses,
//   });
//
//   final int id;
//   final DateTime date;
//   final _DriverInfo driverInfo;
//   final List<_DeliveryProcess> deliveryProcesses;
// }
//
// class _DriverInfo {
//   const _DriverInfo({
//     @required this.name,
//     @required this.thumbnailUrl,
//   });
//
//   final String name;
//   final String thumbnailUrl;
// }
//
// class _DeliveryProcess {
//   const _DeliveryProcess(
//       this.name, {
//         this.messages = const [],
//       });
//
//   const _DeliveryProcess.complete()
//       : this.name = 'Done',
//         this.messages = const [];
//
//   final String name;
//   final List<_DeliveryMessage> messages;
//
//   bool get isCompleted => name == 'Done';
// }
//
// class _DeliveryMessage {
//   const _DeliveryMessage(this.message);
//
//   // final String createdAt; // final DateTime createdAt;
//   final String message;
//
//   @override
//   String toString() {
//     return '$message';
//   }
// }

//
// import 'package:flutter/material.dart';
// import 'package:flutter_showcase/flutter_showcase.dart';
// import 'package:timeline_tile/timeline_tile.dart';
//
// class ShowcaseDeliveryTimeline extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Showcase(
//       title: 'Delivery Timeline',
//       app: _DeliveryTimelineApp(),
//       description:
//       'A simple timeline with few steps to show the current status of '
//           'an order.',
//       template: SimpleTemplate(reverse: false),
//       theme: TemplateThemeData(
//         frameTheme: FrameThemeData(
//           statusBarBrightness: Brightness.dark,
//           frameColor: const Color(0xFF215C3F),
//         ),
//         flutterLogoColor: FlutterLogoColor.original,
//         brightness: Brightness.dark,
//         backgroundColor: const Color(0xFFE9E9E9),
//         titleTextStyle: GoogleFonts.neuton(
//           fontSize: 80,
//           fontWeight: FontWeight.bold,
//           color: const Color(0xFF2C7B54),
//         ),
//         descriptionTextStyle: GoogleFonts.yantramanav(
//           fontSize: 24,
//           height: 1.2,
//           color: const Color(0xFF2C7B54),
//         ),
//         buttonTextStyle: const TextStyle(
//           color: Colors.white,
//           fontWeight: FontWeight.bold,
//           letterSpacing: 2,
//         ),
//         buttonIconTheme: const IconThemeData(color: Colors.white),
//         buttonTheme: ButtonThemeData(
//           buttonColor: const Color(0xFF2C7B54),
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(50),
//           ),
//           padding: const EdgeInsets.all(16),
//         ),
//       ),
//       links: [
//         LinkData.github('https://github.com/JHBitencourt/timeline_tile'),
//       ],
//       logoLink: LinkData(
//         icon: Image.asset(
//           'assets/built_by_jhb_black.png',
//           fit: BoxFit.fitHeight,
//         ),
//         url: 'https://github.com/JHBitencourt',
//       ),
//     );
//   }
// }
//
// class _DeliveryTimelineApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'Delivery TimelineTile',
//       builder: Frame.builder,
//       home: _DeliveryTimeline(),
//     );
//   }
// }
//
// class _DeliveryTimeline extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       color: const Color(0xFF379A69),
//       child: Theme(
//         data: Theme.of(context).copyWith(
//           accentColor: const Color(0xFF27AA69).withOpacity(0.2),
//         ),
//         child: SafeArea(
//           child: Scaffold(
//             appBar: _AppBar(),
//             backgroundColor: Colors.white,
//             body: Column(
//               children: <Widget>[
//                 _Header(),
//                 Expanded(child: _TimelineDelivery()),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// class _TimelineDelivery extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: ListView(
//         shrinkWrap: true,
//         children: <Widget>[
//           TimelineTile(
//             alignment: TimelineAlign.manual,
//             lineXY: 0.1,
//             isFirst: true,
//             indicatorStyle: const IndicatorStyle(
//               width: 20,
//               color: Color(0xFF27AA69),
//               padding: EdgeInsets.all(6),
//             ),
//             endChild: const _RightChild(
//               asset: 'assets/delivery/order_placed.png',
//               title: 'Order Placed',
//               message: 'We have received your order.',
//             ),
//             beforeLineStyle: const LineStyle(
//               color: Color(0xFF27AA69),
//             ),
//           ),
//           TimelineTile(
//             alignment: TimelineAlign.manual,
//             lineXY: 0.1,
//             indicatorStyle: const IndicatorStyle(
//               width: 20,
//               color: Color(0xFF27AA69),
//               padding: EdgeInsets.all(6),
//             ),
//             endChild: const _RightChild(
//               asset: 'assets/delivery/order_confirmed.png',
//               title: 'Order Confirmed',
//               message: 'Your order has been confirmed.',
//             ),
//             beforeLineStyle: const LineStyle(
//               color: Color(0xFF27AA69),
//             ),
//           ),
//           TimelineTile(
//             alignment: TimelineAlign.manual,
//             lineXY: 0.1,
//             indicatorStyle: const IndicatorStyle(
//               width: 20,
//               color: Color(0xFF2B619C),
//               padding: EdgeInsets.all(6),
//             ),
//             endChild: const _RightChild(
//               asset: 'assets/delivery/order_processed.png',
//               title: 'Order Processed',
//               message: 'We are preparing your order.',
//             ),
//             beforeLineStyle: const LineStyle(
//               color: Color(0xFF27AA69),
//             ),
//             afterLineStyle: const LineStyle(
//               color: Color(0xFFDADADA),
//             ),
//           ),
//           TimelineTile(
//             alignment: TimelineAlign.manual,
//             lineXY: 0.1,
//             isLast: true,
//             indicatorStyle: const IndicatorStyle(
//               width: 20,
//               color: Color(0xFFDADADA),
//               padding: EdgeInsets.all(6),
//             ),
//             endChild: const _RightChild(
//               disabled: true,
//               asset: 'assets/delivery/ready_to_pickup.png',
//               title: 'Ready to Pickup',
//               message: 'Your order is ready for pickup.',
//             ),
//             beforeLineStyle: const LineStyle(
//               color: Color(0xFFDADADA),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// class _RightChild extends StatelessWidget {
//   const _RightChild({
//     Key key,
//     this.asset,
//     this.title,
//     this.message,
//     this.disabled = false,
//   }) : super(key: key);
//
//   final String asset;
//   final String title;
//   final String message;
//   final bool disabled;
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(16.0),
//       child: Row(
//         children: <Widget>[
//           Opacity(
//             child: Image.asset(asset, height: 50),
//             opacity: disabled ? 0.5 : 1,
//           ),
//           const SizedBox(width: 16),
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             mainAxisSize: MainAxisSize.min,
//             children: <Widget>[
//               Text(
//                 title,
//                 style: GoogleFonts.yantramanav(
//                   color: disabled
//                       ? const Color(0xFFBABABA)
//                       : const Color(0xFF636564),
//                   fontSize: 18,
//                   fontWeight: FontWeight.w500,
//                 ),
//               ),
//               const SizedBox(height: 6),
//               Text(
//                 message,
//                 style: GoogleFonts.yantramanav(
//                   color: disabled
//                       ? const Color(0xFFD5D5D5)
//                       : const Color(0xFF636564),
//                   fontSize: 16,
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// class _Header extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: const BoxDecoration(
//         color: Color(0xFFF9F9F9),
//         border: Border(
//           bottom: BorderSide(
//             color: Color(0xFFE9E9E9),
//             width: 3,
//           ),
//         ),
//       ),
//       child: Padding(
//         padding: const EdgeInsets.all(10),
//         child: Row(
//           children: <Widget>[
//             Expanded(
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: <Widget>[
//                   Text(
//                     'ESTIMATED TIME',
//                     style: GoogleFonts.yantramanav(
//                       color: const Color(0xFFA2A2A2),
//                       fontSize: 16,
//                     ),
//                   ),
//                   Text(
//                     '30 minutes',
//                     style: GoogleFonts.yantramanav(
//                       color: const Color(0xFF636564),
//                       fontSize: 16,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             Expanded(
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: <Widget>[
//                   Text(
//                     'ORDER NUMBER',
//                     style: GoogleFonts.yantramanav(
//                       color: const Color(0xFFA2A2A2),
//                       fontSize: 16,
//                     ),
//                   ),
//                   Text(
//                     '#2482011',
//                     style: GoogleFonts.yantramanav(
//                       color: const Color(0xFF636564),
//                       fontSize: 16,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// class _AppBar extends StatelessWidget implements PreferredSizeWidget {
//   @override
//   Widget build(BuildContext context) {
//     return AppBar(
//       backgroundColor: const Color(0xFF27AA69),
//       leading: const Icon(Icons.menu),
//       actions: <Widget>[
//         Center(
//           child: Padding(
//             padding: const EdgeInsets.only(right: 16),
//             child: Text(
//               'CANCEL',
//               style: GoogleFonts.neuton(
//                 color: Colors.white,
//                 fontSize: 16,
//               ),
//             ),
//           ),
//         ),
//       ],
//       title: Text(
//         'Track Order',
//         style: GoogleFonts.neuton(
//             color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
//       ),
//     );
//   }
//
//   @override
//   Size get preferredSize => const Size.fromHeight(kToolbarHeight);
// }