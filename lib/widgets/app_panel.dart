import 'package:flutter/material.dart';
import 'package:wow_shopping/app/theme.dart';
import 'package:wow_shopping/widgets/common.dart';

class AppPanel extends StatelessWidget {
  const AppPanel({
    super.key,
    this.padding = emptyPadding,
    required this.child,
  });

  final EdgeInsetsGeometry padding;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: appLightGreyColor,
        border: Border(
          top: BorderSide(color: appDividerColor, width: 2.0),
        ),
      ),
      child: Padding(
        padding: padding,
        child: child,
      ),
    );
  }
}
