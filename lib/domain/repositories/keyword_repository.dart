import 'package:flickr_viewer/common/model/keyword.dart';

abstract class KeywordRepository {
  Stream<List<Keyword>> getKeywords();
}
