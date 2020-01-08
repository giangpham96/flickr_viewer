import 'package:flickr_viewer/common/model/page_of_photos.dart';
import 'package:flickr_viewer/common/model/photo.dart';
import 'package:flickr_viewer/domain/get_photos_by_keyword_use_case.dart';
import 'package:flickr_viewer/domain/repositories/photo_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:rxdart/rxdart.dart';
import '../test_util.dart';

class MockedPhotoRepository extends Mock implements PhotoRepository {}

main() {
  final repository = MockedPhotoRepository();
  final getPhotosByKeywordUseCase = GetPhotosByKeywordUseCaseImpl(repository);

  test('should start with Loading', () async {
    when(repository.getPhotos('batman', 1)).thenAnswer((_) => NeverStream());
    await getPhotosByKeywordUseCase.getPhotos('batman', 1).expect(
      emits(isA<Loading>()),
    );
  });

  test('should start with Loading and move to Success', () async {
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
    when(repository.getPhotos('batman', 1))
        .thenAnswer((_) => Stream.value(testData));
    await getPhotosByKeywordUseCase.getPhotos('batman', 1).expect(
      emitsInOrder([
        isA<Loading>(),
        isA<Success>()
            .having((s) => s.pageOfPhotos, 'match test data', testData)
      ]),
    );
  });

  test('should start with Loading and move to Failure', () async {
    when(repository.getPhotos('batman', 1))
        .thenAnswer((_) => Stream.error(Exception()));
    await getPhotosByKeywordUseCase.getPhotos('batman', 1).expect(
      emitsInOrder([
        isA<Loading>(),
        isA<Failure>()
            .having((f) => f.error, 'match test data', isA<Exception>())
      ]),
    );
  });
}
