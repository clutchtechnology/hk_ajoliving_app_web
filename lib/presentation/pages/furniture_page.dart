import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../widgets/buy_filter_panel.dart';
import '../widgets/ad_rent_card.dart';
import '../widgets/furniture_card.dart';

/// 家具页面
class FurniturePage extends StatefulWidget {
  const FurniturePage({super.key});

  @override
  State<FurniturePage> createState() => _FurniturePageState();
}

class _FurniturePageState extends State<FurniturePage> {
  String _selectedRegion = '不限';
  String _selectedCategory = '不限';
  String _selectedPrice = '不限';
  String _selectedAreaType = '實用面積';
  String _selectedArea = '不限';
  String _selectedRooms = '不限';
  final Set<String> _selectedTags = {};
  final Set<String> _selectedMoreOptions = {};
  String _searchText = '';

  void _performSearch() {
    // TODO: 实现搜索逻辑
    debugPrint('搜索: $_searchText');
  }

  @override
  Widget build(BuildContext context) {
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
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            BuyFilterPanel(
                              config: FilterPanelConfig.furniture,
                              selectedRegion: _selectedRegion,
                              selectedCategory: _selectedCategory,
                              selectedPrice: _selectedPrice,
                              selectedAreaType: _selectedAreaType,
                              selectedArea: _selectedArea,
                              selectedRooms: _selectedRooms,
                              selectedTags: _selectedTags,
                              selectedMoreOptions: _selectedMoreOptions,
                              searchText: _searchText,
                              onRegionChanged: (v) => setState(() => _selectedRegion = v),
                              onCategoryChanged: (v) => setState(() => _selectedCategory = v),
                              onPriceChanged: (v) => setState(() => _selectedPrice = v),
                              onAreaTypeChanged: (v) => setState(() => _selectedAreaType = v),
                              onAreaChanged: (v) => setState(() => _selectedArea = v),
                              onRoomsChanged: (v) => setState(() => _selectedRooms = v),
                              onSearchChanged: (v) => setState(() => _searchText = v),
                              onSearchSubmitted: _performSearch,
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
                            // 列表布局展示家具卡片
                            Column(
                              children: [
                                ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: 12,
                                  itemBuilder: (context, index) {
                                    return FurnitureCard(
                                      data: FurnitureCardData(
                                        title: _getFurnitureTitle(index),
                                        description: _getFurnitureDescription(index),
                                        location: _getFurnitureLocation(index),
                                        tags: _getFurnitureTags(index),
                                        price: (2800 + (index * 500)).toDouble(),
                                        priceUnit: '元',
                                        imageUrl: '',
                                        isFavorite: false,
                                        onTap: () {
                                          debugPrint('点击家具 #${index + 1}');
                                        },
                                        onFavoritePressed: () {
                                          debugPrint('收藏家具 #${index + 1}');
                                        },
                                      ),
                                    );
                                  },
                                ),
                                // 分页器
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

  // 生成家具标题
  String _getFurnitureTitle(int index) {
    final titles = [
      '北歐風沙發',
      '實木餐桌',
      '雙人床架',
      '書櫃組合',
      '茶几組',
      '辦公椅',
      '衣櫃',
      '梳化床',
      '電視櫃',
      '鞋櫃',
      '床頭櫃',
      '餐椅套裝',
    ];
    return titles[index % titles.length];
  }

  // 生成家具描述
  String _getFurnitureDescription(int index) {
    final descriptions = [
      '全新進口布藝沙發，三人座，可拆洗，舒適耐用',
      '優質實木材質，簡約設計，可容納6人',
      '現代簡約設計，堅固耐用，包送貨安裝',
      '多層收納空間，環保材質，適合書房',
      '時尚設計，鋼化玻璃檯面，易清潔',
      '人體工學設計，透氣網布，久坐不累',
      '大容量收納，推拉門設計，節省空間',
      '多功能設計，可變床使用，適合小戶型',
      '簡約現代風格，多層收納，承重力強',
      '多層設計，可放多雙鞋，防塵防潮',
      '配套床架使用，帶抽屜收納，實用美觀',
      '包含4張餐椅，符合人體工學，舒適穩固',
    ];
    return descriptions[index % descriptions.length];
  }

  // 生成家具位置
  String _getFurnitureLocation(int index) {
    final locations = [
      '尖沙咀',
      '銅鑼灣',
      '旺角',
      '中環',
      '九龍灣',
      '觀塘',
    ];
    return locations[index % locations.length];
  }

  // 生成家具标签
  List<String> _getFurnitureTags(int index) {
    final tagsList = [
      ['沙發', '北歐風', '全新'],
      ['餐桌', '實木', '優惠中'],
      ['床架', '現代', '包送貨'],
      ['書櫃', '環保', '組合式'],
      ['茶几', '時尚', '易清潔'],
      ['辦公椅', '人體工學', '透氣'],
      ['衣櫃', '大容量', '推拉門'],
      ['梳化床', '多功能', '節省空間'],
      ['電視櫃', '簡約', '多層'],
      ['鞋櫃', '防塵', '多層'],
      ['床頭櫃', '配套', '收納'],
      ['餐椅', '套裝', '舒適'],
    ];
    return tagsList[index % tagsList.length];
  }
}
