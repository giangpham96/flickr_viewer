import 'package:dio/dio.dart';
import 'package:flickr_viewer/common/config/secret_provider.dart';
import 'package:flickr_viewer/data/sources/photo_data_sources.dart';
import 'package:flickr_viewer/remote/flickr_interceptor.dart';
import 'package:flickr_viewer/remote/photo_remote_data_source_impl.dart';
import 'package:get_it/get_it.dart';

import 'flickr_service.dart';

const FLICKR_INTERCEPTOR_TAG = 'FLICKR_INTERCEPTOR_TAG';

remoteModule() {
  GetIt.instance.registerFactory<Interceptor>(
    () => FlickrInterceptor(
      GetIt.instance.get<SecretProvider>().getFlickrApiKey(),
    ),
    instanceName: FLICKR_INTERCEPTOR_TAG,
  );
  GetIt.instance.registerLazySingleton<Dio>(() {
    final dio = Dio();
    dio.interceptors.add(GetIt.instance.get(FLICKR_INTERCEPTOR_TAG));
    dio.options.baseUrl = 'https://www.flickr.com/';
    return dio;
  });
  GetIt.instance.registerLazySingleton<FlickrService>(() {
    return FlickrService(GetIt.instance.get());
  });
  GetIt.instance.registerFactory<PhotoRemoteDataSource>(
    () => PhotoRemoteDataSourceImpl(GetIt.instance.get()),
  );
}
