import 'package:meta/meta.dart';
import 'package:orderly/Models/cart_model.dart';
import 'package:orderly/Models/view_cart.dart';

@immutable
abstract class CartState {}

class InitialCartListState extends CartState {}

class CartLoading extends CartState {}

class CartListSuccess extends CartState {
  final List<Cart> cartList;
  CartListSuccess({this.cartList});
}

class CartListLoadFail extends CartState {}
