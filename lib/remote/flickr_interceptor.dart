import 'package:dio/dio.dart';

import 'model/flickr_error_response_remote_model.dart';

class FlickrInterceptor extends Interceptor {
  final String _apiKey;

  FlickrInterceptor(this._apiKey);

  @override
  Future onRequest(RequestOptions options) async {
    return options.queryParameters.addAll(
      {'api_key': _apiKey, 'format': 'json', 'nojsoncallback': '1'},
    );
  }

  @override
  Future onResponse(Response response) {
    FlickrErrorResponseRemoteModel err;
    try {
      err = FlickrErrorResponseRemoteModel.fromJson(response.data);
    } catch (_) {
      err = null;
    }
    if (err == null)
      return super.onResponse(response);
    else
      return Future.error(
        DioError(
          request: response.request,
          response: response,
          type: DioErrorType.RESPONSE,
          error: err,
        ),
      );
  }
}
