import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/school_net_provider.dart';

class SchoolNetPage extends ConsumerStatefulWidget {
  const SchoolNetPage({super.key});

  @override
  ConsumerState<SchoolNetPage> createState() => _SchoolNetPageState();
}

class _SchoolNetPageState extends ConsumerState<SchoolNetPage> {
  final TextEditingController _searchController = TextEditingController();
  String? selectedType;
  
  @override
  void initState() {
    super.initState();
    // 页面加载时自动获取数据
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(schoolNetProvider.notifier).loadSchoolNets();
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
    final schoolNetState = ref.watch(schoolNetProvider);

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
                    children: [
                      // 标题区域
                      Padding(
                        padding: const EdgeInsets.all(24),
                        child: const Text(
                          '校網查詢',
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
                      _buildContent(schoolNetState),
                      
                      const SizedBox(height: 24),
                      
                      // 分页器
                      if (!schoolNetState.isLoading && schoolNetState.error == null && schoolNetState.schoolNets.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(left: 24, right: 24, bottom: 24),
                          child: _buildPagination(schoolNetState),
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
  Widget _buildContent(SchoolNetState state) {
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
            Text(
              '加載失敗',
              style: const TextStyle(
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
                ref.read(schoolNetProvider.notifier).loadSchoolNets();
              },
              icon: const Icon(Icons.refresh),
              label: const Text('重試'),
            ),
          ],
        ),
      );
    }
    
    // 3. 空数据
    if (state.schoolNets.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(48),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.school_outlined,
              size: 64,
              color: Color(0xFF94A3B8),
            ),
            const SizedBox(height: 16),
            const Text(
              '暫無校網數據',
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
      child: _buildTable(state),
    );
  }
  
  Widget _buildFilters() {
    final schoolNetState = ref.watch(schoolNetProvider);
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Wrap(
        spacing: 16,
        runSpacing: 16,
        children: [
          // 搜索框
          SizedBox(
            width: 300,
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: '搜索校網',
                border: const OutlineInputBorder(),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                filled: true,
                fillColor: Colors.white,
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {
                    ref.read(schoolNetProvider.notifier).search(_searchController.text);
                  },
                ),
              ),
              onSubmitted: (value) {
                ref.read(schoolNetProvider.notifier).search(value);
              },
            ),
          ),
          
          // 类型筛选
          SizedBox(
            width: 200,
            child: DropdownButtonFormField<String>(
              value: selectedType,
              decoration: const InputDecoration(
                labelText: '類型',
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                filled: true,
                fillColor: Colors.white,
              ),
              items: const [
                DropdownMenuItem(value: null, child: Text('全部')),
                DropdownMenuItem(value: 'primary', child: Text('小學')),
                DropdownMenuItem(value: 'secondary', child: Text('中學')),
              ],
              onChanged: (value) {
                setState(() {
                  selectedType = value;
                });
                ref.read(schoolNetProvider.notifier).updateType(value);
              },
            ),
          ),
          
          // 地区筛选（暂时移除，等待地区 API 集成）
          // SizedBox(
          //   width: 200,
          //   child: DropdownButtonFormField<int>(
          //     value: schoolNetState.filter.districtId,
          //     decoration: const InputDecoration(
          //       labelText: '地區',
          //       border: OutlineInputBorder(),
          //       contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          //       filled: true,
          //       fillColor: Colors.white,
          //     ),
          //     items: const [
          //       DropdownMenuItem(value: null, child: Text('全部地區')),
          //     ],
          //     onChanged: (value) {
          //       ref.read(schoolNetProvider.notifier).updateDistrict(value);
          //     },
          //   ),
          // ),
          
          // 重置按钮
          ElevatedButton.icon(
            onPressed: () {
              setState(() {
                selectedType = null;
                _searchController.clear();
              });
              ref.read(schoolNetProvider.notifier).clearFilter();
            },
            icon: const Icon(Icons.refresh),
            label: const Text('重置'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildTable(SchoolNetState state) {
    final schoolNets = state.schoolNets;
    
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFE2E8F0)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 表头
          Container(
            decoration: const BoxDecoration(
              color: Color(0xFFF8FAFC),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(8),
                topRight: Radius.circular(8),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: _buildHeaderCell('校網編號'),
                ),
                Expanded(
                  flex: 3,
                  child: _buildHeaderCell('校網名稱'),
                ),
                Expanded(
                  flex: 1,
                  child: _buildHeaderCell('類型'),
                ),
                Expanded(
                  flex: 2,
                  child: _buildHeaderCell('地區'),
                ),
                Expanded(
                  flex: 1,
                  child: _buildHeaderCell('學校數'),
                ),
              ],
            ),
          ),
          // 数据行
          ...List.generate(schoolNets.length, (index) {
            final schoolNet = schoolNets[index];
            return Container(
              decoration: BoxDecoration(
                color: index % 2 == 0 ? Colors.white : const Color(0xFFFAFAFA),
                border: const Border(
                  top: BorderSide(color: Color(0xFFE2E8F0)),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: _buildDataCell(schoolNet.code),
                  ),
                  Expanded(
                    flex: 3,
                    child: _buildDataCell(schoolNet.nameZhHant),
                  ),
                  Expanded(
                    flex: 1,
                    child: _buildDataCell(schoolNet.typeText),
                  ),
                  Expanded(
                    flex: 2,
                    child: _buildDataCell(schoolNet.district?.nameZh ?? '-'),
                  ),
                  Expanded(
                    flex: 1,
                    child: _buildDataCell(schoolNet.schoolCount.toString()),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
  
  Widget _buildHeaderCell(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Color(0xFF1E293B),
        ),
      ),
    );
  }
  
  Widget _buildDataCell(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 14,
          color: Color(0xFF475569),
        ),
      ),
    );
  }
  
  Widget _buildPagination(SchoolNetState state) {
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
    
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 8,
      runSpacing: 8,
      children: [
        // 上一页按钮
        IconButton(
          onPressed: state.currentPage > 1
              ? () => ref.read(schoolNetProvider.notifier).previousPage()
              : null,
          icon: const Icon(Icons.chevron_left),
          tooltip: '上一頁',
        ),
        
        // 页码按钮
        ...List.generate(endPage - startPage + 1, (index) {
          final pageNum = startPage + index;
          return _buildPageButton(pageNum, state.currentPage);
        }),
        
        // 下一页按钮
        IconButton(
          onPressed: state.currentPage < state.totalPages
              ? () => ref.read(schoolNetProvider.notifier).nextPage()
              : null,
          icon: const Icon(Icons.chevron_right),
          tooltip: '下一頁',
        ),
      ],
    );
  }
  
  Widget _buildPageButton(int pageNum, int currentPage) {
    final isCurrentPage = pageNum == currentPage;
    
    return InkWell(
      onTap: () {
        ref.read(schoolNetProvider.notifier).changePage(pageNum);
      },
      borderRadius: BorderRadius.circular(4),
      child: Container(
        width: 40,
        height: 40,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isCurrentPage ? const Color(0xFF2563EB) : Colors.transparent,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(
            color: isCurrentPage ? const Color(0xFF2563EB) : const Color(0xFFE2E8F0),
          ),
        ),
        child: Text(
          pageNum.toString(),
          style: TextStyle(
            fontSize: 14,
            fontWeight: isCurrentPage ? FontWeight.bold : FontWeight.normal,
            color: isCurrentPage ? Colors.white : const Color(0xFF475569),
          ),
        ),
      ),
    );
  }
}
