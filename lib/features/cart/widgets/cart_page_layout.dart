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
  RenderObject createRenderObject(BuildContext context) => RenderCartPageLayout();
}

class CartPageLayoutParentData extends ContainerBoxParentData<RenderBox> {}

class RenderCartPageLayout extends RenderBox
    with
        WidgetsBindingObserver,
        ContainerRenderObjectMixin<RenderBox, CartPageLayoutParentData>,
        RenderBoxContainerDefaultsMixin<RenderBox, CartPageLayoutParentData> {
  double viewHeight = 0.0;
  double bottomInset = 0.0;

  @override
  void attach(PipelineOwner owner) {
    super.attach(owner);
    WidgetsBinding.instance.addObserver(this);
    didChangeMetrics();
  }

  @override
  void didChangeMetrics() {
    final view = WidgetsBinding.instance.platformDispatcher.implicitView!;
    final newViewHeight = (view.physicalSize / view.devicePixelRatio).height;
    final newBottomInset = view.viewInsets.bottom / view.devicePixelRatio;
    if (viewHeight != newViewHeight || bottomInset != newBottomInset) {
      viewHeight = newViewHeight;
      bottomInset = newBottomInset;
      markNeedsLayout();
    }
  }

  @override
  void detach() {
    WidgetsBinding.instance.removeObserver(this);
    super.detach();
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
    final inset = math.max(0.0, bottomInset - (viewHeight - bottom.dy));
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
