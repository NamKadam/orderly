
import 'package:orderly/Models/imageFile.dart';

class OTPVerify{

  String flagForReg,flagForLogin,flagRoleType,phone,countrycode,name,address,pincode,firstName,lastName;
  ImageFile image;


  OTPVerify({
    this.flagForReg,
    this.flagForLogin,
    this.flagRoleType,
    this.name,
    this.countrycode,
    this.firstName,
    this.lastName,
    this.phone,
    this.address,
    this.pincode,
    this.image,
  });

}