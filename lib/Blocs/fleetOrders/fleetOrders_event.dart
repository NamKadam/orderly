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

class UpdateFleetOrdersStatus extends FleetOrdersEvent {
  String orderid,status;
  UpdateFleetOrdersStatus({this.orderid,this.status});
}

//fleet orders return replace
class FleetOrdersReturnReplace extends FleetOrdersEvent {
  String producerId;
  FleetOrdersReturnReplace({this.producerId});
}



