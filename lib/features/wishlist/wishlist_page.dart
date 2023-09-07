import 'package:flutter/material.dart';
import 'package:wow_shopping/app/assets.dart';
import 'package:wow_shopping/backend/backend.dart';
import 'package:wow_shopping/features/wishlist/widgets/wishlist_item.dart';
import 'package:wow_shopping/models/product_item.dart';
import 'package:wow_shopping/widgets/app_button.dart';
import 'package:wow_shopping/widgets/app_panel.dart';
import 'package:wow_shopping/widgets/common.dart';
import 'package:wow_shopping/widgets/top_nav_bar.dart';

@immutable
class WishlistPage extends StatefulWidget {
  const WishlistPage({super.key});

  @override
  State<WishlistPage> createState() => _WishlistPageState();
}

class _WishlistPageState extends State<WishlistPage> {
  var _wishlistItems = <ProductItem>[];
  final _selectedItems = <String>{};

  bool isSelected(ProductItem item) {
    return _selectedItems.contains(item.id);
  }

  void setSelected(ProductItem item, bool selected) {
    setState(() {
      if (selected) {
        _selectedItems.add(item.id);
      } else {
        _selectedItems.remove(item.id);
      }
    });
  }

  void toggleSelectAll() {
    final allIds = _wishlistItems.map((el) => el.id).toList();
    setState(() {
      if (_selectedItems.containsAll(allIds)) {
        _selectedItems.clear();
      } else {
        _selectedItems.addAll(allIds);
      }
    });
  }

  void _removeSelected() {
    setState(() {
      for (final selected in _selectedItems) {
        wishlistRepo.removeToWishlist(selected);
      }
      _selectedItems.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Material(
        child: WishlistConsumer(
          builder: (BuildContext context, WishlistState state) {
            if (state is! WishlistStateActive) {
              return const Center(child: CircularProgressIndicator());
            }
            _wishlistItems = state.items;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TopNavBar(
                  title: const Text('Wishlist'),
                  actions: [
                    TextButton(
                      onPressed: toggleSelectAll,
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Select All'),
                    ),
                  ],
                ),
                Expanded(
                  child: MediaQuery.removeViewPadding(
                    context: context,
                    removeTop: true,
                    child: ListView.builder(
                      padding: verticalPadding12,
                      itemCount: _wishlistItems.length,
                      itemBuilder: (BuildContext context, int index) {
                        final item = _wishlistItems[index];
                        return Padding(
                          padding: verticalPadding12,
                          child: WishlistItem(
                            item: item,
                            onPressed: (item) {
                              // FIXME: navigate to product details
                            },
                            selected: isSelected(item),
                            onToggleSelection: setSelected,
                          ),
                        );
                      },
                    ),
                  ),
                ),
                AnimatedSize(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.fastOutSlowIn,
                  alignment: Alignment.topCenter,
                  child: Align(
                    alignment: Alignment.topCenter,
                    heightFactor: _selectedItems.isEmpty ? 0.0 : 1.0,
                    child: AppPanel(
                      padding: allPadding24,
                      child: Row(
                        children: [
                          Expanded(
                            child: AppButton(
                              onPressed: _removeSelected,
                              label: 'Remove',
                              iconAsset: Assets.iconRemove,
                            ),
                          ),
                          horizontalMargin16,
                          Expanded(
                            child: AppButton(
                              onPressed: () {
                                // FIXME: implement Buy Now button
                              },
                              label: 'Buy now',
                              iconAsset: Assets.iconBuy,
                              style: AppButtonStyle.highlighted,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

@immutable
class WishlistConsumer extends StatelessWidget {
  const WishlistConsumer({
    super.key,
    required this.builder,
  });

  final Widget Function(BuildContext context, WishlistState state) builder;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<WishlistState>(
      initialData: context.wishlistRepo.currentState,
      stream: context.wishlistRepo.streamState,
      builder: (BuildContext context, AsyncSnapshot<WishlistState> snapshot) {
        return builder(context, snapshot.requireData);
      },
    );
  }
}
