import 'dart:async';

import 'package:flickr_viewer/common/model/photo.dart';
import 'package:flickr_viewer/domain/get_photos_by_keyword_use_case.dart';
import 'package:flickr_viewer/presentation/base/bloc.dart';
import 'package:flickr_viewer/presentation/photo_view_state.dart';
import 'package:rxdart/rxdart.dart';

class _ResultWithKeyword {
  final String keyword;
  final GetPhotosByKeywordResult result;

  _ResultWithKeyword(this.keyword, this.result);
}

class _CurrentStoredSearch {
  final String keyword;

  final List<Photo> loadedPhotos;

  final int loadedPage;

  final int totalPages;

  _CurrentStoredSearch(
      this.keyword, this.loadedPhotos, this.loadedPage, this.totalPages);
}

class PhotoBloc extends BaseBloc {

  Stream<PhotoViewState> get photoState => _photoController.stream;

  final _photoController = StreamController<PhotoViewState>();

  final _keywordChangeNotifier = PublishSubject<String>();

  _CurrentStoredSearch _currentStoredPhotos;

  StreamSubscription _loadingNextPageSubscription;

  bool _ableToLoadNextPage = false;

  final GetPhotosByKeywordUseCase _getPhotosByKeywordUseCase;

  PhotoBloc(this._getPhotosByKeywordUseCase) {
    _photoController.add(Idling());
    _keywordChangeNotifier
        .distinct()
        .switchMap((k) => _cancelLoadingNextPageIfNecessary().map((_) => k))
        .flatMap(_searchPhotos)
        .listen(_mapResultWithKeywordToSearchState);
  }

  resetSearch() {
    _currentStoredPhotos = null;
    _cancelLoadingNextPageIfNecessary()
        .listen((_) => _photoController.add(Idling()));
  }

  onKeywordChanged(String keyword) {
    _currentStoredPhotos = null;
    _keywordChangeNotifier.add(keyword);
  }

  onRetryQuery(String keyword) {
    _currentStoredPhotos = null;
    _searchPhotos(keyword).listen(_mapResultWithKeywordToSearchState);
  }

  loadNextPage() {
    if (_currentStoredPhotos == null) return;
    if (_currentStoredPhotos.loadedPage >= _currentStoredPhotos.totalPages ||
        !_ableToLoadNextPage) return;

    _loadingNextPageSubscription = _getPhotosByKeywordUseCase
        .getPhotos(
            _currentStoredPhotos.keyword, _currentStoredPhotos.loadedPage + 1)
        .listen(_mapResultToLoadNextPageState);
  }

  Stream<dynamic> _cancelLoadingNextPageIfNecessary() {
    if (_loadingNextPageSubscription != null) {
      final stream = _loadingNextPageSubscription.cancel().asStream();
      _loadingNextPageSubscription = null;
      return stream;
    } else {
      return Stream.value(null);
    }
  }

  Stream<_ResultWithKeyword> _searchPhotos(String keyword) {
    return _getPhotosByKeywordUseCase
        .getPhotos(keyword, 1)
        .map((r) => _ResultWithKeyword(keyword, r));
  }

  _mapResultWithKeywordToSearchState(_ResultWithKeyword resultWithKeyword) {
    final result = resultWithKeyword.result;
    final keyword = resultWithKeyword.keyword;
    if (result is Loading) {
      _ableToLoadNextPage = false;
      _photoController.add(Searching());
    } else if (result is Failure) {
      _ableToLoadNextPage = false;
      _photoController.add(SearchFailed(keyword));
    } else if (result is Success) {
      if (result.pageOfPhotos.photos.length == 0) {
        _ableToLoadNextPage = false;
        _photoController.add(NotFound(keyword));
      } else {
        _ableToLoadNextPage = true;
        _currentStoredPhotos = _CurrentStoredSearch(
          keyword,
          result.pageOfPhotos.photos,
          1,
          result.pageOfPhotos.totalPages,
        );
        _photoController.add(
          PhotosFetched(
            keyword,
            result.pageOfPhotos.photos,
          ),
        );
      }
    } else {
      throw Exception('unsupported result');
    }
  }

  _mapResultToLoadNextPageState(GetPhotosByKeywordResult r) {
    if (r is Loading) {
      _ableToLoadNextPage = false;
      _photoController.add(LoadingNextPage(_currentStoredPhotos.loadedPhotos));
    } else if (r is Failure) {
      _ableToLoadNextPage = true;
      _photoController.add(
        LoadPageFailed(
          _currentStoredPhotos.keyword,
          _currentStoredPhotos.loadedPhotos,
        ),
      );
    } else if (r is Success) {
      _currentStoredPhotos = _CurrentStoredSearch(
        _currentStoredPhotos.keyword,
        _currentStoredPhotos.loadedPhotos + r.pageOfPhotos.photos,
        r.pageOfPhotos.page,
        r.pageOfPhotos.totalPages,
      );
      _ableToLoadNextPage = true;
      _photoController.add(
        PhotosFetched(
          _currentStoredPhotos.keyword,
          _currentStoredPhotos.loadedPhotos,
        ),
      );
    } else {
      throw Exception('unsupported result');
    }
  }

  @override
  dispose() {
    _cancelLoadingNextPageIfNecessary().listen(
      (_) {
        _keywordChangeNotifier.close();
        _photoController.close();
      },
    );
  }
}
