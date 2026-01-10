import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_styles.dart';
import '../providers/search_provider.dart';
import '../widgets/search_widgets.dart';
import '../widgets/property_card.dart';

/// 搜索结果页面
class SearchResultPage extends ConsumerStatefulWidget {
  final String query;
  final String? type; // 搜索类型：property, estate, agent

  const SearchResultPage({
    super.key,
    required this.query,
    this.type,
  });

  @override
  ConsumerState<SearchResultPage> createState() => _SearchResultPageState();
}

class _SearchResultPageState extends ConsumerState<SearchResultPage> {
  @override
  void initState() {
    super.initState();
    // 执行搜索
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _performSearch();
    });
  }

  void _performSearch() {
    if (widget.type == 'property') {
      ref.read(searchProvider.notifier).searchProperties(query: widget.query);
    } else if (widget.type == 'estate') {
      ref.read(searchProvider.notifier).searchEstates(query: widget.query);
    } else if (widget.type == 'agent') {
      ref.read(searchProvider.notifier).searchAgents(query: widget.query);
    } else {
      ref.read(searchProvider.notifier).globalSearch(query: widget.query);
    }
  }

  @override
  Widget build(BuildContext context) {
    final searchState = ref.watch(searchProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.navBarBackground,
        elevation: 1,
        title: Text(
          '搜索結果：${widget.query}',
          style: const TextStyle(
            fontSize: AppStyles.fontSizeH3,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
      ),
      body: _buildBody(searchState),
    );
  }

  Widget _buildBody(SearchState searchState) {
    if (searchState.isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (searchState.error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 64,
              color: AppColors.error,
            ),
            const SizedBox(height: AppStyles.spacing16),
            Text(
              searchState.error!,
              style: const TextStyle(
                fontSize: AppStyles.fontSizeBody,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: AppStyles.spacing16),
            ElevatedButton(
              onPressed: _performSearch,
              child: const Text('重試'),
            ),
          ],
        ),
      );
    }

    // 根据类型显示不同结果
    if (widget.type == 'property' && searchState.propertyResults != null) {
      return _buildPropertyResults(searchState);
    } else if (widget.type == 'estate' && searchState.estateResults != null) {
      return _buildEstateResults(searchState);
    } else if (widget.type == 'agent' && searchState.agentResults != null) {
      return _buildAgentResults(searchState);
    } else if (searchState.globalResults != null) {
      return _buildGlobalResults(searchState);
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.search_off,
            size: 64,
            color: AppColors.textTertiary,
          ),
          const SizedBox(height: AppStyles.spacing16),
          const Text(
            '沒有找到相關結果',
            style: TextStyle(
              fontSize: AppStyles.fontSizeBody,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGlobalResults(SearchState searchState) {
    final results = searchState.globalResults!;
    final totalResults = results.totalResults;

    if (totalResults == 0) {
      return const Center(
        child: Text(
          '沒有找到相關結果',
          style: TextStyle(
            fontSize: AppStyles.fontSizeBody,
            color: AppColors.textSecondary,
          ),
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.all(AppStyles.spacing16),
      children: [
        Text(
          '共找到 $totalResults 個結果',
          style: const TextStyle(
            fontSize: AppStyles.fontSizeBody,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: AppStyles.spacing16),
        
        // 房产结果
        if (results.properties.isNotEmpty) ...[
          _buildSectionTitle('房產 (${results.propertyCount})'),
          ...results.properties.take(5).map(
            (property) => Card(
              margin: const EdgeInsets.only(bottom: AppStyles.spacing12),
              child: ListTile(
                leading: const Icon(Icons.home, color: AppColors.primary),
                title: Text(property.title),
                subtitle: Text('HK\$ ${property.price.toStringAsFixed(0)}'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  print('点击了房产：${property.title}');
                },
              ),
            ),
          ),
          if (results.properties.length > 5)
            TextButton(
              onPressed: () {},
              child: Text('查看全部 ${results.propertyCount} 個房產 →'),
            ),
          const SizedBox(height: AppStyles.spacing16),
        ],
        
        // 屋苑结果
        if (results.estates.isNotEmpty) ...[
          _buildSectionTitle('屋苑 (${results.estateCount})'),
          ...results.estates.take(5).map(
            (estate) => Card(
              margin: const EdgeInsets.only(bottom: AppStyles.spacing12),
              child: ListTile(
                leading: const Icon(Icons.apartment, color: AppColors.secondary),
                title: Text(estate.name),
                subtitle: Text(estate.address ?? ''),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  print('点击了屋苑：${estate.name}');
                },
              ),
            ),
          ),
          if (results.estates.length > 5)
            TextButton(
              onPressed: () {},
              child: Text('查看全部 ${results.estateCount} 個屋苑 →'),
            ),
          const SizedBox(height: AppStyles.spacing16),
        ],
        
        // 代理人结果
        if (results.agents.isNotEmpty) ...[
          _buildSectionTitle('代理人 (${results.agentCount})'),
          ...results.agents.take(5).map(
            (agent) => Card(
              margin: const EdgeInsets.only(bottom: AppStyles.spacing12),
              child: ListTile(
                leading: const Icon(Icons.person, color: AppColors.accent),
                title: Text(agent.name),
                subtitle: Text(agent.agencyName ?? ''),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  print('点击了代理人：${agent.name}');
                },
              ),
            ),
          ),
          if (results.agents.length > 5)
            TextButton(
              onPressed: () {},
              child: Text('查看全部 ${results.agentCount} 個代理人 →'),
            ),
          const SizedBox(height: AppStyles.spacing16),
        ],
        
        // 代理公司结果
        if (results.agencies.isNotEmpty) ...[
          _buildSectionTitle('代理公司 (${results.agencyCount})'),
          ...results.agencies.take(5).map(
            (agency) => Card(
              margin: const EdgeInsets.only(bottom: AppStyles.spacing12),
              child: ListTile(
                leading: const Icon(Icons.business, color: AppColors.primary),
                title: Text(agency.name),
                subtitle: Text(agency.address ?? ''),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  print('点击了代理公司：${agency.name}');
                },
              ),
            ),
          ),
          if (results.agencies.length > 5)
            TextButton(
              onPressed: () {},
              child: Text('查看全部 ${results.agencyCount} 個代理公司 →'),
            ),
        ],
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppStyles.spacing8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: AppStyles.fontSizeH3,
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimary,
        ),
      ),
    );
  }

  Widget _buildPropertyResults(SearchState searchState) {
    final results = searchState.propertyResults!;

    if (results.results.isEmpty) {
      return const Center(
        child: Text(
          '沒有找到相關房產',
          style: TextStyle(
            fontSize: AppStyles.fontSizeBody,
            color: AppColors.textSecondary,
          ),
        ),
      );
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(AppStyles.spacing16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '共找到 ${results.total} 個房產',
                style: const TextStyle(
                  fontSize: AppStyles.fontSizeBody,
                  color: AppColors.textSecondary,
                ),
              ),
              // TODO: 添加筛选和排序按钮
            ],
          ),
        ),
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.symmetric(horizontal: AppStyles.spacing16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              crossAxisSpacing: AppStyles.spacing12,
              mainAxisSpacing: AppStyles.spacing12,
              childAspectRatio: 1 / 1.25,
            ),
            itemCount: results.results.length,
            itemBuilder: (context, index) {
              return const PropertyCard(); // TODO: 传入实际数据
            },
          ),
        ),
      ],
    );
  }

  Widget _buildEstateResults(SearchState searchState) {
    final results = searchState.estateResults!;

    if (results.results.isEmpty) {
      return const Center(
        child: Text(
          '沒有找到相關屋苑',
          style: TextStyle(
            fontSize: AppStyles.fontSizeBody,
            color: AppColors.textSecondary,
          ),
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.all(AppStyles.spacing16),
      children: [
        Text(
          '共找到 ${results.total} 個屋苑',
          style: const TextStyle(
            fontSize: AppStyles.fontSizeBody,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: AppStyles.spacing16),
        ...results.results.map(
          (estate) => Card(
            margin: const EdgeInsets.only(bottom: AppStyles.spacing12),
            child: ListTile(
              leading: estate.images != null && estate.images!.isNotEmpty
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(AppStyles.radiusSmall),
                      child: Image.network(
                        estate.images!.first,
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                      ),
                    )
                  : Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: AppColors.background,
                        borderRadius: BorderRadius.circular(AppStyles.radiusSmall),
                      ),
                      child: const Icon(Icons.apartment, color: AppColors.textTertiary),
                    ),
              title: Text(
                estate.name,
                style: const TextStyle(
                  fontSize: AppStyles.fontSizeBody,
                  fontWeight: FontWeight.w600,
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (estate.address != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      estate.address!,
                      style: const TextStyle(
                        fontSize: AppStyles.fontSizeSmall,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                  if (estate.propertyCount != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      '${estate.propertyCount} 個房源',
                      style: const TextStyle(
                        fontSize: AppStyles.fontSizeSmall,
                        color: AppColors.textTertiary,
                      ),
                    ),
                  ],
                ],
              ),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                // TODO: 导航到屋苑详情页面
                print('点击了屋苑：${estate.name}');
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAgentResults(SearchState searchState) {
    final results = searchState.agentResults!;

    if (results.results.isEmpty) {
      return const Center(
        child: Text(
          '沒有找到相關代理人',
          style: TextStyle(
            fontSize: AppStyles.fontSizeBody,
            color: AppColors.textSecondary,
          ),
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.all(AppStyles.spacing16),
      children: [
        Text(
          '共找到 ${results.total} 個代理人',
          style: const TextStyle(
            fontSize: AppStyles.fontSizeBody,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: AppStyles.spacing16),
        ...results.results.map(
          (agent) => Card(
            margin: const EdgeInsets.only(bottom: AppStyles.spacing12),
            child: ListTile(
              leading: agent.avatar != null
                  ? CircleAvatar(
                      radius: 30,
                      backgroundImage: NetworkImage(agent.avatar!),
                    )
                  : const CircleAvatar(
                      radius: 30,
                      child: Icon(Icons.person),
                    ),
              title: Text(
                agent.name,
                style: const TextStyle(
                  fontSize: AppStyles.fontSizeBody,
                  fontWeight: FontWeight.w600,
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (agent.agencyName != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      agent.agencyName!,
                      style: const TextStyle(
                        fontSize: AppStyles.fontSizeSmall,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                  if (agent.listingsCount != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      '${agent.listingsCount} 個房源',
                      style: const TextStyle(
                        fontSize: AppStyles.fontSizeSmall,
                        color: AppColors.textTertiary,
                      ),
                    ),
                  ],
                ],
              ),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                // TODO: 导航到代理人详情页面
                print('点击了代理人：${agent.name}');
              },
            ),
          ),
        ),
      ],
    );
  }
}
