import 'package:flutter/material.dart';
import 'routes/app_router.dart';
import 'core/constants/app_colors.dart';

/// App 主应用
class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'AJO Living',
      debugShowCheckedModeBanner: false,

      // 路由配置
      routerConfig: appRouter,

      // 主题配置
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          primary: AppColors.primary,
          secondary: AppColors.secondary,
          surface: AppColors.surface,
          background: AppColors.background,
        ),
        scaffoldBackgroundColor: AppColors.background,
        fontFamily: 'NotoSansHK',
      ),

      // TODO: 配置国际化
      // locale: const Locale('zh', 'HK'),
      // localizationsDelegates: AppLocalizations.localizationsDelegates,
      // supportedLocales: AppLocalizations.supportedLocales,
    );
  }
}
