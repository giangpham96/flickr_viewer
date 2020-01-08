import 'package:flickr_viewer/common/model/keyword.dart';
import 'package:flickr_viewer/domain/get_keywords_use_case.dart';
import 'package:flickr_viewer/domain/repositories/keyword_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:rxdart/rxdart.dart';
import '../test_util.dart';

class MockedKeywordRepository extends Mock implements KeywordRepository {}

main() {
  final repository = MockedKeywordRepository();
  final getPhotosByKeywordUseCase = GetKeywordUseCaseImpl(repository);

  test('should start with Loading', () async {
    when(repository.getKeywords()).thenAnswer((_) => NeverStream());
    await getPhotosByKeywordUseCase
        .getKeywords()
        .expect(emits(isA<LoadingKeywords>()));
  });

  test('should start with Loading and move to Success', () async {
    final testData = const [
      Keyword(
        'Animals',
        subKeywords: [
          Keyword(
            'Pets',
            subKeywords: [
              Keyword('Guppy'),
            ],
          ),
          Keyword(
            'Wild animals',
            subKeywords: [
              Keyword('Tiger'),
            ],
          ),
          Keyword(
            'Domestic animals',
            subKeywords: [
              Keyword('Cow'),
              Keyword('Pig'),
              Keyword('Goat'),
              Keyword('Horse'),
            ],
          ),
        ],
      ),
    ];
    when(repository.getKeywords())
        .thenAnswer((_) => Stream.value(testData));
    await getPhotosByKeywordUseCase.getKeywords().expect(
          emitsInOrder([
            isA<LoadingKeywords>(),
            isA<KeywordsLoaded>()
                .having((s) => s.keywords, 'match test data', testData)
          ]),
        );
  });

  test('should start with Loading and move to Failure', () async {
    when(repository.getKeywords())
        .thenAnswer((_) => Stream.error(Exception()));
    await getPhotosByKeywordUseCase.getKeywords().expect(
          emitsInOrder([
            isA<LoadingKeywords>(),
            isA<FailureLoadingKeywords>()
                .having((f) => f.error, 'match test data', isA<Exception>())
          ]),
        );
  });
}
