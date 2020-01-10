import 'package:flickr_viewer/common/model/page_of_photos.dart';

abstract class PhotoRemoteDataSource {
  Future<PageOfPhotos> getPhotos(String keyword, int page);
}
