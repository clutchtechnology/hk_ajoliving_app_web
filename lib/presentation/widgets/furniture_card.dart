import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_styles.dart';

/// 家具卡片数据模型
class FurnitureCardData {
  final String imageUrl;
  final String title; // 家具标题
  final String description; // 家具详情描述
  final String location; // 位置信息，例如: "銅鑼灣店"
  final List<String> tags; // 标签，例如: ['實木', '北歐風', '現貨', '包送貨']
  final double price; // 价格
  final String? priceUnit; // 例如: "元"
  final bool isFavorite;
  final VoidCallback? onFavoritePressed;
  final VoidCallback? onTap;

  FurnitureCardData({
    required this.imageUrl,
    required this.title,
    required this.description,
    required this.location,
    required this.tags,
    required this.price,
    this.priceUnit = "元",
    this.isFavorite = false,
    this.onFavoritePressed,
    this.onTap,
  });
}

/// 家具列表卡片组件
class FurnitureCard extends StatelessWidget {
  final FurnitureCardData data;
  
  const FurnitureCard({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: data.onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: Column(
            children: [
              _buildCardContent(context),
              const Divider(
                height: 1,
                thickness: 1,
                color: AppColors.border,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCardContent(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 左侧图片
          _buildImage(),
          const SizedBox(width: 12),
          // 右侧内容
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 标题和价格行
                _buildTitleRow(context),
                const SizedBox(height: 8),
                // 详情描述
                _buildDescription(),
                const SizedBox(height: 6),
                // 位置信息
                _buildLocationInfo(),
                const SizedBox(height: 8),
                // 标签
                _buildTags(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImage() {
    return Stack(
      children: [
        Container(
          width: 200,
          height: 150,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Colors.grey[200],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              data.imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: Colors.grey[300],
                  child: const Icon(Icons.image_not_supported),
                );
              },
            ),
          ),
        ),
        // 收藏按钮
        Positioned(
          top: 8,
          right: 8,
          child: GestureDetector(
            onTap: data.onFavoritePressed,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(6),
              child: Icon(
                data.isFavorite ? Icons.favorite : Icons.favorite_border,
                color: data.isFavorite ? Colors.red : Colors.grey,
                size: 20,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTitleRow(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            data.title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
        ),
        const SizedBox(width: 8),
        // 价格显示在右侧（与房产卡片相同位置）
        Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                "HK\$ ${data.price.toStringAsFixed(0)}",
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
              ),
              Text(
                data.priceUnit ?? "元",
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDescription() {
    return Text(
      data.description,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      style: const TextStyle(
        fontSize: 13,
        color: AppColors.textSecondary,
        height: 1.4,
      ),
    );
  }

  Widget _buildLocationInfo() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Icon(Icons.location_on, size: 16, color: AppColors.textSecondary),
        const SizedBox(width: 4),
        Expanded(
          child: Text(
            data.location,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 13,
              color: AppColors.textSecondary,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTags() {
    return Wrap(
      spacing: 6,
      runSpacing: 4,
      children: data.tags.map((tag) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: const Color(0xFFF5F5F5),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            tag,
            style: const TextStyle(
              fontSize: 11,
              color: Color(0xFF666666),
              fontWeight: FontWeight.w500,
            ),
          ),
        );
      }).toList(),
    );
  }
}
