import 'package:orderly/Models/model_user.dart';

abstract class AuthenticationEvent {}

class OnAuthCheck extends AuthenticationEvent {}

class OnSaveUser extends AuthenticationEvent {
  final User user;
  OnSaveUser(this.user);

}

class OnClear extends AuthenticationEvent {}
