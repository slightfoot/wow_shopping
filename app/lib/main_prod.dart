import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wow_shopping/app/app.dart';

void main() {
  runApp(
    ProviderScope(
      overrides: [
        appConfigProvider.overrideWithValue(
          const AppConfig(
            env: AppEnv.prod,
            baseApiUrl: 'https://example.com/api/',
          ),
        ),
      ],
      child: const ShopWowApp(),
    ),
  );
}
