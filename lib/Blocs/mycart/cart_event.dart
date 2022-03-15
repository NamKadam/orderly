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

class PlaceOrder extends CartEvent {
  String cartDetails,deliveryType,deliveryDate,deliverySlot,amount,subTotal,convFee,total,addressId,paymentId,paymentMode,dest_address;
  PlaceOrder({this.cartDetails,this.deliveryType,this.deliveryDate,this.deliverySlot,
    this.amount,this.subTotal,this.convFee,this.total,this.addressId,this.paymentId,this.paymentMode,this.dest_address});
}
