import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/agency_repository.dart';
import '../../data/models/agency.dart';
import '../../data/services/agency_service.dart';
import '../../core/network/api_client.dart';

// ==================== 依赖注入 ====================

final apiClientProviderForAgency = Provider<ApiClient>((ref) => ApiClient());

final agencyServiceProvider = Provider<AgencyService>((ref) {
  return AgencyService(ref.watch(apiClientProviderForAgency));
});

final agencyRepositoryProvider = Provider<AgencyRepository>((ref) {
  return AgencyRepository(ref.watch(agencyServiceProvider));
});

// ==================== 筛选条件 ====================

/// 代理公司筛选条件
class AgencyFilter {
  final int? districtId;
  final double? minRating;
  final bool? isVerified;
  final String? keyword;
  final String? sortBy; // rating, agent_count, established_year, created_at
  final String? sortOrder; // asc, desc

  AgencyFilter({
    this.districtId,
    this.minRating,
    this.isVerified,
    this.keyword,
    this.sortBy,
    this.sortOrder,
  });

  AgencyFilter copyWith({
    int? districtId,
    double? minRating,
    bool? isVerified,
    String? keyword,
    String? sortBy,
    String? sortOrder,
  }) {
    return AgencyFilter(
      districtId: districtId ?? this.districtId,
      minRating: minRating ?? this.minRating,
      isVerified: isVerified ?? this.isVerified,
      keyword: keyword ?? this.keyword,
      sortBy: sortBy ?? this.sortBy,
      sortOrder: sortOrder ?? this.sortOrder,
    );
  }

  AgencyFilter clearFilter() {
    return AgencyFilter();
  }
}

// ==================== 状态类 ====================

class AgencyState {
  final List<Agency> agencies;
  final bool isLoading;
  final String? error;
  final int currentPage;
  final int totalPages;
  final AgencyFilter filter;

  AgencyState({
    this.agencies = const [],
    this.isLoading = false,
    this.error,
    this.currentPage = 1,
    this.totalPages = 0,
    AgencyFilter? filter,
  }) : filter = filter ?? AgencyFilter();

  AgencyState copyWith({
    List<Agency>? agencies,
    bool? isLoading,
    String? error,
    int? currentPage,
    int? totalPages,
    AgencyFilter? filter,
  }) {
    return AgencyState(
      agencies: agencies ?? this.agencies,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages ?? this.totalPages,
      filter: filter ?? this.filter,
    );
  }
}

// ==================== 状态管理 ====================

class AgencyNotifier extends StateNotifier<AgencyState> {
  final AgencyRepository _repository;

  AgencyNotifier(this._repository) : super(AgencyState());

  /// 加载代理公司列表
  Future<void> loadAgencies({int? page}) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final currentPage = page ?? state.currentPage;
      final response = await _repository.getAgencies(
        districtId: state.filter.districtId,
        minRating: state.filter.minRating,
        isVerified: state.filter.isVerified,
        keyword: state.filter.keyword,
        sortBy: state.filter.sortBy,
        sortOrder: state.filter.sortOrder,
        page: currentPage,
        pageSize: 20,
      );

      state = state.copyWith(
        agencies: response.agencies,
        isLoading: false,
        currentPage: response.page,
        totalPages: response.totalPages,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  /// 搜索代理公司
  Future<void> search(String keyword) async {
    state = state.copyWith(
      filter: state.filter.copyWith(keyword: keyword),
    );
    await loadAgencies(page: 1);
  }

  /// 更新筛选条件
  void updateFilter(AgencyFilter filter) {
    state = state.copyWith(filter: filter);
    loadAgencies(page: 1);
  }

  /// 更新地区
  void updateDistrict(int? districtId) {
    state = state.copyWith(filter: state.filter.copyWith(districtId: districtId));
    loadAgencies(page: 1);
  }

  /// 更新最低评分
  void updateMinRating(double? minRating) {
    state = state.copyWith(filter: state.filter.copyWith(minRating: minRating));
    loadAgencies(page: 1);
  }

  /// 更新验证状态
  void updateIsVerified(bool? isVerified) {
    state = state.copyWith(filter: state.filter.copyWith(isVerified: isVerified));
    loadAgencies(page: 1);
  }

  /// 更新排序
  void updateSort(String? sortBy, String? sortOrder) {
    state = state.copyWith(
      filter: state.filter.copyWith(sortBy: sortBy, sortOrder: sortOrder),
    );
    loadAgencies(page: 1);
  }

  /// 清除筛选
  void clearFilter() {
    state = state.copyWith(filter: AgencyFilter());
    loadAgencies(page: 1);
  }

  /// 切换页码
  void changePage(int page) {
    loadAgencies(page: page);
  }

  /// 下一页
  void nextPage() {
    if (state.currentPage < state.totalPages) {
      loadAgencies(page: state.currentPage + 1);
    }
  }

  /// 上一页
  void previousPage() {
    if (state.currentPage > 1) {
      loadAgencies(page: state.currentPage - 1);
    }
  }
}

// ==================== Provider ====================

final agencyProvider = StateNotifierProvider<AgencyNotifier, AgencyState>((ref) {
  return AgencyNotifier(ref.watch(agencyRepositoryProvider));
});
