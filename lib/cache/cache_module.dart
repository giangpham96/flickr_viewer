import 'package:flickr_viewer/cache/keyword_cache_data_source_impl.dart';
import 'package:flickr_viewer/data/sources/keyword_data_sources.dart';
import 'package:get_it/get_it.dart';

cacheModule() {
  GetIt.instance.registerSingleton<KeywordCacheDataSource>(
    KeywordCacheDataSourceImpl(),
  );
}
