import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dash/flutter_dash.dart';
import 'package:intl/intl.dart';
import 'package:orderly/Configs/theme.dart';
import 'package:orderly/Screens/Customer/orders/track_order.dart';

class TimeLineWidget extends StatefulWidget {
  final List<TrackOrderList> trackOrderList;

  const TimeLineWidget({
    Key key,
    this.trackOrderList,
  }) : super(key: key);

  @override
  createState() {
    return new TimeLineState();
  }
}

class TimeLineState extends State<TimeLineWidget> {
  @override
  void initState() {
    super.initState();
  }

  Widget setHighlightedSimpleTrackLineCircle(
      List<TrackOrderList> trackOrderList, int index) {
    return Stack(children: <Widget>[
      //for simple line
      trackOrderList[index].isActiveColor == true && (index != widget.trackOrderList.length - 1)
          ? Container(
              margin: EdgeInsets.only(left: 10),
              height: double.infinity,
              width: 0,
              decoration: BoxDecoration(
                  border: Border(
                      right: BorderSide(color: AppTheme.appColor, width: 2))))
          : Container(
              margin: EdgeInsets.only(left: 10),
              height: double.infinity,
              width: 0,
              decoration: BoxDecoration(
                  border: Border(
                      right: BorderSide(
                          color: index == widget.trackOrderList.length - 1
                              ? Colors.transparent
                              : Colors.grey,
                          width: 2)))),

      //for circular part
      Container(
          margin: new EdgeInsets.only(left: 1),
          height: 15.0,
          width: 15.0,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(7),
              border: new Border.all(
                color: AppTheme.appColor,
                width: 2.5,
              ),
              // border: Border(
              //   // top: BorderSide(
              //   //     width: 16.0, color: Colors.red.shade600),
              //   // bottom: BorderSide(
              //   //     width: 16.0, color: index == widget.taskList.length - 1 ?  Colors.green : Colors.black)
              // ),
              color:
                  // index == widget.trackOrderList.length - 1 ?  Colors.green : Colors.black)
                  widget.trackOrderList[index].isActiveColor == true
                      ? AppTheme.appColor
                      : Colors.white)

          //TODO CIRCLE DECORATION
          /*decoration: new BoxDecoration(
          shape: BoxShape.circle, color: Colors.red)*/
          )
    ]);
  }

  //updated code on 2/02/2022 for dashed line and hollow circle
  Widget setDashedLineHollowCircle(
      List<TrackOrderList> trackOrderList, int index) {
    return Column(
      children: <Widget>[
        Container(
            margin: new EdgeInsets.only(left: 1),
            height: 16.0,
            width: 16.0,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: new Border.all(
                  color: AppTheme.appColor,
                  width: 2.5,
                ),
                color:
                    // index == widget.trackOrderList.length - 1 ?  Colors.green : Colors.black)
                    widget.trackOrderList[index].isActiveColor == true
                        ? AppTheme.appColor
                        : Colors.white)),
        //for highlighted part
        (widget.trackOrderList[index].isActiveColor == true &&
                (index != widget.trackOrderList.length - 1))
            ? Dash(
                direction: Axis.vertical,
                length: 65,
            dashThickness: 1.5,
                dashLength: 59,
                dashColor: AppTheme.appColor)
            : Dash(
                direction: Axis.vertical,
                length: 65,
                dashLength: 2,
                dashThickness: 2,
                dashColor: index == widget.trackOrderList.length - 1
                    ? Colors.transparent
                    : AppTheme.appColor)
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return new ListView.builder(
        itemCount: widget.trackOrderList.length,
        itemBuilder: (_, index) {
          return Container(
              margin: new EdgeInsets.only(top: index == 0 ? 10 : 0),
              child: Column(children: <Widget>[
                IntrinsicHeight(
                    child: Row(children: [
                  // Container(
                  //     width: 30,
                  //     margin: new EdgeInsets.only(left: 10, top: 10),
                  //     child: Column(
                  //         mainAxisAlignment: MainAxisAlignment.center,
                  //         children: <Widget>[
                  //           Text(widget.taskList[index].time),
                  //           Text(widget.taskList[index].timeStatus)
                  //         ])),
                      //commented on 2/02/2021
                     setHighlightedSimpleTrackLineCircle(widget.trackOrderList, index),

                  //updated on 2/02/2022 for dashed line
                  // setDashedLineHollowCircle(widget.trackOrderList, index),
                  Expanded(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                        Container(
                            margin: new EdgeInsets.only(left: 10),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: <Widget>[
                                  Text(
                                    widget
                                        .trackOrderList[index].trackStatusName,
                                    style: TextStyle(
                                        fontFamily: 'Poppins',
                                        fontWeight: FontWeight.w500,
                                        color: widget.trackOrderList[index]
                                                    .isActiveColor ==
                                                true
                                            ? AppTheme.appColor
                                            : Colors.black26),
                                  ),
                                  Text(
                                    widget.trackOrderList[index].date != ""
                                        ?
                                        // DateFormat('EEEE, d MMM, yyyy').format(DateTime.parse(widget.trackOrderList[index].date))
                                        widget.trackOrderList[index].date
                                        : "",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontFamily: 'Poppins',
                                        fontSize: 14.0,
                                        color: widget.trackOrderList[index]
                                                    .isActiveColor ==
                                                true
                                            ? AppTheme.textColor
                                            : Colors.black26),
                                  ),
                                  SizedBox(height: 30)
                                ]))
                      ]))
                ]))
              ]));
        });
  }

  @override
  void dispose() {
    super.dispose();
  }
}
