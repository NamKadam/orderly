import 'package:json_annotation/json_annotation.dart';
part 'postalcode.g.dart';


@JsonSerializable()
class PostalCode {

  @JsonKey(name:"status")
  bool status;
  @JsonKey(name:"result")
  // List<Result> result;
  dynamic result = <Result>[];


  PostalCode({ this.status, this.result});

  factory PostalCode.fromJson(Map<String, dynamic> json) =>
      _$PostalCodeFromJson(json);

  Map<String, dynamic> toJson() => _$PostalCodeToJson(this);


}

@JsonSerializable()
class Result {

  @JsonKey(name:"id")
  String id;
  @JsonKey(name:"country")
   String country;
  @JsonKey(name:"postalCode")
 String postalCode;
  @JsonKey(name:"postalLocation")
 String postalLocation;
  @JsonKey(name:"state")
String state;
  @JsonKey(name:"stateId")
 String stateId;
  @JsonKey(name:"district")
 String district;
  @JsonKey(name:"districtId")
String districtId;
  @JsonKey(name:"province")
String province;
  @JsonKey(name:"provinceId")
String provinceId;
  @JsonKey(name:"latitude")
String latitude;
  @JsonKey(name:"longitude")
 String longitude;

  Result(
      {this.id,
        this.country,
        this.postalCode,
        this.postalLocation,
        this.state,
        this.stateId,
        this.district,
        this.districtId,
        this.province,
        this.provinceId,
        this.latitude,
         this.longitude});

  factory Result.fromJson(Map<String, dynamic> json) =>
      _$PostResultFromJson(json);

  Map<String, dynamic> toJson() => _$PostResultToJson(this);

}