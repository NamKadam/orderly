class FleetOrderDetResp {
  dynamic status;
  dynamic ordersDet;
  dynamic msg;

  FleetOrderDetResp({this.status, this.ordersDet, this.msg});

  factory FleetOrderDetResp.fromJson(Map<dynamic, dynamic> json) {
    try {
      return FleetOrderDetResp(
        msg: json['msg'],
        ordersDet: json['orders'],
        status: json['status'].toString(),
      );
    } catch (error) {
      return FleetOrderDetResp(
        msg: false,
        ordersDet: null,
        status: '',
      );

  }
}
}

class FleetOrdersDet {
  int orderDetailsId;
  int orderId;
  String orderNumber;
  int producerId;
  int productId;
  int qty;
  String productName;
  int ratePerHour;
  String productDesc;
  String imgPaths;
  int currentStatus;
  String orderDate;
  String producerName;
  bool isChecked=false;

  //for return replace list part
  int returnId;
  int returnType;
  String returnTitle;
  String review;
  String userId;



  FleetOrdersDet(
      {this.orderDetailsId,
        this.orderId,
        this.orderNumber,
        this.producerId,
        this.productId,
        this.qty,
        this.productName,
        this.ratePerHour,
        this.productDesc,
        this.imgPaths,
        this.currentStatus,
        this.orderDate,
        this.producerName,
      this.isChecked,
      //for return replace part
     this.returnId,
      this.returnType,
      this.returnTitle,
      this.review,
      this.userId});

  FleetOrdersDet.fromJson(Map<String, dynamic> json) {
    orderDetailsId = json['order_details_id'];
    orderId = json['order_id'];
    orderNumber = json['order_number'];
    producerId = json['producer_id'];
    productId = json['product_id'];
    qty = json['qty'];
    productName = json['product_name'];
    ratePerHour = json['rate_per_hour'];
    productDesc = json['product_desc'];
    imgPaths = json['img_paths'];
    currentStatus = json['current_status'];
    orderDate = json['order_date'];
    producerName = json['producer_name'];
    //for return and replace part
    returnId = json['return_id'];
    returnType = json['return_type'];
    returnTitle = json['return_title'];
    review = json['review'];
    userId = json['user_id'];
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
    data['rate_per_hour'] = this.ratePerHour;
    data['product_desc'] = this.productDesc;
    data['img_paths'] = this.imgPaths;
    data['current_status'] = this.currentStatus;
    data['order_date'] = this.orderDate;
    data['producer_name'] = this.producerName;
    //for return and replace part
    data['return_id'] = this.returnId;
    data['return_type'] = this.returnType;
    data['return_title'] = this.returnTitle;
    data['review'] = this.review;
    data['user_id'] = this.userId;

    return data;
  }
}
