import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:orderly/Api/api.dart';
import 'package:orderly/Models/model_truck.dart';
import 'package:orderly/Utils/application.dart';

Future<List<TruckList>> fetchTruck() async{

  Map<String,String> params={
    'producerid':Application.user.producerid
  };

  var response = await http.post(
    Uri.parse(Api.FETCH_TRUCK),
    body: params
  );

  try{
    final resp = json.decode(response.body);
    List<TruckList> listOftruck=[];
    if( response.statusCode==200) {
      listOftruck = resp['truck_list'].map<TruckList>((item) {
        return TruckList.fromJson(item);
      }).toList();

    }
    return listOftruck;
  }catch(e){
    print(e);
  }
}