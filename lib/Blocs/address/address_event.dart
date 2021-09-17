import 'package:meta/meta.dart';

@immutable
abstract class AddressEvent {}

class OnLoadingAddressList extends AddressEvent {
  String fbId;
  OnLoadingAddressList({this.fbId});
}

class OnAddAdress extends AddressEvent {
  String fullName,mobile,email,address,zipcode,city,state,country;
  OnAddAdress({this.fullName,this.mobile,this.email,this.address,this.zipcode,this.city,this.state,this.country});
}

class OnEditAdress extends AddressEvent {
  String fullName,mobile,email,address,zipcode,city,state,country,addressId;
  OnEditAdress({this.fullName,this.mobile,this.email,this.address,this.zipcode,this.city,this.state,this.country,this.addressId});
}


