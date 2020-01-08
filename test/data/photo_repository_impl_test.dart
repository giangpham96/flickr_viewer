import 'package:flickr_viewer/common/model/page_of_photos.dart';
import 'package:flickr_viewer/common/model/photo.dart';
import 'package:flickr_viewer/data/photo_repository_impl.dart';
import 'package:flickr_viewer/data/sources/photo_data_sources.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import '../test_util.dart';

class _MockedPhotoRemoteDataSource extends Mock
    implements PhotoRemoteDataSource {}

main() {
  final dataSource = _MockedPhotoRemoteDataSource();
  final repository = PhotoRepositoryImpl(dataSource);

  test('should propagate result from remote layer', () async {
    final testData = PageOfPhotos(
      1,
      1,
      [
        Photo(66, "48961354943", "183117384@N08", "4128d45088", "65535",
            "Highland Cattle"),
        Photo(66, "48961354338", "45582668@N03", "39815c1990", "65535",
            "Animal sculptures, 01.07.2019."),
      ],
    );
    when(dataSource.getPhotos('batman', 1))
        .thenAnswer((_) => Stream.value(testData));

    await repository.getPhotos('batman', 1).expect(
          emits(testData),
        );

    verify(dataSource.getPhotos('batman', 1));
  });

  test('should propagate error from remote layer', () async {
    when(dataSource.getPhotos('batman', 1))
        .thenAnswer((_) => Stream.error(Exception()));

    await repository.getPhotos('batman', 1).expect(
          emitsError(isA<Exception>()),
        );

    verify(dataSource.getPhotos('batman', 1));
  });
}
