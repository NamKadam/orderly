abstract class LoginEvent {}

class OnLogin extends LoginEvent {
  // final String username;
  //   final String password;
  var fbId;

  // OnLogin({this.username, this.password}); //commented on 8/02/2021
  OnLogin({this.fbId});

}

class OnLogout extends LoginEvent {
  OnLogout();
}
