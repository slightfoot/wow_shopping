import 'package:flutter/material.dart';
import 'package:wow_shopping/app/app.dart';

void main() {
  runApp(const ShopWowApp(
    config: AppConfig(
      env: AppEnv.dev,
      baseApiUrl: 'http://localhost:8080/api'
    ),
  ));
}
