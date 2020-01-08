// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'flickr_service.dart';

// **************************************************************************
// RetrofitGenerator
// **************************************************************************

class _FlickrService implements FlickrService {
  _FlickrService(this._dio, {this.baseUrl}) {
    ArgumentError.checkNotNull(_dio, '_dio');
  }

  final Dio _dio;

  String baseUrl;

  @override
  getPhotos(keyword, page, {method = 'flickr.photos.search'}) async {
    ArgumentError.checkNotNull(keyword, 'keyword');
    ArgumentError.checkNotNull(page, 'page');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      'text': keyword,
      'page': page,
      'method': method
    };
    final _data = <String, dynamic>{};
    final Response<Map<String, dynamic>> _result = await _dio.request(
        'services/rest/',
        queryParameters: queryParameters,
        options: RequestOptions(
            method: 'GET',
            headers: <String, dynamic>{},
            extra: _extra,
            baseUrl: baseUrl),
        data: _data);
    final value = PhotosResponseRemoteModel.fromJson(_result.data);
    return Future.value(value);
  }
}
