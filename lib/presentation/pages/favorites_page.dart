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
  int _currentPage = 1;
  final int _itemsPerPage = 10;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
    _tabController.addListener(() {
      // 切换Tab时重置页码
      if (!_tabController.indexIsChanging) {
        setState(() {
          _currentPage = 1;
        });
      }
    });
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
                      // Tab 内容区域 - 动态高度
                      LayoutBuilder(
                        builder: (context, constraints) {
                          // 计算每个卡片的大概高度：图片150 + padding和边距约60 = 210
                          const double estimatedItemHeight = 210.0;
                          // 分页器高度约80像素
                          const double paginationHeight = 80.0;
                          final double contentHeight = estimatedItemHeight * _itemsPerPage + paginationHeight;
                          
                          return SizedBox(
                            height: contentHeight,
                            child: TabBarView(
                              controller: _tabController,
                              children: [
                                _buildBuyTab(),
                                _buildRentTab(),
                                _buildServicedApartmentsTab(),
                                _buildNewPropertiesTab(),
                                _buildFurnitureTab(),
                              ],
                            ),
                          );
                        },
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
          Tab(text: '租屋'),
          Tab(text: '服務式住宅'),
          Tab(text: '新盤'),
          Tab(text: '家具'),
        ],
      ),
    );
  }

  /// 构建买楼 Tab
  Widget _buildBuyTab() {
    final allProperties = _getMockBuyProperties();
    return _buildPropertyList(
      properties: allProperties,
      emptyMessage: '還沒有收藏任何買樓房源',
    );
  }

  /// 构建租屋/服务式住宅/新盘 Tab
  Widget _buildRentTab() {
    final allProperties = _getMockRentProperties();
    return _buildPropertyList(
      properties: allProperties,
      emptyMessage: '還沒有收藏任何租屋房源',
    );
  }

  /// 构建服务式住宅 Tab
  Widget _buildServicedApartmentsTab() {
    final allProperties = _getMockServicedApartmentsProperties();
    return _buildPropertyList(
      properties: allProperties,
      emptyMessage: '還沒有收藏任何服務式住宅',
    );
  }

  /// 构建新盘 Tab
  Widget _buildNewPropertiesTab() {
    final allProperties = _getMockNewProperties();
    return _buildPropertyList(
      properties: allProperties,
      emptyMessage: '還沒有收藏任何新盤',
    );
  }

  /// 构建家具 Tab
  Widget _buildFurnitureTab() {
    final allFurniture = _getMockFurniture();
    return _buildFurnitureList(
      furniture: allFurniture,
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

    // 计算分页
    final totalItems = properties.length;
    final totalPages = (totalItems / _itemsPerPage).ceil();
    
    // 确保当前页码在有效范围内
    if (_currentPage > totalPages) {
      _currentPage = 1;
    }
    
    final startIndex = (_currentPage - 1) * _itemsPerPage;
    final endIndex = (startIndex + _itemsPerPage > totalItems) ? totalItems : startIndex + _itemsPerPage;
    final displayedProperties = properties.sublist(startIndex, endIndex);

    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: displayedProperties.length,
            itemBuilder: (context, index) {
              return PropertyListItem(
                data: displayedProperties[index],
              );
            },
          ),
        ),
        _buildPagination(totalPages),
      ],
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

    // 计算分页
    final totalItems = furniture.length;
    final totalPages = (totalItems / _itemsPerPage).ceil();
    
    // 确保当前页码在有效范围内
    if (_currentPage > totalPages) {
      _currentPage = 1;
    }
    
    final startIndex = (_currentPage - 1) * _itemsPerPage;
    final endIndex = (startIndex + _itemsPerPage > totalItems) ? totalItems : startIndex + _itemsPerPage;
    final displayedFurniture = furniture.sublist(startIndex, endIndex);

    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: displayedFurniture.length,
            itemBuilder: (context, index) {
              return FurnitureCard(
                data: displayedFurniture[index],
              );
            },
          ),
        ),
        _buildPagination(totalPages),
      ],
    );
  }

  /// 构建分页器
  Widget _buildPagination(int totalPages) {
    if (totalPages <= 1) {
      return const SizedBox(height: 16);
    }

    // 限制显示的页码数量，避免溢出
    const int maxVisiblePages = 7;
    List<int> visiblePages = [];
    
    if (totalPages <= maxVisiblePages) {
      // 如果总页数少于最大显示数，显示所有页码
      visiblePages = List.generate(totalPages, (i) => i + 1);
    } else {
      // 否则只显示部分页码
      int start = (_currentPage - 3).clamp(1, totalPages - maxVisiblePages + 1);
      int end = (start + maxVisiblePages - 1).clamp(maxVisiblePages, totalPages);
      start = (end - maxVisiblePages + 1).clamp(1, totalPages);
      visiblePages = List.generate(end - start + 1, (i) => start + i);
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // 上一页按钮
          if (_currentPage > 1)
            Container(
              width: 36,
              height: 36,
              margin: const EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.border),
              ),
              child: IconButton(
                onPressed: () {
                  setState(() {
                    _currentPage--;
                  });
                },
                icon: const Icon(Icons.chevron_left, size: 20),
                padding: EdgeInsets.zero,
              ),
            ),
          
          // 页码按钮
          ...visiblePages.map((pageNumber) {
            final isActive = pageNumber == _currentPage;
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
                  setState(() {
                    _currentPage = pageNumber;
                  });
                },
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: Size.zero,
                ),
                child: Text(
                  pageNumber.toString(),
                  style: TextStyle(
                    fontSize: 14,
                    color: isActive ? Colors.white : AppColors.textSecondary,
                    fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
              ),
            );
          }).toList(),
          
          // 下一页按钮
          if (_currentPage < totalPages)
            Container(
              width: 36,
              height: 36,
              margin: const EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.border),
              ),
              child: IconButton(
                onPressed: () {
                  setState(() {
                    _currentPage++;
                  });
                },
                icon: const Icon(Icons.chevron_right, size: 20),
                padding: EdgeInsets.zero,
              ),
            ),
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
    return List.generate(25, (index) {
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
    return List.generate(18, (index) {
      return PropertyCardData(
        imageUrl: 'https://via.placeholder.com/200x150',
        title: '旺角精裝公寓 #${index + 1}',
        district: '油尖旺',
        estate: '旺角中心',
        location: '${index + 5}座 中層 C室',
        area: 450 + (index * 30),
        propertyType: '住宅',
        tags: ['2 房', '1 浴室', '包部分家具', '近商圈'],
        price: 18000 + (index * 3000).toDouble(),
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

  /// 获取模拟服务式住宅数据
  List<PropertyCardData> _getMockServicedApartmentsProperties() {
    return List.generate(15, (index) {
      return PropertyCardData(
        imageUrl: 'https://via.placeholder.com/200x150',
        title: '中環服務式公寓 #${index + 1}',
        district: '中西區',
        estate: '中環中心',
        location: '${index + 10}座 高層 A室',
        area: 500 + (index * 30),
        propertyType: '服務式住宅',
        tags: ['2 房', '1 浴室', '全包家具', '酒店式服務'],
        price: 28000 + (index * 5000).toDouble(),
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

  /// 获取模拟新盘数据
  List<PropertyCardData> _getMockNewProperties() {
    return List.generate(22, (index) {
      return PropertyCardData(
        imageUrl: 'https://via.placeholder.com/200x150',
        title: '將軍澳新盤項目 #${index + 1}',
        district: '西貢',
        estate: '日出康城',
        location: '${index + 1}期 ${index + 1}座',
        area: 550 + (index * 40),
        propertyType: '新盤',
        tags: ['3 房', '2 浴室', '現樓', '會所設施'],
        price: 950 + (index * 80).toDouble(),
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

  /// 获取模拟家具数据
  List<FurnitureCardData> _getMockFurniture() {
    return List.generate(32, (index) {
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
      final basePrices = [3500.0, 8800.0, 2800.0, 6500.0, 1200.0, 3200.0];

      return FurnitureCardData(
        imageUrl: 'https://via.placeholder.com/200x150',
        title: '${titles[index % titles.length]} #${index + 1}',
        description: descriptions[index % descriptions.length],
        location: locations[index % locations.length],
        tags: ['實木', '包送貨', '現貨', '質保2年'],
        price: basePrices[index % basePrices.length] + (index * 100),
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
