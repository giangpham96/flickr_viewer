import 'package:flickr_viewer/common/model/page_of_photos.dart';
import 'package:flickr_viewer/domain/repositories/photo_repository.dart';
import 'package:rxdart/rxdart.dart';

abstract class GetPhotosByKeywordUseCase {
  Stream<GetPhotosByKeywordResult> getPhotos(String keyword, int page);
}

abstract class GetPhotosByKeywordResult {}

class LoadingPhotos extends GetPhotosByKeywordResult {}

class FailureLoadingPhotos extends GetPhotosByKeywordResult {
  final Exception error;

  FailureLoadingPhotos(this.error);
}

class PhotosLoaded extends GetPhotosByKeywordResult {
  final PageOfPhotos pageOfPhotos;

  PhotosLoaded(this.pageOfPhotos);
}

class GetPhotosByKeywordUseCaseImpl implements GetPhotosByKeywordUseCase {
  final PhotoRepository _photoRepository;

  GetPhotosByKeywordUseCaseImpl(this._photoRepository);

  @override
  Stream<GetPhotosByKeywordResult> getPhotos(String keyword, int page) {
    return _photoRepository
        .getPhotos(keyword, page)
        .map<GetPhotosByKeywordResult>((p) => PhotosLoaded(p))
        .onErrorResume((e) => Stream.value(FailureLoadingPhotos(e)))
        .startWith(LoadingPhotos());
  }
}
