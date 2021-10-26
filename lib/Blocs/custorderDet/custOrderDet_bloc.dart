import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:orderly/Api/api.dart';
import 'package:orderly/Blocs/address/address_event.dart';
import 'package:orderly/Blocs/address/address_state.dart';
import 'package:orderly/Blocs/fleetOrders/bloc.dart';
import 'package:orderly/Blocs/custorderDet/bloc.dart';
import 'package:orderly/Blocs/home/bloc.dart';
import 'package:orderly/Blocs/myOrders/bloc.dart';
import 'package:orderly/Blocs/mycart/bloc.dart';
import 'package:orderly/Models/model_address.dart';
import 'package:orderly/Models/model_fleetOrder_det.dart';
import 'package:orderly/Models/model_fleet_orders.dart';
import 'package:orderly/Models/model_myOrders.dart';
import 'package:orderly/Models/model_return_reason.dart';
import 'package:orderly/Models/model_scoped_cart.dart';
import 'package:orderly/Models/model_producer_list.dart';
import 'package:orderly/Models/model_product_List.dart';
import 'package:orderly/Models/model_view_cart.dart';
import 'package:orderly/Repository/UserRepository.dart';
import 'package:orderly/Utils/application.dart';
import 'package:http/http.dart' as http;


class CustOrderDetBloc extends Bloc<CustOrdersDetEvent,CustOrdersDetState> {
  CustOrderDetBloc({this.custOrdersDetRepo}) : super(InitialCustOrdersDetState());
  final UserRepository custOrdersDetRepo;

  @override
  Stream<CustOrdersDetState> mapEventToState(CustOrdersDetEvent event) async* {
    // TODO: implement mapEventToState

    //for fleet order list
    if (event is SendProductReview) {
      yield CustOrdersDetLoading();

      Map<String,dynamic> params={
       'order_number':event.orderNum,
        'app_exp':event.appExp,
        'vehicle_qty':event.VehicleQty,
        'drive_exp':event.driveExp,
        'payment_exp':event.payExp,
        'overall':event.overall,
        'user_id':event.fbId,
        'product_id':event.prodId,
        'comment':event.comment
      };
      try {
        var resp=await http.post(Uri.parse(Api.CUST_PROD_REVIEW),body: params);
        var response=json.decode(resp.body);
        if (response['msg'] == "Successed") {

        yield ProductReviewSuccess();
        } else {
          yield ProductReviewFail();
        }
      } catch (e) {
        print(e);
        yield ProductReviewFail();
      }
    }

    //send return replace
    if (event is sendReturnReplace) {
      yield CustOrdersDetLoading();

      Map<String,dynamic> params={
        'order_number':event.orderNum,
        'return_type':event.returnType,
        'return_title':event.returnTitle,
        'review':event.review,
        'order_details_id':event.orderdetailsId,
        'user_id':event.fbId,
        'product_id':event.prodId,
        'status':event.status
      };
      try {
        var resp=await http.post(Uri.parse(Api.CUST_RETURN_REPLACE),body: params);
        var response=json.decode(resp.body);
        if (response['msg'] == "Successed") {

          yield ReturnReplaceSuccess();
        } else {
          yield ReturnReplaceFail();
        }
      } catch (e) {
        print(e);
        yield ReturnReplaceFail();
      }
    }

    if (event is getReturnOrderReason) {
      yield CustOrdersDetLoading();

      try {
        var resp=await http.get(Uri.parse(Api.GET_RETURN_REASONS));
        var response=json.decode(resp.body);
        if (response['msg'] == "Success") {
          final Iterable refactorCategory = response['charges'] ?? [];
          final listReason = refactorCategory.map((item) {
            return Reasons.fromJson(item);
          }).toList();

          yield ReturnReasonSuccess(reasonList: listReason);
        } else {
          yield ReturnReasonFail();
        }
      } catch (e) {
        print(e);
        yield ReturnReasonFail();
      }
    }


  }
}



