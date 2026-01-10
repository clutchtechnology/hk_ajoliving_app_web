/// 代理公司模型
class Agency {
  final int id;
  final String companyName;
  final String? companyNameEn;
  final String? logoUrl;
  final String address;
  final String phone;
  final String email;
  final String? websiteUrl;
  final int? establishedYear;
  final int agentCount;
  final double rating;
  final int reviewCount;
  final bool isVerified;

  Agency({
    required this.id,
    required this.companyName,
    this.companyNameEn,
    this.logoUrl,
    required this.address,
    required this.phone,
    required this.email,
    this.websiteUrl,
    this.establishedYear,
    required this.agentCount,
    required this.rating,
    required this.reviewCount,
    required this.isVerified,
  });

  factory Agency.fromJson(Map<String, dynamic> json) {
    return Agency(
      id: json['id'] as int,
      companyName: json['company_name'] as String,
      companyNameEn: json['company_name_en'] as String?,
      logoUrl: json['logo_url'] as String?,
      address: json['address'] as String,
      phone: json['phone'] as String,
      email: json['email'] as String,
      websiteUrl: json['website_url'] as String?,
      establishedYear: json['established_year'] as int?,
      agentCount: json['agent_count'] as int? ?? 0,
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      reviewCount: json['review_count'] as int? ?? 0,
      isVerified: json['is_verified'] as bool? ?? false,
    );
  }

  /// 格式化评分
  String get formattedRating => rating.toStringAsFixed(1);
}

/// 代理公司列表响应
class AgencyListResponse {
  final List<Agency> agencies;
  final int total;
  final int page;
  final int pageSize;

  AgencyListResponse({
    required this.agencies,
    required this.total,
    required this.page,
    required this.pageSize,
  });

  int get totalPages => (total / pageSize).ceil();
  bool get hasMore => page < totalPages;

  factory AgencyListResponse.fromJson(Map<String, dynamic> json) {
    return AgencyListResponse(
      agencies: (json['agencies'] as List? ?? [])
          .map((item) => Agency.fromJson(item as Map<String, dynamic>))
          .toList(),
      total: json['total'] as int? ?? 0,
      page: json['page'] as int? ?? 1,
      pageSize: json['page_size'] as int? ?? 20,
    );
  }
}
