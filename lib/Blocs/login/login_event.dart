abstract class LoginEvent {}

class OnLogin extends LoginEvent {
  // final String username;
  //   final String password;
  var fbId;

  // OnLogin({this.username, this.password}); //commented on 8/02/2021
  OnLogin({this.fbId});

}

class OnFleetLogin extends LoginEvent{
  var fbId,mobile,fcmId,deviceId;

  OnFleetLogin({this.fbId,this.fcmId,this.deviceId,this.mobile});

}

class OnLogout extends LoginEvent {
  OnLogout();
}
