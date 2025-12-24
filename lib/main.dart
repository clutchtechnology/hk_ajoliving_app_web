import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // TODO: 初始化应用配置
  // TODO: 初始化依赖注入
  // TODO: 初始化本地存储

  runApp(
    const ProviderScope(
      child: App(),
    ),
  );
}
