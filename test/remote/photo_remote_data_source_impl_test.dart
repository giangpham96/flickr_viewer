import 'package:dio/dio.dart';
import 'package:flickr_viewer/common/model/page_of_photos.dart';
import 'package:flickr_viewer/common/model/photo.dart';
import 'package:flickr_viewer/remote/flickr_interceptor.dart';
import 'package:flickr_viewer/remote/flickr_service.dart';
import 'package:flickr_viewer/remote/model/flickr_error_response_remote_model.dart';
import 'package:flickr_viewer/remote/photo_remote_data_source_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:mock_web_server/mock_web_server.dart';
import '../test_util.dart';

main() {
  MockWebServer _mockWebServer;

  final _headers = {"Content-Type": "application/json"};
  Dio _dio = Dio();
  final _service = FlickrService(_dio);
  final _datasource = PhotoRemoteDataSourceImpl(_service);
  _dio.interceptors.add(FlickrInterceptor("api_key"));

  group('get photos', () {
    setUp(() async {
      _mockWebServer = MockWebServer();
      await _mockWebServer.start();
      _dio.options.baseUrl = _mockWebServer.url;
    });

    tearDown(() async {
      await _mockWebServer.shutdown();
    });

    test('should return a list of 2 items', () async {
      const result = '''
        {
          "photos": {
            "page": 1,
            "pages": 1,
            "perpage": 100,
            "total": "2",
            "photo": [
              {
                "id": "48961354943",
                "owner": "183117384@N08",
                "secret": "4128d45088",
                "server": "65535",
                "farm": 66,
                "title": "Highland Cattle",
                "ispublic": 1,
                "isfriend": 0,
                "isfamily": 0
              },
              {
                "id": "48961354338",
                "owner": "45582668@N03",
                "secret": "39815c1990",
                "server": "65535",
                "farm": 66,
                "title": "Animal sculptures, 01.07.2019.",
                "ispublic": 1,
                "isfriend": 0,
                "isfamily": 0
              }
            ]
          },
          "stat": "ok"
        }
        ''';
      _mockWebServer.enqueue(httpCode: 200, body: result, headers: _headers);

      await _datasource.getPhotos('batman', 1).expect(
            emits(
              PageOfPhotos(
                1,
                1,
                [
                  Photo(66, "48961354943", "183117384@N08", "4128d45088",
                      "65535", "Highland Cattle"),
                  Photo(66, "48961354338", "45582668@N03", "39815c1990",
                      "65535", "Animal sculptures, 01.07.2019."),
                ],
              ),
            ),
          );

      final req = _mockWebServer.takeRequest();

      expect(
        req.uri.toString(),
        '/services/rest/?text=batman&page=1&method=flickr.photos.search&api_key=api_key&format=json&nojsoncallback=1',
      );

      expect(req.method, 'GET');
    });

    test('should throw exception if response body is malformed', () async {
      const result = '''
        {
          "photos": {
            "page": 1,
            "pages": 1,
            "perpage": 100,
            "total": "2",
            "photo": [
              {
                "id": "48961354943",
                "owner": "183117384@N08",
                "secret": "4128d45088",
                "server": "65535",
                "farm": 66,
                "ispublic": 1,
                "isfriend": 0,
                "isfamily": 0
              },
              {
                "id": "48961354338",
                "owner": "45582668@N03",
                "secret": "39815c1990",
                "farm": 66,
                "title": "Animal sculptures, 01.07.2019.",
                "ispublic": 1,
                "isfriend": 0,
                "isfamily": 0
              }
            ]
          },
          "stat": "ok"
        }
        ''';
      _mockWebServer.enqueue(httpCode: 200, body: result, headers: _headers);

      await _datasource
          .getPhotos('batman', 1)
          .expect(emitsError(isA<MissingRequiredKeysException>()));

      final req = _mockWebServer.takeRequest();

      expect(
        req.uri.toString(),
        '/services/rest/?text=batman&page=1&method=flickr.photos.search&api_key=api_key&format=json&nojsoncallback=1',
      );

      expect(req.method, 'GET');
    });

    test('should throw exception if backend gives stat as fail', () async {
      const result = '''
        {
          "stat": "fail",
          "code": 100,
          "message": "Invalid API Key (Key has invalid format)"
        }
        ''';
      _mockWebServer.enqueue(httpCode: 200, body: result, headers: _headers);

      await _datasource
          .getPhotos('batman', 1)
          .expect(emitsError(isA<FlickrErrorResponseRemoteModel>()));

      final req = _mockWebServer.takeRequest();

      expect(
        req.uri.toString(),
        '/services/rest/?text=batman&page=1&method=flickr.photos.search&api_key=api_key&format=json&nojsoncallback=1',
      );

      expect(req.method, 'GET');
    });
  });
}
