import 'package:flickr_viewer/common/model/page_of_photos.dart';
import 'package:flickr_viewer/data/sources/photo_data_sources.dart';
import 'package:flickr_viewer/domain/repositories/photo_repository.dart';

class PhotoRepositoryImpl implements PhotoRepository {

  final PhotoRemoteDataSource _photoRemoteDataSource;

  PhotoRepositoryImpl(this._photoRemoteDataSource);

  @override
  Stream<PageOfPhotos> getPhotos(String keyword, int page) {
    return _photoRemoteDataSource.getPhotos(keyword, page);
  }
}
