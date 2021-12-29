import 'package:meta/meta.dart';
import 'package:orderly/Models/model_address.dart';
import 'package:orderly/Models/model_myOrders.dart';
import 'package:orderly/Models/model_scoped_cart.dart';
import 'package:orderly/Models/model_trackOrder.dart';
import 'package:orderly/Models/model_view_cart.dart';

@immutable
abstract class MyOrdersState {}

class InitialOrdersListState extends MyOrdersState {}

class MyOrdersLoading extends MyOrdersState {}
class TrackOrdersLoading extends MyOrdersState {}


class MyOrdersListSuccess extends MyOrdersState {
  final List<Orders> orderList;
  MyOrdersListSuccess({this.orderList});
}

//for track order
class TrackOrdersListSuccess extends MyOrdersState {
  List<TrackData> trackOrderList;
  String currentstatus="";
  TrackOrdersListSuccess({this.trackOrderList,this.currentstatus});
}


class MyOrdersListLoadFail extends MyOrdersState {}
class TrackOrdersListLoadFail extends MyOrdersState {}
