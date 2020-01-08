import 'package:flickr_viewer/common/model/photo.dart';
import 'package:flickr_viewer/presentation/photo_bloc.dart';
import 'package:flickr_viewer/presentation/photo_view_state.dart';
import 'package:flickr_viewer/ui/base/base_stateful_widget.dart';
import 'package:flickr_viewer/ui/search/widgets/paginated_grid_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:transparent_image/transparent_image.dart';

class SearchResult extends BaseBlocAwareWidget {
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
      return Container();
    }
    if (viewState is PhotosFetched) {
      return _renderPhotoList(viewState.photos);
    }
    if (viewState is SearchFailed) {
      return _renderSnackBar(
        'An error has occured',
        action: SnackBarAction(
          label: 'Retry',
          onPressed: () => bloc.onRetryQuery(viewState.keyword),
        ),
      );
    }
    if (viewState is LoadingNextPage) {
      return _renderPhotoList(
        viewState.photos,
        footerState: FooterState.loadingFooter(),
      );
    }
    if (viewState is LoadPageFailed) {
      return _renderPhotoList(
        viewState.photos,
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
      return _renderSnackBar("No image found for \"${viewState.keyword}\"");
    }
    return Center(
      child: CircularProgressIndicator(),
    );
  }
}

extension RenderPhotoList on _SearchResultState {
  Widget _renderPhotoList(
    List<Photo> photos, {
    FooterState footerState,
  }) {
    return PaginatedGridView(
      itemBuilder: (_, index) => _mapPhotoToItemView(photos[index]),
      itemCount: photos.length,
      onNextPage: bloc.loadNextPage,
      childAspectRatio: 0.75,
      footerState: footerState,
    );
  }

  Widget _mapPhotoToItemView(Photo photo) {
    return Stack(
      alignment: AlignmentDirectional.bottomCenter,
      children: <Widget>[
        Positioned.fill(
          child: FadeInImage.memoryNetwork(
            fadeInCurve: Curves.easeIn,
            image: photo.thumbnail,
            placeholder: kTransparentImage,
            fit: BoxFit.cover,
          ),
        ),
        Container(
          width: double.infinity,
          // Add box decoration
          decoration: const BoxDecoration(
            // Box decoration takes a gradient
            gradient: const LinearGradient(
              // Where the linear gradient begins and ends
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              // Add one stop for each color. Stops should increase from 0 to 1
              stops: const [0.1, 0.25, 0.5, 1.0],
              colors: const [
                // Colors are easy thanks to Flutter's Colors class.
                Colors.transparent,
                Colors.black12,
                Colors.black54,
                Colors.black,
              ],
            ),
          ),
          child: Padding(
            padding: EdgeInsets.all(8),
            child: Text(
              photo.title,
              style: const TextStyle(color: Colors.white),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
      ],
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
