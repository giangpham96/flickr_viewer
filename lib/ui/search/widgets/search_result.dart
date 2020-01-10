import 'package:flickr_viewer/presentation/photo_bloc.dart';
import 'package:flickr_viewer/presentation/photo_view_state.dart';
import 'package:flickr_viewer/ui/base/base_stateful_widget.dart';
import 'package:flickr_viewer/ui/custom_widgets/paginated_grid_view.dart';
import 'package:flickr_viewer/ui/search/widgets/keyword_list.dart';
import 'package:flickr_viewer/ui/search/widgets/photo_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class SearchResult extends BaseBlocAwareWidget {
  final Function(String) onKeywordChange;

  SearchResult({this.onKeywordChange});

  @override
  State<StatefulWidget> createState() {
    return _SearchResultState();
  }
}

class _SearchResultState
    extends BaseBlocAwareState<SearchResult, PhotoBloc, PhotoViewState> {
  @override
  Stream<PhotoViewState> getStream(PhotoBloc bloc) {
    return bloc.photoState;
  }

  @override
  Widget render(BuildContext context, PhotoViewState viewState) {
    _hideSnackBar();
    if (viewState is Idling) {
      return KeywordList(
        keywords: viewState.keywords,
        onKeywordSelected: widget.onKeywordChange ?? (_) {},
      );
    }
    if (viewState is PhotosFetched) {
      if (viewState.hideKeyboard)
        FocusScope.of(context).requestFocus(FocusNode());
      return PhotoList(
        photos: viewState.photos,
        loadNextPage: bloc.loadNextPage,
      );
    }
    if (viewState is SearchFailed) {
      FocusScope.of(context).requestFocus(FocusNode());
      return _renderSnackBar(
        'An error has occured',
        action: SnackBarAction(
          label: 'Retry',
          onPressed: () => bloc.onRetryQuery(viewState.keyword),
        ),
      );
    }
    if (viewState is LoadingNextPage) {
      return PhotoList(
        photos: viewState.photos,
        footerState: FooterState.loadingFooter(),
        loadNextPage: bloc.loadNextPage,
      );
    }
    if (viewState is LoadPageFailed) {
      return PhotoList(
        photos: viewState.photos,
        loadNextPage: bloc.loadNextPage,
        footerState: LoadingFailedFooter(
          (context) => Theme(
            data: ThemeData(splashColor: Colors.transparent),
            child: Container(
              padding: EdgeInsets.all(15),
              alignment: Alignment.center,
              child: FlatButton.icon(
                  onPressed: bloc.loadNextPage,
                  icon: const Icon(
                    Icons.refresh,
                    color: Colors.grey,
                  ),
                  label: const Text(
                    'An error has occured. Tap to retry',
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  )),
            ),
          ),
        ),
      );
    }
    if (viewState is NotFound) {
      FocusScope.of(context).requestFocus(FocusNode());
      return _renderSnackBar("No image found for \"${viewState.keyword}\"");
    }
    return Center(
      child: CircularProgressIndicator(),
    );
  }
}

extension RenderSnackBarAction on _SearchResultState {
  Widget _renderSnackBar(String content, {SnackBarAction action}) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final snackBar = SnackBar(
        duration: Duration(seconds: 6),
        content: Text(content),
        action: action,
      );
      Scaffold.of(context).showSnackBar(snackBar);
    });
    return Container();
  }

  _hideSnackBar() {
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => Scaffold.of(context).hideCurrentSnackBar(),
    );
  }
}
