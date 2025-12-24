import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

/// 物业估价页面
class ValuationPage extends StatefulWidget {
  const ValuationPage({super.key});

  @override
  State<ValuationPage> createState() => _ValuationPageState();
}

class _ValuationPageState extends State<ValuationPage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const double maxCardWidth = 1716.0; // 1100 + 600 + 16

    return Container(
      color: AppColors.background,
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
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // 搜索框区域
                    Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 600),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: AppColors.border),
                          ),
                          child: TextField(
                            controller: _searchController,
                            decoration: InputDecoration(
                              hintText: '輸入物業地址或屋苑名稱',
                              hintStyle: const TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 14,
                              ),
                              prefixIcon: const Icon(
                                Icons.search,
                                color: AppColors.textSecondary,
                              ),
                              suffixIcon: IconButton(
                                icon: const Icon(
                                  Icons.clear,
                                  color: AppColors.textSecondary,
                                ),
                                onPressed: () {
                                  _searchController.clear();
                                },
                              ),
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    // 物业列表表格
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                      child: Table(
                        border: TableBorder.all(color: AppColors.border),
                        columnWidths: const {
                          0: FlexColumnWidth(2),
                          1: FlexColumnWidth(3),
                          2: FlexColumnWidth(1.5),
                          3: FlexColumnWidth(1.5),
                        },
                        children: [
                          // 表头
                          TableRow(
                            decoration: BoxDecoration(
                              color: AppColors.background,
                            ),
                            children: [
                              _buildTableHeader('屋苑'),
                              _buildTableHeader('物業地址'),
                              _buildTableHeader('成交面積'),
                              _buildTableHeader('成交價'),
                            ],
                          ),
                          // 数据行
                          ...List.generate(15, (index) {
                            return TableRow(
                              children: [
                                _buildTableCell('屋苑名稱 ${index + 1}'),
                                _buildTableCell('香港九龍觀塘區某某街道 ${index + 1} 號'),
                                _buildTableCell('${500 + index * 10} 呎'),
                                _buildTableCell('HK\$ ${(600 + index * 50)} 萬'),
                              ],
                            );
                          }),
                        ],
                      ),
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
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTableHeader(String text) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildTableCell(String text) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 14,
          color: AppColors.textPrimary,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
