import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:orderly/Blocs/home/bloc.dart';
import 'package:orderly/Blocs/mycart/bloc.dart';
import 'package:orderly/Models/cart_model.dart';
import 'package:orderly/Models/model_producer_list.dart';
import 'package:orderly/Models/productList_scopedModel.dart';
import 'package:orderly/Models/view_cart.dart';
import 'package:orderly/Repository/UserRepository.dart';
import 'package:orderly/Utils/application.dart';

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


  }


}