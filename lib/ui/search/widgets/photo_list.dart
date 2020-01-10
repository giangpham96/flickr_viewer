import 'package:flickr_viewer/common/model/photo.dart';
import 'package:flickr_viewer/ui/custom_widgets/paginated_grid_view.dart';
import 'package:flickr_viewer/ui/search/widgets/photo_item.dart';
import 'package:flutter/widgets.dart';

class PhotoList extends StatelessWidget {
  final List<Photo> photos;
  final FooterState footerState;
  final VoidCallback loadNextPage;

  const PhotoList({Key key, this.photos = const [], this.footerState, this.loadNextPage})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PaginatedGridView(
      itemBuilder: (_, index) => PhotoItem(photo: photos[index],),
      itemCount: photos.length,
      onNextPage: loadNextPage ?? () {},
      childAspectRatio: 0.75,
      footerState: footerState,
    );
  }
}
