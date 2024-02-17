import 'package:flutter/material.dart';
import 'package:wow_shopping/widgets/common.dart';

class PromoModel {
  const PromoModel({required this.asset});

  final String asset;
}

@immutable
class PromoCarousel extends StatefulWidget {
  const PromoCarousel({
    super.key,
    required this.promos,
    required this.onPromoPressed,
  });

  final List<PromoModel> promos;
  final ValueChanged<PromoModel> onPromoPressed;

  @override
  State<PromoCarousel> createState() => _PromoCarouselState();
}

class _PromoCarouselState extends State<PromoCarousel> {
  final _controller = PageController(viewportFraction: 0.8);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 12.0 + 170.0 + 12.0,
      child: PageView(
        controller: _controller,
        children: [
          for (final promo in widget.promos) //
            Padding(
              padding: verticalPadding12 + horizontalPadding8,
              child: _PromoCarouselItem(
                onPressed: () => widget.onPromoPressed(promo),
                asset: promo.asset,
              ),
            ),
        ],
      ),
    );
  }
}

@immutable
class _PromoCarouselItem extends StatelessWidget {
  const _PromoCarouselItem({
    required this.onPressed,
    required this.asset,
  });

  final VoidCallback onPressed;
  final String asset;

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: const BorderRadius.all(
        Radius.circular(16.0),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onPressed,
        child: Ink.image(
          image: AssetImage(asset),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
