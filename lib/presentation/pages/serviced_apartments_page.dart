import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_colors.dart';
import '../providers/serviced_apartment_provider.dart';
import '../widgets/buy_filter_panel.dart';
import '../widgets/ad_rent_card.dart';
import '../widgets/property_list_item.dart';

/// 服务式住宅页面
class ServicedApartmentsPage extends ConsumerStatefulWidget {
  const ServicedApartmentsPage({super.key});

  @override
  ConsumerState<ServicedApartmentsPage> createState() => _ServicedApartmentsPageState();
}

class _ServicedApartmentsPageState extends ConsumerState<ServicedApartmentsPage> {
  String _selectedRegion = '不限';
  String _selectedCategory = '不限';
  String _selectedPrice = '不限';
  String _selectedAreaType = '實用面積';
  String _selectedArea = '不限';
  String _selectedRooms = '不限';
  final Set<String> _selectedTags = {};
  final Set<String> _selectedMoreOptions = {};
  final Set<String> _selectedFacilities = {};

  @override
  void initState() {
    super.initState();
    // 页面加载时自动获取数据
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(servicedApartmentProvider.notifier).loadApartments();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(servicedApartmentProvider);
    
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
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // 筛选面板
                          BuyFilterPanel(
                            config: FilterPanelConfig.servicedApartment,
                            selectedRegion: _selectedRegion,
                            selectedCategory: _selectedCategory,
                            selectedPrice: _selectedPrice,
                            selectedAreaType: _selectedAreaType,
                            selectedArea: _selectedArea,
                            selectedRooms: _selectedRooms,
                            selectedTags: _selectedTags,
                            selectedMoreOptions: _selectedMoreOptions,
                            selectedFacilities: _selectedFacilities,
                            selectedPriceType: state.filter.priceType == 'daily' ? '日租' : '月租',
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
                            onFacilityToggled: (v) => setState(() {
                              if (_selectedFacilities.contains(v)) {
                                _selectedFacilities.remove(v);
                              } else {
                                _selectedFacilities.add(v);
                              }
                            }),
                            onPriceTypeChanged: (v) {
                              ref.read(servicedApartmentProvider.notifier).togglePriceType();
                            },
                          ),
                          
                          // 内容区域
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: _buildContent(state),
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

  /// 构建内容区域
  Widget _buildContent(ServicedApartmentState state) {
    // 加载中状态
    if (state.isLoading) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(48.0),
          child: CircularProgressIndicator(),
        ),
      );
    }

    // 错误状态
    if (state.error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(48.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
              const SizedBox(height: 16),
              Text(
                '加载失败',
                style: TextStyle(fontSize: 18, color: AppColors.textPrimary),
              ),
              const SizedBox(height: 8),
              Text(
                state.error!,
                style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  ref.read(servicedApartmentProvider.notifier).loadApartments();
                },
                child: const Text('重试'),
              ),
            ],
          ),
        ),
      );
    }

    // 空状态
    if (state.apartments.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(48.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.search_off, size: 64, color: AppColors.textSecondary),
              const SizedBox(height: 16),
              Text(
                '暂无服务式公寓',
                style: TextStyle(fontSize: 18, color: AppColors.textPrimary),
              ),
              const SizedBox(height: 8),
              Text(
                '试试调整筛选条件',
                style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
              ),
            ],
          ),
        ),
      );
    }

    // 成功状态 - 显示列表
    return Column(
      children: [
        // 服务式公寓列表
        ListView.builder(
          itemCount: state.apartments.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            final apartment = state.apartments[index];
            final unit = apartment.units?.isNotEmpty == true ? apartment.units!.first : null;
            
            return PropertyListItem(
              data: PropertyCardData(
                imageUrl: apartment.coverImage ?? 'https://via.placeholder.com/140',
                title: apartment.name,
                district: apartment.district?.nameZh ?? '',
                estate: '服務式公寓',
                location: apartment.address,
                area: unit?.area ?? 0,
                propertyType: unit?.unitType ?? '服務式公寓',
                tags: _buildTags(apartment, unit),
                price: state.filter.priceType == 'daily' 
                    ? (unit?.dailyPrice ?? unit?.monthlyPrice ?? 0)
                    : (unit?.monthlyPrice ?? 0),
                priceUnit: state.filter.priceType == 'daily' ? '元/日' : '元/月',
              ),
            );
          },
        ),
        
        // 分页控件
        if (state.totalPages > 1)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // 上一页
                IconButton(
                  onPressed: state.currentPage > 1
                      ? () => ref.read(servicedApartmentProvider.notifier).previousPage()
                      : null,
                  icon: const Icon(Icons.chevron_left),
                ),
                
                // 页码
                ...List.generate(
                  state.totalPages > 5 ? 5 : state.totalPages,
                  (i) {
                    int pageNum;
                    if (state.totalPages <= 5) {
                      pageNum = i + 1;
                    } else {
                      if (state.currentPage <= 3) {
                        pageNum = i + 1;
                      } else if (state.currentPage >= state.totalPages - 2) {
                        pageNum = state.totalPages - 4 + i;
                      } else {
                        pageNum = state.currentPage - 2 + i;
                      }
                    }
                    
                    final isActive = pageNum == state.currentPage;
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
                        onPressed: () {
                          ref.read(servicedApartmentProvider.notifier).changePage(pageNum);
                        },
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          minimumSize: Size.zero,
                        ),
                        child: Text(
                          pageNum.toString(),
                          style: TextStyle(
                            fontSize: 14,
                            color: isActive ? Colors.white : AppColors.textSecondary,
                            fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
                          ),
                        ),
                      ),
                    );
                  },
                ),
                
                // 下一页
                IconButton(
                  onPressed: state.currentPage < state.totalPages
                      ? () => ref.read(servicedApartmentProvider.notifier).nextPage()
                      : null,
                  icon: const Icon(Icons.chevron_right),
                ),
              ],
            ),
          ),
      ],
    );
  }

  /// 构建标签列表
  List<String> _buildTags(apartment, unit) {
    final tags = <String>[];
    
    if (unit != null) {
      if (unit.bedrooms > 0) {
        tags.add('${unit.bedrooms} 房');
      }
      if (unit.bathrooms != null && unit.bathrooms > 0) {
        tags.add('${unit.bathrooms} 浴室');
      }
    }
    
    tags.add('家具齊全');
    
    if (apartment.minStayDays != null && apartment.minStayDays < 30) {
      tags.add('短租');
    }
    
    if (apartment.rating != null && apartment.rating >= 4.0) {
      tags.add('${apartment.rating.toStringAsFixed(1)}⭐');
    }
    
    return tags;
  }
}
