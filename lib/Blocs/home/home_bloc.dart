import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:orderly/Api/api.dart';
import 'package:orderly/Blocs/home/bloc.dart';
import 'package:orderly/Models/ResultApiModel.dart';
import 'package:orderly/Models/model_producer_list.dart';
import 'package:orderly/Models/model_product_List.dart';
import 'package:orderly/Repository/UserRepository.dart';
import 'package:orderly/Utils/application.dart';
import 'package:http/http.dart' as http;
import 'package:orderly/db/orderly_database.dart';


class HomeBloc extends Bloc<HomeEvent,HomeState> {
  HomeBloc({this.homeRepository}) : super(InitialProducerListState());
  final UserRepository homeRepository;

  @override
  Stream<HomeState> mapEventToState(HomeEvent event) async* {
    Uri url=Uri.parse("http://93.188.162.210:3000/add_to_cart");
    int countProducer=0,countProd=0;
   const _pageSize = 10;


    // TODO: implement mapEventToState
    if (event is OnLoadingProducerList) {
      yield ProducerLoading();

      final ProducerListResp response = await homeRepository.fetchProducerCat(
      lat: event.latitude,
      long: event.longitude

      );
      try {
        if (response.msg == "Success") {
          String conveyanceFee=response.convfee;
          final Iterable refactorCategory = response.producer ?? [];
          final listCategory = refactorCategory.map((item) {
            //for offline db
            // if(countProducer==0){
            //   OrderlyDatabase.database.addProducer(Producer.fromJson(item));
            //
            // }

            return Producer.fromJson(item);
          }).toList();

          ///Sync UI
          // countProducer++;
          yield ProducerListSuccess(producerList: listCategory,convFee:conveyanceFee);
        } else {
          yield ProducerListLoadFail();
        }
      }catch(e)
    {
      print(e);
    }
    }

    //for product List
    if (event is OnLoadingProductList) {
      yield ProductLoading();

      final ProductListResp response = await homeRepository.fetchProduct(
        producerId: event.producerId,
        type: event.type,
        offset: event.offset
      );
      try {
        // if (response.msg == "Success") {

          final Iterable refactorCategory = response.product ?? [];
          // PagingController controller=new PagingController(firstPageKey: 0);
          // controller.appendLastPage(refactorCategory);
          final listCategory = refactorCategory.map((item) {
            //for offlie db
            if(countProd==0){
              OrderlyDatabase.database.addProduct(Product.fromJson(item));
            }

            return Product.fromJson(item);

          }).toList();

          ///Sync UI
          countProd++;
          yield ProductListSuccess(productList: listCategory);
        // } else {
        //   yield ProductListLoadFail();
        // }
      }catch(e)
      {
        print(e);
      }
    }



    //for addTo Cart
    if(event is OnAddToCart){
       yield AddToCartLoading();

       Map<String,String> params={
         'producer_id':event.producerId,
         'product_id':event.productId,
         'user_id':event.FbId,
         'qty':event.qty,
         'rate_per_hour':event.price
           };

      var response = await http.post(Uri.parse(Api.ADD_TO_CART),
               body: params,
             );
       var resp;
       try{
         if (response.statusCode == 200) {
           resp = json.decode(response.body);
           yield AddToCartSuccess(msg:resp['msg']);
         }
       }catch(e){
         yield AddToCartFail(msg:resp['msg']);
       }
    }

  }

  
}