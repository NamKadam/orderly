class InventResp {
  dynamic status;
  dynamic inventory;
  dynamic msg;

  InventResp({this.status, this.inventory, this.msg});

  factory InventResp.fromJson(Map<dynamic, dynamic> json) {
    try {
      return InventResp(
        msg: json['msg'],
        inventory: json['inventory'],
        status: json['status'].toString(),
      );
    } catch (error) {
      return InventResp(
        msg: false,
        inventory: null,
        status: '',
      );

    }
  }
}

class Inventory {
  int productId;
  String producerName;
  String productName;
  String productDesc;
  String ratePerHour;
  String truckName;
  String truckNumber;
  int displayStatus;
  int productQty;
  String imgPaths;

  Inventory(
      {this.productId,
        this.producerName,
        this.productName,
        this.productDesc,
        this.ratePerHour,
        this.truckName,
        this.truckNumber,
        this.displayStatus,
        this.productQty,
        this.imgPaths});

  Inventory.fromJson(Map<String, dynamic> json) {
    productId = json['product_id'];
    producerName = json['producer_name'];
    productName = json['product_name'];
    productDesc = json['product_desc'];
    ratePerHour = json['rate_per_hour'];
    truckName = json['truck_name'];
    truckNumber = json['truck_number'];
    displayStatus = json['display_status'];
    productQty = json['product_qty'];
    imgPaths = json['img_paths'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['product_id'] = this.productId;
    data['producer_name'] = this.producerName;
    data['product_name'] = this.productName;
    data['product_desc'] = this.productDesc;
    data['rate_per_hour'] = this.ratePerHour;
    data['truck_name'] = this.truckName;
    data['truck_number'] = this.truckNumber;
    data['display_status'] = this.displayStatus;
    data['product_qty'] = this.productQty;
    data['img_paths'] = this.imgPaths;
    return data;
  }
}
