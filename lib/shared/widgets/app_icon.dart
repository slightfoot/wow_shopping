import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:wow_shopping/app/theme.dart';

@immutable
class AppIcon extends StatelessWidget {
  const AppIcon({
    super.key,
    required this.iconAsset,
    this.color,
    this.highlighted = false,
  });

  final String iconAsset;
  final Color? color;
  final bool highlighted;

  @override
  Widget build(BuildContext context) {
    final icon = SvgPicture.asset(
      iconAsset,
      colorFilter: color != null && !highlighted //
          ? ColorFilter.mode(color!, BlendMode.srcIn)
          : null,
    );
    if (highlighted) {
      return ShaderMask(
        shaderCallback: appVerticalGradientHighlight.createShader,
        blendMode: BlendMode.srcIn,
        child: icon,
      );
    } else {
      return icon;
    }
  }
}
