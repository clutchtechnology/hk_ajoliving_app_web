import 'package:flutter/material.dart';
import 'app_colors.dart';

/// 应用样式常量定义
class AppStyles {
  AppStyles._();

  // 导航栏样式
  static const double navBarHeight = 64.0;
  static const double navBarPaddingHorizontal = 24.0;
  static const double navBarLogoWidth = 120.0;

  // 字体大小
  static const double fontSizeH1 = 32.0;
  static const double fontSizeH2 = 24.0;
  static const double fontSizeH3 = 20.0;
  static const double fontSizeBody = 16.0;
  static const double fontSizeCaption = 14.0;
  static const double fontSizeSmall = 12.0;

  // 间距
  static const double spacing4 = 4.0;
  static const double spacing8 = 8.0;
  static const double spacing12 = 12.0;
  static const double spacing16 = 16.0;
  static const double spacing24 = 24.0;
  static const double spacing32 = 32.0;
  static const double spacing48 = 48.0;
  static const double spacing64 = 64.0;

  // 圆角
  static const double radiusSmall = 4.0;
  static const double radiusMedium = 8.0;
  static const double radiusLarge = 12.0;
  static const double radiusXLarge = 16.0;

  // 阴影
  static List<BoxShadow> get shadowSmall => [
        BoxShadow(
          color: Colors.black.withOpacity(0.05),
          blurRadius: 4,
          offset: const Offset(0, 2),
        ),
      ];

  static List<BoxShadow> get shadowMedium => [
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          blurRadius: 8,
          offset: const Offset(0, 4),
        ),
      ];

  // 导航栏文字样式
  static const TextStyle navBarTextStyle = TextStyle(
    fontSize: fontSizeBody,
    color: AppColors.navBarText,
    fontWeight: FontWeight.w500,
  );

  static const TextStyle navBarTextHoverStyle = TextStyle(
    fontSize: fontSizeBody,
    color: AppColors.navBarTextHover,
    fontWeight: FontWeight.w600,
  );
}
