
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

buildNetworkImage({required String imageUrl, Color? color, BoxFit? fit, double? height, double? width,}) {
  String encodedUrl = Uri.encodeFull(imageUrl);
  return CachedNetworkImage(
    imageUrl: imageUrl,
    imageBuilder: (context, imageProvider) =>
        Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            color: color,
            image: DecorationImage(
              image: imageProvider,
              fit: fit ?? BoxFit.cover,
            ),
          ),
        ),
    placeholder: (context, url) => SizedBox(width: width,
      height: height,
      child: Icon(Icons.image,size: height,color: Colors.black12,),
    ),
    errorWidget: (context, url, error) => SizedBox(width: width,
        height: height,
        child:  const Icon(Icons.error)),
  );
}