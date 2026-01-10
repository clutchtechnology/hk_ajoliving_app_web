import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_colors.dart';
import '../widgets/buy_filter_panel.dart';
import '../widgets/ad_rent_card.dart';
import '../widgets/property_list_item.dart';
import '../providers/new_property_provider.dart';

/// 新盘页面
class NewPropertiesPage extends ConsumerStatefulWidget {
  const NewPropertiesPage({super.key});

  @override
  ConsumerState<NewPropertiesPage> createState() => _NewPropertiesPageState();
}

class _NewPropertiesPageState extends ConsumerState<NewPropertiesPage> {
  @override
  void initState() {
    super.initState();
    // 页面加载时获取新盘数据
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(newPropertyProvider.notifier).loadProperties();
    });
  }

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
    final newPropertyState = ref.watch(newPropertyProvider);
    
    const double maxLeftWidth = 1100.0;
    const double maxRightWidth = 600.0;
    const double maxTotalWidth = maxLeftWidth + maxRightWidth + 16.0;

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
                            config: FilterPanelConfig.newProperty,
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
                          // 新盘列表区域
                          if (newPropertyState.isLoading)
                            const Padding(
                              padding: EdgeInsets.all(32.0),
                              child: Center(
                                child: CircularProgressIndicator(),
                              ),
                            )
                          else if (newPropertyState.error != null)
                            Padding(
                              padding: const EdgeInsets.all(32.0),
                              child: Center(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(Icons.error_outline, size: 48, color: AppColors.error),
                                    const SizedBox(height: 16),
                                    Text(
                                      '加載失敗: ${newPropertyState.error}',
                                      style: const TextStyle(color: AppColors.error),
                                    ),
                                    const SizedBox(height: 16),
                                    ElevatedButton(
                                      onPressed: () => ref.read(newPropertyProvider.notifier).loadProperties(),
                                      child: const Text('重試'),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          else if (newPropertyState.response?.properties.isEmpty ?? true)
                            const Padding(
                              padding: EdgeInsets.all(32.0),
                              child: Center(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.search_off, size: 48, color: AppColors.textSecondary),
                                    SizedBox(height: 16),
                                    Text(
                                      '暫無新盤項目',
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
                                  itemCount: newPropertyState.response!.properties.length,
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemBuilder: (context, index) {
                                    final property = newPropertyState.response!.properties[index];
                                    return PropertyListItem(
                                      data: PropertyCardData(
                                        imageUrl: property.coverImage ?? 'https://via.placeholder.com/140',
                                        title: property.name,
                                        district: property.district?.nameZh ?? '未知地區',
                                        estate: property.developer,
                                        location: '共${property.totalUnits}伙',
                                        area: property.layouts?.isNotEmpty == true 
                                            ? property.layouts!.first.saleableArea 
                                            : 0,
                                        propertyType: '新盤',
                                        tags: [
                                          property.status == 'upcoming' ? '即將推出' :
                                          property.status == 'presale' ? '預售中' :
                                          property.status == 'selling' ? '銷售中' : '已完成',
                                          if (property.unitsForSale != null && property.unitsForSale! > 0)
                                            '${property.unitsForSale}伙在售',
                                          if (property.primarySchoolNet != null)
                                            '校網: ${property.primarySchoolNet}',
                                        ],
                                        price: 0, // 使用priceRange代替
                                        priceUnit: property.priceRange,
                                      ),
                                    );
                                  },
                                ),
                                // 分页控件
                                if (newPropertyState.response != null && newPropertyState.response!.totalPages > 1)
                                  Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 16),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        // 上一页按钮
                                        IconButton(
                                          icon: const Icon(Icons.chevron_left),
                                          onPressed: newPropertyState.response!.page > 1
                                              ? () => ref.read(newPropertyProvider.notifier).changePage(
                                                    newPropertyState.response!.page - 1,
                                                  )
                                              : null,
                                        ),
                                        const SizedBox(width: 8),
                                        // 页码
                                        Text(
                                          '${newPropertyState.response!.page} / ${newPropertyState.response!.totalPages}',
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        // 下一页按钮
                                        IconButton(
                                          icon: const Icon(Icons.chevron_right),
                                          onPressed: newPropertyState.response!.page < newPropertyState.response!.totalPages
                                              ? () => ref.read(newPropertyProvider.notifier).changePage(
                                                    newPropertyState.response!.page + 1,
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
}
