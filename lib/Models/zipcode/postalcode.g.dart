// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'postalcode.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************



PostalCode _$PostalCodeFromJson(Map<String, dynamic> json) {
  return PostalCode(
    status: json['status'] as bool,
    result: (json['result'])
        ?.map((e) =>
    e == null ? null : Result.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$PostalCodeToJson(PostalCode instance) =>
    <String, dynamic>{
      'status': instance.status,
      'result': instance.result,
    };

Result _$PostResultFromJson(Map<String, dynamic> json) {
  return Result(
    id: json['id'] as String,
    country: json['country'] as String,
    postalCode: json['postalCode'] as String,
    postalLocation: json['postalLocation'] as String,
    state: json['state'] as String,
    stateId: json['stateId'] as String,
    district: json['district'] as String,
    districtId: json['districtId'] as String,
    province: json['province'] as String,
    provinceId: json['provinceId'] as String,
    latitude: json['latitude'] as String,
    longitude: json['longitude'] as String,
  );
}

Map<String, dynamic> _$PostResultToJson(Result instance) =>
    <String, dynamic>{
      'id': instance.id,
      'country': instance.country,
      'postalCode': instance.postalCode,
      'postalLocation': instance.postalLocation,
      'state': instance.state,
      'stateId': instance.stateId,
      'district': instance.district,
      'districtId': instance.districtId,
      'province': instance.province,
      'provinceId': instance.provinceId,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
    };
