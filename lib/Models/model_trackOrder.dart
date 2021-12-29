class TrackOrderResp {
  int status;
  TrackOrder trackOrder;
  String msg;

  TrackOrderResp({this.status, this.trackOrder, this.msg});

  TrackOrderResp.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    trackOrder = json['track_order'] != null
        ? new TrackOrder.fromJson(json['track_order'])
        : null;
    msg = json['msg'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.trackOrder != null) {
      data['track_order'] = this.trackOrder.toJson();
    }
    data['msg'] = this.msg;
    return data;
  }
}

class TrackOrder {
  String retRplc;
  List<TrackData> trackData;

  TrackOrder({this.retRplc, this.trackData});

  TrackOrder.fromJson(Map<String, dynamic> json) {
    retRplc = json['ret_rplc'];
    if (json['track_data'] != null) {
      trackData = new List<TrackData>();
      json['track_data'].forEach((v) {
        trackData.add(new TrackData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ret_rplc'] = this.retRplc;
    if (this.trackData != null) {
      data['track_data'] = this.trackData.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class TrackData {
  String orderNum;
  String ohStatus;
  String orderDate;

  TrackData({this.orderNum, this.ohStatus, this.orderDate});

  TrackData.fromJson(Map<String, dynamic> json) {
    orderNum = json['order_num'];
    ohStatus = json['oh_status'];
    orderDate = json['order_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['order_num'] = this.orderNum;
    data['oh_status'] = this.ohStatus;
    data['order_date'] = this.orderDate;
    return data;
  }
}



// class TrackOrderResp {
//   int status;
//   List<TrackOrders> orders;
//   String msg;
//
//   TrackOrderResp({this.status, this.orders, this.msg});
//
//   TrackOrderResp.fromJson(Map<String, dynamic> json) {
//     status = json['status'];
//     if (json['orders'] != null) {
//       orders = [];
//       json['orders'].forEach((v) {
//         orders.add(new TrackOrders.fromJson(v));
//       });
//     }
//     msg = json['msg'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['status'] = this.status;
//     if (this.orders != null) {
//       data['orders'] = this.orders.map((v) => v.toJson()).toList();
//     }
//     data['msg'] = this.msg;
//     return data;
//   }
// }
//
// class TrackOrders {
//   String orderNum;
//   int ohStatus;
//   String orderDate;
//
//   TrackOrders({this.orderNum, this.ohStatus, this.orderDate});
//
//   TrackOrders.fromJson(Map<String, dynamic> json) {
//     orderNum = json['order_num'];
//     ohStatus = json['oh_status'];
//     orderDate = json['order_date'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['order_num'] = this.orderNum;
//     data['oh_status'] = this.ohStatus;
//     data['order_date'] = this.orderDate;
//     return data;
//   }
// }
