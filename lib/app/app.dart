import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart' hide TextDirection;
import 'package:wow_shopping/app/config.dart';
import 'package:wow_shopping/app/theme.dart';
import 'package:wow_shopping/backend/backend.dart';
import 'package:wow_shopping/features/main/main_screen.dart';
import 'package:wow_shopping/features/splash/splash_screen.dart';

export 'package:wow_shopping/app/config.dart';

const _appTitle = 'Shop Wow';

class ShopWowApp extends StatefulWidget {
  const ShopWowApp({
    super.key,
    required this.config,
  });

  final AppConfig config;

  @override
  State<ShopWowApp> createState() => _ShopWowAppState();
}

class _ShopWowAppState extends State<ShopWowApp> {
  final _navigatorKey = GlobalKey<NavigatorState>();

  NavigatorState get navigatorState => _navigatorKey.currentState!;

  late Future<Backend> _appLoader;

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    Intl.defaultLocale = PlatformDispatcher.instance.locale.toLanguageTag();
    _appLoader = _loadApp();
  }

  Future<Backend> _loadApp() async {
    await initializeDateFormatting();
    return Backend.init();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: appOverlayDarkIcons,
      child: FutureBuilder<Backend>(
        future: _appLoader,
        builder: (BuildContext context, AsyncSnapshot<Backend> snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return Theme(
              data: generateLightTheme(),
              child: const Directionality(
                textDirection: TextDirection.ltr,
                child: SplashScreen(),
              ),
            );
          } else {
            return BackendInheritedWidget(
              backend: snapshot.requireData,
              child: MaterialApp(
                debugShowCheckedModeBanner: false,
                navigatorKey: _navigatorKey,
                title: _appTitle,
                theme: generateLightTheme(),
                home: const MainScreen(),
              ),
            );
          }
        },
      ),
    );
  }
}
