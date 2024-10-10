import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wow_shopping/app/app.dart';

void main() {
  runApp(
    ProviderScope(
      overrides: [
        appConfigProvider.overrideWithValue(
          const AppConfig(
            env: AppEnv.dev,
            baseApiUrl: 'http://192.168.1.128:8080',
          ),
        ),
      ],
      child: const ShopWowApp(),
    ),
  );
}
