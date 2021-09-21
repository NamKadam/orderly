class FleetOrderModel {
  int id;
  int orderid;
  String orderName;
  String productDesc;
  String noOfItems;
  String date;
  String orderNumber;
  String orderStatus;
  String orderImage;
  bool isSelected;



  FleetOrderModel({this.id,
    this.orderid,
    this.orderName,
    this.noOfItems,
    this.date,
    this.orderNumber,
    this.orderStatus,
    this.orderImage,
    this.isSelected
    });


}
