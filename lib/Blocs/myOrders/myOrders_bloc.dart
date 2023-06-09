import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:orderly/Api/api.dart';
import 'package:orderly/Blocs/address/address_event.dart';
import 'package:orderly/Blocs/address/address_state.dart';
import 'package:orderly/Blocs/home/bloc.dart';
import 'package:orderly/Blocs/myOrders/bloc.dart';
import 'package:orderly/Blocs/mycart/bloc.dart';
import 'package:orderly/Models/model_address.dart';
import 'package:orderly/Models/model_myOrders.dart';
import 'package:orderly/Models/model_scoped_cart.dart';
import 'package:orderly/Models/model_producer_list.dart';
import 'package:orderly/Models/model_product_List.dart';
import 'package:orderly/Models/model_trackOrder.dart';
import 'package:orderly/Models/model_view_cart.dart';
import 'package:orderly/Repository/UserRepository.dart';
import 'package:orderly/Utils/application.dart';
import 'package:http/http.dart' as http;


class MyOrdersBloc extends Bloc<MyOrdersEvent,MyOrdersState> {
  MyOrdersBloc({this.ordersRepo}) : super(InitialOrdersListState());
  final UserRepository ordersRepo;

  @override
  Stream<MyOrdersState> mapEventToState(MyOrdersEvent event) async* {
    // TODO: implement mapEventToState

    //for addressList
    if (event is OnLoadingOrdersList) {
      yield MyOrdersLoading();
      print("fbId"+Application.user.fbId);

      final MyOrdersResp response = await ordersRepo.fetchMyOrdersList(
          fbId: Application.user.fbId
      );
      try {
        // if (response.msg == "Success") {
        final Iterable refactorCategory = response.orders ?? [];
        final listOrders = refactorCategory.map((item) {
          return Orders.fromJson(item);
        }).toList();

        ///Sync UI
        yield MyOrdersListSuccess(orderList: listOrders);
        // } else {
        //   yield ProductListLoadFail();
        // }
      } catch (e) {
        print(e);
        yield MyOrdersListLoadFail();
      }
    }

    //for track order
    if(event is OnLoadingTrackOrderList){
      yield TrackOrdersLoading();

      final TrackOrderResp response = await ordersRepo.fetchTrackOrdersList(
          orderId: event.orderId
      );
      try {
        // if (response.msg == "Success") {
        final Iterable refactorCategory = response.trackOrder.trackData ?? [];
        String currentStatus=response.trackOrder.retRplc;
        List<TrackData> listtrackOrders=refactorCategory.toList();

        // final listtrackOrders = refactorCategory.map((item) {
        //   return TrackOrder.fromJson(item);
        // }).toList();
         if(listtrackOrders.length>0)
           {
        ///Sync UI
        yield TrackOrdersListSuccess(trackOrderList: listtrackOrders,currentstatus: currentStatus);
        } else {
           yield TrackOrdersListLoadFail();
        }
      } catch (e) {
        print(e);
        yield TrackOrdersListLoadFail();
      }
    }
  }
}



