import 'package:flutter/material.dart';
import 'package:wow_shopping/app/theme.dart';
import 'package:wow_shopping/widgets/app_icon.dart';
import 'package:wow_shopping/widgets/common.dart';

enum AppButtonStyle {
  regular,
  highlighted,
  outlined,
}

@immutable
class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    this.onPressed,
    required this.label,
    this.iconAsset,
    this.style = AppButtonStyle.regular,
  });

  final VoidCallback? onPressed;
  final String label;
  final String? iconAsset;
  final AppButtonStyle style;

  @override
  Widget build(BuildContext context) {
    final appTheme = AppTheme.of(context);
    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        onTap: onPressed,
        customBorder: const RoundedRectangleBorder(
          borderRadius: appButtonRadius,
        ),
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: appButtonRadius,
            color: style == AppButtonStyle.regular //
                ? appTheme.appBarColor
                : null,
            border: switch (style) {
              AppButtonStyle.outlined => Border.all(
                  color: appTheme.appColor,
                ),
              _ => null,
            },
            gradient: style == AppButtonStyle.highlighted //
                ? appHorizontalGradientHighlight
                : null,
          ),
          child: Padding(
            padding: horizontalPadding16 + verticalPadding8,
            child: IntrinsicWidth(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                    child: Text(
                      label,
                      textAlign: iconAsset != null //
                          ? TextAlign.start
                          : TextAlign.center,
                      style: switch (style) {
                        AppButtonStyle.outlined => TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.w700,
                            color: appTheme.appColor,
                          ),
                        _ => const TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                      },
                    ),
                  ),
                  if (iconAsset case String iconAsset) //
                    AppIcon(iconAsset: iconAsset),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
