import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

/// 地產代理頁面
class AgentsPage extends StatefulWidget {
  const AgentsPage({super.key});

  @override
  State<AgentsPage> createState() => _AgentsPageState();
}

class _AgentsPageState extends State<AgentsPage> {
  // 筛选器状态
  String _selectedListingType = '全部'; // 放賣、放租、全部
  String _selectedDistrict = '全部';
  String _selectedCategory = '全部';

  // 分页状态
  int _currentPage = 1;
  final int _rowsPerPage = 10;

  // 筛选选项
  final List<String> _listingTypes = ['全部', '放賣', '放租'];
  final List<String> _districts = [
    '全部',
    '港島',
    '九龍',
    '新界東',
    '新界西',
  ];
  final List<String> _categories = [
    '全部',
    '住宅',
    '工商舖',
    '車位',
  ];

  // 模拟代理公司数据
  final List<AgentCompany> _agentCompanies = [
    AgentCompany(name: '中原地產', district: '港島', forSale: 1250, forRent: 890, agentCount: 450),
    AgentCompany(name: '美聯物業', district: '九龍', forSale: 1180, forRent: 760, agentCount: 380),
    AgentCompany(name: '利嘉閣地產', district: '新界東', forSale: 980, forRent: 650, agentCount: 320),
    AgentCompany(name: '世紀21', district: '新界西', forSale: 720, forRent: 480, agentCount: 250),
    AgentCompany(name: '香港置業', district: '港島', forSale: 850, forRent: 560, agentCount: 280),
    AgentCompany(name: '置富地產', district: '九龍', forSale: 620, forRent: 410, agentCount: 180),
    AgentCompany(name: '富山地產', district: '新界東', forSale: 480, forRent: 320, agentCount: 150),
    AgentCompany(name: '恒豐地產', district: '新界西', forSale: 350, forRent: 230, agentCount: 120),
    AgentCompany(name: '永豐地產', district: '港島', forSale: 290, forRent: 180, agentCount: 95),
    AgentCompany(name: '新鴻基地產代理', district: '九龍', forSale: 580, forRent: 390, agentCount: 200),
    AgentCompany(name: '長江實業地產', district: '新界東', forSale: 420, forRent: 280, agentCount: 140),
    AgentCompany(name: '信和置業代理', district: '新界西', forSale: 380, forRent: 250, agentCount: 130),
    AgentCompany(name: '嘉華地產', district: '港島', forSale: 310, forRent: 200, agentCount: 100),
    AgentCompany(name: '恒隆地產', district: '九龍', forSale: 270, forRent: 170, agentCount: 85),
    AgentCompany(name: '九龍倉地產', district: '新界東', forSale: 240, forRent: 150, agentCount: 75),
  ];

  // 获取筛选后的数据
  List<AgentCompany> get _filteredCompanies {
    return _agentCompanies.where((company) {
      if (_selectedDistrict != '全部' && company.district != _selectedDistrict) {
        return false;
      }
      return true;
    }).toList();
  }

  // 获取当前页数据
  List<AgentCompany> get _currentPageData {
    final filtered = _filteredCompanies;
    final startIndex = (_currentPage - 1) * _rowsPerPage;
    final endIndex = startIndex + _rowsPerPage;
    return filtered.sublist(
      startIndex,
      endIndex > filtered.length ? filtered.length : endIndex,
    );
  }

  // 获取总页数
  int get _totalPages {
    return (_filteredCompanies.length / _rowsPerPage).ceil();
  }

  @override
  Widget build(BuildContext context) {
    const double maxCardWidth = 1716.0;

    return Container(
      color: const Color(0xFFF8FAFC),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: maxCardWidth),
          child: FractionallySizedBox(
            widthFactor: 0.8,
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

                    // 表格
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: _buildDataTable(),
                    ),
                    const SizedBox(height: 24),

                    // 分页器
                    Padding(
                      padding: const EdgeInsets.only(left: 24, right: 24, bottom: 24),
                      child: _buildPagination(),
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

  /// 构建筛选器
  Widget _buildFilters() {
    return Row(
      children: [
        // 租賣筛选
        SizedBox(
          width: 150,
          child: _buildFilterDropdown(
            label: '租賣',
            value: _selectedListingType,
            items: _listingTypes,
            onChanged: (value) {
              setState(() {
                _selectedListingType = value!;
                _currentPage = 1;
              });
            },
          ),
        ),
        const SizedBox(width: 16),

        // 区域筛选
        SizedBox(
          width: 150,
          child: _buildFilterDropdown(
            label: '區域',
            value: _selectedDistrict,
            items: _districts,
            onChanged: (value) {
              setState(() {
                _selectedDistrict = value!;
                _currentPage = 1;
              });
            },
          ),
        ),
        const SizedBox(width: 16),

        // 类别筛选
        SizedBox(
          width: 150,
          child: _buildFilterDropdown(
            label: '類別',
            value: _selectedCategory,
            items: _categories,
            onChanged: (value) {
              setState(() {
                _selectedCategory = value!;
                _currentPage = 1;
              });
            },
          ),
        ),
      ],
    );
  }

  /// 构建单个筛选下拉框
  Widget _buildFilterDropdown({
    required String label,
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.border),
            borderRadius: BorderRadius.circular(8),
            color: AppColors.surface,
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              isExpanded: true,
              icon: const Icon(Icons.keyboard_arrow_down, color: AppColors.textSecondary),
              items: items.map((item) {
                return DropdownMenuItem<String>(
                  value: item,
                  child: Text(
                    item,
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.textPrimary,
                    ),
                  ),
                );
              }).toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }

  /// 构建数据表格
  Widget _buildDataTable() {
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
              '區域',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          DataColumn(
            label: Text(
              '售盤',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            numeric: true,
          ),
          DataColumn(
            label: Text(
              '租盤',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            numeric: true,
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
        ],
        rows: _currentPageData.map((company) {
          return DataRow(
            cells: [
              DataCell(
                Text(
                  company.name,
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              DataCell(
                Text(
                  company.district,
                  style: const TextStyle(color: AppColors.textPrimary),
                ),
              ),
              DataCell(
                Text(
                  company.forSale.toString(),
                  style: const TextStyle(color: AppColors.textPrimary),
                ),
              ),
              DataCell(
                Text(
                  company.forRent.toString(),
                  style: const TextStyle(color: AppColors.textPrimary),
                ),
              ),
              DataCell(
                Text(
                  company.agentCount.toString(),
                  style: const TextStyle(color: AppColors.textPrimary),
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }

  /// 构建分页器
  Widget _buildPagination() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // 上一页按钮
        IconButton(
          onPressed: _currentPage > 1
              ? () {
                  setState(() {
                    _currentPage--;
                  });
                }
              : null,
          icon: const Icon(Icons.chevron_left),
          color: AppColors.primary,
          disabledColor: AppColors.textTertiary,
        ),

        // 页码按钮
        ..._buildPageNumbers(),

        // 下一页按钮
        IconButton(
          onPressed: _currentPage < _totalPages
              ? () {
                  setState(() {
                    _currentPage++;
                  });
                }
              : null,
          icon: const Icon(Icons.chevron_right),
          color: AppColors.primary,
          disabledColor: AppColors.textTertiary,
        ),
      ],
    );
  }

  /// 构建页码按钮列表
  List<Widget> _buildPageNumbers() {
    List<Widget> pageButtons = [];
    int startPage = (_currentPage - 2).clamp(1, _totalPages);
    int endPage = (startPage + 4).clamp(1, _totalPages);

    // 调整起始页，确保显示5个页码（如果有的话）
    if (endPage - startPage < 4 && startPage > 1) {
      startPage = (endPage - 4).clamp(1, _totalPages);
    }

    for (int i = startPage; i <= endPage; i++) {
      pageButtons.add(
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: InkWell(
            onTap: () {
              setState(() {
                _currentPage = i;
              });
            },
            borderRadius: BorderRadius.circular(8),
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: _currentPage == i ? AppColors.primary : Colors.transparent,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: _currentPage == i ? AppColors.primary : AppColors.border,
                ),
              ),
              alignment: Alignment.center,
              child: Text(
                i.toString(),
                style: TextStyle(
                  color: _currentPage == i ? Colors.white : AppColors.textPrimary,
                  fontWeight: _currentPage == i ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
          ),
        ),
      );
    }

    return pageButtons;
  }
}

/// 代理公司数据模型
class AgentCompany {
  final String name;
  final String district;
  final int forSale;
  final int forRent;
  final int agentCount;

  AgentCompany({
    required this.name,
    required this.district,
    required this.forSale,
    required this.forRent,
    required this.agentCount,
  });
}
