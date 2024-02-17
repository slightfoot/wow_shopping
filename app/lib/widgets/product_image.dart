import 'package:flutter/material.dart';
import 'package:flutter_image/flutter_image.dart';
import 'package:wow_shopping/backend/backend.dart';
import 'package:wow_shopping/models/product_item.dart';

class ProductImage extends StatelessWidget {
  const ProductImage({
    super.key,
    this.imageIndex = 0,
    this.inkEnabled = true,
    required this.item,
  });

  final int imageIndex;
  final bool inkEnabled;
  final ProductItem item;

  @override
  Widget build(BuildContext context) {
    final image = NetworkImageWithRetry(
      context.resolveApiUrl(item.photos[imageIndex]),
    );
    if (inkEnabled) {
      return Ink.image(
        image: image,
        fit: BoxFit.cover,
      );
    } else {
      return Image(
        image: image,
        fit: BoxFit.cover,
      );
    }
  }
}
