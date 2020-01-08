import 'package:flickr_viewer/common/model/photo.dart';
import 'package:flickr_viewer/presentation/photo_bloc.dart';
import 'package:flickr_viewer/presentation/photo_view_state.dart';
import 'package:flickr_viewer/ui/base/base_stateful_widget.dart';
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
    if (viewState is Idling) {
      return Container();
    }
    if (viewState is PhotosFetched) {
      return GridView.count(
        childAspectRatio: 3 / 4,
        crossAxisCount: 2,
        children: _renderPhotoList(viewState.photos),
      );
    }
    return Center(
      child: CircularProgressIndicator(),
    );
  }
}

extension RenderPhotoList on _SearchResultState {

  List<Widget> _renderPhotoList(List<Photo> photos) {
    return photos.map(_mapPhotoToItemView).toList();
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
