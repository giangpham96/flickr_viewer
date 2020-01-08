import 'package:flickr_viewer/common/model/photo.dart';
import 'package:flutter/foundation.dart';

class PageOfPhotos {
  final int page;
  final int totalPages;
  final List<Photo> photos;

  PageOfPhotos(this.page, this.totalPages, this.photos);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PageOfPhotos &&
          runtimeType == other.runtimeType &&
          page == other.page &&
          totalPages == other.totalPages &&
          listEquals(photos, other.photos);

  @override
  int get hashCode => page.hashCode ^ totalPages.hashCode ^ photos.hashCode;
}
