import 'package:meta/meta.dart';
import 'package:orderly/Models/model_address.dart';
import 'package:orderly/Models/model_scoped_cart.dart';
import 'package:orderly/Models/model_view_cart.dart';

@immutable
abstract class AddressState {}

class InitialAddressListState extends AddressState {}

class AddressLoading extends AddressState {}

class AddressListSuccess extends AddressState {
  final List<Address> addressList;
  AddressListSuccess({this.addressList});
}

class Add_AddressSuccess extends AddressState {
  Add_AddressSuccess();
}

class Update_AddressSuccess extends AddressState {
  Update_AddressSuccess();
}

class Add_AddressLoadFail extends AddressState {}
class Update_AddressLoadFail extends AddressState {}
class AddressListLoadFail extends AddressState {}
