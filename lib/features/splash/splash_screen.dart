import 'package:flutter/material.dart';
import 'package:wow_shopping/app/assets.dart';
import 'package:wow_shopping/app/theme.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:wow_shopping/widgets/common.dart';

@immutable
class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appTheme = AppTheme.of(context);
    return Material(
      type: MaterialType.transparency,
      child: Ink(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment(0.0, 0.5),
            end: Alignment(-1.25, 0.0),
            colors: [
              Color(0xFFEB670A),
              Color(0xFFF6751D),
            ],
          ),
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            FractionallySizedBox(
              widthFactor: 1.0,
              heightFactor: 0.65,
              alignment: Alignment.bottomCenter,
              child: Image.asset(
                Assets.splashBottom,
                fit: BoxFit.cover,
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Image.asset(Assets.splashTop),
                verticalMargin48 + verticalMargin16,
                FractionallySizedBox(
                  widthFactor: 0.6,
                  child: SvgPicture.asset(
                    Assets.logo,
                    fit: BoxFit.fitWidth,
                    allowDrawingOutsideViewBox: true,
                    clipBehavior: Clip.none,
                    colorFilter: appTheme.whiteIcon,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
