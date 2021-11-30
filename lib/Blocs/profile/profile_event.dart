import 'package:orderly/Models/imageFile.dart';

abstract class ProfileEvent {}

class EditProf extends ProfileEvent {
  String firstName,lastName,email,zipcode,mobile,address;

  EditProf({this.firstName, this.lastName,this.email,this.zipcode,this.address,this.mobile});
}

class FetchFAQ extends ProfileEvent {
  FetchFAQ();
}
