import 'dart:async';
import 'package:orderly/Models/ResultApiModel.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:orderly/Models/zipcode/postalcode.dart';


class Api {

  static const String HOST_URL="https://rajputudyog.in/backend/api/";//updated on 23/12/2020
  static const String CUST_REG="https://rajputudyog.in/backend/api/";//updated on 23/12/2020
  static const String CUST_LOGIN="https://rajputudyog.in/backend/api/";//updated on 23/12/2020

  ///Login api
  static Future<dynamic> login(params) async {
    final response = await http.post(
      Uri.parse(HOST_URL),
      body: params,
    );
    if (response.statusCode == 200) {
      final responseJson = json.decode(response.body);
      return ResultApiModel.fromJson(responseJson);
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