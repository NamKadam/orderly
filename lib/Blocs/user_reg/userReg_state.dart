import 'package:orderly/Models/model_user.dart';

abstract class UserRegState {}

class InitialUserRegisteState extends UserRegState {}

class FetchingUserRegister extends UserRegState {}

class RegisterUserSuccess extends UserRegState {
  User user;

  RegisterUserSuccess({this.user});

}

class RegisterUserFail extends UserRegState {
  final String msg;
  RegisterUserFail({this.msg});
}
