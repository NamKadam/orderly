import 'package:orderly/Models/model_view_cart.dart';
import 'package:scoped_model/scoped_model.dart';

class CartModel extends Model {
  // List<Products> cart = [];
  List<Cart> cart = [];
  double totalCartValue = 0;

  int get total => cart.length;

  void addProduct(product) {
    int index = cart.indexWhere((i) => i.id == product.id);
    print(index);
    if (index != -1)
      updateProduct(product, product.qty + 1);
    else {
      cart.add(product);
      calculateTotal();
      notifyListeners();
    }
  }

  void addAllProduct(cartList){
    cart.addAll(cartList);
    calculateTotal();

    notifyListeners();

  }

  void removeProduct(product) {
    int index = cart.indexWhere((i) => i.id == product.id);
    cart[index].qty = 1;
    cart.removeWhere((item) => item.id == product.id);
    calculateTotal();
    notifyListeners();
  }

  void updateProduct(product, qty) {
    int index = cart.indexWhere((i) => i.id == product.id);
    cart[index].qty = qty;
    if (cart[index].qty == 0)
      removeProduct(product);
    calculateTotal();
    notifyListeners();
  }

  void clearCart() {
    cart.forEach((f) => f.qty = 1);
    cart = [];
    notifyListeners();
  }

  void calculateTotal() {
    totalCartValue = 0;
    cart.forEach((f) {
      totalCartValue += f.ratePerHour * f.qty;
    });
    print(""+totalCartValue.toString());
  }
}

// class Products {
//   int id;
//   String title;
//   String imgUrl;
//   double price;
//   int qty;
//
//   Products({this.id, this.title, this.price, this.qty, this.imgUrl});
// }

class Products {
  int id;
  String productName;
  String productDesc;
  String ratePerHour;
  String truckName;
  String truckNumber;
  int displayStatus;
  String productImage;
  int qty;


  Products({
    this.id,
    this.productName,
    this.productDesc,
    this.ratePerHour,
    this.truckName,
    this.truckNumber,
    this.displayStatus,
    this.productImage,
    this.qty});


  Products.fromJson(Map<String, dynamic> json) {
    id = json['product_id'];
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
    data['product_id'] = this.id;
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
