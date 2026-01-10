import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/valuation_repository.dart';
import '../../data/models/valuation.dart';
import '../../data/services/valuation_service.dart';
import '../../core/network/api_client.dart';

// ==================== 依赖注入 ====================

final apiClientProviderForValuation = Provider<ApiClient>((ref) => ApiClient());

final valuationServiceProvider = Provider<ValuationService>((ref) {
  return ValuationService(ref.watch(apiClientProviderForValuation));
});

final valuationRepositoryProvider = Provider<ValuationRepository>((ref) {
  return ValuationRepository(ref.watch(valuationServiceProvider));
});

// ==================== 筛选条件 ====================

/// 估价筛选条件
class ValuationFilter {
  final int? districtId;
  final String? primarySchoolNet;
  final String? secondarySchoolNet;
  final double? minAvgPrice;
  final double? maxAvgPrice;
  final double? minRentalYield;
  final String? keyword;
  final String? sortBy; // price, yield, transactions, name
  final String? sortOrder; // asc, desc

  ValuationFilter({
    this.districtId,
    this.primarySchoolNet,
    this.secondarySchoolNet,
    this.minAvgPrice,
    this.maxAvgPrice,
    this.minRentalYield,
    this.keyword,
    this.sortBy,
    this.sortOrder,
  });

  ValuationFilter copyWith({
    int? districtId,
    String? primarySchoolNet,
    String? secondarySchoolNet,
    double? minAvgPrice,
    double? maxAvgPrice,
    double? minRentalYield,
    String? keyword,
    String? sortBy,
    String? sortOrder,
  }) {
    return ValuationFilter(
      districtId: districtId ?? this.districtId,
      primarySchoolNet: primarySchoolNet ?? this.primarySchoolNet,
      secondarySchoolNet: secondarySchoolNet ?? this.secondarySchoolNet,
      minAvgPrice: minAvgPrice ?? this.minAvgPrice,
      maxAvgPrice: maxAvgPrice ?? this.maxAvgPrice,
      minRentalYield: minRentalYield ?? this.minRentalYield,
      keyword: keyword ?? this.keyword,
      sortBy: sortBy ?? this.sortBy,
      sortOrder: sortOrder ?? this.sortOrder,
    );
  }

  ValuationFilter clearFilter() {
    return ValuationFilter();
  }
}

// ==================== 状态类 ====================

class ValuationState {
  final List<Valuation> valuations;
  final bool isLoading;
  final String? error;
  final int currentPage;
  final int totalPages;
  final ValuationFilter filter;

  ValuationState({
    this.valuations = const [],
    this.isLoading = false,
    this.error,
    this.currentPage = 1,
    this.totalPages = 0,
    ValuationFilter? filter,
  }) : filter = filter ?? ValuationFilter();

  ValuationState copyWith({
    List<Valuation>? valuations,
    bool? isLoading,
    String? error,
    int? currentPage,
    int? totalPages,
    ValuationFilter? filter,
  }) {
    return ValuationState(
      valuations: valuations ?? this.valuations,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages ?? this.totalPages,
      filter: filter ?? this.filter,
    );
  }
}

// ==================== 状态管理 ====================

class ValuationNotifier extends StateNotifier<ValuationState> {
  final ValuationRepository _repository;

  ValuationNotifier(this._repository) : super(ValuationState());

  /// 加载估价列表
  Future<void> loadValuations({int? page}) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final currentPage = page ?? state.currentPage;
      final response = await _repository.getValuations(
        districtId: state.filter.districtId,
        primarySchoolNet: state.filter.primarySchoolNet,
        secondarySchoolNet: state.filter.secondarySchoolNet,
        minAvgPrice: state.filter.minAvgPrice,
        maxAvgPrice: state.filter.maxAvgPrice,
        minRentalYield: state.filter.minRentalYield,
        keyword: state.filter.keyword,
        sortBy: state.filter.sortBy,
        sortOrder: state.filter.sortOrder,
        page: currentPage,
        pageSize: 20,
      );

      state = state.copyWith(
        valuations: response.valuations,
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

  /// 搜索估价
  Future<void> search(String keyword) async {
    if (keyword.isEmpty) {
      state = state.copyWith(filter: state.filter.copyWith(keyword: null));
      await loadValuations(page: 1);
      return;
    }

    state = state.copyWith(
      isLoading: true,
      error: null,
      filter: state.filter.copyWith(keyword: keyword),
    );

    try {
      final response = await _repository.searchValuations(
        keyword: keyword,
        page: 1,
        pageSize: 20,
      );

      state = state.copyWith(
        valuations: response.valuations,
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

  /// 更新筛选条件
  void updateFilter(ValuationFilter filter) {
    state = state.copyWith(filter: filter);
    loadValuations(page: 1);
  }

  /// 更新地区
  void updateDistrict(int? districtId) {
    state = state.copyWith(filter: state.filter.copyWith(districtId: districtId));
    loadValuations(page: 1);
  }

  /// 更新价格范围
  void updatePriceRange(double? minPrice, double? maxPrice) {
    state = state.copyWith(
      filter: state.filter.copyWith(
        minAvgPrice: minPrice,
        maxAvgPrice: maxPrice,
      ),
    );
    loadValuations(page: 1);
  }

  /// 更新租金回报率
  void updateRentalYield(double? minYield) {
    state = state.copyWith(
      filter: state.filter.copyWith(minRentalYield: minYield),
    );
    loadValuations(page: 1);
  }

  /// 更新校网
  void updateSchoolNet(String? primarySchoolNet, String? secondarySchoolNet) {
    state = state.copyWith(
      filter: state.filter.copyWith(
        primarySchoolNet: primarySchoolNet,
        secondarySchoolNet: secondarySchoolNet,
      ),
    );
    loadValuations(page: 1);
  }

  /// 更新排序
  void updateSort(String sortBy, String sortOrder) {
    state = state.copyWith(
      filter: state.filter.copyWith(
        sortBy: sortBy,
        sortOrder: sortOrder,
      ),
    );
    loadValuations(page: 1);
  }

  /// 清除筛选
  void clearFilter() {
    state = state.copyWith(filter: ValuationFilter());
    loadValuations(page: 1);
  }

  /// 切换页码
  void changePage(int page) {
    loadValuations(page: page);
  }

  /// 下一页
  void nextPage() {
    if (state.currentPage < state.totalPages) {
      loadValuations(page: state.currentPage + 1);
    }
  }

  /// 上一页
  void previousPage() {
    if (state.currentPage > 1) {
      loadValuations(page: state.currentPage - 1);
    }
  }
}

// ==================== Provider ====================

final valuationProvider = StateNotifierProvider<ValuationNotifier, ValuationState>((ref) {
  return ValuationNotifier(ref.watch(valuationRepositoryProvider));
});
