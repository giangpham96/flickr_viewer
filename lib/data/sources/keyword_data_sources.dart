import 'package:flickr_viewer/common/model/keyword.dart';

abstract class KeywordCacheDataSource {
  Stream<List<Keyword>> getPredefinedKeywords();
}
