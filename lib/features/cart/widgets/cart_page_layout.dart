import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class CartPageLayout extends MultiChildRenderObjectWidget {
  CartPageLayout({
    super.key,
    required Widget checkoutPanel,
    required Widget content,
  }) : super(children: [content, checkoutPanel]);

  @override
  RenderObject createRenderObject(BuildContext context) {
    return RenderCartPageLayout(
      viewInsets: MediaQuery.viewInsetsOf(context),
      viewSize: MediaQuery.sizeOf(context),
    );
  }

  @override
  void updateRenderObject(BuildContext context, covariant RenderCartPageLayout renderObject) {
    renderObject
      ..viewInsets = MediaQuery.viewInsetsOf(context)
      ..viewSize = MediaQuery.sizeOf(context);
  }
}

class CartPageLayoutParentData extends ContainerBoxParentData<RenderBox> {}

class RenderCartPageLayout extends RenderBox
    with
        ContainerRenderObjectMixin<RenderBox, CartPageLayoutParentData>,
        RenderBoxContainerDefaultsMixin<RenderBox, CartPageLayoutParentData> {
  RenderCartPageLayout({
    required EdgeInsets viewInsets,
    required Size viewSize,
  })  : _viewInsets = viewInsets,
        _viewSize = viewSize;

  late EdgeInsets _viewInsets;

  EdgeInsets get viewInsets => _viewInsets;

  set viewInsets(EdgeInsets value) {
    if (value != _viewInsets) {
      _viewInsets = value;
      markNeedsLayout();
    }
  }

  late Size _viewSize;

  Size get viewSize => _viewSize;

  set viewSize(Size value) {
    if (value != _viewSize) {
      _viewSize = value;
      markNeedsLayout();
    }
  }

  @override
  void setupParentData(RenderBox child) {
    if (child.parentData is! CartPageLayoutParentData) {
      child.parentData = CartPageLayoutParentData();
    }
  }

  @override
  void performLayout() {
    final children = getChildrenAsList();
    final contentBox = children[0];
    final checkoutPanelBox = children[1];

    final width = constraints.maxWidth;
    final height = constraints.maxHeight;

    checkoutPanelBox.layout(BoxConstraints.tightFor(width: width), parentUsesSize: true);

    final bottom = localToGlobal(Offset(0.0, height));
    final inset = math.max(0.0, _viewInsets.bottom - (_viewSize.height - bottom.dy));
    final offset = height - inset - checkoutPanelBox.size.height;

    (checkoutPanelBox.parentData! as BoxParentData).offset = Offset(0.0, offset);

    contentBox.layout(BoxConstraints.tightFor(width: width, height: offset));
    (contentBox.parentData! as BoxParentData).offset = Offset.zero;

    size = constraints.biggest;
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    defaultPaint(context, offset);
  }

  @override
  bool hitTestChildren(BoxHitTestResult result, {required Offset position}) {
    return defaultHitTestChildren(result, position: position);
  }
}
