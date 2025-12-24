import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_styles.dart';

/// 房源卡片组件
class PropertyCard extends StatelessWidget {
  const PropertyCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppStyles.radiusMedium),
        border: Border.all(
          color: AppColors.border,
          width: 1,
        ),
      ),
      child: const Center(
        child: Padding(
          padding: EdgeInsets.all(AppStyles.spacing16),
          child: Text(
            '房源卡片',
            style: TextStyle(
              fontSize: AppStyles.fontSizeBody,
              color: AppColors.textSecondary,
            ),
          ),
        ),
      ),
    );
  }
}
