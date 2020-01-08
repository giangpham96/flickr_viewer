import 'package:dio/dio.dart';
import 'package:flickr_viewer/remote/model/photos_response_remote_model.dart';
import 'package:retrofit/http.dart';

part 'flickr_service.g.dart';

@RestApi()
abstract class FlickrService {
  factory FlickrService(Dio dio) = _FlickrService;

  @GET('services/rest/')
  Future<PhotosResponseRemoteModel> getPhotos(
    @Query('text') String keyword,
    @Query('page') int page, {
    @Query('method') String method = 'flickr.photos.search',
  });
}
