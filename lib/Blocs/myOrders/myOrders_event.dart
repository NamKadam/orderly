import 'package:meta/meta.dart';

@immutable
abstract class MyOrdersEvent {}

class OnLoadingOrdersList extends MyOrdersEvent {
  String fbId;
  OnLoadingOrdersList({this.fbId});
}




