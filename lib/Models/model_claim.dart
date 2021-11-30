class ClaimResp {
  int status;
  ClaimDetails claimDetails;
  String msg;

  ClaimResp({this.status, this.claimDetails, this.msg});

  ClaimResp.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    claimDetails = json['claim_details'] != null
        ? new ClaimDetails.fromJson(json['claim_details'])
        : null;
    msg = json['msg'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.claimDetails != null) {
      data['claim_details'] = this.claimDetails.toJson();
    }
    data['msg'] = this.msg;
    return data;
  }
}

class ClaimDetails {
  String receivedAmount;
  int refundedAmount;
  List<ClaimData> claimData;

  ClaimDetails({this.receivedAmount, this.refundedAmount, this.claimData});

  ClaimDetails.fromJson(Map<String, dynamic> json) {
    receivedAmount = json['received_amount'];
    refundedAmount = json['refunded_amount'];
    if (json['claim_data'] != null) {
      claimData = [];
      json['claim_data'].forEach((v) {
        claimData.add(new ClaimData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['received_amount'] = this.receivedAmount;
    data['refunded_amount'] = this.refundedAmount;
    if (this.claimData != null) {
      data['claim_data'] = this.claimData.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ClaimData {
  String orderDetailsId;
  String orderId;
  String orderNumber;
  String qty;
  String total;
  String imgPaths;
  String orderDate;
  String currentStatus;

  ClaimData(
      {this.orderDetailsId,
        this.orderId,
        this.orderNumber,
        this.qty,
        this.total,
        this.imgPaths,
        this.orderDate,
        this.currentStatus});

  ClaimData.fromJson(Map<String, dynamic> json) {
    orderDetailsId = json['order_details_id'];
    orderId = json['order_id'];
    orderNumber = json['order_number'];
    qty = json['qty'];
    total = json['total'];
    imgPaths = json['img_paths'];
    orderDate = json['order_date'];
    currentStatus = json['current_status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['order_details_id'] = this.orderDetailsId;
    data['order_id'] = this.orderId;
    data['order_number'] = this.orderNumber;
    data['qty'] = this.qty;
    data['total'] = this.total;
    data['img_paths'] = this.imgPaths;
    data['order_date'] = this.orderDate;
    data['current_status'] = this.currentStatus;
    return data;
  }
}
