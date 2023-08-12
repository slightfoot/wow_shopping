import 'package:flutter/material.dart';
import 'package:wow_shopping/app/app.dart';

import 'setup.dart';

void main() {
  setup();
  runApp(const ShopWowApp(
    config: AppConfig(
      env: AppEnv.dev,
    ),
  ));
}
