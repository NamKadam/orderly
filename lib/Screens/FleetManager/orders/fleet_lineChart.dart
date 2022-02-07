import 'dart:async';
import 'dart:convert';
import 'dart:math' as math;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:orderly/Api/api.dart';
import 'package:orderly/Blocs/fleetOrders/bloc.dart';
import 'package:orderly/Blocs/fleetOrders/fleetOrders_bloc.dart';
import 'package:orderly/Models/model_fleetOrder_det.dart';
import 'package:orderly/Models/model_tempLatLng.dart';
import 'package:orderly/Utils/connectivity_check.dart';
import 'package:orderly/Utils/progressDialog.dart';
import 'package:orderly/Widgets/app_dialogs.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:http/http.dart' as http;


class ChartLineApp extends StatefulWidget {
  int index;
  List<FleetOrdersDet> orderDet;
  ChartLineApp({Key key,@required this.index,@required this.orderDet}):super(key: key);

  @override
  _ChartLineAppState createState() => _ChartLineAppState();
}

class _ChartLineAppState extends State<ChartLineApp> {
  ChartSeriesController _chartSeriesController ; //used to update chart automatically
  List<LiveData> _chartData=[];
  double time;
  Timer timer;
  List<Ordertemp> _fleetOrderDetListTemp;
  bool isconnectedToInternet = false;
  int timerCount=0;

  //Live data
  List<LiveData> getChartData(List<Ordertemp> fleetOrderDetListTemp){
    print("len:-"+fleetOrderDetListTemp.length.toString());

    for(int i=0;i<fleetOrderDetListTemp.length;i++){
      // for(int j=0;j<widget.orderTempList.length;j++){
      //   if(i==j){
      double round=double.parse(fleetOrderDetListTemp[i].temperature);
      // LiveData liveData=new LiveData(i.toDouble(), round);
      _chartData.add(LiveData(i+1.toDouble(), round));
        // }else{
        //   LiveData(i,0);
        //
        // }
      // }
    }

    return _chartData;


    // print(_chartData.toString());
    // \u2103 for degree celcius
    // return <LiveData>[
    //   LiveData(0,42),
    //   LiveData(1,47),
    //   LiveData(2,43),
    //   LiveData(3,42),
    //   LiveData(4,49),
    //   LiveData(5,54),
    //   LiveData(6,0),
    //   LiveData(7,0),
    //   LiveData(8,0),
    //   LiveData(9,0),
    //   LiveData(10,0),
    //
    // ];
  }
  // double timeLive=13;

  void updateDataSource(Timer timer){
    // _chartData.add(LiveData(timeLive++,(math.Random().nextInt(60)+30).toDouble()));
    _chartData=[];
    fetchTemperature(widget.orderDet[widget.index]);
    // _chartData.removeAt(0);
//used to improve performance of chart which updated data after 1 seconds
    _chartSeriesController.updateDataSource(
        addedDataIndex: _chartData.length-1,
        removedDataIndex: 0);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    timer.cancel();
    _chartSeriesController=null;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // _chartData=getChartData();
    fetchTemperature(widget.orderDet[widget.index]);
    startTimer();
  }

  startTimer() {
    // return new Timer.periodic(const Duration(seconds: 15), updateDataSource);
    timer = Timer.periodic(Duration(minutes: 5), (timer) {
      timerCount++;
      if( timerCount == 12 ) { //to fetch for 1 hour and hit api for every 5 minutes i.e 1hour =12 hits
        timer.cancel();
        setState(() {});
      }else{
        PsProgressDialog.showProgressWithoutMsg(context);
        updateDataSource(timer);
      }

    });
  }

  Future<void> fetchTemperature(FleetOrdersDet orderDet) async {
    // PsProgressDialog.showProgressWithoutMsg(context);
    isconnectedToInternet = await ConnectivityCheck.checkInternetConnectivity();
    if (isconnectedToInternet == true) {
      Map<String,String> params={
        'order_details_id':orderDet.orderDetailsId.toString(),
        'order_status':"0",
      };
      var response = await http.post(Uri.parse(Api.GET_FLEET_ORDER_DET_TEMP),
        body: params,
      );

      try {
        if (response.statusCode == 200) {
          var resp = json.decode(response.body);
          final Iterable refactorCategory = resp['ordertemp'] ?? [];
          _fleetOrderDetListTemp = refactorCategory.map((item) {
            return Ordertemp.fromJson(item);
          }).toList();
          _chartData=getChartData(_fleetOrderDetListTemp);
          setState(() {

          });
        }

      }
      catch(e){

      }
    } else {
      CustomDialogs.showDialogCustom(
          "Internet", "Please check your Internet Connection!", context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Temperature Chart'),
        ),
        body:
        //Initialize the chart widget
        _chartData.length>0
        ?
             SfCartesianChart(
               // Chart title
               title: ChartTitle(text: 'Temperature analysis'),
               // Enable legend
               legend: Legend(isVisible: true),
               // Enable tooltip
               tooltipBehavior: TooltipBehavior(enable: true),
               series: <LineSeries<LiveData, double>>[
                 LineSeries<LiveData, double>(
                     onRendererCreated: (ChartSeriesController controller){
                       _chartSeriesController=controller;
                     },
                     dataSource: _chartData,
                     xValueMapper: (LiveData sales, _) => sales.time,
                     yValueMapper: (LiveData sales, _) => sales.temp,
                     name: 'Temp \u2103',
                     // Enable data label
                     dataLabelSettings: DataLabelSettings(isVisible: true))
               ],
               primaryXAxis: NumericAxis(
                   majorGridLines: const MajorGridLines(width: 0),
                   edgeLabelPlacement: EdgeLabelPlacement.shift,
                   interval: 1,
                   title: AxisTitle(text: 'Time (minutes)')
               ),

               primaryYAxis:NumericAxis(
                   axisLine: const AxisLine(width: 0),
                   majorTickLines: const MajorTickLines(size: 0),
                   title: AxisTitle(text: 'Temperature in \u2103')
               ),
             )
            :
            Center(
              child: CircularProgressIndicator(),
            )

    );
  }
}


//for live data
class LiveData{
  LiveData(this.time,this.temp);
  final double time;
  final double temp;
}