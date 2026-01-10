import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_styles.dart';
import '../widgets/property_card.dart';
import '../providers/search_provider.dart';
import '../providers/property_provider.dart';
import '../../data/models/search.dart';

/// 地产主页
class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  bool _showSuggestions = false;

  @override
  void initState() {
    super.initState();
    
    // 加载房产数据
    Future.microtask(() {
      ref.read(propertyProvider.notifier).getProperties(pageSize: 12);
    });
    
    // 监听搜索框焦点
    _searchFocusNode.addListener(() {
      setState(() {
        _showSuggestions = _searchFocusNode.hasFocus && _searchController.text.isNotEmpty;
      });
    });
    
    // 监听搜索框输入
    _searchController.addListener(() {
      final query = _searchController.text.trim();
      if (query.isNotEmpty) {
        // 获取搜索建议
        ref.read(searchProvider.notifier).getSearchSuggestions(query: query);
        setState(() {
          _showSuggestions = _searchFocusNode.hasFocus;
        });
      } else {
        setState(() {
          _showSuggestions = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  /// 执行搜索
  void _performSearch() {
    final query = _searchController.text.trim();
    if (query.isEmpty) return;

    // 执行全局搜索
    ref.read(searchProvider.notifier).globalSearch(query: query);
    
    // 隐藏建议
    setState(() {
      _showSuggestions = false;
    });
    
    // 移除焦点
    _searchFocusNode.unfocus();
    
    // TODO: 导航到搜索结果页面
    // context.go('/search?q=$query');
  }

  /// 选择搜索建议
  void _selectSuggestion(SearchSuggestion suggestion) {
    _searchController.text = suggestion.text;
    _performSearch();
  }

  // 构建新闻条目
  Widget _buildNewsItem(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppStyles.spacing8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 6,
            height: 6,
            margin: const EdgeInsets.only(top: 6, right: AppStyles.spacing8),
            decoration: BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
            ),
          ),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: AppStyles.fontSizeBody,
                color: AppColors.textPrimary,
                height: 1.4,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  // 构建页码按钮
  Widget _buildPageButton(int page, {bool isActive = false, VoidCallback? onTap}) {
    return Container(
      width: 36,
      height: 36,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: isActive ? AppColors.primary : AppColors.background,
        borderRadius: BorderRadius.circular(AppStyles.radiusSmall),
        border: Border.all(
          color: isActive ? AppColors.primary : AppColors.border,
        ),
      ),
      child: TextButton(
        onPressed: onTap,
        style: TextButton.styleFrom(
          padding: EdgeInsets.zero,
          minimumSize: Size.zero,
        ),
        child: Text(
          page.toString(),
          style: TextStyle(
            fontSize: AppStyles.fontSizeCaption,
            color: isActive ? Colors.white : AppColors.textSecondary,
            fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final searchState = ref.watch(searchProvider);
    
    // 最大宽度限制
    const double maxLeftWidth = 1100.0;
    const double maxRightWidth = 600.0;
    const double maxTotalWidth = maxLeftWidth + maxRightWidth + AppStyles.spacing16;
    
    return Container(
      color: AppColors.background,
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: maxTotalWidth),
          child: Padding(
            padding: const EdgeInsets.all(AppStyles.spacing16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 左侧容器 - 60%
                Expanded(
                  flex: 60,
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: maxLeftWidth),
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.navBarBackground,
                        borderRadius: BorderRadius.circular(AppStyles.radiusMedium),
                        boxShadow: AppStyles.shadowSmall,
                      ),
                      child: Column(
                        children: [
                          // 顶部图片容器
                          SizedBox(
                            width: double.infinity,
                            height: screenHeight * 0.4,
                            child: Stack(
                              children: [
                                // 背景图片
                                Positioned.fill(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(AppStyles.radiusMedium),
                                      topRight: Radius.circular(AppStyles.radiusMedium),
                                    ),
                                    child: Image.asset(
                                      'assets/images/801-210610160U4459.jpg',
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                // 搜索框
                                Positioned(
                                  left: AppStyles.spacing24,
                                  right: AppStyles.spacing24,
                                  bottom: AppStyles.spacing24,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      // 搜索输入容器
                                      Container(
                                        height: 48,
                                        decoration: BoxDecoration(
                                          color: AppColors.surface,
                                          borderRadius: BorderRadius.circular(AppStyles.radiusMedium),
                                          boxShadow: AppStyles.shadowMedium,
                                        ),
                                        child: Row(
                                          children: [
                                            // 搜索输入框
                                            Expanded(
                                              child: TextField(
                                                controller: _searchController,
                                                focusNode: _searchFocusNode,
                                                onSubmitted: (_) => _performSearch(),
                                                decoration: InputDecoration(
                                                  hintText: '請輸入地區、大廈或街道...',
                                                  hintStyle: TextStyle(
                                                    color: AppColors.textTertiary,
                                                    fontSize: AppStyles.fontSizeBody,
                                                  ),
                                                  prefixIcon: Icon(
                                                    Icons.search,
                                                    color: AppColors.textTertiary,
                                                  ),
                                                  suffixIcon: _searchController.text.isNotEmpty
                                                      ? IconButton(
                                                          icon: const Icon(Icons.clear, size: 20),
                                                          onPressed: () {
                                                            _searchController.clear();
                                                            setState(() {
                                                              _showSuggestions = false;
                                                            });
                                                          },
                                                        )
                                                      : null,
                                                  border: InputBorder.none,
                                                  contentPadding: const EdgeInsets.symmetric(
                                                    horizontal: AppStyles.spacing16,
                                                    vertical: AppStyles.spacing12,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            // 搜索按钮
                                            Container(
                                              height: 48,
                                              decoration: BoxDecoration(
                                                color: AppColors.primary,
                                                borderRadius: BorderRadius.only(
                                                  topRight: Radius.circular(AppStyles.radiusMedium),
                                                  bottomRight: Radius.circular(AppStyles.radiusMedium),
                                                ),
                                              ),
                                              child: TextButton(
                                                onPressed: _performSearch,
                                                style: TextButton.styleFrom(
                                                  padding: const EdgeInsets.symmetric(
                                                    horizontal: AppStyles.spacing24,
                                                  ),
                                                ),
                                                child: searchState.isLoading
                                                    ? const SizedBox(
                                                        width: 20,
                                                        height: 20,
                                                        child: CircularProgressIndicator(
                                                          color: Colors.white,
                                                          strokeWidth: 2,
                                                        ),
                                                      )
                                                    : const Text(
                                                        '搜尋',
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: AppStyles.fontSizeBody,
                                                          fontWeight: FontWeight.w600,
                                                        ),
                                                      ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      
                                      // 搜索建议下拉框
                                      if (_showSuggestions && searchState.suggestions.isNotEmpty)
                                        Container(
                                          margin: const EdgeInsets.only(top: AppStyles.spacing8),
                                          constraints: const BoxConstraints(maxHeight: 300),
                                          decoration: BoxDecoration(
                                            color: AppColors.surface,
                                            borderRadius: BorderRadius.circular(AppStyles.radiusMedium),
                                            boxShadow: AppStyles.shadowMedium,
                                          ),
                                          child: Material(
                                            color: Colors.transparent,
                                            child: ListView.builder(
                                              shrinkWrap: true,
                                              padding: const EdgeInsets.symmetric(vertical: AppStyles.spacing8),
                                              itemCount: searchState.suggestions.length,
                                              itemBuilder: (context, index) {
                                                final suggestion = searchState.suggestions[index];
                                                return ListTile(
                                                  leading: Icon(
                                                    Icons.search,
                                                    color: AppColors.textTertiary,
                                                    size: 20,
                                                  ),
                                                  title: Text(
                                                    suggestion.text,
                                                    style: const TextStyle(
                                                      fontSize: AppStyles.fontSizeBody,
                                                      color: AppColors.textPrimary,
                                                    ),
                                                  ),
                                                  trailing: Text(
                                                    suggestion.count > 0 ? '${suggestion.count} 個結果' : '',
                                                    style: TextStyle(
                                                      fontSize: AppStyles.fontSizeSmall,
                                                      color: AppColors.textTertiary,
                                                    ),
                                                  ),
                                                  onTap: () => _selectSuggestion(suggestion),
                                                  dense: true,
                                                  contentPadding: const EdgeInsets.symmetric(
                                                    horizontal: AppStyles.spacing16,
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          
                          // 精选房源标题
                          Padding(
                            padding: const EdgeInsets.all(AppStyles.spacing16),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                '精選房源',
                                style: TextStyle(
                                  fontSize: AppStyles.fontSizeH3,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                            ),
                          ),
                          
                          // 房源卡片网格 3行4列
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppStyles.spacing16,
                            ),
                            child: Builder(
                              builder: (context) {
                                final propertyState = ref.watch(propertyProvider);
                                
                                // 1. 加载状态
                                if (propertyState.isLoading && propertyState.properties.isEmpty) {
                                  return Container(
                                    height: 400,
                                    child: const Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                  );
                                }
                                
                                // 2. 错误状态
                                if (propertyState.error != null && propertyState.properties.isEmpty) {
                                  return Container(
                                    height: 400,
                                    child: Center(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const Icon(
                                            Icons.error_outline,
                                            size: 48,
                                            color: AppColors.error,
                                          ),
                                          const SizedBox(height: AppStyles.spacing16),
                                          Text(
                                            '加載失敗',
                                            style: TextStyle(
                                              fontSize: AppStyles.fontSizeH3,
                                              color: AppColors.textSecondary,
                                            ),
                                          ),
                                          const SizedBox(height: AppStyles.spacing8),
                                          TextButton(
                                            onPressed: () => ref.read(propertyProvider.notifier).refresh(),
                                            child: const Text('重試'),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }
                                
                                // 3. 空数据状态
                                if (propertyState.properties.isEmpty) {
                                  return Container(
                                    height: 400,
                                    child: Center(
                                      child: Text(
                                        '暫無房源',
                                        style: TextStyle(
                                          fontSize: AppStyles.fontSizeH3,
                                          color: AppColors.textSecondary,
                                        ),
                                      ),
                                    ),
                                  );
                                }
                                
                                // 4. 成功状态 - 显示房源数据
                                return GridView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 4,
                                    crossAxisSpacing: AppStyles.spacing12,
                                    mainAxisSpacing: AppStyles.spacing12,
                                    childAspectRatio: 1 / 1.25,
                                  ),
                                  itemCount: propertyState.properties.length,
                                  itemBuilder: (context, index) {
                                    final property = propertyState.properties[index];
                                    return PropertyCard(
                                      property: property,
                                    );
                                  },
                                );
                              },
                            ),
                          ),
                          
                          // 页码选择器
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppStyles.spacing16,
                              vertical: AppStyles.spacing16,
                            ),
                            child: Builder(
                              builder: (context) {
                                final propertyState = ref.watch(propertyProvider);
                                
                                // 只在有数据时显示分页
                                if (propertyState.properties.isEmpty) {
                                  return const SizedBox.shrink();
                                }
                                
                                final currentPage = propertyState.currentPage;
                                final totalPages = propertyState.totalPages;
                                
                                // 智能显示5个页码
                                int startPage = currentPage - 2;
                                if (startPage < 1) startPage = 1;
                                int endPage = startPage + 4;
                                if (endPage > totalPages) {
                                  endPage = totalPages;
                                  startPage = endPage - 4;
                                  if (startPage < 1) startPage = 1;
                                }
                                
                                final pageButtons = <Widget>[];
                                for (int i = startPage; i <= endPage; i++) {
                                  pageButtons.add(_buildPageButton(
                                    i,
                                    isActive: i == currentPage,
                                    onTap: () => ref.read(propertyProvider.notifier).goToPage(i),
                                  ));
                                }
                                
                                return Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    // 上一页按钮
                                    Container(
                                      width: 36,
                                      height: 36,
                                      decoration: BoxDecoration(
                                        color: AppColors.background,
                                        borderRadius: BorderRadius.circular(AppStyles.radiusSmall),
                                        border: Border.all(color: AppColors.border),
                                      ),
                                      child: IconButton(
                                        padding: EdgeInsets.zero,
                                        icon: const Icon(Icons.chevron_left, size: 20),
                                        color: currentPage > 1 ? AppColors.textSecondary : AppColors.textTertiary,
                                        onPressed: currentPage > 1
                                            ? () => ref.read(propertyProvider.notifier).loadPreviousPage()
                                            : null,
                                      ),
                                    ),
                                    const SizedBox(width: AppStyles.spacing8),
                                    // 页码按钮
                                    ...pageButtons,
                                    const SizedBox(width: AppStyles.spacing8),
                                    // 下一页按钮
                                    Container(
                                      width: 36,
                                      height: 36,
                                      decoration: BoxDecoration(
                                        color: AppColors.background,
                                        borderRadius: BorderRadius.circular(AppStyles.radiusSmall),
                                        border: Border.all(color: AppColors.border),
                                      ),
                                      child: IconButton(
                                        padding: EdgeInsets.zero,
                                        icon: const Icon(Icons.chevron_right, size: 20),
                                        color: currentPage < totalPages ? AppColors.textSecondary : AppColors.textTertiary,
                                        onPressed: currentPage < totalPages
                                            ? () => ref.read(propertyProvider.notifier).loadNextPage()
                                            : null,
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
                          
                          const SizedBox(height: AppStyles.spacing16),
                        ],
                      ),
                    ),
                  ),
                ),
                
                const SizedBox(width: AppStyles.spacing16),
                
                // 右侧容器 - 40%
                Expanded(
                  flex: 40,
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: maxRightWidth),
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.navBarBackground,
                        borderRadius: BorderRadius.circular(AppStyles.radiusMedium),
                        boxShadow: AppStyles.shadowSmall,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(AppStyles.spacing16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // 标题
                            Text(
                              '易發樓價指數趨勢',
                              style: TextStyle(
                                fontSize: AppStyles.fontSizeH3,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: AppStyles.spacing16),
                            // 折线图
                            SizedBox(
                              height: 300,
                              child: LineChart(
                                LineChartData(
                                  gridData: FlGridData(
                                    show: true,
                                    drawVerticalLine: false,
                                    horizontalInterval: 20,
                                    getDrawingHorizontalLine: (value) {
                                      return FlLine(
                                        color: AppColors.border,
                                        strokeWidth: 1,
                                      );
                                    },
                                  ),
                                  titlesData: FlTitlesData(
                                    show: true,
                                    rightTitles: const AxisTitles(
                                      sideTitles: SideTitles(showTitles: false),
                                    ),
                                    topTitles: const AxisTitles(
                                      sideTitles: SideTitles(showTitles: false),
                                    ),
                                    bottomTitles: AxisTitles(
                                      sideTitles: SideTitles(
                                        showTitles: true,
                                        reservedSize: 30,
                                        interval: 1,
                                        getTitlesWidget: (value, meta) {
                                          const months = ['1月', '2月', '3月', '4月', '5月', '6月', '7月', '8月', '9月', '10月', '11月', '12月'];
                                          if (value.toInt() >= 0 && value.toInt() < months.length) {
                                            return Padding(
                                              padding: const EdgeInsets.only(top: 8),
                                              child: Text(
                                                months[value.toInt()],
                                                style: TextStyle(
                                                  color: AppColors.textTertiary,
                                                  fontSize: AppStyles.fontSizeSmall,
                                                ),
                                              ),
                                            );
                                          }
                                          return const Text('');
                                        },
                                      ),
                                    ),
                                    leftTitles: AxisTitles(
                                      sideTitles: SideTitles(
                                        showTitles: true,
                                        interval: 20,
                                        reservedSize: 42,
                                        getTitlesWidget: (value, meta) {
                                          return Text(
                                            value.toInt().toString(),
                                            style: TextStyle(
                                              color: AppColors.textTertiary,
                                              fontSize: AppStyles.fontSizeSmall,
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                  borderData: FlBorderData(show: false),
                                  minX: 0,
                                  maxX: 11,
                                  minY: 100,
                                  maxY: 180,
                                  lineBarsData: [
                                    LineChartBarData(
                                      spots: const [
                                        FlSpot(0, 145),
                                        FlSpot(1, 148),
                                        FlSpot(2, 152),
                                        FlSpot(3, 150),
                                        FlSpot(4, 155),
                                        FlSpot(5, 158),
                                        FlSpot(6, 162),
                                        FlSpot(7, 160),
                                        FlSpot(8, 165),
                                        FlSpot(9, 168),
                                        FlSpot(10, 170),
                                        FlSpot(11, 172),
                                      ],
                                      isCurved: true,
                                      color: AppColors.primary,
                                      barWidth: 3,
                                      isStrokeCapRound: true,
                                      dotData: const FlDotData(show: false),
                                      belowBarData: BarAreaData(
                                        show: true,
                                        color: AppColors.primary.withOpacity(0.1),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: AppStyles.spacing16),
                            // 广告位
                            Container(
                              width: double.infinity,
                              height: 200,
                              decoration: BoxDecoration(
                                color: AppColors.background,
                                borderRadius: BorderRadius.circular(AppStyles.radiusMedium),
                                border: Border.all(
                                  color: AppColors.border,
                                  width: 1,
                                ),
                              ),
                              child: const Center(
                                child: Text(
                                  '廣告位招租',
                                  style: TextStyle(
                                    fontSize: AppStyles.fontSizeH3,
                                    color: AppColors.textTertiary,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: AppStyles.spacing16),
                            // 新闻速递标题
                            Text(
                              '新聞速遞',
                              style: TextStyle(
                                fontSize: AppStyles.fontSizeH3,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: AppStyles.spacing12),
                            // 新闻列表
                            _buildNewsItem('樓市回暖：本月成交量按月升15%'),
                            _buildNewsItem('政府放寬按揭成數 首置客最高可借九成'),
                            _buildNewsItem('新界北都會區規劃曝光 料可容納250萬人'),
                            _buildNewsItem('銀行下調按揭利率 H+1.3%創新低'),
                            _buildNewsItem('啟德新盤周末開售 料吸引逾千人認購'),
                          ],
                        ),
                      ),
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
