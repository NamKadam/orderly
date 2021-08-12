import 'package:orderly/Models/imageFile.dart';

abstract class UserRegEvent {}

class OnUserRegister extends UserRegEvent {
  String firstName,lastName,mobile,email,password,address,zipcode,firebaseId,version,signupType,fcmId,deviceId,deviceName,lat,lng,userType;
  final ImageFile profile_photo; //added on 12/02/2021

  OnUserRegister({this.firstName, this.lastName,this.mobile,this.email,this.password,
    this.address,this.zipcode,this.profile_photo,this.firebaseId,this.version,this.signupType,this.fcmId,this.deviceId,
    this.deviceName,this.lat,this.lng,this.userType
  });
}
