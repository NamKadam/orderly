import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';


class ChartLineApp extends StatefulWidget {
  // ignore: prefer_const_constructors_in_immutables
  ChartLineApp({Key key}) : super(key: key);

  @override
  _ChartLineAppState createState() => _ChartLineAppState();
}

class _ChartLineAppState extends State<ChartLineApp> {
  ChartSeriesController _chartSeriesController ; //used to update chart automatically
  List<LiveData> _chartData;



  //Live data
  List<LiveData> getChartData(){
    // for(int i=0;i<50;i++){
    //   LiveData(i,42);
    // }
    // \u2103 for degree celcius
    return <LiveData>[
      LiveData(0,42),
      LiveData(1,47),
      LiveData(2,43),
      LiveData(3,42),
      LiveData(4,49),
      LiveData(5,54),
      LiveData(6,41),
      LiveData(7,58),
      LiveData(8,51),
      LiveData(9,98),
      LiveData(10,41),

    ];
  }

  int time=13;
  void updateDataSource(Timer timer){
    _chartData.add(LiveData(time++,(math.Random().nextInt(60)+30)));
    _chartData.removeAt(0);
//used to improve performance of chart which updated data after 1 seconds
    _chartSeriesController.updateDataSource(
        addedDataIndex: _chartData.length-1,
        removedDataIndex: 0

    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _chartData=getChartData();
    Timer.periodic(const Duration(seconds: 5), updateDataSource);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Syncfusion Flutter chart'),
        ),
        body:
        //Initialize the chart widget
        SfCartesianChart(
          // Chart title
          title: ChartTitle(text: 'Temperature analysis'),
          // Enable legend
          legend: Legend(isVisible: true),
          // Enable tooltip
          tooltipBehavior: TooltipBehavior(enable: true),
          series: <LineSeries<LiveData, int>>[
            LineSeries<LiveData, int>(
                onRendererCreated: (ChartSeriesController controller){
                  _chartSeriesController=controller;
                },
                dataSource: _chartData,
                xValueMapper: (LiveData sales, _) => sales.time,
                yValueMapper: (LiveData sales, _) => sales.temp,
                name: 'Temp',
                // Enable data label
                dataLabelSettings: DataLabelSettings(isVisible: true))
          ],
          primaryXAxis: NumericAxis(
              majorGridLines: const MajorGridLines(width: 0),
              edgeLabelPlacement: EdgeLabelPlacement.shift,
              interval: 3,
              title: AxisTitle(text: 'Time (minutes)')
          ),

          primaryYAxis:NumericAxis(
              axisLine: const AxisLine(width: 0),
              majorTickLines: const MajorTickLines(size: 0),
              title: AxisTitle(text: 'Temperature in \u2103')
          ),
        )
    );
  }
}


//for live data
class LiveData{
  LiveData(this.time,this.temp);
  final int time;
  final int temp;
}