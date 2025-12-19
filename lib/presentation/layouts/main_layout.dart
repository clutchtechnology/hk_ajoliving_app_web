import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import 'nav_bar.dart';

/// 主布局组件
/// 包含顶部导航栏和页面内容区域
class MainLayout extends StatelessWidget {
  final Widget child;

  const MainLayout({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          // 顶部导航栏
          const NavBar(),

          // 页面内容区域
          Expanded(
            child: SingleChildScrollView(
              child: child,
            ),
          ),
        ],
      ),
    );
  }
}
