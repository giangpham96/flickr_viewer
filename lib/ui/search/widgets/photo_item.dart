import 'package:flickr_viewer/common/model/photo.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:transparent_image/transparent_image.dart';

class PhotoItem extends StatelessWidget {
  final Photo photo;

  const PhotoItem({Key key, @required this.photo}) : super(key: key);
  @override
  Widget build(BuildContext context) {
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
