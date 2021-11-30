import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:orderly/Api/api.dart';
import 'package:orderly/Blocs/inventory/bloc.dart';
import 'package:orderly/Models/model_invent_list.dart';
import 'package:orderly/Repository/UserRepository.dart';
import 'package:http/http.dart' as http;
import 'package:orderly/Utils/application.dart';


class InventoryBloc extends Bloc<InventoryEvent,InventoryState> {
  InventoryBloc({this.inventoryRepo}) : super(InitialInventoryListState());
  final UserRepository inventoryRepo;

  @override
  Stream<InventoryState> mapEventToState(InventoryEvent event) async* {
    // TODO: implement mapEventToState

    //for inventory list
    if (event is OnLoadingInventoryList) {
      yield InventoryLoading();

      final InventResp response = await inventoryRepo.fetchFleetInventory(
          producerId: event.producerId
      );
      try {
        // if (response.msg == "Success") {
        final Iterable refactorCategory = response.inventory ?? [];
        final listInventory = refactorCategory.map((item) {
          return Inventory.fromJson(item);
        }).toList();

        ///Sync UI
        yield InventoryListSuccess(inventoryList: listInventory);
        // } else {
        //   yield ProductListLoadFail();
        // }
      } catch (e) {
        print(e);
        yield InventoryListLoadFail();
      }
    }

    //for delete inventory item
    if(event is OnRemoveInventoryItem){
      yield InventoryLoading();

      Map<String,String> params={
        'product_id':event.productId,
      };

      var response = await http.post(
        Uri.parse(Api.DEL_INVENTORY_ITEM),
        body: params,
      );
      try {
        if (response.statusCode == 200) {
          var resp = json.decode(response.body); //for dio dont need to convert to json.decode
          yield InventoryRemovedSuccess();
        }
      }catch(e){
        yield InventoryRemovedFail();
      }

    }

    //for add inventory item
    if(event is OnAddInventoryItem){
      yield InventoryAddEditLoading();

      Map<String,dynamic> params={
        'producerid':Application.user.producerid,
        'product_name':event.title,
        'product_desc':event.desc,
        'rate_per_hour':event.rate,
        'product_qty':event.qty
      };

      var response = await http.post(
        Uri.parse(Api.ADD_INVENTORY_ITEM),
        body:params,
      );
      try {
        if (response.statusCode == 200) {
          var resp = json.decode(response.body); //for dio dont need to convert to json.decode
          yield InventoryAddedSuccess();
        }
      }catch(e){
        yield InventoryAddedFail();
      }

    }

    //for edit item
    if(event is OnEditInventoryItem){
      yield InventoryAddEditLoading();

      Map<String,dynamic> params={
        'product_id':event.prodId,
        'product_name':event.title,
        'product_desc':event.desc,
        'rate_per_hour':event.rate,
        'product_qty':event.qty
      };

      var response = await http.post(
        Uri.parse(Api.EDIT_INVENTORY_ITEM),
        body:params,
      );
      try {
        if (response.statusCode == 200) {
          var resp = json.decode(response.body); //for dio dont need to convert to json.decode
          yield InventoryUpdatedSuccess();
        }
      }catch(e){
        yield InventoryUpdatedFail();
      }

    }
  }
}
