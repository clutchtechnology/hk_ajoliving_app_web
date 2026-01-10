import 'property.dart';

/// 屋苑估价响应
class Valuation {
  final int estateId;
  final String estateName;
  final String? estateNameEn;
  final int districtId;
  final District? district;
  final String address;
  final int? completionYear;
  final int totalUnits;
  final double avgPricePerSqft;
  final double avgSalePrice;
  final double avgRentPrice;
  final double minPricePerSqft;
  final double maxPricePerSqft;
  final int recentTransactionCount;
  final int forSaleCount;
  final int forRentCount;
  final double priceChange30d;
  final double priceChange90d;
  final double rentalYield;
  final DateTime lastUpdated;

  Valuation({
    required this.estateId,
    required this.estateName,
    this.estateNameEn,
    required this.districtId,
    this.district,
    required this.address,
    this.completionYear,
    required this.totalUnits,
    required this.avgPricePerSqft,
    required this.avgSalePrice,
    required this.avgRentPrice,
    required this.minPricePerSqft,
    required this.maxPricePerSqft,
    required this.recentTransactionCount,
    required this.forSaleCount,
    required this.forRentCount,
    required this.priceChange30d,
    required this.priceChange90d,
    required this.rentalYield,
    required this.lastUpdated,
  });

  factory Valuation.fromJson(Map<String, dynamic> json) {
    return Valuation(
      estateId: json['estate_id'] as int,
      estateName: json['estate_name'] as String,
      estateNameEn: json['estate_name_en'] as String?,
      districtId: json['district_id'] as int,
      district: json['district'] != null 
          ? District.fromJson(json['district'] as Map<String, dynamic>)
          : null,
      address: json['address'] as String,
      completionYear: json['completion_year'] as int?,
      totalUnits: json['total_units'] as int,
      avgPricePerSqft: (json['avg_price_per_sqft'] as num).toDouble(),
      avgSalePrice: (json['avg_sale_price'] as num).toDouble(),
      avgRentPrice: (json['avg_rent_price'] as num).toDouble(),
      minPricePerSqft: (json['min_price_per_sqft'] as num).toDouble(),
      maxPricePerSqft: (json['max_price_per_sqft'] as num).toDouble(),
      recentTransactionCount: json['recent_transaction_count'] as int,
      forSaleCount: json['for_sale_count'] as int,
      forRentCount: json['for_rent_count'] as int,
      priceChange30d: (json['price_change_30d'] as num).toDouble(),
      priceChange90d: (json['price_change_90d'] as num).toDouble(),
      rentalYield: (json['rental_yield'] as num).toDouble(),
      lastUpdated: DateTime.parse(json['last_updated'] as String),
    );
  }

  /// 建筑年龄
  int? get buildingAge {
    if (completionYear == null) return null;
    return DateTime.now().year - completionYear!;
  }

  /// 格式化平均价格（万元）
  String get formattedAvgPrice {
    return 'HK\$ ${(avgSalePrice / 10000).toStringAsFixed(0)} 萬';
  }

  /// 格式化平均呎價
  String get formattedAvgPricePerSqft {
    return 'HK\$ ${avgPricePerSqft.toStringAsFixed(0)} /呎';
  }

  /// 格式化租金回報率
  String get formattedRentalYield {
    return '${rentalYield.toStringAsFixed(2)}%';
  }
}

/// 屋苑估价列表响应
class ValuationListResponse {
  final List<Valuation> valuations;
  final int total;
  final int page;
  final int pageSize;

  ValuationListResponse({
    required this.valuations,
    required this.total,
    required this.page,
    required this.pageSize,
  });

  int get totalPages => (total / pageSize).ceil();
  bool get hasMore => page < totalPages;

  factory ValuationListResponse.fromJson(Map<String, dynamic> json) {
    return ValuationListResponse(
      valuations: (json['data'] as List? ?? [])
          .map((item) => Valuation.fromJson(item as Map<String, dynamic>))
          .toList(),
      total: json['total'] as int? ?? 0,
      page: json['page'] as int? ?? 1,
      pageSize: json['page_size'] as int? ?? 20,
    );
  }
}
