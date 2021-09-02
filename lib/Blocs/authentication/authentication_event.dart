import 'package:orderly/Models/model_scoped_cart.dart';
import 'package:orderly/Models/model_user.dart';
import 'package:orderly/Models/model_view_cart.dart';

abstract class AuthenticationEvent {}

class OnAuthCheck extends AuthenticationEvent {}

class OnSaveUser extends AuthenticationEvent {
  final User user;
  OnSaveUser(this.user);

}

class OnSaveCart extends AuthenticationEvent {
  final CartModel cartModel;
  OnSaveCart(this.cartModel);

}

class OnClear extends AuthenticationEvent {}
