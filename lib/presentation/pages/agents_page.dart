import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_colors.dart';
import '../providers/agency_provider.dart';

/// 地產代理頁面
class AgentsPage extends ConsumerStatefulWidget {
  const AgentsPage({super.key});

  @override
  ConsumerState<AgentsPage> createState() => _AgentsPageState();
}

class _AgentsPageState extends ConsumerState<AgentsPage> {
  final TextEditingController _searchController = TextEditingController();
  
  @override
  void initState() {
    super.initState();
    // 页面加载时自动获取数据
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(agencyProvider.notifier).loadAgencies();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const double maxCardWidth = 1716.0;
    final agencyState = ref.watch(agencyProvider);

    return Container(
      color: const Color(0xFFF8FAFC),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: maxCardWidth),
          child: FractionallySizedBox(
            widthFactor: 0.8,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12.0),
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
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // 页面标题
                      const Padding(
                        padding: EdgeInsets.all(24),
                        child: Text(
                          '地產代理',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1E293B),
                          ),
                        ),
                      ),

                      // 筛选器
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: _buildFilters(),
                      ),
                      const SizedBox(height: 24),

                      // 内容区域
                      _buildContent(agencyState),
                      const SizedBox(height: 24),

                      // 分页器
                      if (!agencyState.isLoading && agencyState.error == null && agencyState.agencies.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(left: 24, right: 24, bottom: 24),
                          child: _buildPagination(agencyState),
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

  /// 内容区域（4状态渲染）
  Widget _buildContent(AgencyState state) {
    // 1. 加载中
    if (state.isLoading) {
      return Container(
        padding: const EdgeInsets.all(48),
        alignment: Alignment.center,
        child: const CircularProgressIndicator(),
      );
    }
    
    // 2. 错误状态
    if (state.error != null) {
      return Container(
        padding: const EdgeInsets.all(48),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.error_outline,
              size: 64,
              color: Color(0xFFEF4444),
            ),
            const SizedBox(height: 16),
            const Text(
              '加載失敗',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E293B),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              state.error!,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF64748B),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                ref.read(agencyProvider.notifier).loadAgencies();
              },
              icon: const Icon(Icons.refresh),
              label: const Text('重試'),
            ),
          ],
        ),
      );
    }
    
    // 3. 空数据
    if (state.agencies.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(48),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.business_outlined,
              size: 64,
              color: Color(0xFF94A3B8),
            ),
            const SizedBox(height: 16),
            const Text(
              '暫無代理公司數據',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E293B),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              '請嘗試調整篩選條件',
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFF64748B),
              ),
            ),
          ],
        ),
      );
    }
    
    // 4. 成功状态 - 显示表格
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: _buildDataTable(state),
    );
  }

  /// 构建筛选器
  Widget _buildFilters() {
    return Row(
      children: [
        // 搜索框
        SizedBox(
          width: 300,
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              labelText: '搜索代理公司',
              border: const OutlineInputBorder(),
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              suffixIcon: IconButton(
                icon: const Icon(Icons.search),
                onPressed: () {
                  ref.read(agencyProvider.notifier).search(_searchController.text);
                },
              ),
            ),
            onSubmitted: (value) {
              ref.read(agencyProvider.notifier).search(value);
            },
          ),
        ),
        const SizedBox(width: 16),

        // 重置按钮
        ElevatedButton.icon(
          onPressed: () {
            _searchController.clear();
            ref.read(agencyProvider.notifier).clearFilter();
          },
          icon: const Icon(Icons.refresh),
          label: const Text('重置'),
        ),
      ],
    );
  }

  /// 构建数据表格
  Widget _buildDataTable(AgencyState state) {
    return SizedBox(
      width: double.infinity,
      child: DataTable(
        headingRowColor: WidgetStateProperty.all(AppColors.background),
        dataRowColor: WidgetStateProperty.resolveWith<Color?>((states) {
          if (states.contains(WidgetState.hovered)) {
            return AppColors.primary.withOpacity(0.05);
          }
          return null;
        }),
        border: TableBorder.all(
          color: AppColors.border,
          borderRadius: BorderRadius.circular(8),
        ),
        columns: const [
          DataColumn(
            label: Text(
              '公司名稱',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          DataColumn(
            label: Text(
              '地址',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          DataColumn(
            label: Text(
              '代理數目',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            numeric: true,
          ),
          DataColumn(
            label: Text(
              '評分',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            numeric: true,
          ),
          DataColumn(
            label: Text(
              '認證',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ],
        rows: state.agencies.map((agency) {
          return DataRow(
            cells: [
              DataCell(
                Text(
                  agency.companyName,
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              DataCell(
                Text(
                  agency.address,
                  style: const TextStyle(color: AppColors.textPrimary),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              DataCell(
                Text(
                  agency.agentCount.toString(),
                  style: const TextStyle(color: AppColors.textPrimary),
                ),
              ),
              DataCell(
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.star, size: 16, color: Colors.amber),
                    const SizedBox(width: 4),
                    Text(
                      agency.formattedRating,
                      style: const TextStyle(color: AppColors.textPrimary),
                    ),
                  ],
                ),
              ),
              DataCell(
                agency.isVerified
                    ? const Icon(Icons.verified, color: AppColors.success, size: 20)
                    : const Text('-', style: TextStyle(color: AppColors.textSecondary)),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }

  /// 构建分页器
  Widget _buildPagination(AgencyState state) {
    if (state.totalPages <= 1) {
      return const SizedBox.shrink();
    }
    
    // 智能显示5个页码
    int startPage = (state.currentPage - 2).clamp(1, state.totalPages);
    int endPage = (startPage + 4).clamp(1, state.totalPages);
    
    // 如果结束页是最后一页，调整起始页
    if (endPage == state.totalPages && endPage - startPage < 4) {
      startPage = (endPage - 4).clamp(1, state.totalPages);
    }
    
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // 上一页按钮
        IconButton(
          onPressed: state.currentPage > 1
              ? () => ref.read(agencyProvider.notifier).previousPage()
              : null,
          icon: const Icon(Icons.chevron_left),
          color: AppColors.primary,
          disabledColor: AppColors.textTertiary,
        ),

        // 页码按钮
        ...List.generate(endPage - startPage + 1, (index) {
          final pageNum = startPage + index;
          return _buildPageButton(pageNum, state.currentPage);
        }),

        // 下一页按钮
        IconButton(
          onPressed: state.currentPage < state.totalPages
              ? () => ref.read(agencyProvider.notifier).nextPage()
              : null,
          icon: const Icon(Icons.chevron_right),
          color: AppColors.primary,
          disabledColor: AppColors.textTertiary,
        ),
      ],
    );
  }

  /// 构建页码按钮
  Widget _buildPageButton(int pageNum, int currentPage) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: InkWell(
        onTap: () {
          ref.read(agencyProvider.notifier).changePage(pageNum);
        },
        borderRadius: BorderRadius.circular(8),
        child: Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: currentPage == pageNum ? AppColors.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: currentPage == pageNum ? AppColors.primary : AppColors.border,
            ),
          ),
          alignment: Alignment.center,
          child: Text(
            pageNum.toString(),
            style: TextStyle(
              color: currentPage == pageNum ? Colors.white : AppColors.textPrimary,
              fontWeight: currentPage == pageNum ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }
}
