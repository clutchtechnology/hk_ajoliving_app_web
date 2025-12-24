import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../widgets/buy_filter_panel.dart';
import '../widgets/ad_rent_card.dart';
import '../widgets/property_list_item.dart';

/// 屋苑成交页面
class TransactionsPage extends StatefulWidget {
  const TransactionsPage({super.key});

  @override
  State<TransactionsPage> createState() => _TransactionsPageState();
}

class _TransactionsPageState extends State<TransactionsPage> {
  String _selectedRegion = '不限';
  String _selectedCategory = '不限';
  String _selectedPrice = '不限';
  String _selectedAreaType = '實用面積';
  String _selectedArea = '不限';
  String _selectedRooms = '不限';
  String _selectedBuildingAge = '不限';  // 楼龄
  final Set<String> _selectedTags = {};
  final Set<String> _selectedMoreOptions = {};

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
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          BuyFilterPanel(
                            config: FilterPanelConfig.transaction,
                            selectedRegion: _selectedRegion,
                            selectedCategory: _selectedCategory,
                            selectedPrice: _selectedPrice,
                            selectedAreaType: _selectedAreaType,
                            selectedArea: _selectedArea,
                            selectedRooms: _selectedRooms,
                            selectedBuildingAge: _selectedBuildingAge,
                            selectedTags: _selectedTags,
                            selectedMoreOptions: _selectedMoreOptions,
                            onRegionChanged: (v) => setState(() => _selectedRegion = v),
                            onCategoryChanged: (v) => setState(() => _selectedCategory = v),
                            onPriceChanged: (v) => setState(() => _selectedPrice = v),
                            onAreaTypeChanged: (v) => setState(() => _selectedAreaType = v),
                            onAreaChanged: (v) => setState(() => _selectedArea = v),
                            onRoomsChanged: (v) => setState(() => _selectedRooms = v),
                            onBuildingAgeChanged: (v) => setState(() => _selectedBuildingAge = v),
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
                          Column(
                            children: [
                              ListView.builder(
                                itemCount: 10,
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) {
                                  return PropertyListItem(
                                    child: Text('房源信息 #${index + 1}', style: const TextStyle(fontSize: 16)),
                                  );
                                },
                              ),
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
