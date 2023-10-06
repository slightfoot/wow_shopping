import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../app/assets.dart';
import '../../app/theme.dart';
import '../../widgets/common.dart';
import '../../widgets/top_nav_bar.dart';

class LogInPageWrapper extends StatelessWidget {
  const LogInPageWrapper({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final appTheme = AppTheme.of(context);
    return Material(
      color: appTheme.appBarColor,
      child: DefaultTextStyle.merge(
        style: const TextStyle(
          color: Colors.white,
        ),
        child: Column(
          children: [
            TopNavBar(
              title: Padding(
                padding: verticalPadding8,
                child: SvgPicture.asset(Assets.logo),
              ),
            ),
            verticalMargin48,
            Expanded(child: child),
          ],
        ),
      ),
    );
  }
}
