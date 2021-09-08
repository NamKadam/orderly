import 'package:meta/meta.dart';

@immutable
abstract class CartEvent {}

class OnLoadingCartList extends CartEvent {
  String fbId;
  OnLoadingCartList({this.fbId});
}

class OnDeleteCartList extends CartEvent {
  String cartId;
  OnDeleteCartList({this.cartId});
}
