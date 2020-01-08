import 'package:flickr_viewer/common/config/secret_provider.dart';
import 'package:flickr_viewer/common/constants.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';

appModule(SecretProvider secretProvider) {
  GetIt.instance.registerSingleton<SecretProvider>(secretProvider);
  GetIt.instance.registerSingleton(kDebugMode, instanceName: DEBUG_TAG);
}
