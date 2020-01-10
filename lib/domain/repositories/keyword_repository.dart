import 'package:flickr_viewer/common/model/keyword.dart';

abstract class KeywordRepository {
  Future<List<Keyword>> getKeywords();
}
