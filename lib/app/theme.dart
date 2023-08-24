// EB670A

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show SystemUiOverlayStyle;

const _appOrangeColor = Color(0xFFEC722A);
const _appLightOrangeColor = Color(0xFFF39A24);
const _appAppBarColor = Color(0xFF242529);
const appGreyColor = Color(0xFF555555);
const appLightGreyColor = Color(0xFFF0F0F0);

const appDividerColor = Color(0xFFE6E6E6);

const appButtonRadius = BorderRadius.all(Radius.circular(6.0));

const appHorizontalGradientHighlight = LinearGradient(
  begin: Alignment.centerLeft,
  end: Alignment.centerRight,
  colors: [
    _appOrangeColor,
    _appLightOrangeColor,
  ],
);

const appVerticalGradientHighlight = LinearGradient(
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
  colors: [
    _appOrangeColor,
    _appLightOrangeColor,
  ],
);

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
        appColorLight: _appLightOrangeColor,
        appBarColor: _appAppBarColor,
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
