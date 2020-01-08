// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'photos_response_remote_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PhotosResponseRemoteModel _$PhotosResponseRemoteModelFromJson(
    Map<String, dynamic> json) {
  $checkKeys(json,
      requiredKeys: const ['photos', 'stat'],
      disallowNullValues: const ['photos', 'stat']);
  return PhotosResponseRemoteModel(
    photos: json['photos'] == null
        ? null
        : PhotosRemoteModel.fromJson(json['photos'] as Map<String, dynamic>),
    stat: json['stat'] as String,
  );
}

Map<String, dynamic> _$PhotosResponseRemoteModelToJson(
    PhotosResponseRemoteModel instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('photos', instance.photos);
  writeNotNull('stat', instance.stat);
  return val;
}

PhotosRemoteModel _$PhotosRemoteModelFromJson(Map<String, dynamic> json) {
  $checkKeys(json,
      requiredKeys: const ['page', 'pages', 'perpage', 'photo', 'total'],
      disallowNullValues: const ['page', 'pages', 'perpage', 'photo', 'total']);
  return PhotosRemoteModel(
    page: json['page'] as int,
    pages: json['pages'] as int,
    perpage: json['perpage'] as int,
    photo: (json['photo'] as List)
        ?.map((e) => e == null
            ? null
            : PhotoRemoteModel.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    total: json['total'] as String,
  );
}

Map<String, dynamic> _$PhotosRemoteModelToJson(PhotosRemoteModel instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('page', instance.page);
  writeNotNull('pages', instance.pages);
  writeNotNull('perpage', instance.perpage);
  writeNotNull('photo', instance.photo);
  writeNotNull('total', instance.total);
  return val;
}

PhotoRemoteModel _$PhotoRemoteModelFromJson(Map<String, dynamic> json) {
  $checkKeys(json, requiredKeys: const [
    'farm',
    'id',
    'owner',
    'secret',
    'server',
    'title'
  ], disallowNullValues: const [
    'farm',
    'id',
    'owner',
    'secret',
    'server',
    'title'
  ]);
  return PhotoRemoteModel(
    farm: json['farm'] as int,
    id: json['id'] as String,
    isfamily: json['isfamily'] as int,
    isfriend: json['isfriend'] as int,
    ispublic: json['ispublic'] as int,
    owner: json['owner'] as String,
    secret: json['secret'] as String,
    server: json['server'] as String,
    title: json['title'] as String,
  );
}

Map<String, dynamic> _$PhotoRemoteModelToJson(PhotoRemoteModel instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('farm', instance.farm);
  writeNotNull('id', instance.id);
  val['isfamily'] = instance.isfamily;
  val['isfriend'] = instance.isfriend;
  val['ispublic'] = instance.ispublic;
  writeNotNull('owner', instance.owner);
  writeNotNull('secret', instance.secret);
  writeNotNull('server', instance.server);
  writeNotNull('title', instance.title);
  return val;
}
