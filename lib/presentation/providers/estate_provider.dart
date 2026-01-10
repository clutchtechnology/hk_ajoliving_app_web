import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/estate_repository.dart';
import '../../data/models/estate.dart';
import '../../data/services/estate_service.dart';
import '../../core/network/api_client.dart';

// ==================== 依赖注入 ====================

final apiClientProviderForEstate = Provider<ApiClient>((ref) => ApiClient());

final estateServiceProvider = Provider<EstateService>((ref) {
  return EstateService(ref.watch(apiClientProviderForEstate));
});

final estateRepositoryProvider = Provider<EstateRepository>((ref) {
  return EstateRepository(ref.watch(estateServiceProvider));
});

// ==================== 筛选条件 ====================

/// 屋苑筛选条件
class EstateFilter {
  final int? districtId;
  final String? primarySchoolNet;
  final String? secondarySchoolNet;
  final String? developer;
  final double? minAvgPrice;
  final double? maxAvgPrice;
  final bool? isFeatured;
  final String? keyword;
  final String? sortBy; // name, recent_transactions, avg_price, view_count
  final String? sortOrder; // asc, desc

  EstateFilter({
    this.districtId,
    this.primarySchoolNet,
    this.secondarySchoolNet,
    this.developer,
    this.minAvgPrice,
    this.maxAvgPrice,
    this.isFeatured,
    this.keyword,
    this.sortBy,
    this.sortOrder,
  });

  EstateFilter copyWith({
    int? districtId,
    String? primarySchoolNet,
    String? secondarySchoolNet,
    String? developer,
    double? minAvgPrice,
    double? maxAvgPrice,
    bool? isFeatured,
    String? keyword,
    String? sortBy,
    String? sortOrder,
  }) {
    return EstateFilter(
      districtId: districtId ?? this.districtId,
      primarySchoolNet: primarySchoolNet ?? this.primarySchoolNet,
      secondarySchoolNet: secondarySchoolNet ?? this.secondarySchoolNet,
      developer: developer ?? this.developer,
      minAvgPrice: minAvgPrice ?? this.minAvgPrice,
      maxAvgPrice: maxAvgPrice ?? this.maxAvgPrice,
      isFeatured: isFeatured ?? this.isFeatured,
      keyword: keyword ?? this.keyword,
      sortBy: sortBy ?? this.sortBy,
      sortOrder: sortOrder ?? this.sortOrder,
    );
  }
}

// ==================== 状态 ====================

/// 屋苑状态
class EstateState {
  final List<Estate> estates;
  final bool isLoading;
  final String? error;
  final int currentPage;
  final int totalPages;
  final EstateFilter filter;

  EstateState({
    this.estates = const [],
    this.isLoading = false,
    this.error,
    this.currentPage = 1,
    this.totalPages = 1,
    EstateFilter? filter,
  }) : filter = filter ?? EstateFilter();

  EstateState copyWith({
    List<Estate>? estates,
    bool? isLoading,
    String? error,
    int? currentPage,
    int? totalPages,
    EstateFilter? filter,
  }) {
    return EstateState(
      estates: estates ?? this.estates,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages ?? this.totalPages,
      filter: filter ?? this.filter,
    );
  }
}

// ==================== Notifier ====================

/// 屋苑 Notifier
class EstateNotifier extends StateNotifier<EstateState> {
  final EstateRepository _repository;

  EstateNotifier(this._repository) : super(EstateState());

  /// 加载屋苑列表
  Future<void> loadEstates({int page = 1}) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final response = await _repository.getEstates(
        districtId: state.filter.districtId,
        primarySchoolNet: state.filter.primarySchoolNet,
        secondarySchoolNet: state.filter.secondarySchoolNet,
        developer: state.filter.developer,
        minAvgPrice: state.filter.minAvgPrice,
        maxAvgPrice: state.filter.maxAvgPrice,
        isFeatured: state.filter.isFeatured,
        keyword: state.filter.keyword,
        sortBy: state.filter.sortBy,
        sortOrder: state.filter.sortOrder,
        page: page,
        pageSize: 20,
      );

      state = state.copyWith(
        estates: response.estates,
        currentPage: response.page,
        totalPages: response.totalPages,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  /// 更新筛选条件
  void updateFilter(EstateFilter filter) {
    state = state.copyWith(filter: filter);
    loadEstates(page: 1);
  }

  /// 更新地区筛选
  void updateDistrict(int? districtId) {
    final newFilter = state.filter.copyWith(districtId: districtId);
    updateFilter(newFilter);
  }

  /// 更新价格范围
  void updatePriceRange(double? minPrice, double? maxPrice) {
    final newFilter = state.filter.copyWith(
      minAvgPrice: minPrice,
      maxAvgPrice: maxPrice,
    );
    updateFilter(newFilter);
  }

  /// 更新发展商筛选
  void updateDeveloper(String? developer) {
    final newFilter = state.filter.copyWith(developer: developer);
    updateFilter(newFilter);
  }

  /// 更新校网筛选
  void updateSchoolNet(String? primary, String? secondary) {
    final newFilter = state.filter.copyWith(
      primarySchoolNet: primary,
      secondarySchoolNet: secondary,
    );
    updateFilter(newFilter);
  }

  /// 更新排序
  void updateSort(String? sortBy, String? sortOrder) {
    final newFilter = state.filter.copyWith(
      sortBy: sortBy,
      sortOrder: sortOrder,
    );
    updateFilter(newFilter);
  }

  /// 切换精选筛选
  void toggleFeatured() {
    final currentFeatured = state.filter.isFeatured;
    final newFilter = state.filter.copyWith(
      isFeatured: currentFeatured == null || !currentFeatured ? true : null,
    );
    updateFilter(newFilter);
  }

  /// 搜索关键词
  void search(String keyword) {
    final newFilter = state.filter.copyWith(keyword: keyword);
    updateFilter(newFilter);
  }

  /// 清除筛选
  void clearFilter() {
    state = state.copyWith(filter: EstateFilter());
    loadEstates(page: 1);
  }

  /// 换页
  void changePage(int page) {
    if (page >= 1 && page <= state.totalPages) {
      loadEstates(page: page);
    }
  }

  /// 下一页
  void nextPage() {
    if (state.currentPage < state.totalPages) {
      changePage(state.currentPage + 1);
    }
  }

  /// 上一页
  void previousPage() {
    if (state.currentPage > 1) {
      changePage(state.currentPage - 1);
    }
  }
}

// ==================== Provider ====================

/// 屋苑 Provider
final estateProvider = StateNotifierProvider<EstateNotifier, EstateState>((ref) {
  final repository = ref.watch(estateRepositoryProvider);
  return EstateNotifier(repository);
});
