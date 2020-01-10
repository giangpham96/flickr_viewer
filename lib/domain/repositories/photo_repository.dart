import 'package:flickr_viewer/common/model/page_of_photos.dart';

abstract class PhotoRepository {
  Future<PageOfPhotos> getPhotos(String keyword, int page);
}
