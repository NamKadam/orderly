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
  String sourceLatitude;
  String sourceLongitude;
  String destinationLatitude;
  String destinationLongitude;
  List<CurrentLocation> currentLocation;

  Ordertemp(
      {this.sourceLatitude,
        this.sourceLongitude,
        this.destinationLatitude,
        this.destinationLongitude,
        this.currentLocation});

  Ordertemp.fromJson(Map<String, dynamic> json) {
    sourceLatitude = json['source_latitude'];
    sourceLongitude = json['source_longitude'];
    destinationLatitude = json['destination_latitude'];
    destinationLongitude = json['destination_longitude'];
    if (json['current_location'] != null) {
      currentLocation = <CurrentLocation>[];
      json['current_location'].forEach((v) {
        currentLocation.add(new CurrentLocation.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['source_latitude'] = this.sourceLatitude;
    data['source_longitude'] = this.sourceLongitude;
    data['destination_latitude'] = this.destinationLatitude;
    data['destination_longitude'] = this.destinationLongitude;
    if (this.currentLocation != null) {
      data['current_location'] =
          this.currentLocation.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CurrentLocation {
  String latitude;
  String longitude;
  String temperature;

  CurrentLocation({this.latitude, this.longitude, this.temperature});

  CurrentLocation.fromJson(Map<String, dynamic> json) {
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

