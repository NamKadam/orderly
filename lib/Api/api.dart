import 'dart:async';
import 'package:orderly/Models/ResultApiModel.dart';
import 'package:http/http.dart' as http;
import 'package:orderly/Models/model_address.dart';
import 'package:orderly/Models/model_claim.dart';
import 'package:orderly/Models/model_faqList.dart';
import 'package:orderly/Models/model_fleetOrder_det.dart';
import 'package:orderly/Models/model_fleet_orders.dart';
import 'package:orderly/Models/model_invent_list.dart';
import 'package:orderly/Models/model_myOrders.dart';
import 'package:orderly/Models/model_producer_list.dart';
import 'package:orderly/Models/model_product_List.dart';
import 'package:orderly/Models/model_tempLatLng.dart';
import 'package:orderly/Models/model_trackOrder.dart';
import 'package:orderly/Models/model_view_cart.dart';
import 'dart:convert';
import 'package:orderly/Models/zipcode/postalcode.dart';


class Api {

  static const String HOST_URL="http://93.188.162.210:3000/";//updated on 23/12/2020
  static const String CUST_REG="register";//updated on 23/12/2020
  static const String CUST_LOGIN=HOST_URL+"login";
  static const String FLEET_LOGIN=HOST_URL+"fleet_login";
  static const String GET_PRODUCER_LIST=HOST_URL+"producer";
  static const String GET_PROD_LIST=HOST_URL+"product_list";
  static const String ADD_TO_CART=HOST_URL+"add_to_cart";
  static const String GET_CART_LIST=HOST_URL+"view_cart";
  static const String DEL_CART_LIST=HOST_URL+"delete_cart";
  static const String GET_CHARGES=HOST_URL+"urgent_charges";
  static const String GET_ADDRESS_LIST=HOST_URL+"view_address";
  static const String ADD_ADDRESS=HOST_URL+"add_address";
  static const String EDIT_ADDRESS=HOST_URL+"update_address";
  static const String DEL_ADDRESS=HOST_URL+"delete_address";
  static const String PLACE_ORDER=HOST_URL+"place_order";
  static const String GET_MYORDER=HOST_URL+"my_order";
  static const String GET_TRACK_ORDER=HOST_URL+"track_order";
  static const String GET_FLEET_ORDER=HOST_URL+"fleet_manager_orders";
  static const String GET_FLEET_ORDER_DET=HOST_URL+"fleet_manager_orders_details";
  static const String GET_FLEET_ORDER_DET_TEMP=HOST_URL+"fetch_temprature";
  static const String UPDATE_FLEET_STATUS=HOST_URL+"update_order_status";
  static const String GET_CLAIM_ORDER=HOST_URL+"fetch_claims_details";

  static const String CUST_PROD_REVIEW=HOST_URL+"product_review";
  static const String CUST_RETURN_REPLACE=HOST_URL+"product_return";
  static const String GET_RETURN_REASONS=HOST_URL+"return_order_reasons";
  static const String GET_FLEET_RETURN_REPLACE=HOST_URL+"fleet_manager_order_return";
  static const String VIEW_INVENTORY_LIST=HOST_URL+"view_inventory";
  static const String DEL_INVENTORY_ITEM=HOST_URL+"remove_inventory";
  static const String ADD_INVENTORY_ITEM=HOST_URL+"add_inventory";
  static const String EDIT_INVENTORY_ITEM=HOST_URL+"update_inventory";
  static const String EDIT_PROFILE=HOST_URL+"update_fleet_profile"; //both for cust and fleet applicable
  static const String TERMS_URL=HOST_URL+"terms_condition";
  static const String PRIVACY_URL=HOST_URL+"privacy_policy";
  static const String FAQ=HOST_URL+"faq_list";
  static const String INVOICE=HOST_URL+"download_invoice";
  static const String LOGOUT=HOST_URL+"logout";
  static const String UPLOAD_IMAGE=HOST_URL+"uploadImage";
  static const String FETCH_TRUCK=HOST_URL+"fetch_truck_listing";
  // image: browse file
  // fb_id:";

  ///Login api
  static Future<dynamic> login(params) async {
    final response = await http.post(
      Uri.parse(CUST_LOGIN),
      body: params,
    );
    if (response.statusCode == 200) {
      final responseJson = json.decode(response.body);
      print(responseJson);
      return ResultApiModel.fromJson(responseJson);
    }
  }

  //for fleet login
  static Future<dynamic> fleetlogin(params) async {
    final response = await http.post(
      Uri.parse(FLEET_LOGIN),
      body: params,
    );
    if (response.statusCode == 200) {
      final responseJson = json.decode(response.body);
      return ResultApiModel.fromJson(responseJson);
    }
  }

  //register api
  static Future<dynamic> register(params) async {
    final response = await http.post(
      Uri.parse(CUST_REG),
      body: params,
    );
    if (response.statusCode == 200) {
      final responseJson = json.decode(response.body);
      return ResultApiModel.fromJson(responseJson);
    }
  }

  //get prod list api
  static Future<dynamic> getProducerList(params) async {
    // final response = await http.get(Uri.parse(GET_PRODUCER_LIST));
    final response = await http.post(Uri.parse(GET_PRODUCER_LIST),
      body: params);
    if (response.statusCode == 200) {
      final responseJson = json.decode(response.body);
      return ProducerListResp.fromJson(responseJson);
    }
  }

  //get product list as per producer Id
  static Future<dynamic> getProdList(params) async {
    final response = await http.post(
      Uri.parse(GET_PROD_LIST),
      body: params,
    );
    if (response.statusCode == 200) {
      final responseJson = json.decode(response.body);
      return ProductListResp.fromJson(responseJson);
    }
  }

  //get cart list
  static Future<dynamic> getCartList(params) async {
    final response = await http.post(
      Uri.parse(GET_CART_LIST),
      body: params,
    );
    if (response.statusCode == 200) {
      final responseJson = json.decode(response.body);
      return ViewCartResp.fromJson(responseJson);
    }
  }

  //get address list
  static Future<dynamic> getAddress(params) async {
    final response = await http.post(
      Uri.parse(GET_ADDRESS_LIST),
      body: params,
    );
    if (response.statusCode == 200) {
      final responseJson = json.decode(response.body);
      return AddressResp.fromJson(responseJson);
    }
  }

  //fetch myorders list
  static Future<dynamic> getOrdersList(params) async {
    final response = await http.post(
      Uri.parse(GET_MYORDER),
      body: params,
    );
    if (response.statusCode == 200) {
      final responseJson = json.decode(response.body);
      return MyOrdersResp.fromJson(responseJson);
    }
  }

  //track order
  //fetch myorders list
  static Future<dynamic> getTrackOrderList(params) async {
    final response = await http.post(
      Uri.parse(GET_TRACK_ORDER),
      body: params,
    );
    if (response.statusCode == 200) {
      final responseJson = json.decode(response.body);
      return TrackOrderResp.fromJson(responseJson);
    }
  }

  //fleet manager
   //fleet order list
  static Future<dynamic> getFleetOrdersList(params) async {
    final response = await http.post(
      Uri.parse(GET_FLEET_ORDER),
      body: params,
    );
    if (response.statusCode == 200) {
      final responseJson = json.decode(response.body);
      return FleetOrderResp.fromJson(responseJson);
    }
  }

  //fleet order det
  static Future<dynamic> getFleetOrdersDet(params) async {
    final response = await http.post(
      Uri.parse(GET_FLEET_ORDER_DET),
      body: params,
    );
    if (response.statusCode == 200) {
      final responseJson = json.decode(response.body);
      return FleetOrderDetResp.fromJson(responseJson);
    }
  }

  //for fleet order det temp
  static Future<dynamic> getFleetOrdersDetTemp(params) async {
    final response = await http.post(
      Uri.parse(GET_FLEET_ORDER_DET_TEMP),
      body: params,
    );
    if (response.statusCode == 200) {
      final responseJson = json.decode(response.body);
      return FleetTempResp.fromJson(responseJson);
    }
  }

  //fleet return replace list
  static Future<dynamic> getFleetReturnReplace(params) async {
    final response = await http.post(
      Uri.parse(GET_FLEET_RETURN_REPLACE),
      body: params,
    );
    if (response.statusCode == 200) {
      final responseJson = json.decode(response.body);
      return FleetOrderDetResp.fromJson(responseJson);
    }
  }
  //fetch claim list
  static Future<dynamic> getClaimOrdersList(params) async {
    final response = await http.post(
      Uri.parse(GET_CLAIM_ORDER),
      body: params,
    );
    if (response.statusCode == 200) {
      final responseJson = json.decode(response.body);
      return ClaimResp.fromJson(responseJson);
    }
  }

  //view inventory list
  static Future<dynamic> viewInventoryList(params) async {
    final response = await http.post(Uri.parse(VIEW_INVENTORY_LIST),
    body: params);
    if (response.statusCode == 200) {
      final responseJson = json.decode(response.body);

      return InventResp.fromJson(responseJson);
    }
  }

  //faqList
  static Future<dynamic> getFAQLIst() async {
    final response = await http.get(Uri.parse(Api.FAQ));
    if (response.statusCode == 200) {
      final responseJson = json.decode(response.body);

      return FAQResp.fromJson(responseJson);
    }
  }

  static Future<PostalCode> fetchPincode(http.Client client, String value) async {
    print('Passing Area: $value');
    // var finalUrl = 'https://api.postalpincode.in/postoffice/$value';
    //USA has Zipcode
    // var finalUrl = Uri.parse('https://api.worldpostallocations.com/pincode?postalcode=$value&countrycode=US');
    var finalUrl = Uri.parse('https://api.worldpostallocations.com/pincode?postalcode=$value&countrycode=IN');
    print('Passing Area: $value and $finalUrl');
    final response = await client.get(finalUrl);
    final parsed = json.decode(response.body);
    // var result=parsed['result'];
    PostalCode postalModel = PostalCode.fromJson(parsed);
    return postalModel;
  }


}