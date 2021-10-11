import 'package:meta/meta.dart';
import 'package:orderly/Models/model_address.dart';
import 'package:orderly/Models/model_fleetOrder_det.dart';
import 'package:orderly/Models/model_fleet_orders.dart';
import 'package:orderly/Models/model_myOrders.dart';
import 'package:orderly/Models/model_scoped_cart.dart';
import 'package:orderly/Models/model_view_cart.dart';

@immutable
abstract class FleetOrdersState {}

class InitialFleetOrdersListState extends FleetOrdersState {}

class FleetOrdersLoading extends FleetOrdersState {}
class FleetOrdersStatusLoading extends FleetOrdersState {}

class FleetOrdersListSuccess extends FleetOrdersState {
  final List<FleetOrderModel> fleetOrderList;
  FleetOrdersListSuccess({this.fleetOrderList});
}

class FleetOrdersDetListSuccess extends FleetOrdersState {
  final List<FleetOrdersDet> fleetOrderDetList;
  FleetOrdersDetListSuccess({this.fleetOrderDetList});
}

class FleetOrdersDetStatusSuccess extends FleetOrdersState {
  FleetOrdersDetStatusSuccess();
}


class FleetOrdersListLoadFail extends FleetOrdersState {}
class FleetOrdersDetLoadFail extends FleetOrdersState {}
class FleetOrdersStatusLoadFail extends FleetOrdersState {}
