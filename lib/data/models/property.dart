/// 房产数据模型
class Property {
  final int id;
  final String propertyNo;
  final String listingType; // sale, rent
  final String title;
  final double price;
  final double area;
  final String address;
  final String? buildingName;
  final int bedrooms;
  final int? bathrooms;
  final String propertyType;
  final String status;
  final int viewCount;
  final int favoriteCount;
  final String? coverImage;
  final District? district;
  final DateTime? publishedAt;
  final DateTime createdAt;

  Property({
    required this.id,
    required this.propertyNo,
    required this.listingType,
    required this.title,
    required this.price,
    required this.area,
    required this.address,
    this.buildingName,
    required this.bedrooms,
    this.bathrooms,
    required this.propertyType,
    required this.status,
    required this.viewCount,
    required this.favoriteCount,
    this.coverImage,
    this.district,
    this.publishedAt,
    required this.createdAt,
  });

  /// 格式化价格显示
  String get formattedPrice {
    if (price >= 10000) {
      return '${(price / 10000).toStringAsFixed(0)}萬';
    }
    return price.toStringAsFixed(0);
  }

  /// 图片URL（使用coverImage）
  String? get imageUrl => coverImage;

  /// 格式化面积显示
  String get formattedArea {
    return '${area.toStringAsFixed(0)}呎';
  }

  factory Property.fromJson(Map<String, dynamic> json) {
    return Property(
      id: json['id'] as int,
      propertyNo: json['property_no'] as String,
      listingType: json['listing_type'] as String,
      title: json['title'] as String,
      price: (json['price'] as num).toDouble(),
      area: (json['area'] as num).toDouble(),
      address: json['address'] as String,
      buildingName: json['building_name'] as String?,
      bedrooms: json['bedrooms'] as int,
      bathrooms: json['bathrooms'] as int?,
      propertyType: json['property_type'] as String,
      status: json['status'] as String,
      viewCount: json['view_count'] as int? ?? 0,
      favoriteCount: json['favorite_count'] as int? ?? 0,
      coverImage: json['cover_image'] as String?,
      district: json['district'] != null
          ? District.fromJson(json['district'] as Map<String, dynamic>)
          : null,
      publishedAt: json['published_at'] != null
          ? DateTime.parse(json['published_at'] as String)
          : null,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }
}

/// 地区数据模型
class District {
  final int id;
  final String nameZh;
  final String? nameEn;
  final String? region;

  District({
    required this.id,
    required this.nameZh,
    this.nameEn,
    this.region,
  });

  factory District.fromJson(Map<String, dynamic> json) {
    return District(
      id: json['id'] as int,
      nameZh: (json['name_zh_hant'] ?? json['name_zh']) as String,
      nameEn: json['name_en'] as String?,
      region: json['region'] as String?,
    );
  }
}

/// 房产列表响应
class PropertyListResponse {
  final List<Property> properties;
  final int total;
  final int page;
  final int pageSize;

  PropertyListResponse({
    required this.properties,
    required this.total,
    required this.page,
    required this.pageSize,
  });

  int get totalPages => (total / pageSize).ceil();
  bool get hasMore => page < totalPages;

  factory PropertyListResponse.fromJson(Map<String, dynamic> json) {
    return PropertyListResponse(
      properties: (json['data'] as List? ?? [])
          .map((item) => Property.fromJson(item as Map<String, dynamic>))
          .toList(),
      total: json['total'] as int? ?? 0,
      page: json['page'] as int? ?? 1,
      pageSize: json['page_size'] as int? ?? 20,
    );
  }
}
