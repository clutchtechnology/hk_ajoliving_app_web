import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../widgets/buy_filter_panel.dart';
import '../widgets/ad_rent_card.dart';
import '../widgets/property_list_item.dart';

/// 买楼页面
class BuyPage extends StatefulWidget {
  const BuyPage({super.key});

  @override
  State<BuyPage> createState() => _BuyPageState();
}

class _BuyPageState extends State<BuyPage> {
  // 筛选选项状态
  String _selectedRegion = '不限';
  String _selectedCategory = '不限';
  String _selectedPrice = '不限';
  String _selectedAreaType = '實用面積';
  String _selectedArea = '不限';
  String _selectedRooms = '不限';
  final Set<String> _selectedTags = {};
  final Set<String> _selectedMoreOptions = {};

  @override
  Widget build(BuildContext context) {
    // 最大宽度与home页保持一致
    const double maxLeftWidth = 1100.0;
    const double maxRightWidth = 600.0;
    const double maxTotalWidth = maxLeftWidth + maxRightWidth + 16.0; // spacing16

    return Container(
      color: AppColors.background,
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: maxTotalWidth),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 左侧卡片容器
                Flexible(
                  flex: 60,
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: maxLeftWidth),
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.navBarBackground,
                        borderRadius: BorderRadius.circular(8.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 4,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          BuyFilterPanel(
                            selectedRegion: _selectedRegion,
                            selectedCategory: _selectedCategory,
                            selectedPrice: _selectedPrice,
                            selectedAreaType: _selectedAreaType,
                            selectedArea: _selectedArea,
                            selectedRooms: _selectedRooms,
                            selectedTags: _selectedTags,
                            selectedMoreOptions: _selectedMoreOptions,
                            onRegionChanged: (v) => setState(() => _selectedRegion = v),
                            onCategoryChanged: (v) => setState(() => _selectedCategory = v),
                            onPriceChanged: (v) => setState(() => _selectedPrice = v),
                            onAreaTypeChanged: (v) => setState(() => _selectedAreaType = v),
                            onAreaChanged: (v) => setState(() => _selectedArea = v),
                            onRoomsChanged: (v) => setState(() => _selectedRooms = v),
                            onTagToggled: (v) => setState(() {
                              if (_selectedTags.contains(v)) {
                                _selectedTags.remove(v);
                              } else {
                                _selectedTags.add(v);
                              }
                            }),
                            onMoreOptionToggled: (v) => setState(() {
                              if (_selectedMoreOptions.contains(v)) {
                                _selectedMoreOptions.remove(v);
                              } else {
                                _selectedMoreOptions.add(v);
                              }
                            }),
                          ),
                          // 房源列表区域
                          // 动态高度房源列表区域
                          Column(
                            children: [
                              ListView.builder(
                                itemCount: 10,
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) {
                                  return PropertyListItem(
                                    data: PropertyCardData(
                                      imageUrl: 'https://via.placeholder.com/140',
                                      title: '尖沙咀高級海景豪宅 #${index + 1}',
                                      district: '九龍城',
                                      estate: '淘大商場',
                                      location: '6座 低層 C室',
                                      area: 700,
                                      propertyType: '住宅',
                                      tags: ['4 房', '3 浴室', '近地鐵站', '私人屋苑'],
                                      price: 1250 + (index * 100).toDouble(),
                                      priceUnit: '万',
                                    ),
                                  );
                                },
                              ),
                              // 页码选择器
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: List.generate(5, (i) {
                                    final isActive = i == 0;
                                    return Container(
                                      width: 36,
                                      height: 36,
                                      margin: const EdgeInsets.symmetric(horizontal: 4),
                                      decoration: BoxDecoration(
                                        color: isActive ? AppColors.primary : AppColors.background,
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(
                                          color: isActive ? AppColors.primary : AppColors.border,
                                        ),
                                      ),
                                      child: TextButton(
                                        onPressed: () {},
                                        style: TextButton.styleFrom(
                                          padding: EdgeInsets.zero,
                                          minimumSize: Size.zero,
                                        ),
                                        child: Text(
                                          (i + 1).toString(),
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: isActive ? Colors.white : AppColors.textSecondary,
                                            fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
                                          ),
                                        ),
                                      ),
                                    );
                                  }),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                // 右侧卡片容器
                Flexible(
                  flex: 20,
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: maxRightWidth),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: const [
                        SizedBox(height: 16),
                        AdRentCard(width: 260, height: 120),
                        AdRentCard(width: 260, height: 180, title: '品牌曝光', subtitle: '黃金廣告位，歡迎合作', icon: Icons.star),
                        AdRentCard(width: 260, height: 110, title: '聯絡客服', subtitle: '定制推廣方案', icon: Icons.support_agent),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // _buildFilterSection 已被 BuyFilterPanel 替代

  /// 构建筛选行
  Widget _buildFilterRow({
    required String label,
    required List<String> options,
    required String selectedValue,
    required ValueChanged<String> onSelected,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 80,
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Expanded(
          child: Wrap(
            spacing: 16,
            runSpacing: 8,
            children: options.map((option) {
              final isSelected = option == selectedValue;
              final isNoLimit = option == '不限';
              return InkWell(
                onTap: () => onSelected(option),
                child: Text(
                  option,
                  style: TextStyle(
                    fontSize: 14,
                    color: isSelected
                        ? (isNoLimit ? AppColors.error : AppColors.primary)
                        : AppColors.textSecondary,
                    fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  /// 构建面积筛选行（带类型切换）
  Widget _buildAreaFilterRow() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 80,
          child: Text(
            '面積:',
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 面积类型切换
              Row(
                children: [
                  _buildAreaTypeOption('實用面積'),
                  const SizedBox(width: 16),
                  _buildAreaTypeOption('建築面積'),
                ],
              ),
              const SizedBox(height: 8),
              // 面积选项
              Wrap(
                spacing: 16,
                runSpacing: 8,
                children: ['不限', '自定', '300呎以下', '300-500呎', '500-1000呎', '1000-2000呎', '2000呎以上'].map((option) {
                  final isSelected = option == _selectedArea;
                  final isNoLimit = option == '不限';
                  return InkWell(
                    onTap: () => setState(() => _selectedArea = option),
                    child: Text(
                      option,
                      style: TextStyle(
                        fontSize: 14,
                        color: isSelected
                            ? (isNoLimit ? AppColors.error : AppColors.primary)
                            : AppColors.textSecondary,
                        fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// 构建面积类型选项
  Widget _buildAreaTypeOption(String type) {
    final isSelected = type == _selectedAreaType;
    return InkWell(
      onTap: () => setState(() => _selectedAreaType = type),
      child: Text(
        type,
        style: TextStyle(
          fontSize: 14,
          color: isSelected ? AppColors.error : AppColors.primary,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  /// 构建标签筛选行（多选）
  Widget _buildTagFilterRow({
    required String label,
    required List<String> options,
    required Set<String> selectedValues,
    required ValueChanged<String> onToggle,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 80,
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Expanded(
          child: Wrap(
            spacing: 16,
            runSpacing: 8,
            children: options.map((option) {
              final isSelected = selectedValues.contains(option);
              return InkWell(
                onTap: () => onToggle(option),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.play_arrow,
                      size: 12,
                      color: isSelected ? AppColors.primary : AppColors.textSecondary,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      option,
                      style: TextStyle(
                        fontSize: 14,
                        color: isSelected ? AppColors.primary : AppColors.textSecondary,
                        fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
