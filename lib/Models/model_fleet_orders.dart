class FleetOrderResp{
  dynamic status;
  dynamic fleetorders;
  dynamic msg;

  FleetOrderResp({this.status, this.fleetorders, this.msg});

  factory FleetOrderResp.fromJson(Map<dynamic, dynamic> json) {
    try {
      return FleetOrderResp(
        msg: json['msg'],
        fleetorders: json['orders'],
        status: json['status'].toString(),
      );
    } catch (error) {
      return FleetOrderResp(
        msg: false,
        fleetorders: null,
        status: '',
      );
    }
  }
}

class FleetOrderModel {
  int id;
  int orderid;
  String orderName;
  String productDesc;
  int noOfItems;
  String date;
  String orderNumber;
  int producerId;
  String orderImage;
  bool isSelected;



  FleetOrderModel({this.id,
    this.orderid,
    this.orderName,
    this.noOfItems,
    this.date,
    this.orderNumber,
    this.producerId,
    this.orderImage,
    this.isSelected
    });

  FleetOrderModel.fromJson(Map<String, dynamic> json) {
    id = json['order_details_id'];
    orderid = json['order_id'];
    orderNumber = json['order_number'];
    noOfItems = json['cnt'];
    producerId = json['producer_id'];
    date = json['date'];
    orderImage = json['producer_image_url'];
    isSelected = json['isSelected'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['order_details_id'] = this.id;
    data['order_id'] = this.orderid;
    data['order_number'] = this.orderNumber;
    data['cnt'] = this.noOfItems;
    data['producer_id'] = this.producerId;
    data['date'] = this.date;
    data['producer_image_url'] = this.orderImage;
    data['isSelected'] = this.isSelected;

    return data;
  }
}
