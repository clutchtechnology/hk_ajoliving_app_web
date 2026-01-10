import 'property.dart';

/// 校网模型
class SchoolNet {
  final int id;
  final String code;
  final String nameZhHant;
  final String? nameZhHans;
  final String? nameEn;
  final String type; // primary, secondary
  final int districtId;
  final District? district;
  final String? description;
  final String? coverage;
  final int schoolCount;

  SchoolNet({
    required this.id,
    required this.code,
    required this.nameZhHant,
    this.nameZhHans,
    this.nameEn,
    required this.type,
    required this.districtId,
    this.district,
    this.description,
    this.coverage,
    required this.schoolCount,
  });

  factory SchoolNet.fromJson(Map<String, dynamic> json) {
    return SchoolNet(
      id: json['id'] as int,
      code: json['code'] as String,
      nameZhHant: json['name_zh_hant'] as String,
      nameZhHans: json['name_zh_hans'] as String?,
      nameEn: json['name_en'] as String?,
      type: json['type'] as String,
      districtId: json['district_id'] as int,
      district: json['district'] != null
          ? District.fromJson(json['district'] as Map<String, dynamic>)
          : null,
      description: json['description'] as String?,
      coverage: json['coverage'] as String?,
      schoolCount: json['school_count'] as int? ?? 0,
    );
  }

  /// 类型中文
  String get typeText {
    return type == 'primary' ? '小學' : '中學';
  }
}

/// 学校模型
class School {
  final int id;
  final String nameZhHant;
  final String? nameZhHans;
  final String? nameEn;
  final String type; // primary, secondary
  final String category; // government, aided, direct_subsidy, private, international
  final String gender; // coed, boys, girls
  final int? schoolNetId;
  final int districtId;
  final String address;
  final String? phone;
  final String? email;
  final String? website;
  final DateTime? establishedAt;
  final String? principal;
  final String? religion;
  final String? curriculum;
  final int studentCount;
  final int teacherCount;
  final double rating;
  final String? description;
  final int viewCount;
  final SchoolNet? schoolNet;
  final District? district;

  School({
    required this.id,
    required this.nameZhHant,
    this.nameZhHans,
    this.nameEn,
    required this.type,
    required this.category,
    required this.gender,
    this.schoolNetId,
    required this.districtId,
    required this.address,
    this.phone,
    this.email,
    this.website,
    this.establishedAt,
    this.principal,
    this.religion,
    this.curriculum,
    required this.studentCount,
    required this.teacherCount,
    required this.rating,
    this.description,
    required this.viewCount,
    this.schoolNet,
    this.district,
  });

  factory School.fromJson(Map<String, dynamic> json) {
    return School(
      id: json['id'] as int,
      nameZhHant: json['name_zh_hant'] as String,
      nameZhHans: json['name_zh_hans'] as String?,
      nameEn: json['name_en'] as String?,
      type: json['type'] as String,
      category: json['category'] as String,
      gender: json['gender'] as String,
      schoolNetId: json['school_net_id'] as int?,
      districtId: json['district_id'] as int,
      address: json['address'] as String,
      phone: json['phone'] as String?,
      email: json['email'] as String?,
      website: json['website'] as String?,
      establishedAt: json['established_at'] != null
          ? DateTime.parse(json['established_at'] as String)
          : null,
      principal: json['principal'] as String?,
      religion: json['religion'] as String?,
      curriculum: json['curriculum'] as String?,
      studentCount: json['student_count'] as int? ?? 0,
      teacherCount: json['teacher_count'] as int? ?? 0,
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      description: json['description'] as String?,
      viewCount: json['view_count'] as int? ?? 0,
      schoolNet: json['school_net'] != null
          ? SchoolNet.fromJson(json['school_net'] as Map<String, dynamic>)
          : null,
      district: json['district'] != null
          ? District.fromJson(json['district'] as Map<String, dynamic>)
          : null,
    );
  }

  /// 类型中文
  String get typeText {
    return type == 'primary' ? '小學' : '中學';
  }

  /// 资助种类中文
  String get categoryText {
    switch (category) {
      case 'government':
        return '官立';
      case 'aided':
        return '資助';
      case 'direct_subsidy':
        return '直資';
      case 'private':
        return '私立';
      case 'international':
        return '國際';
      default:
        return category;
    }
  }

  /// 性别中文
  String get genderText {
    switch (gender) {
      case 'coed':
        return '男女';
      case 'boys':
        return '男';
      case 'girls':
        return '女';
      default:
        return gender;
    }
  }
}

/// 校网列表响应
class SchoolNetListResponse {
  final List<SchoolNet> schoolNets;
  final int total;
  final int page;
  final int pageSize;

  SchoolNetListResponse({
    required this.schoolNets,
    required this.total,
    required this.page,
    required this.pageSize,
  });

  int get totalPages => (total / pageSize).ceil();
  bool get hasMore => page < totalPages;

  factory SchoolNetListResponse.fromJson(Map<String, dynamic> json) {
    return SchoolNetListResponse(
      schoolNets: (json['items'] as List? ?? [])
          .map((item) => SchoolNet.fromJson(item as Map<String, dynamic>))
          .toList(),
      total: json['total'] as int? ?? 0,
      page: json['page'] as int? ?? 1,
      pageSize: json['page_size'] as int? ?? 20,
    );
  }
}

/// 学校列表响应
class SchoolListResponse {
  final List<School> schools;
  final int total;
  final int page;
  final int pageSize;

  SchoolListResponse({
    required this.schools,
    required this.total,
    required this.page,
    required this.pageSize,
  });

  int get totalPages => (total / pageSize).ceil();
  bool get hasMore => page < totalPages;

  factory SchoolListResponse.fromJson(Map<String, dynamic> json) {
    return SchoolListResponse(
      schools: (json['items'] as List? ?? [])
          .map((item) => School.fromJson(item as Map<String, dynamic>))
          .toList(),
      total: json['total'] as int? ?? 0,
      page: json['page'] as int? ?? 1,
      pageSize: json['page_size'] as int? ?? 20,
    );
  }
}
