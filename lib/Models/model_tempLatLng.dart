class FleetTempResp {
  dynamic status;
 dynamic ordertemp;
  dynamic msg;

  FleetTempResp({this.status, this.ordertemp, this.msg});

  factory FleetTempResp.fromJson(Map<dynamic, dynamic> json) {
    try {
      return FleetTempResp(
        msg: json['msg'],
        ordertemp: json['ordertemp'],
        status: json['status'].toString(),
      );
    } catch (error) {
      return FleetTempResp(
        msg: false,
        ordertemp: null,
        status: '',
      );
    }
  }
}

class Ordertemp {
  String latitude;
  String longitude;
  String temperature;

  Ordertemp({this.latitude, this.longitude, this.temperature});

  Ordertemp.fromJson(Map<String, dynamic> json) {
    latitude = json['latitude'];
    longitude = json['longitude'];
    temperature = json['temperature'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['temperature'] = this.temperature;
    return data;
  }
}
