import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/property.dart';
import '../../data/repositories/property_repository.dart';

/// 房产 Repository Provider
final propertyRepositoryProvider = Provider<PropertyRepository>((ref) {
  return PropertyRepository();
});

/// 买房筛选参数
class BuyPropertyFilter {
  final int? districtId;
  final double? minPrice;
  final double? maxPrice;
  final double? minArea;
  final double? maxArea;
  final int? bedrooms;
  final String? propertyType;
  final String? buildingName;
  final String sortBy;
  final int page;
  final int pageSize;

  BuyPropertyFilter({
    this.districtId,
    this.minPrice,
    this.maxPrice,
    this.minArea,
    this.maxArea,
    this.bedrooms,
    this.propertyType,
    this.buildingName,
    this.sortBy = 'created_at_desc',
    this.page = 1,
    this.pageSize = 20,
  });

  BuyPropertyFilter copyWith({
    int? districtId,
    double? minPrice,
    double? maxPrice,
    double? minArea,
    double? maxArea,
    int? bedrooms,
    String? propertyType,
    String? buildingName,
    String? sortBy,
    int? page,
    int? pageSize,
  }) {
    return BuyPropertyFilter(
      districtId: districtId ?? this.districtId,
      minPrice: minPrice ?? this.minPrice,
      maxPrice: maxPrice ?? this.maxPrice,
      minArea: minArea ?? this.minArea,
      maxArea: maxArea ?? this.maxArea,
      bedrooms: bedrooms ?? this.bedrooms,
      propertyType: propertyType ?? this.propertyType,
      buildingName: buildingName ?? this.buildingName,
      sortBy: sortBy ?? this.sortBy,
      page: page ?? this.page,
      pageSize: pageSize ?? this.pageSize,
    );
  }
}

/// 买房房源状态
class BuyPropertyState {
  final bool isLoading;
  final String? error;
  final PropertyListResponse? response;
  final BuyPropertyFilter filter;

  BuyPropertyState({
    this.isLoading = false,
    this.error,
    this.response,
    BuyPropertyFilter? filter,
  }) : filter = filter ?? BuyPropertyFilter();

  BuyPropertyState copyWith({
    bool? isLoading,
    String? error,
    PropertyListResponse? response,
    BuyPropertyFilter? filter,
  }) {
    return BuyPropertyState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      response: response ?? this.response,
      filter: filter ?? this.filter,
    );
  }
}

/// 买房房源 Notifier
class BuyPropertyNotifier extends StateNotifier<BuyPropertyState> {
  final PropertyRepository _repository;

  BuyPropertyNotifier(this._repository) : super(BuyPropertyState());

  /// 加载买房房源列表
  Future<void> loadProperties({BuyPropertyFilter? filter}) async {
    final currentFilter = filter ?? state.filter;
    state = state.copyWith(isLoading: true, error: null, filter: currentFilter);

    try {
      final response = await _repository.getBuyProperties(
        districtId: currentFilter.districtId,
        minPrice: currentFilter.minPrice,
        maxPrice: currentFilter.maxPrice,
        minArea: currentFilter.minArea,
        maxArea: currentFilter.maxArea,
        bedrooms: currentFilter.bedrooms,
        propertyType: currentFilter.propertyType,
        buildingName: currentFilter.buildingName,
        sortBy: currentFilter.sortBy,
        page: currentFilter.page,
        pageSize: currentFilter.pageSize,
      );

      state = state.copyWith(
        isLoading: false,
        response: response,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  /// 更新筛选条件并重新加载
  Future<void> updateFilter({
    int? districtId,
    double? minPrice,
    double? maxPrice,
    double? minArea,
    double? maxArea,
    int? bedrooms,
    String? propertyType,
    String? buildingName,
    String? sortBy,
  }) async {
    final newFilter = state.filter.copyWith(
      districtId: districtId,
      minPrice: minPrice,
      maxPrice: maxPrice,
      minArea: minArea,
      maxArea: maxArea,
      bedrooms: bedrooms,
      propertyType: propertyType,
      buildingName: buildingName,
      sortBy: sortBy,
      page: 1, // 重置为第一页
    );

    await loadProperties(filter: newFilter);
  }

  /// 切换页码
  Future<void> changePage(int page) async {
    final newFilter = state.filter.copyWith(page: page);
    await loadProperties(filter: newFilter);
  }

  /// 清空筛选条件
  Future<void> clearFilter() async {
    await loadProperties(filter: BuyPropertyFilter());
  }
}

/// 买房房源 Provider
final buyPropertyProvider = StateNotifierProvider<BuyPropertyNotifier, BuyPropertyState>((ref) {
  final repository = ref.watch(propertyRepositoryProvider);
  return BuyPropertyNotifier(repository);
});

// ============ 租房相关 ============

/// 租房筛选参数
class RentPropertyFilter {
  final int? districtId;
  final double? minPrice;
  final double? maxPrice;
  final double? minArea;
  final double? maxArea;
  final int? bedrooms;
  final String? propertyType;
  final String? buildingName;
  final String sortBy;
  final int page;
  final int pageSize;

  RentPropertyFilter({
    this.districtId,
    this.minPrice,
    this.maxPrice,
    this.minArea,
    this.maxArea,
    this.bedrooms,
    this.propertyType,
    this.buildingName,
    this.sortBy = 'created_at_desc',
    this.page = 1,
    this.pageSize = 20,
  });

  RentPropertyFilter copyWith({
    int? districtId,
    double? minPrice,
    double? maxPrice,
    double? minArea,
    double? maxArea,
    int? bedrooms,
    String? propertyType,
    String? buildingName,
    String? sortBy,
    int? page,
    int? pageSize,
  }) {
    return RentPropertyFilter(
      districtId: districtId ?? this.districtId,
      minPrice: minPrice ?? this.minPrice,
      maxPrice: maxPrice ?? this.maxPrice,
      minArea: minArea ?? this.minArea,
      maxArea: maxArea ?? this.maxArea,
      bedrooms: bedrooms ?? this.bedrooms,
      propertyType: propertyType ?? this.propertyType,
      buildingName: buildingName ?? this.buildingName,
      sortBy: sortBy ?? this.sortBy,
      page: page ?? this.page,
      pageSize: pageSize ?? this.pageSize,
    );
  }
}

/// 租房房源状态
class RentPropertyState {
  final bool isLoading;
  final String? error;
  final PropertyListResponse? response;
  final RentPropertyFilter filter;

  RentPropertyState({
    this.isLoading = false,
    this.error,
    this.response,
    RentPropertyFilter? filter,
  }) : filter = filter ?? RentPropertyFilter();

  RentPropertyState copyWith({
    bool? isLoading,
    String? error,
    PropertyListResponse? response,
    RentPropertyFilter? filter,
  }) {
    return RentPropertyState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      response: response ?? this.response,
      filter: filter ?? this.filter,
    );
  }
}

/// 租房房源 Notifier
class RentPropertyNotifier extends StateNotifier<RentPropertyState> {
  final PropertyRepository _repository;

  RentPropertyNotifier(this._repository) : super(RentPropertyState());

  /// 加载租房房源列表
  Future<void> loadProperties({RentPropertyFilter? filter}) async {
    final currentFilter = filter ?? state.filter;
    state = state.copyWith(isLoading: true, error: null, filter: currentFilter);

    try {
      final response = await _repository.getRentProperties(
        districtId: currentFilter.districtId,
        minPrice: currentFilter.minPrice,
        maxPrice: currentFilter.maxPrice,
        minArea: currentFilter.minArea,
        maxArea: currentFilter.maxArea,
        bedrooms: currentFilter.bedrooms,
        propertyType: currentFilter.propertyType,
        buildingName: currentFilter.buildingName,
        sortBy: currentFilter.sortBy,
        page: currentFilter.page,
        pageSize: currentFilter.pageSize,
      );

      state = state.copyWith(
        isLoading: false,
        response: response,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  /// 更新筛选条件并重新加载
  Future<void> updateFilter({
    int? districtId,
    double? minPrice,
    double? maxPrice,
    double? minArea,
    double? maxArea,
    int? bedrooms,
    String? propertyType,
    String? buildingName,
    String? sortBy,
  }) async {
    final newFilter = state.filter.copyWith(
      districtId: districtId,
      minPrice: minPrice,
      maxPrice: maxPrice,
      minArea: minArea,
      maxArea: maxArea,
      bedrooms: bedrooms,
      propertyType: propertyType,
      buildingName: buildingName,
      sortBy: sortBy,
      page: 1, // 重置为第一页
    );

    await loadProperties(filter: newFilter);
  }

  /// 切换页码
  Future<void> changePage(int page) async {
    final newFilter = state.filter.copyWith(page: page);
    await loadProperties(filter: newFilter);
  }

  /// 清空筛选条件
  Future<void> clearFilter() async {
    await loadProperties(filter: RentPropertyFilter());
  }
}

/// 租房房源 Provider
final rentPropertyProvider = StateNotifierProvider<RentPropertyNotifier, RentPropertyState>((ref) {
  final repository = ref.watch(propertyRepositoryProvider);
  return RentPropertyNotifier(repository);
});

// ==================== 通用房产 Provider（用于主页等） ====================

/// 通用房产状态
class PropertyState {
  final List<Property> properties;
  final bool isLoading;
  final String? error;
  final int currentPage;
  final int totalPages;
  final int total;

  PropertyState({
    this.properties = const [],
    this.isLoading = false,
    this.error,
    this.currentPage = 1,
    this.totalPages = 1,
    this.total = 0,
  });

  PropertyState copyWith({
    List<Property>? properties,
    bool? isLoading,
    String? error,
    int? currentPage,
    int? totalPages,
    int? total,
  }) {
    return PropertyState(
      properties: properties ?? this.properties,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages ?? this.totalPages,
      total: total ?? this.total,
    );
  }
}

/// 通用房产状态通知器
class PropertyNotifier extends StateNotifier<PropertyState> {
  final PropertyRepository _repository;

  PropertyNotifier(this._repository) : super(PropertyState());

  /// 获取房产列表
  Future<void> getProperties({
    int page = 1,
    int pageSize = 12,
  }) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final response = await _repository.getProperties(
        page: page,
        pageSize: pageSize,
      );

      state = state.copyWith(
        properties: response.properties,
        currentPage: response.page,
        totalPages: response.totalPages,
        total: response.total,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  /// 加载下一页
  Future<void> loadNextPage() async {
    if (state.currentPage >= state.totalPages || state.isLoading) return;
    await getProperties(page: state.currentPage + 1);
  }

  /// 加载上一页
  Future<void> loadPreviousPage() async {
    if (state.currentPage <= 1 || state.isLoading) return;
    await getProperties(page: state.currentPage - 1);
  }

  /// 跳转到指定页
  Future<void> goToPage(int page) async {
    if (page < 1 || page > state.totalPages || state.isLoading) return;
    await getProperties(page: page);
  }

  /// 刷新数据
  Future<void> refresh() async {
    await getProperties(page: 1);
  }
}

/// 通用房产 Provider
final propertyProvider = StateNotifierProvider<PropertyNotifier, PropertyState>((ref) {
  final repository = ref.watch(propertyRepositoryProvider);
  return PropertyNotifier(repository);
});
