/// API 端点常量
class ApiEndpoints {
  // 基础 URL（根据环境配置）
  static const String baseUrl = 'https://ajoliving-api.zeabur.app';
  
  // API 版本前缀
  static const String apiV1 = '/api/v1';
  
  // ==================== 搜索 API ====================
  
  /// 全局搜索
  static const String globalSearch = '$apiV1/search';
  
  /// 搜索房产
  static const String searchProperties = '$apiV1/search/properties';
  
  /// 搜索屋苑
  static const String searchEstates = '$apiV1/search/estates';
  
  /// 搜索代理人
  static const String searchAgents = '$apiV1/search/agents';
  
  /// 搜索建议
  static const String searchSuggestions = '$apiV1/search/suggestions';
  
  /// 搜索历史
  static const String searchHistory = '$apiV1/search/history';
  
  // ==================== 房产 API ====================
  
  /// 房产列表
  static const String properties = '$apiV1/properties';
  
  /// 房产详情
  static String propertyDetail(int id) => '$apiV1/properties/$id';
  
  /// 买房房源列表
  static const String buyProperties = '$apiV1/properties/buy';
  
  /// 租房房源列表
  static const String rentProperties = '$apiV1/properties/rent';
  
  /// 精选房源
  static const String featuredProperties = '$apiV1/properties/featured';
  
  /// 热门房源
  static const String hotProperties = '$apiV1/properties/hot';
  
  // ==================== 新盘 API ====================
  
  /// 新盘列表
  static const String newProperties = '$apiV1/new-properties';
  
  /// 新盘详情
  static String newPropertyDetail(int id) => '$apiV1/new-properties/$id';
  
  /// 新盘户型列表
  static String newPropertyLayouts(int id) => '$apiV1/new-properties/$id/layouts';
  
  // ==================== 服务式公寓 API ====================
  
  /// 服务式公寓列表
  static const String servicedApartments = '$apiV1/serviced-apartments';
  
  /// 服务式公寓详情
  static String servicedApartmentDetail(int id) => '$apiV1/serviced-apartments/$id';
  
  /// 服务式公寓房型列表
  static String servicedApartmentUnits(int id) => '$apiV1/serviced-apartments/$id/units';
  
  /// 服务式公寓图片列表
  static String servicedApartmentImages(int id) => '$apiV1/serviced-apartments/$id/images';
  
  // ==================== 屋苑 API ====================
  
  /// 屋苑列表
  static const String estates = '$apiV1/estates';
  
  /// 屋苑详情
  static String estateDetail(int id) => '$apiV1/estates/$id';
  
  /// 屋苑内房源列表
  static String estateProperties(int id) => '$apiV1/estates/$id/properties';
  
  /// 屋苑图片
  static String estateImages(int id) => '$apiV1/estates/$id/images';
  
  /// 屋苑设施
  static String estateFacilities(int id) => '$apiV1/estates/$id/facilities';
  
  /// 屋苑成交记录
  static String estateTransactions(int id) => '$apiV1/estates/$id/transactions';
  
  /// 屋苑统计数据
  static String estateStatistics(int id) => '$apiV1/estates/$id/statistics';
  
  /// 精选屋苑
  static const String featuredEstates = '$apiV1/estates/featured';
  
  // ==================== 估价 API ====================
  
  /// 估价列表
  static const String valuations = '$apiV1/valuation';
  
  /// 屋苑估价详情
  static String estateValuation(int estateId) => '$apiV1/valuation/estate/$estateId';
  
  /// 搜索估价
  static const String searchValuations = '$apiV1/valuation/search';
  
  /// 地区估价汇总
  static String districtValuations(int districtId) => '$apiV1/valuation/district/$districtId';
  
  // ==================== 家具 API ====================
  
  /// 家具列表
  static const String furniture = '$apiV1/furniture';
  
  /// 家具详情
  static String furnitureDetail(int id) => '$apiV1/furniture/$id';
  
  /// 家具分类
  static const String furnitureCategories = '$apiV1/furniture/categories';
  
  /// 家具图片
  static String furnitureImages(int id) => '$apiV1/furniture/$id/images';
  
  /// 精选家具
  static const String featuredFurniture = '$apiV1/furniture/featured';
  
  // ==================== 校网 API ====================
  
  /// 校网列表
  static const String schoolNets = '$apiV1/school-nets';
  
  /// 校网详情
  static String schoolNetDetail(int id) => '$apiV1/school-nets/$id';
  
  /// 校网内学校列表
  static String schoolsInNet(int schoolNetId) => '$apiV1/school-nets/$schoolNetId/schools';
  
  /// 搜索校网
  static const String searchSchoolNets = '$apiV1/school-nets/search';
  
  // ==================== 代理公司 API ====================
  
  /// 代理公司列表
  static const String agencies = '$apiV1/agencies';
  
  /// 代理公司详情
  static String agencyDetail(int id) => '$apiV1/agencies/$id';
  
  /// 搜索代理公司
  static const String searchAgencies = '$apiV1/agencies/search';
  
  // ==================== 用户 API ====================
  
  /// 用户登录
  static const String login = '$apiV1/auth/login';
  
  /// 用户注册
  static const String register = '$apiV1/auth/register';
  
  /// 用户信息
  static const String userProfile = '$apiV1/users/profile';
  
  // ==================== 收藏 API ====================
  
  /// 收藏列表
  static const String favorites = '$apiV1/favorites';
  
  /// 添加收藏
  static String addFavorite(int propertyId) => '$apiV1/favorites/$propertyId';
}
