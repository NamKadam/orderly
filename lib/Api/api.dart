import 'dart:async';
import 'package:orderly/Models/ResultApiModel.dart';
import 'package:http/http.dart' as http;
import 'package:orderly/Models/model_address.dart';
import 'package:orderly/Models/model_producer_list.dart';
import 'package:orderly/Models/model_product_List.dart';
import 'package:orderly/Models/model_view_cart.dart';
import 'dart:convert';
import 'package:orderly/Models/zipcode/postalcode.dart';


class Api {

  static const String HOST_URL="http://93.188.162.210:3000/";//updated on 23/12/2020
  static const String CUST_REG="register";//updated on 23/12/2020
  static const String CUST_LOGIN=HOST_URL+"login";
  static const String GET_PRODUCER_LIST=HOST_URL+"producer";
  static const String GET_PROD_LIST=HOST_URL+"product_list";
  static const String ADD_TO_CART=HOST_URL+"add_to_cart";
  static const String GET_CART_LIST=HOST_URL+"view_cart";
  static const String DEL_CART_LIST=HOST_URL+"delete_cart";
  static const String GET_CHARGES=HOST_URL+"urgent_charges";
  static const String GET_ADDRESS_LIST=HOST_URL+"view_address";
  static const String ADD_ADDRESS=HOST_URL+"add_address";
  static const String EDIT_ADDRESS=HOST_URL+"update_address";

  ///Login api
  static Future<dynamic> login(params) async {
    final response = await http.post(
      Uri.parse(CUST_LOGIN),
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
  static Future<dynamic> getProducerList() async {
    final response = await http.get(Uri.parse(GET_PRODUCER_LIST));
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

  //get cart list
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

  static Future<PostalCode> fetchPincode(http.Client client, String value) async {
    print('Passing Area: $value');
    // var finalUrl = 'https://api.postalpincode.in/postoffice/$value';
    //USA has Zipcode
    var finalUrl = Uri.parse('https://api.worldpostallocations.com/pincode?postalcode=$value&countrycode=US');
    print('Passing Area: $value and $finalUrl');
    final response = await client.get(finalUrl);
    final parsed = json.decode(response.body);
    // var result=parsed['result'];
    PostalCode postalModel = PostalCode.fromJson(parsed);
    return postalModel;
  }


}