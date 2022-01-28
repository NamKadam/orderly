import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:orderly/Api/api.dart';
import 'package:orderly/Blocs/address/address_event.dart';
import 'package:orderly/Blocs/address/address_state.dart';
import 'package:orderly/Blocs/fleetOrders/bloc.dart';
import 'package:orderly/Blocs/home/bloc.dart';
import 'package:orderly/Blocs/myOrders/bloc.dart';
import 'package:orderly/Blocs/mycart/bloc.dart';
import 'package:orderly/Models/model_address.dart';
import 'package:orderly/Models/model_fleetOrder_det.dart';
import 'package:orderly/Models/model_fleet_orders.dart';
import 'package:orderly/Models/model_myOrders.dart';
import 'package:orderly/Models/model_scoped_cart.dart';
import 'package:orderly/Models/model_producer_list.dart';
import 'package:orderly/Models/model_product_List.dart';
import 'package:orderly/Models/model_view_cart.dart';
import 'package:orderly/Repository/UserRepository.dart';
import 'package:orderly/Utils/application.dart';
import 'package:http/http.dart' as http;


class FleetOrdersBloc extends Bloc<FleetOrdersEvent,FleetOrdersState> {
  FleetOrdersBloc({this.fleetOrdersRepo}) : super(InitialFleetOrdersListState());
  final UserRepository fleetOrdersRepo;

  @override
  Stream<FleetOrdersState> mapEventToState(FleetOrdersEvent event) async* {
    // TODO: implement mapEventToState

    //for fleet order list
    if (event is OnLoadingFleetOrdersList) {
      yield FleetOrdersLoading();

      final FleetOrderResp response = await fleetOrdersRepo.fetchFleetOrdersList(
          producerId: event.producerId,
        status: event.status
      );
      try {
        // if (response.msg == "Success") {
        final Iterable refactorCategory = response.fleetorders ?? [];
        final listOrders = refactorCategory.map((item) {
          return FleetOrderModel.fromJson(item);
        }).toList();

        ///Sync UI
        yield FleetOrdersListSuccess(fleetOrderList: listOrders);
        // } else {
        //   yield ProductListLoadFail();
        // }
      } catch (e) {
        print(e);
        yield FleetOrdersListLoadFail();
      }
    }

    //fleet order details
    if (event is OnLoadingFleetOrdersDet) {
      yield FleetOrdersLoading();

      final FleetOrderDetResp response = await fleetOrdersRepo.fetchFleetOrdersDet(
          orderId: event.orderid,
          status: event.status,
        producerId:event.producerId
      );
      try {
        // if (response.msg == "Success") {
        final Iterable refactorCategory = response.ordersDet ?? [];
        final Iterable refactorUserData = response.userData ?? [];
        final listOrders = refactorCategory.map((item) {
          return FleetOrdersDet.fromJson(item);
        }).toList();
        //for user data
        final listUserData = refactorUserData.map((item) {
          return UserData.fromJson(item);
        }).toList();
        print(listUserData[0]);

        ///Sync UI
        yield FleetOrdersDetListSuccess(fleetOrderDetList: listOrders,fleetUserData:listUserData[0]);
        // } else {
        //   yield ProductListLoadFail();
        // }
      } catch (e) {
        print(e);
        yield FleetOrdersDetLoadFail();
      }
    }

    //fleet order status
    if (event is UpdateFleetOrdersStatus) {
      yield FleetOrdersStatusLoading();

      Map<String,dynamic> params={
        'order_detail_id':event.orderid,
        'status':event.status,
        'reject_reason':event.rejectReason
      };
      try {
        var resp=await http.post(Uri.parse(Api.UPDATE_FLEET_STATUS),body: params);

        if (resp.statusCode==200) {
          var response = json.decode(resp.body);
          if (response['msg'] == "Successed") {
            yield FleetOrdersDetStatusSuccess();
          } else {
            yield FleetOrdersStatusLoadFail();
          }
        }
      } catch (e) {
        print(e);
        yield FleetOrdersStatusLoadFail();
      }
    }

    //fleet orders return replace
    if (event is FleetOrdersReturnReplace) {
      yield FleetOrdersLoading();

      final FleetOrderDetResp response = await fleetOrdersRepo.fetchFleetReturnReplace(
          producerId: event.producerId,
      );
      try {
        // if (response.msg == "Success") {
        final Iterable refactorCategory = response.ordersDet ?? [];
        final listRetReplace = refactorCategory.map((item) {
          return FleetOrdersDet.fromJson(item);
        }).toList();

        ///Sync UI
        yield FleetOrdersRetReplaceSuccess(fleetOrderRetReplaceList: listRetReplace);
        // } else {
        //   yield ProductListLoadFail();
        // }
      } catch (e) {
        print(e);
        yield FleetOrdersRetReplaceFail();
      }
    }



  }
}



