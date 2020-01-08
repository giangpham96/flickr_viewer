import 'package:flickr_viewer/common/model/page_of_photos.dart';
import 'package:flickr_viewer/domain/repositories/photo_repository.dart';
import 'package:rxdart/rxdart.dart';

abstract class GetPhotosByKeywordUseCase {
  Stream<GetPhotosByKeywordResult> getPhotos(String keyword, int page);
}

abstract class GetPhotosByKeywordResult {}

class Loading extends GetPhotosByKeywordResult {}

class Failure extends GetPhotosByKeywordResult {
  final Exception error;

  Failure(this.error);
}

class Success extends GetPhotosByKeywordResult {
  final PageOfPhotos pageOfPhotos;

  Success(this.pageOfPhotos);
}

class GetPhotosByKeywordUseCaseImpl implements GetPhotosByKeywordUseCase {
  final PhotoRepository _photoRepository;

  GetPhotosByKeywordUseCaseImpl(this._photoRepository);

  @override
  Stream<GetPhotosByKeywordResult> getPhotos(String keyword, int page) {
    return _photoRepository
        .getPhotos(keyword, page)
        .map<GetPhotosByKeywordResult>((p) => Success(p))
        .onErrorResume((e) => Stream.value(Failure(e)))
        .startWith(Loading());
  }
}
