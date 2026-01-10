/// 屋苑数据模型

/// 屋苑模型
class Estate {
  final int id;
  final String name;
  final String? nameEn;
  final String address;
  final int districtId;
  final int? totalBlocks;
  final int? totalUnits;
  final int? completionYear;
  final String? developer;
  final String? managementCompany;
  final String? primarySchoolNet;
  final String? secondarySchoolNet;
  final int recentTransactionsCount;
  final int forSaleCount;
  final int forRentCount;
  final double? avgTransactionPrice;
  final String? description;
  final int viewCount;
  final int favoriteCount;
  final bool isFeatured;
  final EstateDistrict? district;
  final List<EstateImage>? images;
  final List<EstateFacility>? facilities;
  final DateTime createdAt;
  final DateTime updatedAt;

  Estate({
    required this.id,
    required this.name,
    this.nameEn,
    required this.address,
    required this.districtId,
    this.totalBlocks,
    this.totalUnits,
    this.completionYear,
    this.developer,
    this.managementCompany,
    this.primarySchoolNet,
    this.secondarySchoolNet,
    required this.recentTransactionsCount,
    required this.forSaleCount,
    required this.forRentCount,
    this.avgTransactionPrice,
    this.description,
    required this.viewCount,
    required this.favoriteCount,
    required this.isFeatured,
    this.district,
    this.images,
    this.facilities,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Estate.fromJson(Map<String, dynamic> json) {
    return Estate(
      id: json['id'] as int,
      name: json['name'] as String,
      nameEn: json['name_en'] as String?,
      address: json['address'] as String,
      districtId: json['district_id'] as int,
      totalBlocks: json['total_blocks'] as int?,
      totalUnits: json['total_units'] as int?,
      completionYear: json['completion_year'] as int?,
      developer: json['developer'] as String?,
      managementCompany: json['management_company'] as String?,
      primarySchoolNet: json['primary_school_net'] as String?,
      secondarySchoolNet: json['secondary_school_net'] as String?,
      recentTransactionsCount: json['recent_transactions_count'] as int? ?? 0,
      forSaleCount: json['for_sale_count'] as int? ?? 0,
      forRentCount: json['for_rent_count'] as int? ?? 0,
      avgTransactionPrice: json['avg_transaction_price'] != null
          ? (json['avg_transaction_price'] as num).toDouble()
          : null,
      description: json['description'] as String?,
      viewCount: json['view_count'] as int? ?? 0,
      favoriteCount: json['favorite_count'] as int? ?? 0,
      isFeatured: json['is_featured'] as bool? ?? false,
      district: json['district'] != null
          ? EstateDistrict.fromJson(json['district'] as Map<String, dynamic>)
          : null,
      images: json['images'] != null
          ? (json['images'] as List)
              .map((item) => EstateImage.fromJson(item as Map<String, dynamic>))
              .toList()
          : null,
      facilities: json['facilities'] != null
          ? (json['facilities'] as List)
              .map((item) => EstateFacility.fromJson(item as Map<String, dynamic>))
              .toList()
          : null,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  /// 获取封面图片
  String? get coverImage {
    if (images != null && images!.isNotEmpty) {
      return images!.first.imageUrl;
    }
    return null;
  }

  /// 获取楼龄
  int? get buildingAge {
    if (completionYear != null) {
      return DateTime.now().year - completionYear!;
    }
    return null;
  }
}

/// 屋苑地区模型
class EstateDistrict {
  final int id;
  final String nameZh;
  final String? nameEn;
  final String? region;

  EstateDistrict({
    required this.id,
    required this.nameZh,
    this.nameEn,
    this.region,
  });

  factory EstateDistrict.fromJson(Map<String, dynamic> json) {
    return EstateDistrict(
      id: json['id'] as int,
      nameZh: (json['name_zh_hant'] ?? json['name_zh']) as String,
      nameEn: json['name_en'] as String?,
      region: json['region'] as String?,
    );
  }
}

/// 屋苑图片模型
class EstateImage {
  final int id;
  final int estateId;
  final String imageUrl;
  final String imageType; // exterior, facilities, environment, aerial
  final String? title;
  final int sortOrder;
  final DateTime createdAt;

  EstateImage({
    required this.id,
    required this.estateId,
    required this.imageUrl,
    required this.imageType,
    this.title,
    required this.sortOrder,
    required this.createdAt,
  });

  factory EstateImage.fromJson(Map<String, dynamic> json) {
    return EstateImage(
      id: json['id'] as int,
      estateId: json['estate_id'] as int,
      imageUrl: json['image_url'] as String,
      imageType: json['image_type'] as String,
      title: json['title'] as String?,
      sortOrder: json['sort_order'] as int? ?? 0,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }
}

/// 屋苑设施模型
class EstateFacility {
  final int id;
  final String nameZhHant;
  final String? nameZhHans;
  final String? nameEn;
  final String? icon;
  final String category; // building, unit
  final int sortOrder;

  EstateFacility({
    required this.id,
    required this.nameZhHant,
    this.nameZhHans,
    this.nameEn,
    this.icon,
    required this.category,
    required this.sortOrder,
  });

  factory EstateFacility.fromJson(Map<String, dynamic> json) {
    return EstateFacility(
      id: json['id'] as int,
      nameZhHant: json['name_zh_hant'] as String,
      nameZhHans: json['name_zh_hans'] as String?,
      nameEn: json['name_en'] as String?,
      icon: json['icon'] as String?,
      category: json['category'] as String,
      sortOrder: json['sort_order'] as int? ?? 0,
    );
  }
}

/// 屋苑列表响应
class EstateListResponse {
  final List<Estate> estates;
  final int total;
  final int page;
  final int pageSize;

  EstateListResponse({
    required this.estates,
    required this.total,
    required this.page,
    required this.pageSize,
  });

  int get totalPages => (total / pageSize).ceil();
  bool get hasMore => page < totalPages;

  factory EstateListResponse.fromJson(Map<String, dynamic> json) {
    return EstateListResponse(
      estates: (json['data'] as List? ?? [])
          .map((item) => Estate.fromJson(item as Map<String, dynamic>))
          .toList(),
      total: json['total'] as int? ?? 0,
      page: json['page'] as int? ?? 1,
      pageSize: json['page_size'] as int? ?? 20,
    );
  }
}
