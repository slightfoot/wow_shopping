import 'dart:async';
import 'dart:collection';

import 'package:wow_shopping/backend/api_service.dart';
import 'package:wow_shopping/backend/auth_repo.dart';
import 'package:wow_shopping/models/category_item.dart';

class CategoryRepo {
  CategoryRepo(this._apiService, this._authRepo);

  final ApiService _apiService;
  final AuthRepo _authRepo;

  late StreamSubscription _authSub;
  var _featuredCategories = <CategoryItem>[];

  List<CategoryItem> get featuredCategories => _featuredCategories;

  static Future<CategoryRepo> create(ApiService apiService, AuthRepo authRepo) async {
    final repo = CategoryRepo(apiService, authRepo);
    if (authRepo.isLoggedIn) {
      repo._fetchFeaturedCategories();
    }
    repo.init();
    return repo;
  }

  void init() {
    _authSub = _authRepo.streamIsLoggedIn.listen((bool isLoggedIn) {
      if (isLoggedIn) {
        _fetchFeaturedCategories();
      }
    });
  }

  void dispose() {
    _authSub.cancel();
  }

  Future<void> _fetchFeaturedCategories() async {
    try {
      final data = await _apiService.getFeaturedCategories();
      _featuredCategories = UnmodifiableListView(
        data //
            .map((id) => CategoryItem.fromId(id))
            .whereType<CategoryItem>(),
      );
    } catch (error, stackTrace) {
      // FIXME: implement logging
      print('$error\n$stackTrace');
    }
  }
}
