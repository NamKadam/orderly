
import 'package:meta/meta.dart';
import 'package:orderly/Models/model_user.dart';

@immutable
abstract class LoginState {}

class InitialLoginState extends LoginState {}

class LoginLoading extends LoginState {}

class LoginFail extends LoginState {
  final String msg;

  LoginFail({this.msg});
}

class LoginSuccess extends LoginState {
  User userModel;
  LoginSuccess({this.userModel});

}




class LogoutLoading extends LoginState {}

class LogoutFail extends LoginState {
  final String message;

  LogoutFail(this.message);
}

class LogoutSuccess extends LoginState {}
