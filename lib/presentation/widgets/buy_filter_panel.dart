import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

/// 筛选面板类型枚举
enum FilterPanelType {
  buy,      // 买楼
  rent,     // 租屋
  newProperty,  // 新盘
}

/// 筛选面板配置
class FilterPanelConfig {
  final String priceLabel;           // 价格标签（售價/租金）
  final List<String> priceOptions;   // 价格选项
  final bool showCategory;           // 是否显示类别筛选
  final bool showRooms;              // 是否显示房间数量筛选
  final bool showTags;               // 是否显示标签筛选
  final bool showMoreOptions;        // 是否显示更多选项
  final bool showArea;               // 是否显示面积筛选
  final bool showFacilities;         // 是否显示设施筛选
  final bool showPriceTypeSwitch;    // 是否显示价格类型切换（日租/月租）
  final bool showBuildingAge;        // 是否显示楼龄筛选
  final bool showSearchBox;          // 是否显示搜索框
  final List<String>? priceTypes;    // 价格类型选项（如：日租、月租）
  final Map<String, List<String>>? priceOptionsByType;  // 不同价格类型对应的价格选项
  final List<String>? categoryOptions;  // 自定义类别选项
  final List<String>? tagOptions;       // 自定义标签选项
  final List<String>? moreOptions;      // 自定义更多选项
  final List<String>? facilityOptions;  // 设施选项
  final List<String>? buildingAgeOptions;  // 楼龄选项
  final String? searchHint;          // 搜索框提示文字

  const FilterPanelConfig({
    this.priceLabel = '售價:',
    this.priceOptions = const ['不限', '自定', '200萬以下', '200萬-400萬', '400萬-800萬', '800萬-2000萬', '2000萬以上'],
    this.showCategory = true,
    this.showRooms = true,
    this.showTags = true,
    this.showMoreOptions = true,
    this.showArea = true,
    this.showFacilities = false,
    this.showPriceTypeSwitch = false,
    this.showBuildingAge = false,
    this.showSearchBox = false,
    this.priceTypes,
    this.priceOptionsByType,
    this.categoryOptions,
    this.tagOptions,
    this.moreOptions,
    this.facilityOptions,
    this.buildingAgeOptions,
    this.searchHint,
  });

  /// 买楼页面配置
  static const FilterPanelConfig buy = FilterPanelConfig(
    priceLabel: '售價:',
    priceOptions: ['不限', '自定', '200萬以下', '200萬-400萬', '400萬-800萬', '800萬-2000萬', '2000萬以上'],
  );

  /// 租屋页面配置
  static const FilterPanelConfig rent = FilterPanelConfig(
    priceLabel: '租價:',
    priceOptions: ['不限', '自定', '5千以下', '5千-1萬', '1萬-2萬', '2萬-4萬', '4萬-8萬', '8萬以上'],
  );

  /// 新盘页面配置
  static const FilterPanelConfig newProperty = FilterPanelConfig(
    priceLabel: '售價:',
    priceOptions: ['不限', '自定', '500萬以下', '500萬-1000萬', '1000萬-2000萬', '2000萬-5000萬', '5000萬以上'],
    showTags: false,
    showMoreOptions: false,
  );

  /// 服务式住宅页面配置
  static const FilterPanelConfig servicedApartment = FilterPanelConfig(
    priceLabel: '價錢:',
    priceOptions: ['不限', '自定', '500以下', '500-1000', '1000-2000', '2000-5000', '5000以上'],
    showCategory: false,
    showRooms: false,
    showTags: false,
    showMoreOptions: false,
    showFacilities: true,
    showPriceTypeSwitch: true,
    priceTypes: ['日租', '月租'],
    priceOptionsByType: {
      '日租': ['不限', '自定', '500以下', '500-1000', '1000-2000', '2000-5000', '5000以上'],
      '月租': ['不限', '自定', '1萬以下', '1萬-2萬', '2萬-4萬', '4萬-8萬', '8萬以上'],
    },
    facilityOptions: ['Wi-Fi', '健身室', '游泳池', '停車場', '24小時保安', '會所設施', '洗衣設備', '廚房設備'],
  );

  /// 屋苑成交页面配置
  static const FilterPanelConfig transaction = FilterPanelConfig(
    priceLabel: '呎價:',
    priceOptions: ['不限', '自定', '5千以下', '5千-1萬', '1萬-1.5萬', '1.5萬-2萬', '2萬-3萬', '3萬以上'],
    showCategory: true,
    showRooms: false,
    showTags: false,
    showMoreOptions: false,
    showArea: false,
    showBuildingAge: true,
  );

  /// 家具页面配置
  static const FilterPanelConfig furniture = FilterPanelConfig(
    priceLabel: '價錢:',
    priceOptions: ['不限', '自定', '500以下', '500-1000', '1000-3000', '3000-5000', '5000-10000', '10000以上'],
    showCategory: true,
    categoryOptions: ['不限', '全新', '二手', '個人商品'],
    showRooms: false,
    showTags: false,
    showMoreOptions: false,
    showArea: false,
    showSearchBox: true,
  );
}

class BuyFilterPanel extends StatelessWidget {
  final String selectedRegion;
  final String selectedCategory;
  final String selectedPrice;
  final String selectedAreaType;
  final String selectedArea;
  final String selectedRooms;
  final String selectedBuildingAge;      // 楼龄选项
  final String searchText;               // 搜索文字
  final Set<String> selectedTags;
  final Set<String> selectedMoreOptions;
  final Set<String> selectedFacilities;  // 设施选项
  final String selectedPriceType;        // 价格类型（日租/月租）
  final ValueChanged<String> onRegionChanged;
  final ValueChanged<String> onCategoryChanged;
  final ValueChanged<String> onPriceChanged;
  final ValueChanged<String> onAreaTypeChanged;
  final ValueChanged<String> onAreaChanged;
  final ValueChanged<String> onRoomsChanged;
  final ValueChanged<String>? onBuildingAgeChanged;  // 楼龄切换回调
  final ValueChanged<String>? onSearchChanged;       // 搜索文字变化回调
  final VoidCallback? onSearchSubmitted;             // 搜索提交回调
  final ValueChanged<String> onTagToggled;
  final ValueChanged<String> onMoreOptionToggled;
  final ValueChanged<String>? onFacilityToggled;  // 设施切换回调
  final ValueChanged<String>? onPriceTypeChanged; // 价格类型切换回调
  
  /// 筛选面板配置，默认为买楼配置
  final FilterPanelConfig config;

  const BuyFilterPanel({
    super.key,
    required this.selectedRegion,
    required this.selectedCategory,
    required this.selectedPrice,
    required this.selectedAreaType,
    required this.selectedArea,
    required this.selectedRooms,
    this.selectedBuildingAge = '不限',
    this.searchText = '',
    required this.selectedTags,
    required this.selectedMoreOptions,
    this.selectedFacilities = const {},
    this.selectedPriceType = '日租',
    required this.onRegionChanged,
    required this.onCategoryChanged,
    required this.onPriceChanged,
    required this.onAreaTypeChanged,
    required this.onAreaChanged,
    required this.onRoomsChanged,
    this.onBuildingAgeChanged,
    this.onSearchChanged,
    this.onSearchSubmitted,
    required this.onTagToggled,
    required this.onMoreOptionToggled,
    this.onFacilityToggled,
    this.onPriceTypeChanged,
    this.config = FilterPanelConfig.buy,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: AppColors.border),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildFilterRow(
            label: '區域:',
            options: ['不限', '全港', '香港島', '九龍', '新界', '離島', '海外', '小學校網', '中學校網', '大學/大專院校'],
            selectedValue: selectedRegion,
            onSelected: onRegionChanged,
          ),
          if (config.showCategory) ...[
            const SizedBox(height: 12),
            _buildFilterRow(
              label: '類別:',
              options: config.categoryOptions ?? ['不限', '住宅', '車位', '工商', '店舖', '土地', '海外'],
              selectedValue: selectedCategory,
              onSelected: onCategoryChanged,
            ),
          ],
          const SizedBox(height: 12),
          // 价格筛选（支持日租/月租切换）
          if (config.showPriceTypeSwitch && config.priceTypes != null) ...[
            _buildPriceFilterWithTypeSwitch(),
          ] else ...[
            _buildFilterRow(
              label: config.priceLabel,
              options: config.priceOptions,
              selectedValue: selectedPrice,
              onSelected: onPriceChanged,
            ),
          ],
          if (config.showArea) ...[
            const SizedBox(height: 12),
            _buildAreaFilterRow(),
          ],
          if (config.showRooms) ...[
            const SizedBox(height: 12),
            _buildFilterRow(
              label: '房間數量:',
              options: ['不限', '開放式間隔', '1房', '2房', '3房', '4房', '5房以上'],
              selectedValue: selectedRooms,
              onSelected: onRoomsChanged,
            ),
          ],
          if (config.showBuildingAge) ...[
            const SizedBox(height: 12),
            _buildFilterRow(
              label: '樓齡:',
              options: config.buildingAgeOptions ?? ['不限', '5年以下', '5-10年', '10-20年', '20-30年', '30年以上'],
              selectedValue: selectedBuildingAge,
              onSelected: onBuildingAgeChanged ?? (_) {},
            ),
          ],
          if (config.showFacilities && config.facilityOptions != null) ...[
            const SizedBox(height: 12),
            _buildTagFilterRow(
              label: '設施:',
              options: config.facilityOptions!,
              selectedValues: selectedFacilities,
              onToggle: onFacilityToggled ?? (_) {},
            ),
          ],
          if (config.showTags) ...[
            const SizedBox(height: 12),
            _buildTagFilterRow(
              label: '標籤:',
              options: config.tagOptions ?? ['有景觀', '有裝修', '獨家盤', '連車位', '單位特色', '工商專用'],
              selectedValues: selectedTags,
              onToggle: onTagToggled,
            ),
          ],
          if (config.showMoreOptions) ...[
            const SizedBox(height: 12),
            _buildTagFilterRow(
              label: '更多:',
              options: config.moreOptions ?? ['座向(客廳)', '業主或代理', '屋苑樓齡', '樓層', '廚房類型', '廚房煮食模式', '發展商', '更多選項'],
              selectedValues: selectedMoreOptions,
              onToggle: onMoreOptionToggled,
            ),
          ],
          if (config.showSearchBox) ...[
            const SizedBox(height: 12),
            _buildSearchRow(),
          ],
        ],
      ),
    );
  }

  Widget _buildSearchRow() {
    return Row(
      children: [
        SizedBox(
          width: 80,
          child: Text(
            '搜索:',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
          ),
        ),
        Expanded(
          child: Container(
            height: 36,
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: AppColors.border),
            ),
            child: TextField(
              controller: TextEditingController(text: searchText),
              decoration: InputDecoration(
                hintText: config.searchHint,
                hintStyle: TextStyle(
                  color: AppColors.textTertiary,
                  fontSize: 14,
                ),
                prefixIcon: Icon(
                  Icons.search,
                  color: AppColors.textSecondary,
                  size: 20,
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
              style: const TextStyle(fontSize: 14),
              onChanged: onSearchChanged,
              onSubmitted: (_) => onSearchSubmitted?.call(),
            ),
          ),
        ),
        const SizedBox(width: 12),
        ElevatedButton(
          onPressed: onSearchSubmitted,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          child: const Text('搜索'),
        ),
      ],
    );
  }

  /// 构建带价格类型切换的价格筛选行（日租/月租）
  Widget _buildPriceFilterWithTypeSwitch() {
    final priceTypes = config.priceTypes ?? ['日租', '月租'];
    final currentPriceOptions = config.priceOptionsByType?[selectedPriceType] ?? config.priceOptions;
    
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 80,
          child: Text(
            config.priceLabel,
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
              // 价格类型切换（日租/月租）
              Row(
                children: priceTypes.map((type) {
                  final isSelected = type == selectedPriceType;
                  return Padding(
                    padding: const EdgeInsets.only(right: 16),
                    child: InkWell(
                      onTap: () => onPriceTypeChanged?.call(type),
                      child: Text(
                        type,
                        style: TextStyle(
                          fontSize: 14,
                          color: isSelected ? AppColors.error : AppColors.primary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 8),
              // 价格选项
              Wrap(
                spacing: 16,
                runSpacing: 8,
                children: currentPriceOptions.map((option) {
                  final isSelected = option == selectedPrice;
                  final isNoLimit = option == '不限';
                  return InkWell(
                    onTap: () => onPriceChanged(option),
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
              Row(
                children: [
                  _buildAreaTypeOption('實用面積'),
                  const SizedBox(width: 16),
                  _buildAreaTypeOption('建築面積'),
                ],
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 16,
                runSpacing: 8,
                children: ['不限', '自定', '300呎以下', '300-500呎', '500-1000呎', '1000-2000呎', '2000呎以上'].map((option) {
                  final isSelected = option == selectedArea;
                  final isNoLimit = option == '不限';
                  return InkWell(
                    onTap: () => onAreaChanged(option),
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

  Widget _buildAreaTypeOption(String type) {
    final isSelected = type == selectedAreaType;
    return InkWell(
      onTap: () => onAreaTypeChanged(type),
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
