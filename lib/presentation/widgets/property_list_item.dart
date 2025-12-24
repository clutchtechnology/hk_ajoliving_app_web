import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

/// 房源列表单行组件（内容待补充）
class PropertyListItem extends StatelessWidget {
  final Widget? child;
  const PropertyListItem({super.key, this.child});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 100, horizontal: 16),
          child: child ?? const Text('房源信息', style: TextStyle(fontSize: 16)),
        ),
        const Divider(
          height: 1,
          thickness: 1,
          color: AppColors.border,
        ),
      ],
    );
  }
}
