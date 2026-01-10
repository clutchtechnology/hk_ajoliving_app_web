import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/new_property.dart';
import '../../data/repositories/new_property_repository.dart';

/// 新盘 Repository Provider
final newPropertyRepositoryProvider = Provider<NewPropertyRepository>((ref) {
  return NewPropertyRepository();
});

/// 新盘筛选参数
class NewPropertyFilter {
  final int? districtId;
  final String? status; // upcoming, presale, selling, completed
  final String? developer;
  final double? minPrice;
  final double? maxPrice;
  final String? primarySchoolNet;
  final String? secondarySchoolNet;
  final bool? isFeatured;
  final int page;
  final int pageSize;

  NewPropertyFilter({
    this.districtId,
    this.status,
    this.developer,
    this.minPrice,
    this.maxPrice,
    this.primarySchoolNet,
    this.secondarySchoolNet,
    this.isFeatured,
    this.page = 1,
    this.pageSize = 20,
  });

  NewPropertyFilter copyWith({
    int? districtId,
    String? status,
    String? developer,
    double? minPrice,
    double? maxPrice,
    String? primarySchoolNet,
    String? secondarySchoolNet,
    bool? isFeatured,
    int? page,
    int? pageSize,
  }) {
    return NewPropertyFilter(
      districtId: districtId ?? this.districtId,
      status: status ?? this.status,
      developer: developer ?? this.developer,
      minPrice: minPrice ?? this.minPrice,
      maxPrice: maxPrice ?? this.maxPrice,
      primarySchoolNet: primarySchoolNet ?? this.primarySchoolNet,
      secondarySchoolNet: secondarySchoolNet ?? this.secondarySchoolNet,
      isFeatured: isFeatured ?? this.isFeatured,
      page: page ?? this.page,
      pageSize: pageSize ?? this.pageSize,
    );
  }
}

/// 新盘状态
class NewPropertyState {
  final bool isLoading;
  final String? error;
  final NewPropertyListResponse? response;
  final NewPropertyFilter filter;

  NewPropertyState({
    this.isLoading = false,
    this.error,
    this.response,
    NewPropertyFilter? filter,
  }) : filter = filter ?? NewPropertyFilter();

  NewPropertyState copyWith({
    bool? isLoading,
    String? error,
    NewPropertyListResponse? response,
    NewPropertyFilter? filter,
  }) {
    return NewPropertyState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      response: response ?? this.response,
      filter: filter ?? this.filter,
    );
  }
}

/// 新盘 Notifier
class NewPropertyNotifier extends StateNotifier<NewPropertyState> {
  final NewPropertyRepository _repository;

  NewPropertyNotifier(this._repository) : super(NewPropertyState());

  /// 加载新盘列表
  Future<void> loadProperties({NewPropertyFilter? filter}) async {
    final currentFilter = filter ?? state.filter;
    state = state.copyWith(isLoading: true, error: null, filter: currentFilter);

    try {
      final response = await _repository.getNewProperties(
        districtId: currentFilter.districtId,
        status: currentFilter.status,
        developer: currentFilter.developer,
        minPrice: currentFilter.minPrice,
        maxPrice: currentFilter.maxPrice,
        primarySchoolNet: currentFilter.primarySchoolNet,
        secondarySchoolNet: currentFilter.secondarySchoolNet,
        isFeatured: currentFilter.isFeatured,
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
    String? status,
    String? developer,
    double? minPrice,
    double? maxPrice,
    String? primarySchoolNet,
    String? secondarySchoolNet,
    bool? isFeatured,
  }) async {
    final newFilter = state.filter.copyWith(
      districtId: districtId,
      status: status,
      developer: developer,
      minPrice: minPrice,
      maxPrice: maxPrice,
      primarySchoolNet: primarySchoolNet,
      secondarySchoolNet: secondarySchoolNet,
      isFeatured: isFeatured,
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
    await loadProperties(filter: NewPropertyFilter());
  }
}

/// 新盘 Provider
final newPropertyProvider = StateNotifierProvider<NewPropertyNotifier, NewPropertyState>((ref) {
  final repository = ref.watch(newPropertyRepositoryProvider);
  return NewPropertyNotifier(repository);
});
