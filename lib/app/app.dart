import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart' hide TextDirection;
import 'package:wow_shopping/app/theme.dart';
import 'package:wow_shopping/backend/backend.dart';
import 'package:wow_shopping/features/main/main_screen.dart';
import 'package:wow_shopping/features/splash/splash_screen.dart';

const _appTitle = 'Shop Wow';

class ShowWowApp extends StatefulWidget {
  const ShowWowApp({super.key});

  @override
  State<ShowWowApp> createState() => _ShowWowAppState();
}

class _ShowWowAppState extends State<ShowWowApp> {
  final _navigatorKey = GlobalKey<NavigatorState>();

  NavigatorState get navigatorState => _navigatorKey.currentState!;

  late Future<Backend> _appLoader;

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    Intl.defaultLocale = PlatformDispatcher.instance.locale.toLanguageTag();
    _appLoader = Backend.init();
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
