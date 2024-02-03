import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:wow_shopping/app/theme.dart';
import 'package:wow_shopping/models/category_item.dart';
import 'package:wow_shopping/widgets/common.dart';

class CategoryCard extends StatelessWidget {
  const CategoryCard({
    super.key,
    required this.category,
  });

  final CategoryItem category;

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: appButtonRadius,
      elevation: 1.0,
      child: InkWell(
        onTap: () {
          print('Opening category ${category.title}');
        },
        customBorder: appButtonBorder,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: SvgPicture.asset(
                category.iconAsset,
                width: 40.0,
              ),
            ),
            Text(
              category.title,
              style: const TextStyle(fontSize: 12.0),
            ),
            verticalMargin12,
          ],
        ),
      ),
    );
  }
}
