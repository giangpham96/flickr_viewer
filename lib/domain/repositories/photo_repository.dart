import 'package:flickr_viewer/common/model/page_of_photos.dart';

abstract class PhotoRepository {
  Stream<PageOfPhotos> getPhotos(String keyword, int page);
}
