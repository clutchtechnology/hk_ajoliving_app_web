import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

/// 屋苑成交卡片数据模型
class EstateTransactionCardData {
  final String imageUrl;
  final String estateName; // 小区名字
  final int transactionCount; // 成交宗数
  final int listingCount; // 放盘数据
  final int rentalCount; // 租盘数量
  final double avgPrice; // 平均价格（万）
  final VoidCallback? onTap;

  EstateTransactionCardData({
    required this.imageUrl,
    required this.estateName,
    required this.transactionCount,
    required this.listingCount,
    required this.rentalCount,
    required this.avgPrice,
    this.onTap,
  });
}

/// 屋苑成交卡片组件
class EstateTransactionCard extends StatelessWidget {
  final EstateTransactionCardData data;
  const EstateTransactionCard({
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
                // 小区名字
                _buildEstateName(),
                const SizedBox(height: 16),
                // 成交、放盘、租盘信息（限制宽度）
                Container(
                  constraints: const BoxConstraints(maxWidth: 250),
                  child: _buildStats(),
                ),
                const SizedBox(height: 20),
                // 平均价格（限制宽度）
                Container(
                  constraints: const BoxConstraints(maxWidth: 250),
                  child: _buildAveragePrice(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImage() {
    return Container(
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
    );
  }

  Widget _buildEstateName() {
    return Text(
      data.estateName,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      ),
    );
  }

  Widget _buildStats() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildStatItem('成交', '${data.transactionCount}宗'),
        _buildStatItem('放盤', '${data.listingCount}個'),
        _buildStatItem('租盤', '${data.rentalCount}個'),
      ],
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAveragePrice() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          '平均價格',
          style: TextStyle(
            fontSize: 13,
            color: AppColors.textSecondary,
          ),
        ),
        Text(
          '${data.avgPrice.toStringAsFixed(1)}万',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: AppColors.primary,
          ),
        ),
      ],
    );
  }
}
