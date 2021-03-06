import 'package:flickr_viewer/common/model/keyword.dart';
import 'package:flickr_viewer/common/model/photo.dart';
import 'package:flutter/foundation.dart';

abstract class PhotoViewState {}

class Idling extends PhotoViewState {
  final List<Keyword> keywords;

  Idling({this.keywords = const <Keyword>[]});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is Idling &&
              runtimeType == other.runtimeType &&
              listEquals(keywords, other.keywords);

  @override
  int get hashCode => keywords.hashCode;
}

class Searching extends PhotoViewState {
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Searching && runtimeType == other.runtimeType;

  @override
  int get hashCode => 0;
}

class LoadingNextPage extends PhotoViewState {
  final List<Photo> photos;

  LoadingNextPage(this.photos);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LoadingNextPage &&
          runtimeType == other.runtimeType &&
          listEquals(photos, other.photos);

  @override
  int get hashCode => photos.hashCode;
}

class PhotosFetched extends PhotoViewState {
  final bool hideKeyboard;
  final String keyword;
  final List<Photo> photos;

  PhotosFetched(this.keyword, this.photos, this.hideKeyboard);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PhotosFetched &&
          hideKeyboard == other.hideKeyboard &&
          runtimeType == other.runtimeType &&
          keyword == other.keyword &&
          listEquals(photos, other.photos);

  @override
  int get hashCode => keyword.hashCode ^ photos.hashCode ^ hideKeyboard.hashCode;
}

class LoadPageFailed extends PhotoViewState {
  final String keyword;
  final List<Photo> photos;

  LoadPageFailed(this.keyword, this.photos);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LoadPageFailed &&
          runtimeType == other.runtimeType &&
          keyword == other.keyword &&
          listEquals(photos, other.photos);

  @override
  int get hashCode => keyword.hashCode ^ photos.hashCode;
}

class SearchFailed extends PhotoViewState {
  final String keyword;

  SearchFailed(this.keyword);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SearchFailed &&
          runtimeType == other.runtimeType &&
          keyword == other.keyword;

  @override
  int get hashCode => keyword.hashCode;
}

class NotFound extends PhotoViewState {
  final String keyword;

  NotFound(this.keyword);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NotFound &&
          runtimeType == other.runtimeType &&
          keyword == other.keyword;

  @override
  int get hashCode => keyword.hashCode;
}
