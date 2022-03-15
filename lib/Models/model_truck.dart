class TruckResp {
  dynamic status;
  dynamic truckList;
  dynamic msg;

  TruckResp({this.status, this.truckList, this.msg});

  factory TruckResp.fromJson(Map<dynamic, dynamic> json) {
    try {
      return TruckResp(
        msg: json['msg'],
        truckList: json['truck_list'],
        status: json['status'].toString(),
      );
    } catch (error) {
      return TruckResp(
        msg: false,
        truckList: null,
        status: '',
      );
    }
  }
}

class TruckList {
  int truckId;
  String truckName;
  int deviceId;

  TruckList({this.truckId, this.truckName, this.deviceId});

  TruckList.fromJson(Map<String, dynamic> json) {
    truckId = json['truck_id'];
    truckName = json['truck_name'];
    deviceId = json['device_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['truck_id'] = this.truckId;
    data['truck_name'] = this.truckName;
    data['device_id'] = this.deviceId;
    return data;
  }
}
