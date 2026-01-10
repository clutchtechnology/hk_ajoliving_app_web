/// 新盘数据模型

/// 新盘模型
class NewProperty {
  final int id;
  final String name;
  final String? nameEn;
  final String address;
  final int? districtId;
  final String status; // upcoming, presale, selling, completed
  final int? unitsForSale;
  final int? unitsSold;
  final String developer;
  final String? managementCompany;
  final int totalUnits;
  final int? totalBlocks;
  final int? maxFloors;
  final String? primarySchoolNet;
  final String? secondarySchoolNet;
  final String? websiteUrl;
  final String? salesOfficeAddress;
  final String? salesPhone;
  final DateTime? expectedCompletion;
  final DateTime? occupationDate;
  final String? description;
  final int viewCount;
  final int favoriteCount;
  final int sortOrder;
  final bool isFeatured;
  final NewPropertyDistrict? district;
  final List<NewPropertyImage>? images;
  final List<NewPropertyLayout>? layouts;
  final DateTime createdAt;
  final DateTime? updatedAt;

  NewProperty({
    required this.id,
    required this.name,
    this.nameEn,
    required this.address,
    this.districtId,
    required this.status,
    this.unitsForSale,
    this.unitsSold,
    required this.developer,
    this.managementCompany,
    required this.totalUnits,
    this.totalBlocks,
    this.maxFloors,
    this.primarySchoolNet,
    this.secondarySchoolNet,
    this.websiteUrl,
    this.salesOfficeAddress,
    this.salesPhone,
    this.expectedCompletion,
    this.occupationDate,
    this.description,
    required this.viewCount,
    required this.favoriteCount,
    required this.sortOrder,
    required this.isFeatured,
    this.district,
    this.images,
    this.layouts,
    required this.createdAt,
    this.updatedAt,
  });

  factory NewProperty.fromJson(Map<String, dynamic> json) {
    final district = json['district'] != null
        ? NewPropertyDistrict.fromJson(json['district'] as Map<String, dynamic>)
        : null;
    
    return NewProperty(
      id: json['id'] as int,
      name: (json['name'] as String?) ?? '',
      nameEn: json['name_en'] as String?,
      address: (json['address'] as String?) ?? '',
      districtId: json['district_id'] as int? ?? district?.id,
      status: (json['status'] as String?) ?? 'upcoming',
      unitsForSale: json['units_for_sale'] as int?,
      unitsSold: json['units_sold'] as int?,
      developer: (json['developer'] as String?) ?? '',
      managementCompany: json['management_company'] as String?,
      totalUnits: json['total_units'] as int,
      totalBlocks: json['total_blocks'] as int?,
      maxFloors: json['max_floors'] as int?,
      primarySchoolNet: json['primary_school_net'] as String?,
      secondarySchoolNet: json['secondary_school_net'] as String?,
      websiteUrl: json['website_url'] as String?,
      salesOfficeAddress: json['sales_office_address'] as String?,
      salesPhone: json['sales_phone'] as String?,
      expectedCompletion: json['expected_completion'] != null
          ? DateTime.parse(json['expected_completion'] as String)
          : null,
      occupationDate: json['occupation_date'] != null
          ? DateTime.parse(json['occupation_date'] as String)
          : null,
      description: json['description'] as String?,
      viewCount: json['view_count'] as int? ?? 0,
      favoriteCount: json['favorite_count'] as int? ?? 0,
      sortOrder: json['sort_order'] as int? ?? 0,
      isFeatured: json['is_featured'] as bool? ?? false,
      district: district,
      images: json['images'] != null
          ? (json['images'] as List)
              .map((item) => NewPropertyImage.fromJson(item as Map<String, dynamic>))
              .toList()
          : null,
      layouts: json['layouts'] != null
          ? (json['layouts'] as List)
              .map((item) => NewPropertyLayout.fromJson(item as Map<String, dynamic>))
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

  /// 获取价格区间描述
  String get priceRange {
    if (layouts == null || layouts!.isEmpty) {
      return '待定';
    }
    
    double? minPrice;
    double? maxPrice;
    
    for (var layout in layouts!) {
      if (minPrice == null || layout.minPrice < minPrice) {
        minPrice = layout.minPrice;
      }
      if (maxPrice == null || (layout.maxPrice != null && layout.maxPrice! > maxPrice)) {
        maxPrice = layout.maxPrice;
      }
    }
    
    if (minPrice != null && maxPrice != null) {
      return '${(minPrice / 10000).toStringAsFixed(0)}-${(maxPrice / 10000).toStringAsFixed(0)}萬';
    } else if (minPrice != null) {
      return '${(minPrice / 10000).toStringAsFixed(0)}萬起';
    }
    
    return '待定';
  }
}

/// 新盘地区模型
class NewPropertyDistrict {
  final int id;
  final String nameZh;
  final String? nameEn;
  final String? region;

  NewPropertyDistrict({
    required this.id,
    required this.nameZh,
    this.nameEn,
    this.region,
  });

  factory NewPropertyDistrict.fromJson(Map<String, dynamic> json) {
    return NewPropertyDistrict(
      id: json['id'] as int,
      nameZh: (json['name_zh'] as String?) ?? '',
      nameEn: json['name_en'] as String?,
      region: json['region'] as String?,
    );
  }
}

/// 新盘图片模型
class NewPropertyImage {
  final int id;
  final int newPropertyId;
  final String imageUrl;
  final String imageType; // exterior, interior, facilities, floorplan, location
  final String? title;
  final int sortOrder;
  final DateTime createdAt;

  NewPropertyImage({
    required this.id,
    required this.newPropertyId,
    required this.imageUrl,
    required this.imageType,
    this.title,
    required this.sortOrder,
    required this.createdAt,
  });

  factory NewPropertyImage.fromJson(Map<String, dynamic> json) {
    return NewPropertyImage(
      id: json['id'] as int,
      newPropertyId: json['new_property_id'] as int,
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

/// 新盘户型模型
class NewPropertyLayout {
  final int id;
  final int newPropertyId;
  final String unitType;
  final int bedrooms;
  final int? bathrooms;
  final double saleableArea;
  final double? grossArea;
  final double minPrice;
  final double? maxPrice;
  final double? pricePerSqft;
  final int availableUnits;
  final String? floorplanUrl;
  final DateTime createdAt;

  NewPropertyLayout({
    required this.id,
    required this.newPropertyId,
    required this.unitType,
    required this.bedrooms,
    this.bathrooms,
    required this.saleableArea,
    this.grossArea,
    required this.minPrice,
    this.maxPrice,
    this.pricePerSqft,
    required this.availableUnits,
    this.floorplanUrl,
    required this.createdAt,
  });

  factory NewPropertyLayout.fromJson(Map<String, dynamic> json) {
    return NewPropertyLayout(
      id: json['id'] as int,
      newPropertyId: json['new_property_id'] as int,
      unitType: (json['unit_type'] as String?) ?? '',
      bedrooms: json['bedrooms'] as int? ?? 0,
      bathrooms: json['bathrooms'] as int?,
      saleableArea: (json['saleable_area'] as num?)?.toDouble() ?? 0.0,
      grossArea: json['gross_area'] != null ? (json['gross_area'] as num).toDouble() : null,
      minPrice: (json['min_price'] as num?)?.toDouble() ?? 0.0,
      maxPrice: json['max_price'] != null ? (json['max_price'] as num).toDouble() : null,
      pricePerSqft: json['price_per_sqft'] != null ? (json['price_per_sqft'] as num).toDouble() : null,
      availableUnits: json['available_units'] as int? ?? 0,
      floorplanUrl: json['floorplan_url'] as String?,
      createdAt: json['created_at'] != null 
          ? DateTime.parse(json['created_at'] as String)
          : DateTime.now(),
    );
  }
}

/// 新盘列表响应
class NewPropertyListResponse {
  final List<NewProperty> properties;
  final int total;
  final int page;
  final int pageSize;

  NewPropertyListResponse({
    required this.properties,
    required this.total,
    required this.page,
    required this.pageSize,
  });

  int get totalPages => (total / pageSize).ceil();
  bool get hasMore => page < totalPages;

  factory NewPropertyListResponse.fromJson(Map<String, dynamic> json) {
    return NewPropertyListResponse(
      properties: (json['data'] as List? ?? [])
          .map((item) => NewProperty.fromJson(item as Map<String, dynamic>))
          .toList(),
      total: json['total'] as int? ?? 0,
      page: json['page'] as int? ?? 1,
      pageSize: json['page_size'] as int? ?? 20,
    );
  }
}
