class MyOrdersResp {
  dynamic status;
  dynamic orders;
  dynamic msg;

  MyOrdersResp({this.status, this.orders, this.msg});

  factory MyOrdersResp.fromJson(Map<dynamic, dynamic> json) {
    try {
      return MyOrdersResp(
        msg: json['msg'],
        orders: json['orders'],
        status: json['status'].toString(),
      );
    } catch (error) {
      return MyOrdersResp(
        msg: false,
        orders: null,
        status: '',
      );
    }
  }

}

class Orders {
  int orderDetailsId;
  int orderId;
  String orderNumber;
  int producerId;
  int productId;
  int qty;
  String productName;
  String productDesc;
  String imgPaths;
  int currentStatus;
  String orderDate;
  String producerName;

  Orders(
      {this.orderDetailsId,
        this.orderId,
        this.orderNumber,
        this.producerId,
        this.productId,
        this.qty,
        this.productName,
        this.productDesc,
        this.imgPaths,
        this.currentStatus,
        this.orderDate,
        this.producerName});

  Orders.fromJson(Map<String, dynamic> json) {
    orderDetailsId = json['order_details_id'];
    orderId = json['order_id'];
    orderNumber = json['order_number'];
    producerId = json['producer_id'];
    productId = json['product_id'];
    qty = json['qty'];
    productName = json['product_name'];
    productDesc = json['product_desc'];
    imgPaths = json['img_paths'];
    currentStatus = json['current_status'];
    orderDate = json['order_date'];
    producerName = json['producer_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['order_details_id'] = this.orderDetailsId;
    data['order_id'] = this.orderId;
    data['order_number'] = this.orderNumber;
    data['producer_id'] = this.producerId;
    data['product_id'] = this.productId;
    data['qty'] = this.qty;
    data['product_name'] = this.productName;
    data['product_desc'] = this.productDesc;
    data['img_paths'] = this.imgPaths;
    data['current_status'] = this.currentStatus;
    data['order_date'] = this.orderDate;
    data['producer_name'] = this.producerName;
    return data;
  }
}
