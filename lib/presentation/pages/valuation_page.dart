import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_colors.dart';
import '../providers/valuation_provider.dart';

/// 物业估价页面
class ValuationPage extends ConsumerStatefulWidget {
  const ValuationPage({super.key});

  @override
  ConsumerState<ValuationPage> createState() => _ValuationPageState();
}

class _ValuationPageState extends ConsumerState<ValuationPage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // 页面加载时自动获取数据
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(valuationProvider.notifier).loadValuations();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(valuationProvider);
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
                                  Icons.search,
                                  color: AppColors.primary,
                                ),
                                onPressed: () {
                                  if (_searchController.text.isNotEmpty) {
                                    ref.read(valuationProvider.notifier)
                                        .search(_searchController.text);
                                  }
                                },
                              ),
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                            ),
                            onSubmitted: (value) {
                              if (value.isNotEmpty) {
                                ref.read(valuationProvider.notifier).search(value);
                              }
                            },
                          ),
                        ),
                      ),
                    ),
                    
                    // 内容区域
                    _buildContent(state),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// 构建内容区域
  Widget _buildContent(ValuationState state) {
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
                  ref.read(valuationProvider.notifier).loadValuations();
                },
                child: const Text('重试'),
              ),
            ],
          ),
        ),
      );
    }

    // 空状态
    if (state.valuations.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(48.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.search_off, size: 64, color: AppColors.textSecondary),
              const SizedBox(height: 16),
              Text(
                '暂无估价数据',
                style: TextStyle(fontSize: 18, color: AppColors.textPrimary),
              ),
              const SizedBox(height: 8),
              Text(
                '试试搜索其他屋苑',
                style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
              ),
            ],
          ),
        ),
      );
    }

    // 成功状态 - 显示表格
    return Column(
      children: [
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
              4: FlexColumnWidth(1.2),
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
                  _buildTableHeader('平均呎價'),
                  _buildTableHeader('平均售價'),
                  _buildTableHeader('租金回報'),
                ],
              ),
              // 数据行
              ...state.valuations.map((valuation) {
                return TableRow(
                  children: [
                    _buildTableCell(valuation.estateName),
                    _buildTableCell(valuation.address),
                    _buildTableCell(valuation.formattedAvgPricePerSqft),
                    _buildTableCell(valuation.formattedAvgPrice),
                    _buildTableCell(valuation.formattedRentalYield),
                  ],
                );
              }).toList(),
            ],
          ),
        ),
        
        // 页码选择器
        if (state.totalPages > 1)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // 上一页
                IconButton(
                  onPressed: state.currentPage > 1
                      ? () => ref.read(valuationProvider.notifier).previousPage()
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
                          ref.read(valuationProvider.notifier).changePage(pageNum);
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
                      ? () => ref.read(valuationProvider.notifier).nextPage()
                      : null,
                  icon: const Icon(Icons.chevron_right),
                ),
              ],
            ),
          ),
      ],
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
