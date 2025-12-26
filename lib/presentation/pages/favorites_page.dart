import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../widgets/property_list_item.dart';
import '../widgets/furniture_card.dart';

/// 收藏页面
/// 展示用户收藏的房源和家具，分为三类：买楼、租屋/服务式住宅/新盘、家具
class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const double maxCardWidth = 1716.0; // 与估价页一致

    return Container(
      color: AppColors.background,
      child: SingleChildScrollView(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: maxCardWidth),
            child: FractionallySizedBox(
              widthFactor: 0.8,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.navBarBackground,
                    borderRadius: BorderRadius.circular(8.0),
                    boxShadow: const [
                      BoxShadow(
                        color: Color.fromRGBO(0, 0, 0, 0.05),
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // 标题区域
                      Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Row(
                          children: const [
                            Icon(
                              Icons.favorite,
                              color: AppColors.primary,
                              size: 28,
                            ),
                            SizedBox(width: 12),
                            Text(
                              '我的收藏',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Divider(height: 1, color: AppColors.border),
                      // Tab 导航栏
                      _buildTabBar(),
                      const Divider(height: 1, color: AppColors.border),
                      // Tab 内容区域 - 使用固定高度
                      SizedBox(
                        height: MediaQuery.of(context).size.height - 300,
                        child: TabBarView(
                          controller: _tabController,
                          children: [
                            _buildBuyTab(),
                            _buildRentTab(),
                            _buildFurnitureTab(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// 构建 Tab 导航栏
  Widget _buildTabBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: TabBar(
        controller: _tabController,
        isScrollable: false,
        indicatorColor: AppColors.primary,
        indicatorWeight: 3,
        labelColor: AppColors.primary,
        unselectedLabelColor: AppColors.textSecondary,
        labelStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.normal,
        ),
        tabs: const [
          Tab(text: '買樓'),
          Tab(text: '租屋 / 服務式住宅 / 新盤'),
          Tab(text: '家具'),
        ],
      ),
    );
  }

  /// 构建买楼 Tab
  Widget _buildBuyTab() {
    return _buildPropertyList(
      properties: _getMockBuyProperties(),
      emptyMessage: '還沒有收藏任何買樓房源',
    );
  }

  /// 构建租屋/服务式住宅/新盘 Tab
  Widget _buildRentTab() {
    return _buildPropertyList(
      properties: _getMockRentProperties(),
      emptyMessage: '還沒有收藏任何租屋房源',
    );
  }

  /// 构建家具 Tab
  Widget _buildFurnitureTab() {
    return _buildFurnitureList(
      furniture: _getMockFurniture(),
      emptyMessage: '還沒有收藏任何家具',
    );
  }

  /// 构建房源列表
  Widget _buildPropertyList({
    required List<PropertyCardData> properties,
    required String emptyMessage,
  }) {
    if (properties.isEmpty) {
      return _buildEmptyState(emptyMessage);
    }

    return SingleChildScrollView(
      child: Column(
        children: [
          ListView.builder(
            itemCount: properties.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return PropertyListItem(
                data: properties[index],
              );
            },
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  /// 构建家具列表
  Widget _buildFurnitureList({
    required List<FurnitureCardData> furniture,
    required String emptyMessage,
  }) {
    if (furniture.isEmpty) {
      return _buildEmptyState(emptyMessage);
    }

    return SingleChildScrollView(
      child: Column(
        children: [
          ListView.builder(
            itemCount: furniture.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return FurnitureCard(
                data: furniture[index],
              );
            },
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  /// 构建空状态
  Widget _buildEmptyState(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(48.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.favorite_border,
              size: 80,
              color: Color.fromRGBO(100, 116, 139, 0.3),
            ),
            const SizedBox(height: 24),
            Text(
              message,
              style: const TextStyle(
                fontSize: 16,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // TODO: 导航到浏览页面
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                '去逛逛',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ==================== Mock 数据 ====================

  /// 获取模拟买楼房源数据
  List<PropertyCardData> _getMockBuyProperties() {
    return List.generate(5, (index) {
      return PropertyCardData(
        imageUrl: 'https://via.placeholder.com/200x150',
        title: '九龍灣豪華公寓 #${index + 1}',
        district: '九龍城',
        estate: '淘大花園',
        location: '${index + 1}座 中層 B室',
        area: 650 + (index * 50),
        propertyType: '住宅',
        tags: ['3 房', '2 浴室', '近地鐵站', '私人屋苑'],
        price: 800 + (index * 100).toDouble(),
        priceUnit: '万',
        isFavorite: true,
        onFavoritePressed: () {
          setState(() {
            // TODO: 取消收藏
          });
        },
        onTap: () {
          // TODO: 导航到详情页
        },
      );
    });
  }

  /// 获取模拟租屋房源数据
  List<PropertyCardData> _getMockRentProperties() {
    return List.generate(4, (index) {
      return PropertyCardData(
        imageUrl: 'https://via.placeholder.com/200x150',
        title: '中環服務式公寓 #${index + 1}',
        district: '中西區',
        estate: '中環中心',
        location: '${index + 10}座 高層 A室',
        area: 500 + (index * 30),
        propertyType: index % 2 == 0 ? '服務式住宅' : '住宅',
        tags: ['2 房', '1 浴室', '包家具', '近商圈'],
        price: 25000 + (index * 5000).toDouble(),
        priceUnit: '元/月',
        isFavorite: true,
        onFavoritePressed: () {
          setState(() {
            // TODO: 取消收藏
          });
        },
        onTap: () {
          // TODO: 导航到详情页
        },
      );
    });
  }

  /// 获取模拟家具数据
  List<FurnitureCardData> _getMockFurniture() {
    return List.generate(6, (index) {
      final titles = ['北歐實木餐桌', '現代簡約沙發', '原木書櫃', '舒適雙人床', '時尚茶几', '多功能電視櫃'];
      final descriptions = [
        '精選進口橡木，環保漆面，可容納6人',
        '高級布藝面料，人體工學設計，柔軟舒適',
        '多層收納空間，承重力強，適合書房客廳',
        '優質床架配優質床墊，包送貨安裝',
        '鋼化玻璃桌面，堅固耐用，易於清潔',
        '大容量儲物空間，多種尺寸可選',
      ];
      final locations = ['銅鑼灣店', '旺角店', '尖沙咀店', '中環店'];
      final prices = [3500.0, 8800.0, 2800.0, 6500.0, 1200.0, 3200.0];

      return FurnitureCardData(
        imageUrl: 'https://via.placeholder.com/200x150',
        title: titles[index],
        description: descriptions[index],
        location: locations[index % locations.length],
        tags: ['實木', '包送貨', '現貨', '質保2年'],
        price: prices[index],
        priceUnit: '元',
        isFavorite: true,
        onFavoritePressed: () {
          setState(() {
            // TODO: 取消收藏
          });
        },
        onTap: () {
          // TODO: 导航到详情页
        },
      );
    });
  }
}
