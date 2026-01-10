import 'property.dart';

/// 家具模型
class Furniture {
  final int id;
  final String furnitureNo;
  final String title;
  final String? description;
  final double price;
  final int categoryId;
  final FurnitureCategory? category;
  final String? brand;
  final String condition; // new, like_new, good, fair, poor
  final DateTime? purchaseDate;
  final int deliveryDistrictId;
  final District? deliveryDistrict;
  final String? deliveryTime;
  final String deliveryMethod; // self_pickup, delivery, negotiable
  final String status; // available, reserved, sold, expired, cancelled
  final int publisherId;
  final String publisherType; // individual, agency
  final int viewCount;
  final int favoriteCount;
  final List<FurnitureImage> images;
  final DateTime publishedAt;
  final DateTime updatedAt;
  final DateTime expiresAt;

  Furniture({
    required this.id,
    required this.furnitureNo,
    required this.title,
    this.description,
    required this.price,
    required this.categoryId,
    this.category,
    this.brand,
    required this.condition,
    this.purchaseDate,
    required this.deliveryDistrictId,
    this.deliveryDistrict,
    this.deliveryTime,
    required this.deliveryMethod,
    required this.status,
    required this.publisherId,
    required this.publisherType,
    required this.viewCount,
    required this.favoriteCount,
    this.images = const [],
    required this.publishedAt,
    required this.updatedAt,
    required this.expiresAt,
  });

  factory Furniture.fromJson(Map<String, dynamic> json) {
    return Furniture(
      id: json['id'] as int,
      furnitureNo: json['furniture_no'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      price: (json['price'] as num).toDouble(),
      categoryId: json['category_id'] as int? ?? 0,
      category: json['category'] != null
          ? FurnitureCategory.fromJson(json['category'] as Map<String, dynamic>)
          : null,
      brand: json['brand'] as String?,
      condition: json['condition'] as String,
      purchaseDate: json['purchase_date'] != null
          ? DateTime.parse(json['purchase_date'] as String)
          : null,
      deliveryDistrictId: json['delivery_district_id'] as int,
      deliveryDistrict: json['delivery_district'] != null
          ? District.fromJson(json['delivery_district'] as Map<String, dynamic>)
          : null,
      deliveryTime: json['delivery_time'] as String?,
      deliveryMethod: json['delivery_method'] as String,
      status: json['status'] as String,
      publisherId: json['publisher_id'] as int,
      publisherType: json['publisher_type'] as String,
      viewCount: json['view_count'] as int? ?? 0,
      favoriteCount: json['favorite_count'] as int? ?? 0,
      images: (json['images'] as List?)
              ?.map((item) => FurnitureImage.fromJson(item as Map<String, dynamic>))
              .toList() ??
          [],
      publishedAt: DateTime.parse(json['published_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      expiresAt: DateTime.parse(json['expires_at'] as String),
    );
  }

  /// 封面图
  String? get coverImage {
    if (images.isEmpty) return null;
    final cover = images.firstWhere(
      (img) => img.isCover,
      orElse: () => images.first,
    );
    return cover.imageUrl;
  }

  /// 格式化价格
  String get formattedPrice {
    return 'HK\$ ${price.toStringAsFixed(0)}';
  }

  /// 新旧程度中文
  String get conditionText {
    switch (condition) {
      case 'new':
        return '全新';
      case 'like_new':
        return '近全新';
      case 'good':
        return '良好';
      case 'fair':
        return '一般';
      case 'poor':
        return '較差';
      default:
        return condition;
    }
  }

  /// 交收方式中文
  String get deliveryMethodText {
    switch (deliveryMethod) {
      case 'self_pickup':
        return '自取';
      case 'delivery':
        return '送貨';
      case 'negotiable':
        return '面議';
      default:
        return deliveryMethod;
    }
  }
}

/// 家具分类
class FurnitureCategory {
  final int id;
  final int? parentId;
  final String nameZhHant;
  final String? nameZhHans;
  final String? nameEn;
  final String? icon;
  final int sortOrder;
  final bool isActive;
  final List<FurnitureCategory> subCategories;
  final int furnitureCount;

  FurnitureCategory({
    required this.id,
    this.parentId,
    required this.nameZhHant,
    this.nameZhHans,
    this.nameEn,
    this.icon,
    required this.sortOrder,
    required this.isActive,
    this.subCategories = const [],
    this.furnitureCount = 0,
  });

  factory FurnitureCategory.fromJson(Map<String, dynamic> json) {
    return FurnitureCategory(
      id: json['id'] as int,
      parentId: json['parent_id'] as int?,
      nameZhHant: json['name_zh_hant'] as String,
      nameZhHans: json['name_zh_hans'] as String?,
      nameEn: json['name_en'] as String?,
      icon: json['icon'] as String?,
      sortOrder: json['sort_order'] as int? ?? 0,
      isActive: json['is_active'] as bool? ?? true,
      subCategories: (json['sub_categories'] as List?)
              ?.map((item) => FurnitureCategory.fromJson(item as Map<String, dynamic>))
              .toList() ??
          [],
      furnitureCount: json['furniture_count'] as int? ?? 0,
    );
  }
}

/// 家具图片
class FurnitureImage {
  final int id;
  final int furnitureId;
  final String imageUrl;
  final bool isCover;
  final int sortOrder;

  FurnitureImage({
    required this.id,
    required this.furnitureId,
    required this.imageUrl,
    required this.isCover,
    required this.sortOrder,
  });

  factory FurnitureImage.fromJson(Map<String, dynamic> json) {
    return FurnitureImage(
      id: json['id'] as int,
      furnitureId: json['furniture_id'] as int,
      imageUrl: json['image_url'] as String,
      isCover: json['is_cover'] as bool? ?? false,
      sortOrder: json['sort_order'] as int? ?? 0,
    );
  }
}

/// 家具列表响应
class FurnitureListResponse {
  final List<Furniture> furniture;
  final int total;
  final int page;
  final int pageSize;

  FurnitureListResponse({
    required this.furniture,
    required this.total,
    required this.page,
    required this.pageSize,
  });

  int get totalPages => (total / pageSize).ceil();
  bool get hasMore => page < totalPages;

  factory FurnitureListResponse.fromJson(Map<String, dynamic> json) {
    return FurnitureListResponse(
      furniture: (json['data'] as List? ?? [])
          .map((item) => Furniture.fromJson(item as Map<String, dynamic>))
          .toList(),
      total: json['total'] as int? ?? 0,
      page: json['page'] as int? ?? 1,
      pageSize: json['page_size'] as int? ?? 20,
    );
  }
}
