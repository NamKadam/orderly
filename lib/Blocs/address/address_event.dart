import 'package:meta/meta.dart';

@immutable
abstract class AddressEvent {}

class OnLoadingAddressList extends AddressEvent {
  String fbId;
  OnLoadingAddressList({this.fbId});
}
class OnDeleteAddress extends AddressEvent {
  String addressId;
  OnDeleteAddress({this.addressId});
}

class OnAddAdress extends AddressEvent {
  String fullName,mobile,email,address,zipcode,city,state,country,streetNo,flatNo,latitude,longitude;
  OnAddAdress({this.fullName,this.mobile,this.email,this.address,this.zipcode,this.city,this.state,this.country,this.streetNo,this.flatNo,
  this.latitude,this.longitude});
}

class OnEditAdress extends AddressEvent {
  String fullName,mobile,email,address,zipcode,city,state,country,addressId,streetNo,flatNo,latitude,longitude;
  OnEditAdress({this.fullName,this.mobile,this.email,this.address,this.zipcode,this.city,this.state,this.country,this.addressId,this.streetNo,
  this.flatNo,this.latitude,this.longitude});
}




