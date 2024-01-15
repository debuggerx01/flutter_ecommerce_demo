import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class WebImage extends StatelessWidget {
  final String url;
  final double? width;
  final double? height;
  final BoxFit? fit;

  const WebImage({
    super.key,
    required this.url,
    this.width,
    this.height,
    this.fit,
  });

  @override
  Widget build(BuildContext context) => CachedNetworkImage(
        imageUrl: url,
        errorWidget: (context, url, error) => Image.network('https://picsum.photos/id/1/300/200'),
        width: width,
        height: height,
        fit: fit,
      );
}
