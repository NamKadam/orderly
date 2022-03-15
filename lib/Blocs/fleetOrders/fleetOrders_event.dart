import 'package:meta/meta.dart';

@immutable
abstract class FleetOrdersEvent {}

class OnLoadingFleetOrdersList extends FleetOrdersEvent {
  String producerId,status;
  OnLoadingFleetOrdersList({this.producerId,this.status});
}

class OnLoadingFleetOrdersDet extends FleetOrdersEvent {
  String orderid,status,producerId;
  OnLoadingFleetOrdersDet({this.orderid,this.status,this.producerId});
}
//for temperature
class OnLoadingFleetOrdersDetTemp extends FleetOrdersEvent {
  String orderid,orderStatus;
  OnLoadingFleetOrdersDetTemp({this.orderid,this.orderStatus});
}

class UpdateFleetOrdersStatus extends FleetOrdersEvent {
  String orderid,status,rejectReason,truckId,deviceId,flag;
  UpdateFleetOrdersStatus({this.orderid,this.status,this.rejectReason,this.truckId,this.deviceId,this.flag});
}

//fleet orders return replace
class FleetOrdersReturnReplace extends FleetOrdersEvent {
  String producerId;
  FleetOrdersReturnReplace({this.producerId});
}



