import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wow_shopping/app/theme.dart';
import 'package:wow_shopping/features/main/main_screen.dart';
import 'package:wow_shopping/features/splash/splash_screen.dart';

class ShowWowApp extends StatefulWidget {
  const ShowWowApp({super.key});

  @override
  State<ShowWowApp> createState() => _ShowWowAppState();
}

class _ShowWowAppState extends State<ShowWowApp> {
  final _navigatorKey = GlobalKey<NavigatorState>();

  NavigatorState get navigatorState => _navigatorKey.currentState!;

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    Future.delayed(const Duration(milliseconds: 2000), () {
      if (mounted) {
        navigatorState.pushReplacementNamed('/main');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: appOverlayDarkIcons,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        navigatorKey: _navigatorKey,
        title: 'Shop Wow',
        theme: generateLightTheme(),
        initialRoute: '/',
        routes: {
          '/': (_) => const SplashScreen(),
          '/main': (_) => const MainScreen(),
        },
      ),
    );
  }
}
