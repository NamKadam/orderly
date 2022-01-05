import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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

  Widget setHighlightedColor(List<TrackOrderList> trackOrderList,int index){
    if(trackOrderList[index].isActiveColor==true && (index != widget.trackOrderList.length - 1)){
      return Container(
          margin: EdgeInsets.only(left: 10),
          height: double.infinity,
          width: 0,
          decoration: BoxDecoration(
              border: Border(
                  right: BorderSide(
                      color:
                      AppTheme.appColor, width: 2))));
    }else {
      return Container(
          margin: EdgeInsets.only(left: 10),
          height: double.infinity,
          width: 0,
          decoration: BoxDecoration(
              border: Border(
                  right: BorderSide(
                      color:
                      index == widget.trackOrderList.length - 1 ? Colors.transparent :Colors.grey, width: 2))));
      }

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
                      Stack(children: <Widget>[
                        setHighlightedColor(widget.trackOrderList,index),
                        // Container(
                        //     margin: EdgeInsets.only(left: 10),
                        //     height: double.infinity,
                        //     width: 0,
                        //     decoration: BoxDecoration(
                        //         border: Border(
                        //             right: BorderSide(
                        //                 color:
                        //                 index == widget.trackOrderList.length - 1 ? Colors.transparent :Colors.grey, width: 2)))),
                        Container(
                            margin: new EdgeInsets.only(left: 1),
                            height: 15.0,
                            width: 15.0,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(7),

                                border: Border(
                                  // top: BorderSide(
                                  //     width: 16.0, color: Colors.red.shade600),
                                  // bottom: BorderSide(
                                  //     width: 16.0, color: index == widget.taskList.length - 1 ?  Colors.green : Colors.black)
                                ),
                                color:
                                // index == widget.trackOrderList.length - 1 ?  Colors.green : Colors.black)
                                widget.trackOrderList[index].isActiveColor==true ? AppTheme.appColor : Colors.grey)

                          //TODO CIRCLE DECORATION
                          /*decoration: new BoxDecoration(
                            shape: BoxShape.circle, color: Colors.red)*/
                        )
                      ]),
                      Expanded(
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                    margin: new EdgeInsets.only(left: 10),
                                    child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.stretch,
                                        children: <Widget>[
                                          Text(widget.trackOrderList[index].trackStatusName,
                                          style: TextStyle(
                                            fontFamily: 'Poppins',
                                            fontWeight: FontWeight.w500,
                                            color: widget.trackOrderList[index].isActiveColor==true
                                                ?
                                                AppTheme.appColor
                                                :
                                                Colors.black26
                                          ),),
                                          Text(
                                              widget.trackOrderList[index].date!=""
                                              ?
                                              // DateFormat('EEEE, d MMM, yyyy').format(DateTime.parse(widget.trackOrderList[index].date))
                                              widget.trackOrderList[index].date
                                              :
                                          "",
                                          style: TextStyle(
                                            fontWeight: FontWeight.w400,
                                            fontFamily: 'Poppins',
                                            fontSize: 14.0,
                                            color: widget.trackOrderList[index].isActiveColor==true
                                                ?
                                            AppTheme.textColor
                                                :
                                            Colors.black26
                                          ),),
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