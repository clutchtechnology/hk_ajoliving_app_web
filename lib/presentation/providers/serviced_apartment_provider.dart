import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/serviced_apartment_repository.dart';
import '../../data/models/serviced_apartment.dart';
import '../../data/services/serviced_apartment_service.dart';
import '../../core/network/api_client.dart';

// ==================== 依赖注入 ====================

final apiClientProvider = Provider<ApiClient>((ref) => ApiClient());

final servicedApartmentServiceProvider = Provider<ServicedApartmentService>((ref) {
  return ServicedApartmentService(ref.watch(apiClientProvider));
});

final servicedApartmentRepositoryProvider = Provider<ServicedApartmentRepository>((ref) {
  return ServicedApartmentRepository(ref.watch(servicedApartmentServiceProvider));
});

// ==================== 筛选条件 ====================

/// 服务式公寓筛选条件
class ServicedApartmentFilter {
  final int? districtId;
  final double? minPrice;
  final double? maxPrice;
  final double? minRating;
  final String? status;
  final bool? isFeatured;
  final String priceType; // 'daily', 'monthly'

  ServicedApartmentFilter({
    this.districtId,
    this.minPrice,
    this.maxPrice,
    this.minRating,
    this.status,
    this.isFeatured,
    this.priceType = 'monthly',
  });

  ServicedApartmentFilter copyWith({
    int? districtId,
    double? minPrice,
    double? maxPrice,
    double? minRating,
    String? status,
    bool? isFeatured,
    String? priceType,
  }) {
    return ServicedApartmentFilter(
      districtId: districtId ?? this.districtId,
      minPrice: minPrice ?? this.minPrice,
      maxPrice: maxPrice ?? this.maxPrice,
      minRating: minRating ?? this.minRating,
      status: status ?? this.status,
      isFeatured: isFeatured ?? this.isFeatured,
      priceType: priceType ?? this.priceType,
    );
  }

  void clear() {}
}

// ==================== 状态 ====================

/// 服务式公寓状态
class ServicedApartmentState {
  final List<ServicedApartment> apartments;
  final bool isLoading;
  final String? error;
  final int currentPage;
  final int totalPages;
  final ServicedApartmentFilter filter;

  ServicedApartmentState({
    this.apartments = const [],
    this.isLoading = false,
    this.error,
    this.currentPage = 1,
    this.totalPages = 1,
    ServicedApartmentFilter? filter,
  }) : filter = filter ?? ServicedApartmentFilter();

  ServicedApartmentState copyWith({
    List<ServicedApartment>? apartments,
    bool? isLoading,
    String? error,
    int? currentPage,
    int? totalPages,
    ServicedApartmentFilter? filter,
  }) {
    return ServicedApartmentState(
      apartments: apartments ?? this.apartments,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages ?? this.totalPages,
      filter: filter ?? this.filter,
    );
  }
}

// ==================== Notifier ====================

/// 服务式公寓 Notifier
class ServicedApartmentNotifier extends StateNotifier<ServicedApartmentState> {
  final ServicedApartmentRepository _repository;

  ServicedApartmentNotifier(this._repository) : super(ServicedApartmentState());

  /// 加载服务式公寓列表
  Future<void> loadApartments({int page = 1}) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final response = await _repository.getServicedApartments(
        districtId: state.filter.districtId,
        minPrice: state.filter.minPrice,
        maxPrice: state.filter.maxPrice,
        minRating: state.filter.minRating,
        status: state.filter.status,
        isFeatured: state.filter.isFeatured,
        page: page,
        pageSize: 20,
      );

      state = state.copyWith(
        apartments: response.apartments,
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
  void updateFilter(ServicedApartmentFilter filter) {
    state = state.copyWith(filter: filter);
    loadApartments(page: 1);
  }

  /// 切换价格类型（日租/月租）
  void togglePriceType() {
    final newPriceType = state.filter.priceType == 'daily' ? 'monthly' : 'daily';
    final newFilter = state.filter.copyWith(priceType: newPriceType);
    state = state.copyWith(filter: newFilter);
  }

  /// 更新地区筛选
  void updateDistrict(int? districtId) {
    final newFilter = state.filter.copyWith(districtId: districtId);
    updateFilter(newFilter);
  }

  /// 更新价格范围
  void updatePriceRange(double? minPrice, double? maxPrice) {
    final newFilter = state.filter.copyWith(
      minPrice: minPrice,
      maxPrice: maxPrice,
    );
    updateFilter(newFilter);
  }

  /// 更新评分筛选
  void updateRating(double? minRating) {
    final newFilter = state.filter.copyWith(minRating: minRating);
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

  /// 清除筛选
  void clearFilter() {
    state = state.copyWith(filter: ServicedApartmentFilter());
    loadApartments(page: 1);
  }

  /// 换页
  void changePage(int page) {
    if (page >= 1 && page <= state.totalPages) {
      loadApartments(page: page);
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

/// 服务式公寓 Provider
final servicedApartmentProvider = StateNotifierProvider<ServicedApartmentNotifier, ServicedApartmentState>((ref) {
  final repository = ref.watch(servicedApartmentRepositoryProvider);
  return ServicedApartmentNotifier(repository);
});
