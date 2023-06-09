import 'package:meta/meta.dart';
import 'package:orderly/Models/model_scoped_cart.dart';
import 'package:orderly/Models/model_view_cart.dart';

@immutable
abstract class CartState {}

class InitialCartListState extends CartState {}

class CartLoading extends CartState {}
class PlaceOrderLoading extends CartState {}

class CartListSuccess extends CartState {
  final List<Cart> cartList;
  CartListSuccess({this.cartList});
}
class CartDeleteSuccess extends CartState {
  final List<Cart> cartList;
  CartDeleteSuccess({this.cartList});
}

class PlaceOrderSuccess extends CartState {
  final String msg;
  PlaceOrderSuccess({this.msg});
}
class CartListLoadFail extends CartState {}
class PlaceOrderFail extends CartState {}
