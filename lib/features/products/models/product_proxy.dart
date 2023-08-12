import 'package:flutter/cupertino.dart';
import 'package:flutter_command/flutter_command.dart';
import 'package:wow_shopping/backend/models/product_item.dart';
import 'package:wow_shopping/shared/utils/formatting.dart';

class ProductProxy extends ChangeNotifier {
  ProductProxy(this.productItem, [this.onWishList = false]) {
    toggleWishListCommand = Command.createAsyncNoParamNoResult(() async {
      onWishList = !onWishList;
      notifyListeners();

      await Future.delayed(const Duration(milliseconds: 2000));
      throw Exception('Failed to add to wishlist');
      // TODO: add to the wishlist
    },
        errorFilter: const ErrorHandlerLocalAndGlobal(),
        debugName: 'toggleWishListCommand');

    toggleWishListCommand.errors.listen((err, _) {
      onWishList = !onWishList;
      notifyListeners();
    });
  }

  late Command<void, void> toggleWishListCommand;

  bool onWishList;

  final ProductItem productItem;

  String get id => productItem.id;
  String get category => productItem.category;
  String get title => productItem.title;
  String get subTitle => productItem.subTitle;
  double get price => productItem.price;
  double get priceWithTax => productItem.priceWithTax;
  List<String> get photos => productItem.photos;
  String get description => productItem.description;

  String get primaryPhoto => photos[0];

  String get formattedPrice => formatCurrency(price);

  String get formattedPriceWithTax => formatCurrency(priceWithTax);
}
