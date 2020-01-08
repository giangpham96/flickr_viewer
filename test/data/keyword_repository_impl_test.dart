import 'package:flickr_viewer/common/model/keyword.dart';
import 'package:flickr_viewer/data/keyword_repository_impl.dart';
import 'package:flickr_viewer/data/sources/keyword_data_sources.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import '../test_util.dart';

class _MockedKeywordCacheDataSource extends Mock
    implements KeywordCacheDataSource {}

main() {
  final dataSource = _MockedKeywordCacheDataSource();
  final repository = KeywordRepositoryImpl(dataSource);

  test('should propagate result from cache layer', () async {
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
    when(dataSource.getPredefinedKeywords())
        .thenAnswer((_) => Stream.value(testData));

    await repository.getKeywords().expect(
          emits(testData),
        );

    verify(dataSource.getPredefinedKeywords());
  });

  test('should propagate error from cache layer', () async {
    when(dataSource.getPredefinedKeywords())
        .thenAnswer((_) => Stream.error(Exception()));

    await repository.getKeywords().expect(
          emitsError(isA<Exception>()),
        );

    verify(dataSource.getPredefinedKeywords());
  });
}
