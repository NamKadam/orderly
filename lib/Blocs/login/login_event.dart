abstract class LoginEvent {}

class OnLogin extends LoginEvent {
  // final String username;
  //   final String password;
  var firstName,lastName,mobile,email,fbId;

  // OnLogin({this.username, this.password}); //commented on 8/02/2021
  OnLogin({this.firstName, this.lastName,this.mobile,this.email,this.fbId});

}

class OnLogout extends LoginEvent {
  OnLogout();
}
