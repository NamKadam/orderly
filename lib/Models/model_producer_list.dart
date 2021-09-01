class ProducerListResp {
  dynamic status;
  dynamic producer;
  dynamic msg;

  ProducerListResp({this.status, this.producer, this.msg});

  factory ProducerListResp.fromJson(Map<dynamic, dynamic> json) {
    try {
      return ProducerListResp(
        msg: json['msg'],
        producer: json['producer'],
        status: json['status'].toString(),
      );
    } catch (error) {
      return ProducerListResp(
        msg: false,
        producer: null,
        status: '',
      );
    }
  }

//
  // ProducerListResp.fromJson(Map<String, dynamic> json) {
  //   status = json['status'];
  //   if (json['producer'] != null) {
  //     producer = [];
  //     json['producer'].forEach((v) {
  //       producer.add(new Producer.fromJson(v));
  //     });
  //   }
  //   msg = json['msg'];
  // }
  //
  // Map<String, dynamic> toJson() {
  //   final Map<String, dynamic> data = new Map<String, dynamic>();
  //   data['status'] = this.status;
  //   if (this.producer != null) {
  //     data['producer'] = this.producer.map((v) => v.toJson()).toList();
  //   }
  //   data['msg'] = this.msg;
  //   return data;
  // }
}

class Producer {
  int producerId;
  String producerName;
  String producerImageUrl;
  String producerIconUrl;

  Producer({this.producerId, this.producerName, this.producerImageUrl,this.producerIconUrl});

  Producer.fromJson(Map<String, dynamic> json) {
    producerId = json['producer_id'];
    producerName = json['producer_name'];
    producerImageUrl = json['producer_image_url'];
    producerIconUrl = json['producer_icon_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['producer_id'] = this.producerId;
    data['producer_name'] = this.producerName;
    data['producer_image_url'] = this.producerImageUrl;
    data['producer_icon_url'] = this.producerIconUrl;
    return data;
  }
}
