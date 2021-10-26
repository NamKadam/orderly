import 'package:meta/meta.dart';
import 'package:orderly/Models/model_address.dart';
import 'package:orderly/Models/model_fleetOrder_det.dart';
import 'package:orderly/Models/model_fleet_orders.dart';
import 'package:orderly/Models/model_myOrders.dart';
import 'package:orderly/Models/model_return_reason.dart';
import 'package:orderly/Models/model_scoped_cart.dart';
import 'package:orderly/Models/model_view_cart.dart';

@immutable
abstract class CustOrdersDetState {}

class InitialCustOrdersDetState extends CustOrdersDetState {}

class CustOrdersDetLoading extends CustOrdersDetState {}

class ProductReviewSuccess extends CustOrdersDetState {
  ProductReviewSuccess();
}

class ReturnReplaceSuccess extends CustOrdersDetState {
  ReturnReplaceSuccess();
}
class ReturnReasonSuccess extends CustOrdersDetState {
  List<Reasons> reasonList;
  ReturnReasonSuccess({this.reasonList});
}

class ProductReviewFail extends CustOrdersDetState {}
class ReturnReplaceFail extends CustOrdersDetState {}
class ReturnReasonFail extends CustOrdersDetState {}
