import 'package:flutter/material.dart';

/// 应用颜色常量定义
class AppColors {
  AppColors._();

  // 主色调
  static const Color primary = Color(0xFF2563EB);      // 蓝色
  static const Color secondary = Color(0xFF10B981);    // 绿色
  static const Color accent = Color(0xFFF59E0B);       // 橙色

  // 中性色
  static const Color background = Color(0xFFF8FAFC);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color textPrimary = Color(0xFF1E293B);
  static const Color textSecondary = Color(0xFF64748B);
  static const Color textTertiary = Color(0xFF94A3B8);

  // 功能色
  static const Color success = Color(0xFF22C55E);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);
  static const Color info = Color(0xFF3B82F6);

  // 导航栏颜色
  static const Color navBarBackground = Color(0xFFFFFFFF);
  static const Color navBarText = Color(0xFF1E293B);
  static const Color navBarTextHover = Color(0xFF2563EB);
  static const Color navBarBorder = Color(0xFFE2E8F0);

  // 边框和分割线
  static const Color border = Color(0xFFE2E8F0);
  static const Color divider = Color(0xFFF1F5F9);
}
