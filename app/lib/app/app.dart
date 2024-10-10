import 'dart:ui';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart' hide TextDirection;
import 'package:wow_shopping/app/config.dart';
import 'package:wow_shopping/app/theme.dart';
import 'package:wow_shopping/backend/auth_repo.dart';
import 'package:wow_shopping/backend/backend.dart';
import 'package:wow_shopping/features/login/login_screen.dart';
import 'package:wow_shopping/features/main/main_screen.dart';
import 'package:wow_shopping/features/splash/splash_screen.dart';

export 'package:wow_shopping/app/config.dart';

const _appTitle = 'Shop Wow';

final appConfigProvider = Provider<AppConfig>(
  (ref) => AppConfig.empty,
);

final appLoaderProvider = FutureProvider<Backend>(
  (FutureProviderRef ref) async {
    final config = ref.read(appConfigProvider);
    if (config.env == AppEnv.dev) {
      EquatableConfig.stringify = true;
    }
    await initializeDateFormatting();
    final backend = await Backend.init(
      ref.read(appConfigProvider),
      ref.read(deviceTypeNotifierProvider),
    );
    await MainScreen.precacheImages();
    return backend;
  },
);

class ShopWowApp extends ConsumerStatefulWidget {
  const ShopWowApp({
    super.key,
  });

  @override
  ConsumerState<ShopWowApp> createState() => _ShopWowAppState();
}

class _ShopWowAppState extends ConsumerState<ShopWowApp> {
  final _navigatorKey = GlobalKey<NavigatorState>();

  NavigatorState? get navigatorState => _navigatorKey.currentState;

  @override
  void initState() {
    super.initState();
    final deviceTypeNotifier = ref.read(deviceTypeNotifierProvider);
    deviceTypeNotifier.init();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setPreferredOrientations(
      deviceTypeNotifier.isPhone //
          ? [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]
          : DeviceOrientation.values,
    );
    Intl.defaultLocale = PlatformDispatcher.instance.locale.toLanguageTag();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: appOverlayDarkIcons,
      child: Builder(
        builder: (BuildContext context) {
          final appLoader = ref.watch(appLoaderProvider);
          if (appLoader.isLoading) {
            return Theme(
              data: generateLightTheme(),
              child: const Directionality(
                textDirection: TextDirection.ltr,
                child: SplashScreen(),
              ),
            );
          } else {
            final backend = appLoader.value!;
            return ProviderScope(
              overrides: [
                backendProvider.overrideWithValue(backend),
              ],
              child: Consumer(
                builder: (BuildContext context, WidgetRef ref, Widget? child) {
                  ref.listen(
                    loggedInProvider,
                    (AsyncValue<bool>? previousAsync, AsyncValue<bool> nextAsync) {
                      final previous = previousAsync?.value ?? false;
                      final next = nextAsync.requireValue;
                      if (previous && !next) {
                        navigatorState?.pushAndRemoveUntil(
                          LoginScreen.route(),
                          (route) => false,
                        );
                      } else if (!previous && next) {
                        navigatorState?.pushAndRemoveUntil(
                          MainScreen.route(),
                          (route) => false,
                        );
                      }
                    },
                  );
                  return MaterialApp(
                    debugShowCheckedModeBanner: false,
                    // FIXME: disabled as rebuild causing issues
                    // restorationScopeId: 'app',
                    navigatorKey: _navigatorKey,
                    title: _appTitle,
                    theme: generateLightTheme(),
                    initialRoute: backend.authRepo.isLoggedIn //
                        ? MainScreen.routeName
                        : LoginScreen.routeName,
                    routes: <String, WidgetBuilder>{
                      LoginScreen.routeName: (_) => const LoginScreen(),
                      MainScreen.routeName: (_) => const MainScreen(),
                    },
                  );
                },
              ),
            );
          }
        },
      ),
    );
  }
}
