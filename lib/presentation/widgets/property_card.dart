import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_styles.dart';

/// 房源卡片组件
class PropertyCard extends StatelessWidget {
  const PropertyCard({
    super.key,
    this.estateName = '示例屋苑',
    this.areaSqft,
    this.price,
    this.imageUrl,
  });

  final String estateName;
  final double? areaSqft; // 面积（平方尺）
  final String? price; // 售价文案，如 "HK$ 8,800,000"
  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    // 使用 LayoutBuilder 读取来自 GridTile 的约束（包含最终高度）
    return LayoutBuilder(
      builder: (context, constraints) {
        final double tileHeight = constraints.maxHeight;
        final double imageHeight = tileHeight * 0.5; // 图片高度为卡片高度的 50%

        return Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppStyles.radiusLarge),
            border: Border.all(color: AppColors.border, width: 1),
            boxShadow: AppStyles.shadowSmall,
          ),
          clipBehavior: Clip.antiAlias,
          child: Stack(
            children: [
              // 内容主列
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // 图片占位区域（高度为卡片 50%）
                  SizedBox(
                    height: imageHeight,
                    child: _buildImagePlaceholder(),
                  ),

                  // 下半部分信息区域
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(
                        AppStyles.spacing12,
                        AppStyles.spacing8, // 减小上内边距以贴近图片
                        AppStyles.spacing12,
                        AppStyles.spacing12,
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          // 左侧：屋苑名 + 面积
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  estateName,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: AppStyles.fontSizeH3,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                                const SizedBox(height: AppStyles.spacing4),
                                Text(
                                  areaSqft != null
                                      ? '${areaSqft!.toStringAsFixed(0)} 平方尺'
                                      : '— 平方尺',
                                  style: const TextStyle(
                                    fontSize: AppStyles.fontSizeCaption,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // 右下角：售价绿色徽标
                          _buildPriceBadge(),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  // 图片占位：没有资源时先显示灰色占位 + 图标
  Widget _buildImagePlaceholder() {
    if (imageUrl == null || imageUrl!.isEmpty) {
      return Container(
        decoration: BoxDecoration(
          color: AppColors.divider,
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(Icons.image, color: AppColors.textTertiary, size: 36),
              SizedBox(height: AppStyles.spacing8),
              Text(
                '圖片待上傳',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: AppStyles.fontSizeSmall,
                ),
              ),
            ],
          ),
        ),
      );
    }

    // 预留图片显示逻辑（未来替换为网络图片）
    return Container(
      decoration: BoxDecoration(
        color: AppColors.divider,
      ),
      child: const Center(
        child: Text(
          '圖片載入中...',
          style: TextStyle(
            color: AppColors.textSecondary,
            fontSize: AppStyles.fontSizeSmall,
          ),
        ),
      ),
    );
  }

  // 售价徽标：右下角绿色背景、白色文字
  Widget _buildPriceBadge() {
    final String text = price ?? '價格待定';
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppStyles.spacing12,
        vertical: AppStyles.spacing8,
      ),
      decoration: BoxDecoration(
        color: AppColors.success,
        borderRadius: BorderRadius.circular(AppStyles.radiusMedium),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: AppStyles.fontSizeCaption,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
