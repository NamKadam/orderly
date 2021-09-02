import 'package:orderly/Api/api.dart';
import 'package:orderly/Models/ResultApiModel.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// class ProductListScopedModel extends Model {
//   List<Product> product ;
//   double totalCartValue = 0;
//   int get total => product.length;
//
//   void addProduct(product) {
//     int index = product.indexWhere((i) => i.productId == product.id);
//     print(index);
//     if (index != -1)
//       updateProduct(product, product.qty + 1);
//     else {
//       product.add(product);
//       // calculateTotal();
//       notifyListeners();
//     }
//   }
//
//   void fetchPhotos(String producerId,String type,String offset) async {
//     final response = await http.post(
//       Uri.parse(Api.GET_PROD_LIST),
//       body: ({"producer_id":producerId,"type":type,"offset":offset}),
//     );
//     print('RESPONSE - ${response.body.length}');
//     if (response.statusCode == 200) {
//       final responseJson = json.decode(response.body);
//       // var prod=responseJson['product'];
//       List productList=responseJson['product'];
//       var msg=responseJson['msg'];
//       try {
//         if (msg == "Success") {
//           // final Iterable refactorCategory = prod ?? [];
//           // final listCategory = refactorCategory.map((item) {
//           //   return Product.fromJson(item);
//           // }).toList();
//           // print(listCategory);
//           for (int index = 0; index < productList.length; index++) {
//             product.add(Product.fromJsonMap(productList[index]));
//           }
//
//           ///Sync UI
//         } else {
//
//         }
//       }catch(e)
//       {
//         print(e);
//       }
//     }
//     // List pList = json.decode(response.body);
//     // int listLength = photoList.length;
//     // print('CURRENT LENGTH - $listLength');
//     // for (int index = listLength; index < (listLength + 5); index++) {
//     //   photoList.add(Photo.fromJsonMap(pList[index]));
//     // }
//     notifyListeners();
//   }
//
//
//   void removeProduct(product) {
//     int index = product.indexWhere((i) => i.productId == product.id);
//     product[index].qty = 1;
//     product.removeWhere((item) => item.id == product.id);
//     // calculateTotal();
//     notifyListeners();
//   }
//
//   void updateProduct(product, qty) {
//     int index = product.indexWhere((i) => i.productId == product.id);
//     product[index].qty = qty;
//     if (product[index].qty == 0)
//       removeProduct(product);
//
//     // calculateTotal();
//     notifyListeners();
//   }
//
//   void clearCart() {
//     product.forEach((f) => f.qty = 1);
//     product = [];
//     notifyListeners();
//   }
//
//   void calculateTotal() {
//     totalCartValue = 0;
//     product.forEach((f) {
//       totalCartValue += int.parse(f.ratePerHour) * f.qty;
//     });
//     print(""+totalCartValue.toString());
//   }
// }
class ProductListResp {
  dynamic status;
  List<dynamic> product;
  dynamic msg;

  ProductListResp({this.status, this.product, this.msg});

  factory ProductListResp.fromJson(Map<dynamic, dynamic> json) {
    try {
      return ProductListResp(
        msg: json['msg'],
        product: json['product'],
        status: json['status'].toString(),
      );
    } catch (error) {
      return ProductListResp(
        msg: false,
        product: null,
        status: '',
      );
    }
  }
}

class Product {
  int productId;
  int producerid;
  String productName;
  String productDesc;
  String ratePerHour;
  String truckName;
  String truckNumber;
  int displayStatus;
  String productImage;
  int qty;


  Product({this.productId,
    this.producerid,
    this.productName,
    this.productDesc,
    this.ratePerHour,
    this.truckName,
    this.truckNumber,
    this.displayStatus,
    this.productImage,
    this.qty});

  Product.fromJson(Map<String, dynamic> json) {
    productId = json['product_id'];
    producerid = json['producerid'];
    productName = json['product_name'];
    productDesc = json['product_desc'];
    ratePerHour = json['rate_per_hour'];
    truckName = json['truck_name'];
    truckNumber = json['truck_number'];
    displayStatus = json['display_status'];
    productImage = json['product_image'];
    qty = json['product_qty'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['product_id'] = this.productId;
    data['producerid'] = this.producerid;
    data['product_name'] = this.productName;
    data['product_desc'] = this.productDesc;
    data['rate_per_hour'] = this.ratePerHour;
    data['truck_name'] = this.truckName;
    data['truck_number'] = this.truckNumber;
    data['display_status'] = this.displayStatus;
    data['product_image'] = this.productImage;
    data['product_qty'] = this.qty;
    return data;
  }
}

//   Product.fromJsonMap(Map map)
//       : productId = map['product_id'],
//         producerid = map['producerid'],
//         productName = map['product_name'],
//         productDesc = map['product_desc'],
//         ratePerHour = map['rate_per_hour'],
//         truckName = map['truck_name'],
//         truckNumber = map['truck_number'],
//         displayStatus = map['display_status'],
//         productImage = map['product_image'],
//         qty = map['product_qty'];
//
// }

// class PList {
//   List<Product> productList;
//
//   PList({
//     this.productList,
//   });
//
//   PList.fromJson(List<dynamic> parsedJson) {
//     List<Product> photos = new List<Product>();
//     print(parsedJson.length);
//     parsedJson.forEach((pic){
//       photos.add(Product.fromJsonMap(pic));
//     });
//   }
// }