import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:orderly/Api/api.dart';
import 'package:orderly/Blocs/home/bloc.dart';
import 'package:orderly/Blocs/producer/bloc.dart';
import 'package:orderly/Models/ResultApiModel.dart';
import 'package:orderly/Models/model_producer_list.dart';
import 'package:orderly/Models/model_product_List.dart';
import 'package:orderly/Repository/UserRepository.dart';
import 'package:orderly/Utils/application.dart';
import 'package:http/http.dart' as http;
import 'package:orderly/db/orderly_database.dart';


class ProducerProdBloc extends Bloc<ProducerProdEvent,ProducerProdState> {
  ProducerProdBloc({this.producerProdRepo}) : super(InitialProducerProdListState());
  final UserRepository producerProdRepo;

  @override
  Stream<ProducerProdState> mapEventToState(ProducerProdEvent event) async* {
    Uri url=Uri.parse("http://93.188.162.210:3000/add_to_cart");
    int countProducer=0,countProd=0;
    const _pageSize = 10;


    // TODO: implement mapEventToState
    if (event is OnLoadingProducerTabList) {
      yield ProducerTabLoading();

      final ProducerListResp response = await producerProdRepo.fetchProducerCat();
      try {
        if (response.msg == "Success") {
          final Iterable refactorCategory = response.producer ?? [];
          final listCategory = refactorCategory.map((item) {

            return Producer.fromJson(item);
          }).toList();


          yield ProducerListTabSuccess(producerList: listCategory);
        } else {
          yield ProducerListTabLoadFail();
        }
      }catch(e)
      {
        print(e);
      }
    }

    //for product List
    if (event is OnLoadingProductTabList) {
      yield ProductTabLoading();

      final ProductListResp response = await producerProdRepo.fetchProduct(
          producerId: event.producerId,
          type: event.type,
          offset: event.offset
      );
      try {
        final Iterable refactorCategory = response.product ?? [];
        final listCategory = refactorCategory.map((item) {
          return Product.fromJson(item);
        }).toList();

        yield ProductListTabSuccess(productList: listCategory);

      }catch(e)
      {
        print(e);
      }
    }



    //for addTo Cart
    if(event is OnAddToCartTab){
      yield AddToCartTabLoading();

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
          yield AddToCartTabSuccess(msg:resp['msg']);
        }
      }catch(e){
        yield AddToCartTabFail(msg:resp['msg']);
      }
    }

  }


}