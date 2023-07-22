// EB670A

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show SystemUiOverlayStyle;

const _appOrangeColor = Color(0xFFEB670A);

const appOverlayDarkIcons = SystemUiOverlayStyle(
  statusBarColor: Colors.transparent,
  statusBarBrightness: Brightness.light,
  statusBarIconBrightness: Brightness.dark,
  systemNavigationBarColor: Colors.transparent,
  systemNavigationBarIconBrightness: Brightness.dark,
);

const appOverlayLightIcons = SystemUiOverlayStyle(
  statusBarColor: Colors.transparent,
  statusBarBrightness: Brightness.dark,
  statusBarIconBrightness: Brightness.light,
  systemNavigationBarColor: Colors.transparent,
  systemNavigationBarIconBrightness: Brightness.dark,
);

ThemeData generateLightTheme() {
  return ThemeData(
    colorScheme: ColorScheme.fromSeed(
      brightness: Brightness.light,
      seedColor: _appOrangeColor,
    ),
    useMaterial3: true,
    extensions: const [
      AppTheme(
        appColor: _appOrangeColor,
        appColorLight: Color(0xFFF6751D),
        appBarColor: Color(0xFF242529),
        whiteIcon: ColorFilter.mode(Colors.white, BlendMode.srcIn),
      ),
    ],
  );
}

class AppTheme extends ThemeExtension<AppTheme> {
  const AppTheme({
    required this.appColor,
    required this.appColorLight,
    required this.appBarColor,
    required this.whiteIcon,
  });

  final Color appColor;
  final Color appColorLight;
  final Color appBarColor;
  final ColorFilter whiteIcon;

  static AppTheme of(BuildContext context) {
    return Theme.of(context).extension<AppTheme>()!;
  }

  @override
  ThemeExtension<AppTheme> copyWith({
    Color? appColor,
    Color? appColorLight,
    Color? appBarColor,
    ColorFilter? whiteIcon,
  }) {
    return AppTheme(
      appColor: appColor ?? this.appColor,
      appColorLight: appColorLight ?? this.appColorLight,
      appBarColor: appBarColor ?? this.appBarColor,
      whiteIcon: whiteIcon ?? this.whiteIcon,
    );
  }

  @override
  ThemeExtension<AppTheme> lerp(covariant AppTheme other, double t) {
    return AppTheme(
      appColor: Color.lerp(appColor, other.appColor, t)!,
      appColorLight: Color.lerp(appColorLight, other.appColorLight, t)!,
      appBarColor: Color.lerp(appBarColor, other.appBarColor, t)!,
      whiteIcon: t < 0.5 ? whiteIcon : other.whiteIcon,
    );
  }
}
