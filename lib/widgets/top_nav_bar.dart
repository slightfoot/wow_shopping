import 'package:flutter/material.dart';
import 'package:wow_shopping/app/theme.dart';

export 'package:wow_shopping/models/category_item.dart';

@immutable
class TopNavBar extends StatelessWidget {
  const TopNavBar({
    super.key,
    required this.title,
    this.actions,
    this.bottom,
  });

  final Widget title;
  final List<Widget>? actions;
  final Widget? bottom;

  @override
  Widget build(BuildContext context) {
    final appTheme = AppTheme.of(context);
    final viewPadding = MediaQuery.viewPaddingOf(context);
    final parentRoute = ModalRoute.of(context);
    final canPop = parentRoute?.canPop ?? false;
    final useCloseButton = parentRoute is PageRoute<dynamic> && parentRoute.fullscreenDialog;
    return AnnotatedRegion(
      value: appOverlayLightIcons,
      child: Material(
        color: appTheme.appBarColor,
        child: IconTheme.merge(
          data: const IconThemeData(
            color: Colors.white,
          ),
          child: Padding(
            padding: EdgeInsets.only(top: viewPadding.top),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ConstrainedBox(
                  constraints: const BoxConstraints(minHeight: 48.0),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      if (canPop) //
                        Align(
                          alignment: Alignment.centerLeft,
                          child: useCloseButton ? const CloseButton() : const BackButton(),
                        ),
                      DefaultTextStyle.merge(
                        style: const TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                        child: title,
                      ),
                      if (actions case List<Widget> actions) //
                        Align(
                          alignment: Alignment.centerRight,
                          child: Theme(
                            data: Theme.of(context).copyWith(
                              visualDensity: VisualDensity.compact,
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: actions,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                if (bottom case Widget bottom) //
                  bottom,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
