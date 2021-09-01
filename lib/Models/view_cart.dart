class ViewCartResp {
  dynamic status;
  dynamic cart;
  dynamic msg;

  ViewCartResp({this.status, this.cart, this.msg});


  factory ViewCartResp.fromJson(Map<dynamic, dynamic> json) {
    try {
      return ViewCartResp(
        msg: json['msg'],
        cart: json['cart'],
        status: json['status'].toString(),
      );
    } catch (error) {
      return ViewCartResp(
        msg: false,
        cart: null,
        status: '',
      );
    }
  }
}

class Cart {
  int id;
  String userId;
  int producerId;
  int productId;
  String ratePerHour;
  int qty;
  String productName;
  String productDesc;
  String productImg;

  Cart(
      {this.id,
        this.userId,
        this.producerId,
        this.productId,
        this.ratePerHour,
        this.qty,
        this.productName,
        this.productDesc,
      this.productImg});

  Cart.fromJson(Map<String, dynamic> json) {
    id = json['cart_id'];
    userId = json['user_id'];
    producerId = json['producer_id'];
    productId = json['product_id'];
    ratePerHour = json['rate_per_hour'];
    qty = json['qty'];
    productName = json['product_name'];
    productDesc = json['product_desc'];
    productImg=json['img_paths'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['cart_id'] = this.id;
    data['user_id'] = this.userId;
    data['producer_id'] = this.producerId;
    data['product_id'] = this.productId;
    data['rate_per_hour'] = this.ratePerHour;
    data['qty'] = this.qty;
    data['product_name'] = this.productName;
    data['product_desc'] = this.productDesc;
    data['img_paths']=this.productImg;
    return data;
  }
}
