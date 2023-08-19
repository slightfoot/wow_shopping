import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wow_shopping/app/app.dart';

void main() {
  runApp(const ProviderScope(
    child:  ShopWowApp(
      config: AppConfig(
        env: AppEnv.dev,
      ),
    ),
  ));
}
