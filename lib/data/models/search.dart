/// 搜索结果类型枚举
enum SearchResultType {
  property('property', '房产'),
  estate('estate', '屋苑'),
  agent('agent', '代理人'),
  district('district', '地区');

  final String value;
  final String label;

  const SearchResultType(this.value, this.label);
}

/// 全局搜索结果
class GlobalSearchResult {
  final String type;
  final int id;
  final String title;
  final String? subtitle;
  final String? imageUrl;
  final Map<String, dynamic>? extra;

  GlobalSearchResult({
    required this.type,
    required this.id,
    required this.title,
    this.subtitle,
    this.imageUrl,
    this.extra,
  });

  factory GlobalSearchResult.fromJson(Map<String, dynamic> json) {
    return GlobalSearchResult(
      type: json['type'] as String,
      id: json['id'] as int,
      title: json['title'] as String,
      subtitle: json['subtitle'] as String?,
      imageUrl: json['image_url'] as String?,
      extra: json['extra'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'id': id,
      'title': title,
      'subtitle': subtitle,
      'image_url': imageUrl,
      'extra': extra,
    };
  }
}

/// 搜索建议
class SearchSuggestion {
  final String text;
  final String type;
  final int? id;
  final int count;

  SearchSuggestion({
    required this.text,
    required this.type,
    this.id,
    required this.count,
  });

  factory SearchSuggestion.fromJson(Map<String, dynamic> json) {
    return SearchSuggestion(
      text: json['text'] as String,
      type: json['type'] as String,
      id: json['id'] as int?,
      count: json['count'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'type': type,
      'id': id,
      'count': count,
    };
  }
}

/// 搜索历史记录
class SearchHistory {
  final int id;
  final String query;
  final String? type;
  final DateTime createdAt;

  SearchHistory({
    required this.id,
    required this.query,
    this.type,
    required this.createdAt,
  });

  factory SearchHistory.fromJson(Map<String, dynamic> json) {
    return SearchHistory(
      id: json['id'] as int,
      query: json['query'] as String,
      type: json['type'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'query': query,
      'type': type,
      'created_at': createdAt.toIso8601String(),
    };
  }
}

/// 房产搜索结果
class PropertySearchResult {
  final int id;
  final String title;
  final String? description;
  final double price;
  final double? area;
  final int? bedrooms;
  final int? bathrooms;
  final String? propertyType;
  final String? listingType;
  final String address;
  final String? districtName;
  final String? estateName;
  final String? coverImage;
  final List<String>? images;
  final String status;
  final DateTime createdAt;

  PropertySearchResult({
    required this.id,
    required this.title,
    this.description,
    required this.price,
    this.area,
    this.bedrooms,
    this.bathrooms,
    this.propertyType,
    this.listingType,
    required this.address,
    this.districtName,
    this.estateName,
    this.coverImage,
    this.images,
    required this.status,
    required this.createdAt,
  });

  factory PropertySearchResult.fromJson(Map<String, dynamic> json) {
    return PropertySearchResult(
      id: json['id'] as int,
      title: json['title'] as String,
      description: json['description'] as String?,
      price: (json['price'] as num).toDouble(),
      area: json['area'] != null ? (json['area'] as num).toDouble() : null,
      bedrooms: json['bedrooms'] as int?,
      bathrooms: json['bathrooms'] as int?,
      propertyType: json['property_type'] as String?,
      listingType: json['listing_type'] as String?,
      address: json['address'] as String,
      districtName: json['district_name'] as String?,
      estateName: json['estate_name'] as String?,
      coverImage: json['cover_image'] as String?,
      images: json['images'] != null 
          ? List<String>.from(json['images'] as List)
          : null,
      status: json['status'] as String? ?? 'active',
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }
}

/// 屋苑搜索结果
class EstateSearchResult {
  final int id;
  final String name;
  final String? englishName;
  final String? address;
  final String? districtName;
  final int? propertyCount;
  final String? description;
  final List<String>? images;

  EstateSearchResult({
    required this.id,
    required this.name,
    this.englishName,
    this.address,
    this.districtName,
    this.propertyCount,
    this.description,
    this.images,
  });

  factory EstateSearchResult.fromJson(Map<String, dynamic> json) {
    return EstateSearchResult(
      id: json['id'] as int,
      name: json['name'] as String,
      englishName: json['english_name'] as String?,
      address: json['address'] as String?,
      districtName: json['district_name'] as String?,
      propertyCount: json['property_count'] as int?,
      description: json['description'] as String?,
      images: json['images'] != null 
          ? List<String>.from(json['images'] as List)
          : null,
    );
  }
}

/// 代理人搜索结果
class AgentSearchResult {
  final int id;
  final String name;
  final String? licenseNumber;
  final String? phone;
  final String? email;
  final String? avatar;
  final String? agencyName;
  final int? listingsCount;
  final double? rating;

  AgentSearchResult({
    required this.id,
    required this.name,
    this.licenseNumber,
    this.phone,
    this.email,
    this.avatar,
    this.agencyName,
    this.listingsCount,
    this.rating,
  });

  factory AgentSearchResult.fromJson(Map<String, dynamic> json) {
    return AgentSearchResult(
      id: json['id'] as int,
      name: json['name'] as String,
      licenseNumber: json['license_number'] as String?,
      phone: json['phone'] as String?,
      email: json['email'] as String?,
      avatar: json['avatar'] as String?,
      agencyName: json['agency_name'] as String?,
      listingsCount: json['listings_count'] as int?,
      rating: json['rating'] != null ? (json['rating'] as num).toDouble() : null,
    );
  }
}

/// 代理公司搜索结果
class AgencySearchResult {
  final int id;
  final String name;
  final String? licenseNumber;
  final String? phone;
  final String? email;
  final String? address;
  final String? website;
  final int? agentCount;
  final int? listingsCount;

  AgencySearchResult({
    required this.id,
    required this.name,
    this.licenseNumber,
    this.phone,
    this.email,
    this.address,
    this.website,
    this.agentCount,
    this.listingsCount,
  });

  factory AgencySearchResult.fromJson(Map<String, dynamic> json) {
    return AgencySearchResult(
      id: json['id'] as int,
      name: json['name'] as String,
      licenseNumber: json['license_number'] as String?,
      phone: json['phone'] as String?,
      email: json['email'] as String?,
      address: json['address'] as String?,
      website: json['website'] as String?,
      agentCount: json['agent_count'] as int?,
      listingsCount: json['listings_count'] as int?,
    );
  }
}

/// 搜索响应基类
class SearchResponse<T> {
  final List<T> results;
  final int total;
  final int page;
  final int pageSize;

  SearchResponse({
    required this.results,
    required this.total,
    required this.page,
    required this.pageSize,
  });

  int get totalPages => (total / pageSize).ceil();
  bool get hasMore => page < totalPages;
}

/// 全局搜索响应
class GlobalSearchResponse {
  final List<PropertySearchResult> properties;
  final List<EstateSearchResult> estates;
  final List<AgentSearchResult> agents;
  final List<AgencySearchResult> agencies;
  final int totalResults;
  final int propertyCount;
  final int estateCount;
  final int agentCount;
  final int agencyCount;

  GlobalSearchResponse({
    required this.properties,
    required this.estates,
    required this.agents,
    required this.agencies,
    required this.totalResults,
    required this.propertyCount,
    required this.estateCount,
    required this.agentCount,
    required this.agencyCount,
  });

  factory GlobalSearchResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>;
    return GlobalSearchResponse(
      properties: (data['properties'] as List? ?? [])
          .map((item) => PropertySearchResult.fromJson(item as Map<String, dynamic>))
          .toList(),
      estates: (data['estates'] as List? ?? [])
          .map((item) => EstateSearchResult.fromJson(item as Map<String, dynamic>))
          .toList(),
      agents: (data['agents'] as List? ?? [])
          .map((item) => AgentSearchResult.fromJson(item as Map<String, dynamic>))
          .toList(),
      agencies: (data['agencies'] as List? ?? [])
          .map((item) => AgencySearchResult.fromJson(item as Map<String, dynamic>))
          .toList(),
      totalResults: data['total_results'] as int? ?? 0,
      propertyCount: data['property_count'] as int? ?? 0,
      estateCount: data['estate_count'] as int? ?? 0,
      agentCount: data['agent_count'] as int? ?? 0,
      agencyCount: data['agency_count'] as int? ?? 0,
    );
  }
}

/// 房产搜索响应
class PropertySearchResponse extends SearchResponse<PropertySearchResult> {
  PropertySearchResponse({
    required super.results,
    required super.total,
    required super.page,
    required super.pageSize,
  });

  factory PropertySearchResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>;
    return PropertySearchResponse(
      results: (data['results'] as List)
          .map((item) => PropertySearchResult.fromJson(item as Map<String, dynamic>))
          .toList(),
      total: data['total'] as int? ?? 0,
      page: data['page'] as int? ?? 1,
      pageSize: data['page_size'] as int? ?? 20,
    );
  }
}

/// 屋苑搜索响应
class EstateSearchResponse extends SearchResponse<EstateSearchResult> {
  EstateSearchResponse({
    required super.results,
    required super.total,
    required super.page,
    required super.pageSize,
  });

  factory EstateSearchResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>;
    return EstateSearchResponse(
      results: (data['results'] as List)
          .map((item) => EstateSearchResult.fromJson(item as Map<String, dynamic>))
          .toList(),
      total: data['total'] as int? ?? 0,
      page: data['page'] as int? ?? 1,
      pageSize: data['page_size'] as int? ?? 20,
    );
  }
}

/// 代理人搜索响应
class AgentSearchResponse extends SearchResponse<AgentSearchResult> {
  AgentSearchResponse({
    required super.results,
    required super.total,
    required super.page,
    required super.pageSize,
  });

  factory AgentSearchResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>;
    return AgentSearchResponse(
      results: (data['results'] as List)
          .map((item) => AgentSearchResult.fromJson(item as Map<String, dynamic>))
          .toList(),
      total: data['total'] as int? ?? 0,
      page: data['page'] as int? ?? 1,
      pageSize: data['page_size'] as int? ?? 20,
    );
  }
}
