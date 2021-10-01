import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:orderly/Api/api.dart';
import 'package:orderly/Blocs/address/address_event.dart';
import 'package:orderly/Blocs/address/address_state.dart';
import 'package:orderly/Blocs/home/bloc.dart';
import 'package:orderly/Blocs/mycart/bloc.dart';
import 'package:orderly/Models/model_address.dart';
import 'package:orderly/Models/model_scoped_cart.dart';
import 'package:orderly/Models/model_producer_list.dart';
import 'package:orderly/Models/model_product_List.dart';
import 'package:orderly/Models/model_view_cart.dart';
import 'package:orderly/Repository/UserRepository.dart';
import 'package:orderly/Utils/application.dart';
import 'package:http/http.dart' as http;


class AddressBloc extends Bloc<AddressEvent,AddressState> {
  AddressBloc({this.addressRepo}) : super(InitialAddressListState());
  final UserRepository addressRepo;

  @override
  Stream<AddressState> mapEventToState(AddressEvent event) async* {
    // TODO: implement mapEventToState

    //for addressList
    if (event is OnLoadingAddressList) {
      yield AddressLoading();

      final AddressResp response = await addressRepo.fetchAddressList(
          fbId: Application.user.fbId
      );
      try {
        // if (response.msg == "Success") {

        final Iterable refactorCategory = response.address ?? [];
        final listCategory = refactorCategory.map((item) {
          return Address.fromJson(item);
        }).toList();

        ///Sync UI
        yield AddressListSuccess(addressList: listCategory);
        // } else {
        //   yield ProductListLoadFail();
        // }
      }catch(e)
      {
        print(e);
        yield AddressListLoadFail();

      }
    }

    //add address
    if(event is OnAddAdress){
      yield AddressLoading();

      Map<String,String> params={
        'userid':Application.user.fbId,
        'user_name':event.fullName,
        'mobile':event.mobile,
        'email_id':event.email,
        'address':event.address,
        'zipcode':event.zipcode,
        'city':event.city,
        'state':event.state,
        'country':event.country
      };

      var response = await http.post(
        Uri.parse(Api.ADD_ADDRESS),
        body: params,
      );
      try {
        if (response.statusCode == 200) {
          var resp = json.decode(response.body); //for dio dont need to convert to json.decode
          yield Add_AddressSuccess();
        }
      }catch(e){
        yield Add_AddressLoadFail();
      }

    }

    //edit address
    if(event is OnEditAdress){
      yield AddressLoading();

      Map<String,String> params={
        'userid':Application.user.fbId,
        'user_name':event.fullName,
        'mobile':event.mobile,
        'email_id':event.email,
        'address':event.address,
        'zipcode':event.zipcode,
        'city':event.city,
        'state':event.state,
        'country':event.country,
        'addressid':event.addressId
      };

      var response = await http.post(
        Uri.parse(Api.EDIT_ADDRESS),
        body: params,
      );
      try {
        if (response.statusCode == 200) {
          var resp = json.decode(response.body); //for dio dont need to convert to json.decode
          yield Update_AddressSuccess();
        }
      }catch(e){
        yield Update_AddressLoadFail();
      }

    }

  }

}