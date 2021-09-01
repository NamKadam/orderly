import 'package:orderly/Models/model_user.dart';
import 'package:orderly/Models/view_cart.dart';

abstract class AuthenticationEvent {}

class OnAuthCheck extends AuthenticationEvent {}

class OnSaveUser extends AuthenticationEvent {
  final User user;
  OnSaveUser(this.user);

}

class OnSaveCart extends AuthenticationEvent {
  final List<Cart> cart;
  OnSaveCart(this.cart);

}

class OnClear extends AuthenticationEvent {}
