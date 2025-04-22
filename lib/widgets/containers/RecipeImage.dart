import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../services/ImageService.dart';

class RecipeImage extends StatelessWidget {
  final int id;
  final int imageVersion;

  const RecipeImage({super.key, required this.id, required this.imageVersion});

  @override
  Widget build(BuildContext context) {
    if(imageVersion != 0) {
      return CachedNetworkImage(imageUrl: ImageService.buildImageUrl("recipes", id, version: imageVersion),
        fit: BoxFit.cover,
        errorWidget: (context, url, error) =>
            Image.asset('assets/images/default.png', fit: BoxFit.cover),
      );
    }else{
      return Image.asset('assets/images/default.png', fit: BoxFit.cover);
    }
  }

}