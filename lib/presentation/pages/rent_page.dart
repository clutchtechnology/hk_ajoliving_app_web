import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_colors.dart';
import '../widgets/buy_filter_panel.dart';
import '../widgets/ad_rent_card.dart';
import '../widgets/property_list_item.dart';
import '../providers/property_provider.dart';

/// 租屋页面
class RentPage extends ConsumerStatefulWidget {
  const RentPage({super.key});

  @override
  ConsumerState<RentPage> createState() => _RentPageState();
}

class _RentPageState extends ConsumerState<RentPage> {
  @override
  void initState() {
    super.initState();
    // 页面加载时获取租房房源数据
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(rentPropertyProvider.notifier).loadProperties();
    });
  }

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
    final rentPropertyState = ref.watch(rentPropertyProvider);
    
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
                            config: FilterPanelConfig.rent,
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
                          if (rentPropertyState.isLoading)
                            const Padding(
                              padding: EdgeInsets.all(32.0),
                              child: Center(
                                child: CircularProgressIndicator(),
                              ),
                            )
                          else if (rentPropertyState.error != null)
                            Padding(
                              padding: const EdgeInsets.all(32.0),
                              child: Center(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(Icons.error_outline, size: 48, color: AppColors.error),
                                    const SizedBox(height: 16),
                                    Text(
                                      '加載失敗: ${rentPropertyState.error}',
                                      style: const TextStyle(color: AppColors.error),
                                    ),
                                    const SizedBox(height: 16),
                                    ElevatedButton(
                                      onPressed: () => ref.read(rentPropertyProvider.notifier).loadProperties(),
                                      child: const Text('重試'),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          else if (rentPropertyState.response?.properties.isEmpty ?? true)
                            const Padding(
                              padding: EdgeInsets.all(32.0),
                              child: Center(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.search_off, size: 48, color: AppColors.textSecondary),
                                    SizedBox(height: 16),
                                    Text(
                                      '暫無租房房源',
                                      style: TextStyle(color: AppColors.textSecondary, fontSize: 16),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          else
                            Column(
                              children: [
                                ListView.builder(
                                  itemCount: rentPropertyState.response!.properties.length,
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemBuilder: (context, index) {
                                    final property = rentPropertyState.response!.properties[index];
                                    return PropertyListItem(
                                      data: PropertyCardData(
                                        imageUrl: property.coverImage ?? 'https://via.placeholder.com/140',
                                        title: property.title,
                                        district: property.district?.nameZh ?? '未知地區',
                                        estate: property.buildingName ?? '未知大廈',
                                        location: '',
                                        area: property.area,
                                        propertyType: property.propertyType ?? '住宅',
                                        tags: [
                                          if (property.bedrooms != null) '${property.bedrooms} 房',
                                          if (property.bathrooms != null) '${property.bathrooms} 浴室',
                                        ],
                                        price: property.price / 10000,
                                        priceUnit: '萬/月',
                                      ),
                                    );
                                  },
                                ),
                                // 分页控件
                                if (rentPropertyState.response != null && rentPropertyState.response!.totalPages > 1)
                                  Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 16),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        // 上一页按钮
                                        IconButton(
                                          icon: const Icon(Icons.chevron_left),
                                          onPressed: rentPropertyState.response!.page > 1
                                              ? () => ref.read(rentPropertyProvider.notifier).changePage(
                                                    rentPropertyState.response!.page - 1,
                                                  )
                                              : null,
                                        ),
                                        const SizedBox(width: 8),
                                        // 页码
                                        Text(
                                          '${rentPropertyState.response!.page} / ${rentPropertyState.response!.totalPages}',
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        // 下一页按钮
                                        IconButton(
                                          icon: const Icon(Icons.chevron_right),
                                          onPressed: rentPropertyState.response!.page < rentPropertyState.response!.totalPages
                                              ? () => ref.read(rentPropertyProvider.notifier).changePage(
                                                    rentPropertyState.response!.page + 1,
                                                  )
                                              : null,
                                        ),
                                      ],
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
