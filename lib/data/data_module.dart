import 'package:flickr_viewer/data/keyword_repository_impl.dart';
import 'package:flickr_viewer/data/photo_repository_impl.dart';
import 'package:flickr_viewer/domain/repositories/keyword_repository.dart';
import 'package:flickr_viewer/domain/repositories/photo_repository.dart';
import 'package:get_it/get_it.dart';

dataModule() {
  GetIt.instance
    ..registerFactory<PhotoRepository>(
      () => PhotoRepositoryImpl(GetIt.instance.get()),
    )
    ..registerFactory<KeywordRepository>(
      () => KeywordRepositoryImpl(GetIt.instance.get()),
    );
}
