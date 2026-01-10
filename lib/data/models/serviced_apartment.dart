/// 服务式公寓数据模型

/// 服务式公寓模型
class ServicedApartment {
  final int id;
  final String name;
  final String? nameEn;
  final String address;
  final int? districtId;
  final String? description;
  final String phone;
  final String? websiteUrl;
  final String? email;
  final int? companyId;
  final String? checkInTime;
  final String? checkOutTime;
  final int? minStayDays;
  final String status; // active, inactive, closed
  final double? rating;
  final int reviewCount;
  final int viewCount;
  final int favoriteCount;
  final bool isFeatured;
  final ServicedApartmentDistrict? district;
  final List<ServicedApartmentImage>? images;
  final List<ServicedApartmentUnit>? units;
  final DateTime createdAt;
  final DateTime? updatedAt;

  ServicedApartment({
    required this.id,
    required this.name,
    this.nameEn,
    required this.address,
    this.districtId,
    this.description,
    required this.phone,
    this.websiteUrl,
    this.email,
    this.companyId,
    this.checkInTime,
    this.checkOutTime,
    this.minStayDays,
    required this.status,
    this.rating,
    required this.reviewCount,
    required this.viewCount,
    required this.favoriteCount,
    required this.isFeatured,
    this.district,
    this.images,
    this.units,
    required this.createdAt,
    this.updatedAt,
  });

  factory ServicedApartment.fromJson(Map<String, dynamic> json) {
    final district = json['district'] != null
        ? ServicedApartmentDistrict.fromJson(json['district'] as Map<String, dynamic>)
        : null;
    
    return ServicedApartment(
      id: json['id'] as int,
      name: (json['name'] as String?) ?? '',
      nameEn: json['name_en'] as String?,
      address: (json['address'] as String?) ?? '',
      districtId: json['district_id'] as int? ?? district?.id,
      description: json['description'] as String?,
      phone: (json['phone'] as String?) ?? '',
      websiteUrl: json['website_url'] as String?,
      email: json['email'] as String?,
      companyId: json['company_id'] as int?,
      checkInTime: json['check_in_time'] as String?,
      checkOutTime: json['check_out_time'] as String?,
      minStayDays: json['min_stay_days'] as int?,
      status: (json['status'] as String?) ?? 'active',
      rating: json['rating'] != null ? (json['rating'] as num).toDouble() : null,
      reviewCount: json['review_count'] as int? ?? 0,
      viewCount: json['view_count'] as int? ?? 0,
      favoriteCount: json['favorite_count'] as int? ?? 0,
      isFeatured: json['is_featured'] as bool? ?? false,
      district: district,
      images: json['images'] != null
          ? (json['images'] as List)
              .map((item) => ServicedApartmentImage.fromJson(item as Map<String, dynamic>))
              .toList()
          : null,
      units: json['units'] != null
          ? (json['units'] as List)
              .map((item) => ServicedApartmentUnit.fromJson(item as Map<String, dynamic>))
              .toList()
          : null,
      createdAt: json['created_at'] != null 
          ? DateTime.parse(json['created_at'] as String)
          : DateTime.now(),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : (json['created_at'] != null 
              ? DateTime.parse(json['created_at'] as String)
              : DateTime.now()),
    );
  }

  /// 获取封面图片
  String? get coverImage {
    if (images != null && images!.isNotEmpty) {
      return images!.first.imageUrl;
    }
    return null;
  }

  /// 获取最低月租价格
  double? get minMonthlyPrice {
    if (units == null || units!.isEmpty) {
      return null;
    }
    return units!.map((u) => u.monthlyPrice).reduce((a, b) => a < b ? a : b);
  }

  /// 获取价格区间
  String get priceRange {
    if (units == null || units!.isEmpty) {
      return '待定';
    }
    
    final prices = units!.map((u) => u.monthlyPrice).toList()..sort();
    final minPrice = prices.first;
    final maxPrice = prices.last;
    
    if (minPrice == maxPrice) {
      return '${(minPrice / 10000).toStringAsFixed(1)}萬/月';
    }
    return '${(minPrice / 10000).toStringAsFixed(1)}-${(maxPrice / 10000).toStringAsFixed(1)}萬/月';
  }
}

/// 服务式公寓地区模型
class ServicedApartmentDistrict {
  final int id;
  final String nameZh;
  final String? nameEn;
  final String? region;

  ServicedApartmentDistrict({
    required this.id,
    required this.nameZh,
    this.nameEn,
    this.region,
  });

  factory ServicedApartmentDistrict.fromJson(Map<String, dynamic> json) {
    return ServicedApartmentDistrict(
      id: json['id'] as int,
      nameZh: (json['name_zh'] as String?) ?? '',
      nameEn: json['name_en'] as String?,
      region: json['region'] as String?,
    );
  }
}

/// 服务式公寓房型模型
class ServicedApartmentUnit {
  final int id;
  final int servicedApartmentId;
  final String unitType;
  final int bedrooms;
  final int? bathrooms;
  final double area;
  final int maxOccupancy;
  final double? dailyPrice;
  final double? weeklyPrice;
  final double monthlyPrice;
  final int availableUnits;
  final String? description;
  final int sortOrder;
  final DateTime createdAt;
  final DateTime updatedAt;

  ServicedApartmentUnit({
    required this.id,
    required this.servicedApartmentId,
    required this.unitType,
    required this.bedrooms,
    this.bathrooms,
    required this.area,
    required this.maxOccupancy,
    this.dailyPrice,
    this.weeklyPrice,
    required this.monthlyPrice,
    required this.availableUnits,
    this.description,
    required this.sortOrder,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ServicedApartmentUnit.fromJson(Map<String, dynamic> json) {
    return ServicedApartmentUnit(
      id: json['id'] as int,
      servicedApartmentId: json['serviced_apartment_id'] as int,
      unitType: (json['unit_type'] as String?) ?? '',
      bedrooms: json['bedrooms'] as int? ?? 0,
      bathrooms: json['bathrooms'] as int?,
      area: (json['area'] as num?)?.toDouble() ?? 0.0,
      maxOccupancy: json['max_occupancy'] as int? ?? 1,
      dailyPrice: json['daily_price'] != null ? (json['daily_price'] as num).toDouble() : null,
      weeklyPrice: json['weekly_price'] != null ? (json['weekly_price'] as num).toDouble() : null,
      monthlyPrice: (json['monthly_price'] as num?)?.toDouble() ?? 0.0,
      availableUnits: json['available_units'] as int? ?? 0,
      description: json['description'] as String?,
      sortOrder: json['sort_order'] as int? ?? 0,
      createdAt: json['created_at'] != null 
          ? DateTime.parse(json['created_at'] as String)
          : DateTime.now(),
      updatedAt: json['updated_at'] != null 
          ? DateTime.parse(json['updated_at'] as String)
          : DateTime.now(),
    );
  }
}

/// 服务式公寓图片模型
class ServicedApartmentImage {
  final int id;
  final int? servicedApartmentId;
  final int? unitId;
  final String imageUrl;
  final String imageType; // exterior, lobby, room, bathroom, facilities
  final String? title;
  final int sortOrder;
  final DateTime createdAt;

  ServicedApartmentImage({
    required this.id,
    this.servicedApartmentId,
    this.unitId,
    required this.imageUrl,
    required this.imageType,
    this.title,
    required this.sortOrder,
    required this.createdAt,
  });

  factory ServicedApartmentImage.fromJson(Map<String, dynamic> json) {
    return ServicedApartmentImage(
      id: json['id'] as int,
      servicedApartmentId: json['serviced_apartment_id'] as int?,
      unitId: json['unit_id'] as int?,
      imageUrl: (json['image_url'] as String?) ?? '',
      imageType: (json['image_type'] as String?) ?? 'exterior',
      title: json['title'] as String?,
      sortOrder: json['sort_order'] as int? ?? 0,
      createdAt: json['created_at'] != null 
          ? DateTime.parse(json['created_at'] as String)
          : DateTime.now(),
    );
  }
}

/// 服务式公寓列表响应
class ServicedApartmentListResponse {
  final List<ServicedApartment> apartments;
  final int total;
  final int page;
  final int pageSize;

  ServicedApartmentListResponse({
    required this.apartments,
    required this.total,
    required this.page,
    required this.pageSize,
  });

  int get totalPages => (total / pageSize).ceil();
  bool get hasMore => page < totalPages;

  factory ServicedApartmentListResponse.fromJson(Map<String, dynamic> json) {
    return ServicedApartmentListResponse(
      apartments: (json['data'] as List? ?? [])
          .map((item) => ServicedApartment.fromJson(item as Map<String, dynamic>))
          .toList(),
      total: json['total'] as int? ?? 0,
      page: json['page'] as int? ?? 1,
      pageSize: json['page_size'] as int? ?? 20,
    );
  }
}
