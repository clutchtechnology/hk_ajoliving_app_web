import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_styles.dart';
import '../../data/models/property.dart';

/// 房源卡片组件
class PropertyCard extends StatelessWidget {
  const PropertyCard({
    super.key,
    this.property,
    this.estateName = '示例屋苑',
    this.areaSqft,
    this.price,
    this.imageUrl,
  });

  final Property? property;
  final String estateName;
  final double? areaSqft; // 面积（平方尺）
  final String? price; // 售价文案，如 "HK$ 8,800,000"
  final String? imageUrl;
  
  // 获取屋苑名称
  String get _estateName => property?.title ?? estateName;
  
  // 获取面积
  double? get _areaSqft => property?.area ?? areaSqft;
  
  // 获取价格
  String get _price => property?.formattedPrice ?? price ?? '價格待定';
  
  // 获取图片URL
  String? get _imageUrl => property?.imageUrl ?? imageUrl;

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
                      padding: const EdgeInsets.all(AppStyles.spacing12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // 上部分：标题区域（占 2/3）
                          Expanded(
                            flex: 2,
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                _estateName,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: AppStyles.fontSizeBody,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textPrimary,
                                  height: 1.3,
                                ),
                              ),
                            ),
                          ),

                          // 下部分：面积和价格（占 1/3）
                          Expanded(
                            flex: 1,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                // 左侧：面积
                                Expanded(
                                  child: Text(
                                    _areaSqft != null
                                        ? '${_areaSqft!.toStringAsFixed(0)} 尺'
                                        : '— 尺',
                                    style: const TextStyle(
                                      fontSize: AppStyles.fontSizeCaption,
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                ),

                                // 右侧：价格徽标
                                _buildPriceBadge(),
                              ],
                            ),
                          ),
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
    if (_imageUrl == null || _imageUrl!.isEmpty) {
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

    // 显示网络图片
    return Image.network(
      _imageUrl!,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        return Container(
          decoration: BoxDecoration(
            color: AppColors.divider,
          ),
          child: const Center(
            child: Icon(Icons.broken_image, color: AppColors.textTertiary, size: 36),
          ),
        );
      },
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return Container(
          decoration: BoxDecoration(
            color: AppColors.divider,
          ),
          child: const Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }

  // 售价徽标：右下角绿色背景、白色文字
  Widget _buildPriceBadge() {
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
        _price,
        style: const TextStyle(
          color: Colors.white,
          fontSize: AppStyles.fontSizeCaption,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
