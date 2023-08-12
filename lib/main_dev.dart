import 'package:flutter/material.dart';
import 'package:wow_shopping/app/app.dart';

import 'app/di.dart';

void main() {
  setupDi();
  runApp(const ShopWowApp(
    config: AppConfig(
      env: AppEnv.dev,
    ),
  ));
}
