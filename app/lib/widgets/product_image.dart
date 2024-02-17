import 'package:flutter/material.dart';
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
    if (inkEnabled) {
      return Ink.image(
        image: AssetImage(
          item.photos[imageIndex],
        ),
        fit: BoxFit.cover,
      );
    } else {
      return Image.asset(
        item.photos[imageIndex],
        fit: BoxFit.cover,
      );
    }
  }
}
