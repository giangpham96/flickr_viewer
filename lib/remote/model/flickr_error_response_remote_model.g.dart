// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'flickr_error_response_remote_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FlickrErrorResponseRemoteModel _$FlickrErrorResponseRemoteModelFromJson(
    Map<String, dynamic> json) {
  $checkKeys(json,
      requiredKeys: const ['code'], disallowNullValues: const ['code']);
  return FlickrErrorResponseRemoteModel(
    code: json['code'] as int,
    message: json['message'] as String,
    stat: json['stat'] as String,
  );
}

Map<String, dynamic> _$FlickrErrorResponseRemoteModelToJson(
    FlickrErrorResponseRemoteModel instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('code', instance.code);
  val['message'] = instance.message;
  val['stat'] = instance.stat;
  return val;
}
