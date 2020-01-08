import 'package:json_annotation/json_annotation.dart';

part 'flickr_error_response_remote_model.g.dart';

@JsonSerializable()
class FlickrErrorResponseRemoteModel implements Exception {
  @JsonKey(disallowNullValue: true, required: true)
  final int code;
  final String message;
  final String stat;

  FlickrErrorResponseRemoteModel({this.code, this.message, this.stat});

  factory FlickrErrorResponseRemoteModel.fromJson(Map<String, dynamic> json) =>
      _$FlickrErrorResponseRemoteModelFromJson(json);

  Map<String, dynamic> toJson() => _$FlickrErrorResponseRemoteModelToJson(this);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FlickrErrorResponseRemoteModel &&
          runtimeType == other.runtimeType &&
          code == other.code &&
          message == other.message &&
          stat == other.stat;

  @override
  int get hashCode => code.hashCode ^ message.hashCode ^ stat.hashCode;
}
