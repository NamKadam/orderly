class InvoiceResp {
  int status;
  InvoiceDetails invoiceDetails;
  String msg;

  InvoiceResp({this.status, this.invoiceDetails, this.msg});

  InvoiceResp.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    invoiceDetails = json['invoice_details'] != null
        ? new InvoiceDetails.fromJson(json['invoice_details'])
        : null;
    msg = json['msg'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.invoiceDetails != null) {
      data['invoice_details'] = this.invoiceDetails.toJson();
    }
    data['msg'] = this.msg;
    return data;
  }
}

class InvoiceDetails {
  String invoiceNumber;
  String orderDate;
  String totalAmount;
  List<InvoiceData> invoiceData;

  InvoiceDetails(
      {this.invoiceNumber, this.orderDate, this.totalAmount, this.invoiceData});

  InvoiceDetails.fromJson(Map<String, dynamic> json) {
    invoiceNumber = json['invoice_number'];
    orderDate = json['order_date'];
    totalAmount = json['total_amount'];
    if (json['claim_data'] != null) {
      invoiceData = [];
      json['claim_data'].forEach((v) {
        invoiceData.add(new InvoiceData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['invoice_number'] = this.invoiceNumber;
    data['order_date'] = this.orderDate;
    data['total_amount'] = this.totalAmount;
    if (this.invoiceData != null) {
      data['claim_data'] = this.invoiceData.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class InvoiceData {
  String orderDetailsId;
  String orderId;
  String orderNumber;
  String productName;
  String qty;
  String ratePerHour;
  String total;
  String imgPaths;
  String orderDate;
  String currentStatus;

  InvoiceData(
      {this.orderDetailsId,
        this.orderId,
        this.orderNumber,
        this.productName,
        this.qty,
        this.ratePerHour,
        this.total,
        this.imgPaths,
        this.orderDate,
        this.currentStatus});

  InvoiceData.fromJson(Map<String, dynamic> json) {
    orderDetailsId = json['order_details_id'];
    orderId = json['order_id'];
    orderNumber = json['order_number'];
    productName = json['product_name'];
    qty = json['qty'];
    ratePerHour = json['rate_per_hour'];
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
    data['product_name'] = this.productName;
    data['qty'] = this.qty;
    data['rate_per_hour'] = this.ratePerHour;
    data['total'] = this.total;
    data['img_paths'] = this.imgPaths;
    data['order_date'] = this.orderDate;
    data['current_status'] = this.currentStatus;
    return data;
  }
}
