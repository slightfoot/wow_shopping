import 'package:flutter/material.dart';
import 'package:wow_shopping/app/theme.dart';
import 'package:wow_shopping/backend/backend.dart';
import 'package:wow_shopping/widgets/common.dart';

class CartPopupCountHost extends StatefulWidget {
  const CartPopupCountHost({
    super.key,
    required this.child,
  });

  final Widget child;

  static LayerLink layerLinkOf(BuildContext context) {
    final state = context.findAncestorStateOfType<_CartPopupCountHostState>();
    if(state == null) {
      throw Exception('Missing ancestor CartPopupCountHost widget!');
    }
    return state._cartPopupLayerLink;
  }

  @override
  State<CartPopupCountHost> createState() => _CartPopupCountHostState();
}

class _CartPopupCountHostState extends State<CartPopupCountHost> {
  final _cartPopupLayerLink = LayerLink();

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}

class CartPopupNotification extends StatelessWidget {
  const CartPopupNotification({super.key});

  @override
  Widget build(BuildContext context) {
    final appTheme = AppTheme.of(context);
    return StreamBuilder<int>(
      initialData: 0,
      stream: context.cartRepo.streamCartItems.map((items) {
        return items.fold(
          0,
          (prev, item) => prev + item.quantity,
        );
      }),
      builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
        final cartItemsCount = snapshot.requireData;
        if (cartItemsCount == 0) {
          return emptyWidget;
        }
        return CompositedTransformFollower(
          link: CartPopupCountHost.layerLinkOf(context),
          targetAnchor: Alignment.center,
          followerAnchor: Alignment.bottomCenter,
          child: Padding(
            padding: bottomPadding16 + bottomPadding4,
            child: DecoratedBox(
              decoration: ShapeDecoration(
                shape: _PopupBorder(),
                gradient: appHorizontalGradientHighlight,
                shadows: <BoxShadow>[
                  const BoxShadow(
                    color: Colors.black54,
                    spreadRadius: 0.0,
                    blurRadius: 2.0,
                  ),
                  BoxShadow(
                    color: appTheme.appColor.withOpacity(0.7),
                    spreadRadius: -3.0,
                    blurRadius: 12.0,
                    //blurStyle: BlurStyle.solid,
                  ),
                ],
              ),
              child: Padding(
                padding: verticalPadding8 + horizontalPadding16,
                child: Text(
                  '$cartItemsCount items',
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _PopupBorder extends ShapeBorder {
  @override
  EdgeInsetsGeometry get dimensions => emptyPadding;

  @override
  ShapeBorder scale(double t) => _PopupBorder();

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) {
    final path = Path();
    path.addRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTRB(
          rect.left,
          rect.top,
          rect.right,
          rect.bottom,
        ),
        const Radius.circular(6.0),
      ),
    );
    path
      ..moveTo(rect.center.dx - 8.0, rect.bottomCenter.dy - 2.0)
      ..lineTo(rect.center.dx + 8.0, rect.bottomCenter.dy - 2.0)
      ..lineTo(rect.center.dx, rect.bottomCenter.dy + 6.0)
      ..close();
    return path;
  }

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    return getInnerPath(rect, textDirection: textDirection);
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {
    // No painting required
  }
}
