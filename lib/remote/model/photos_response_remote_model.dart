import 'package:json_annotation/json_annotation.dart';

part 'photos_response_remote_model.g.dart';

@JsonSerializable()
class PhotosResponseRemoteModel {
    @JsonKey(disallowNullValue: true, required: true)
    final PhotosRemoteModel photos;
    @JsonKey(disallowNullValue: true, required: true)
    final String stat;

    PhotosResponseRemoteModel({this.photos, this.stat});

    factory PhotosResponseRemoteModel.fromJson(Map<String, dynamic> json) =>
        _$PhotosResponseRemoteModelFromJson(json);

    Map<String, dynamic> toJson() => _$PhotosResponseRemoteModelToJson(this);
}

@JsonSerializable()
class PhotosRemoteModel {
    @JsonKey(disallowNullValue: true, required: true)
    final int page;
    @JsonKey(disallowNullValue: true, required: true)
    final int pages;
    @JsonKey(disallowNullValue: true, required: true)
    final int perpage;
    @JsonKey(disallowNullValue: true, required: true)
    final List<PhotoRemoteModel> photo;
    @JsonKey(disallowNullValue: true, required: true)
    final String total;

    PhotosRemoteModel({this.page, this.pages, this.perpage, this.photo, this.total});

    factory PhotosRemoteModel.fromJson(Map<String, dynamic> json)  =>
        _$PhotosRemoteModelFromJson(json);

    Map<String, dynamic> toJson() => _$PhotosRemoteModelToJson(this);
}

@JsonSerializable()
class PhotoRemoteModel {
    @JsonKey(disallowNullValue: true, required: true)
    final int farm;
    @JsonKey(disallowNullValue: true, required: true)
    final String id;
    final int isfamily;
    final int isfriend;
    final int ispublic;
    @JsonKey(disallowNullValue: true, required: true)
    final String owner;
    @JsonKey(disallowNullValue: true, required: true)
    final String secret;
    @JsonKey(disallowNullValue: true, required: true)
    final String server;
    @JsonKey(disallowNullValue: true, required: true)
    final String title;

    PhotoRemoteModel({this.farm, this.id, this.isfamily, this.isfriend, this.ispublic, this.owner, this.secret, this.server, this.title});

    factory PhotoRemoteModel.fromJson(Map<String, dynamic> json) => _$PhotoRemoteModelFromJson(json);

    Map<String, dynamic> toJson() => _$PhotoRemoteModelToJson(this);
}
