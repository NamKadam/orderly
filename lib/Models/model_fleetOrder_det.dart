class FleetOrderDetResp {
  dynamic status;
  dynamic ordersDet;
  dynamic userData;
  dynamic msg;

  FleetOrderDetResp({this.status, this.ordersDet, this.userData,this.msg});

  factory FleetOrderDetResp.fromJson(Map<dynamic, dynamic> json) {
    try {
      return FleetOrderDetResp(
        msg: json['msg'],
        ordersDet: json['orders'],
        userData: json['user_data'],
        status: json['status'].toString(),
      );
    } catch (error) {
      return FleetOrderDetResp(
        msg: false,
        ordersDet: null,
        userData:null,
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
  String rejectReason;



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
      this.userId,
      this.rejectReason});

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
    rejectReason=json['reject_reason'];
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
    data['reject_reason']=this.rejectReason;
    return data;
  }
}

//for user data
class UserData {
  String userName;
  String mobile;
  String emailId;
  String streetNo;
  String flatNo;
  String address;
  String zipcode;
  String city;
  String state;
  String country;

  UserData(
      {this.userName,
        this.mobile,
        this.emailId,
        this.streetNo,
        this.flatNo,
        this.address,
        this.zipcode,
        this.city,
        this.state,
        this.country});

  UserData.fromJson(Map<String, dynamic> json) {
    userName = json['user_name'];
    mobile = json['mobile'];
    emailId = json['email_id'];
    streetNo = json['street_no'];
    flatNo = json['flat_no'];
    address = json['address'];
    zipcode = json['zipcode'];
    city = json['city'];
    state = json['state'];
    country = json['country'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_name'] = this.userName;
    data['mobile'] = this.mobile;
    data['email_id'] = this.emailId;
    data['street_no'] = this.streetNo;
    data['flat_no'] = this.flatNo;
    data['address'] = this.address;
    data['zipcode'] = this.zipcode;
    data['city'] = this.city;
    data['state'] = this.state;
    data['country'] = this.country;
    return data;
  }
}
