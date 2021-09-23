import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:orderly/Api/api.dart';
import 'package:orderly/Blocs/home/bloc.dart';
import 'package:orderly/Blocs/mycart/bloc.dart';
import 'package:orderly/Models/model_scoped_cart.dart';
import 'package:orderly/Models/model_producer_list.dart';
import 'package:orderly/Models/model_product_List.dart';
import 'package:orderly/Models/model_view_cart.dart';
import 'package:orderly/Repository/UserRepository.dart';
import 'package:orderly/Utils/application.dart';
import 'package:http/http.dart' as http;


class CartBloc extends Bloc<CartEvent,CartState> {
  CartBloc({this.cartRepository}) : super(InitialCartListState());
  final UserRepository cartRepository;

  @override
  Stream<CartState> mapEventToState(CartEvent event) async* {
    // TODO: implement mapEventToState
    CartModel model;

    //for cart List
    if (event is OnLoadingCartList) {
      yield CartLoading();

      final ViewCartResp response = await cartRepository.fetchCartList(
        fbId: Application.user.fbId
      );
      try {
        // if (response.msg == "Success") {

        final Iterable refactorCategory = response.cart ?? [];
        final listCategory = refactorCategory.map((item) {
          return Cart.fromJson(item);
        }).toList();

        ///Sync UI
        yield CartListSuccess(cartList: listCategory);
        // } else {
        //   yield ProductListLoadFail();
        // }
      }catch(e)
      {
        print(e);
      }
    }

    if(event is OnDeleteCartList){
      yield CartLoading();

      Map<String,String> params={
            'cart_id':event.cartId,
          };

      var response = await http.post(
              Uri.parse(Api.DEL_CART_LIST),
              body: params,
            );
      try {
        if (response.statusCode == 200) {
          var resp = json.decode(response.body); //for dio dont need to convert to json.decode
         yield CartDeleteSuccess();
      }
      }catch(e){
        yield CartListLoadFail();
      }

    }

    //for place order
    if(event is PlaceOrder){
      yield PlaceOrderLoading();

      Map<String,String> params={
        'product_array':event.cartDetails,
        'user_id':Application.user.fbId,
        'delivery_type':event.deliveryType,
        'delivery_date':event.deliveryDate,
        'delivery_slot':event.deliverySlot,
        'urgent_amount':event.amount,
        'sub_total':event.subTotal,
        'convinience_fee':event.convFee,
        'grand_total':event.total,
        'discount':'',
        'order_status_id':'1',
        'address':event.addressId
      };

      try {

        var response = await http.post(Uri.parse(Api.PLACE_ORDER), body: params,);

        if (response.statusCode == 200) {
          var resp = json.decode(response.body); //for dio dont need to convert to json.decode
          yield PlaceOrderSuccess();
        }
      }catch(e){
        print("error:-"+e.toString());
        yield PlaceOrderFail();
      }

    }

  }
}