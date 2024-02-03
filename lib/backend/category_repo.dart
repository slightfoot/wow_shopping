import 'dart:collection';
import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:wow_shopping/app/assets.dart';
import 'package:wow_shopping/models/category_item.dart';

class CategoryRepo {
  CategoryRepo(this.featuredCategories);

  final List<CategoryItem> featuredCategories;

  static Future<CategoryRepo> create() async {
    try {
      final data = json.decode(
        await rootBundle.loadString(Assets.featuredCategoriesData),
      );
      final featuredCategories = UnmodifiableListView(
        (data['featured_categories'] as List) //
          .cast<int>() //
          .map((id) => CategoryItem.fromId(id))
          .whereType<CategoryItem>(),
      );
      return CategoryRepo(featuredCategories);
    } catch (error, stackTrace) {
      // FIXME: implement logging
      print('$error\n$stackTrace');
      rethrow;
    }
  }
}
