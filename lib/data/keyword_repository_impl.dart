import 'package:flickr_viewer/common/model/keyword.dart';
import 'package:flickr_viewer/data/sources/keyword_data_sources.dart';
import 'package:flickr_viewer/domain/repositories/keyword_repository.dart';

class KeywordRepositoryImpl implements KeywordRepository {

  final KeywordCacheDataSource _keywordCacheDataSource;

  const KeywordRepositoryImpl(this._keywordCacheDataSource);

  @override
  Future<List<Keyword>> getKeywords() {
    return _keywordCacheDataSource.getPredefinedKeywords();
  }
}
