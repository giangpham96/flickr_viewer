import 'package:dio/dio.dart';
import 'dart:async';
import 'package:flickr_viewer/common/model/page_of_photos.dart';
import 'package:flickr_viewer/common/model/photo.dart';
import 'package:flickr_viewer/data/sources/photo_data_sources.dart';
import 'package:flickr_viewer/remote/model/flickr_error_response_remote_model.dart';

import 'flickr_service.dart';

class PhotoRemoteDataSourceImpl implements PhotoRemoteDataSource {
  final FlickrService _flickrService;

  PhotoRemoteDataSourceImpl(this._flickrService);

  @override
  Future<PageOfPhotos> getPhotos(String keyword, int page) {
    return _flickrService.getPhotos(keyword, page).then(
      (r) => PageOfPhotos(
        r.photos.page,
        r.photos.pages,
        r.photos.photo
            .map(
              (p) => Photo(p.farm, p.id, p.owner, p.secret, p.server, p.title),
            )
            .toList(),
      ),
      onError: (e) {
        throw e is DioError && e.error is FlickrErrorResponseRemoteModel
            ? e.error
            : e;
      },
    );
  }
}
