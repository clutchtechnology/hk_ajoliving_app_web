import 'package:flutter/material.dart';

class SchoolNetPage extends StatefulWidget {
  const SchoolNetPage({super.key});

  @override
  State<SchoolNetPage> createState() => _SchoolNetPageState();
}

class _SchoolNetPageState extends State<SchoolNetPage> {
  // 筛选器状态
  String? selectedDistrict;
  String? selectedGender;
  String? selectedFinanceType;
  
  // 分页状态
  int currentPage = 1;
  final int itemsPerPage = 10;
  
  // 地区选项
  final List<String> districts = [
    '全部地區',
    '中西區',
    '灣仔區',
    '東區',
    '南區',
    '油尖旺區',
    '深水埗區',
    '九龍城區',
    '黃大仙區',
    '觀塘區',
    '葵青區',
    '荃灣區',
    '屯門區',
    '元朗區',
    '北區',
    '大埔區',
    '沙田區',
    '西貢區',
    '離島區',
  ];
  
  // 性别选项
  final List<String> genders = [
    '全部',
    '男女',
    '男',
    '女',
  ];
  
  // 资助种类选项
  final List<String> financeTypes = [
    '全部',
    '官立',
    '資助',
    '直資',
    '私立',
  ];
  
  // 模拟学校数据
  final List<Map<String, String>> schools = [
    {'name': '聖保羅男女中學', 'district': '中西區', 'gender': '男女', 'financeType': '直資'},
    {'name': '拔萃女書院', 'district': '油尖旺區', 'gender': '女', 'financeType': '直資'},
    {'name': '皇仁書院', 'district': '灣仔區', 'gender': '男', 'financeType': '官立'},
    {'name': '嘉諾撒聖心書院', 'district': '南區', 'gender': '女', 'financeType': '資助'},
    {'name': '喇沙書院', 'district': '九龍城區', 'gender': '男', 'financeType': '資助'},
    {'name': '協恩中學', 'district': '九龍城區', 'gender': '女', 'financeType': '資助'},
    {'name': '華仁書院（九龍）', 'district': '油尖旺區', 'gender': '男', 'financeType': '資助'},
    {'name': '庇理羅士女子中學', 'district': '東區', 'gender': '女', 'financeType': '官立'},
    {'name': '英皇書院', 'district': '中西區', 'gender': '男', 'financeType': '官立'},
    {'name': '瑪利諾修院學校', 'district': '九龍城區', 'gender': '女', 'financeType': '資助'},
    {'name': '聖公會林護紀念中學', 'district': '葵青區', 'gender': '男女', 'financeType': '資助'},
    {'name': '培正中學', 'district': '九龍城區', 'gender': '男女', 'financeType': '資助'},
    {'name': '聖保祿學校', 'district': '灣仔區', 'gender': '女', 'financeType': '資助'},
    {'name': '德望學校', 'district': '黃大仙區', 'gender': '女', 'financeType': '資助'},
    {'name': '聖士提反女子中學', 'district': '中西區', 'gender': '女', 'financeType': '資助'},
  ];
  
  // 获取筛选后的学校列表
  List<Map<String, String>> get filteredSchools {
    return schools.where((school) {
      if (selectedDistrict != null && selectedDistrict != '全部地區' && school['district'] != selectedDistrict) {
        return false;
      }
      if (selectedGender != null && selectedGender != '全部' && school['gender'] != selectedGender) {
        return false;
      }
      if (selectedFinanceType != null && selectedFinanceType != '全部' && school['financeType'] != selectedFinanceType) {
        return false;
      }
      return true;
    }).toList();
  }
  
  // 获取当前页的数据
  List<Map<String, String>> get currentPageData {
    final startIndex = (currentPage - 1) * itemsPerPage;
    final endIndex = startIndex + itemsPerPage;
    final filtered = filteredSchools;
    
    if (startIndex >= filtered.length) {
      return [];
    }
    
    return filtered.sublist(
      startIndex,
      endIndex > filtered.length ? filtered.length : endIndex,
    );
  }
  
  // 获取总页数
  int get totalPages {
    final total = filteredSchools.length;
    return (total / itemsPerPage).ceil();
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
                    
                    // 表格
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: _buildTable(),
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
  
  Widget _buildFilters() {
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
          // 地区筛选
          SizedBox(
            width: 200,
            child: DropdownButtonFormField<String>(
              value: selectedDistrict,
              decoration: const InputDecoration(
                labelText: '地區',
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                filled: true,
                fillColor: Colors.white,
              ),
              items: districts.map((district) {
                return DropdownMenuItem(
                  value: district,
                  child: Text(district),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedDistrict = value;
                  currentPage = 1; // 重置页码
                });
              },
            ),
          ),
          
          // 性别筛选
          SizedBox(
            width: 200,
            child: DropdownButtonFormField<String>(
              value: selectedGender,
              decoration: const InputDecoration(
                labelText: '性別',
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                filled: true,
                fillColor: Colors.white,
              ),
              items: genders.map((gender) {
                return DropdownMenuItem(
                  value: gender,
                  child: Text(gender),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedGender = value;
                  currentPage = 1; // 重置页码
                });
              },
            ),
          ),
          
          // 资助种类筛选
          SizedBox(
            width: 200,
            child: DropdownButtonFormField<String>(
              value: selectedFinanceType,
              decoration: const InputDecoration(
                labelText: '資助種類',
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                filled: true,
                fillColor: Colors.white,
              ),
              items: financeTypes.map((type) {
                return DropdownMenuItem(
                  value: type,
                  child: Text(type),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedFinanceType = value;
                  currentPage = 1; // 重置页码
                });
              },
            ),
          ),
          
          // 重置按钮
          ElevatedButton.icon(
            onPressed: () {
              setState(() {
                selectedDistrict = null;
                selectedGender = null;
                selectedFinanceType = null;
                currentPage = 1;
              });
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
  
  Widget _buildTable() {
    final data = currentPageData;
    
    if (data.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(48),
        alignment: Alignment.center,
        child: const Text(
          '沒有符合條件的學校',
          style: TextStyle(
            fontSize: 16,
            color: Color(0xFF64748B),
          ),
        ),
      );
    }
    
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
            child: IntrinsicHeight(
              child: Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: _buildHeaderCell('學校名稱'),
                  ),
                  Expanded(
                    flex: 2,
                    child: _buildHeaderCell('地區'),
                  ),
                  Expanded(
                    flex: 1,
                    child: _buildHeaderCell('性別'),
                  ),
                  Expanded(
                    flex: 2,
                    child: _buildHeaderCell('資助種類'),
                  ),
                ],
              ),
            ),
          ),
          // 数据行
          ...List.generate(data.length, (index) {
            final school = data[index];
            return Container(
              decoration: BoxDecoration(
                color: index % 2 == 0 ? Colors.white : const Color(0xFFFAFAFA),
                border: const Border(
                  top: BorderSide(color: Color(0xFFE2E8F0)),
                ),
              ),
              child: IntrinsicHeight(
                child: Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: _buildDataCell(school['name']!),
                    ),
                    Expanded(
                      flex: 2,
                      child: _buildDataCell(school['district']!),
                    ),
                    Expanded(
                      flex: 1,
                      child: _buildDataCell(school['gender']!),
                    ),
                    Expanded(
                      flex: 2,
                      child: _buildDataCell(school['financeType']!),
                    ),
                  ],
                ),
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
  
  Widget _buildPagination() {
    if (totalPages <= 1) {
      return const SizedBox.shrink();
    }
    
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 8,
      runSpacing: 8,
      children: [
        // 上一页按钮
        IconButton(
          onPressed: currentPage > 1
              ? () {
                  setState(() {
                    currentPage--;
                  });
                }
              : null,
          icon: const Icon(Icons.chevron_left),
          tooltip: '上一頁',
        ),
        
        // 页码按钮
        ...List.generate(totalPages, (index) {
          final pageNum = index + 1;
          
          // 只显示当前页附近的页码
          if (pageNum == 1 ||
              pageNum == totalPages ||
              (pageNum >= currentPage - 2 && pageNum <= currentPage + 2)) {
            return _buildPageButton(pageNum);
          } else if (pageNum == currentPage - 3 || pageNum == currentPage + 3) {
            return const Padding(
              padding: EdgeInsets.symmetric(horizontal: 4),
              child: Text('...'),
            );
          }
          
          return const SizedBox.shrink();
        }),
        
        // 下一页按钮
        IconButton(
          onPressed: currentPage < totalPages
              ? () {
                  setState(() {
                    currentPage++;
                  });
                }
              : null,
          icon: const Icon(Icons.chevron_right),
          tooltip: '下一頁',
        ),
      ],
    );
  }
  
  Widget _buildPageButton(int pageNum) {
    final isCurrentPage = pageNum == currentPage;
    
    return InkWell(
      onTap: () {
        setState(() {
          currentPage = pageNum;
        });
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
