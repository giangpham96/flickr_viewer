import 'package:flickr_viewer/common/model/keyword.dart';

abstract class KeywordCacheDataSource {
  Future<List<Keyword>> getPredefinedKeywords();
}
