import 'package:flutter/services.dart';
import 'dart:convert';

abstract class SecretProvider {
  String getFlickrApiKey();
}

class _SecretProviderImpl implements SecretProvider {
  final Map<String, dynamic> _secretMap;

  _SecretProviderImpl(this._secretMap);

  @override
  String getFlickrApiKey() {
    return _secretMap['flickr_api_key'];
  }
}

class SecretLoader {
  final String secretPath;

  SecretLoader(this.secretPath);

  Future<SecretProvider> load() {
    return rootBundle.loadStructuredData(
      this.secretPath,
      (jsonStr) async {
        return _SecretProviderImpl(json.decode(jsonStr));
      },
    );
  }
}
