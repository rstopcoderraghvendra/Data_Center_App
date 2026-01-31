// class Bill {
//   final String id;
//   final DateTime date;

//   // Your provided fields
//   final String customerName;
//   final String propertyDetails;
//   final String municipality;
//   final String integratedPid;
//   final String integratedOwner;
//   final String areaOfAuthority;
//   final String colony;
//   final String address;
//   final String mobile;
//   final String category;
//   final String totalArea;
//   final String unit;
//   final String authorizationStatus;

//   Bill({
//     required this.id,
//     required this.date,
//     this.customerName = '',
//     this.propertyDetails = '',
//     this.municipality = '',
//     this.integratedPid = '',
//     this.integratedOwner = '',
//     this.areaOfAuthority = '',
//     this.colony = '',
//     this.address = '',
//     this.mobile = '',
//     this.category = '',
//     this.totalArea = '',
//     this.unit = '',
//     this.authorizationStatus = '',
//   });

//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'date': date.toIso8601String(),
//       'customerName': customerName,
//       'propertyDetails': propertyDetails,
//       'municipality': municipality,
//       'integratedPid': integratedPid,
//       'integratedOwner': integratedOwner,
//       'areaOfAuthority': areaOfAuthority,
//       'colony': colony,
//       'address': address,
//       'mobile': mobile,
//       'category': category,
//       'totalArea': totalArea,
//       'unit': unit,
//       'authorizationStatus': authorizationStatus,
//     };
//   }

//   factory Bill.fromJson(Map<String, dynamic> json) {
//     return Bill(
//       id: json['id'] ?? '',
//       date: DateTime.parse(json['date'] ?? DateTime.now().toIso8601String()),
//       customerName: json['customerName'] ?? '',
//       propertyDetails: json['propertyDetails'] ?? '',
//       municipality: json['municipality'] ?? '',
//       integratedPid: json['integratedPid'] ?? '',
//       integratedOwner: json['integratedOwner'] ?? '',
//       areaOfAuthority: json['areaOfAuthority'] ?? '',
//       colony: json['colony'] ?? '',
//       address: json['address'] ?? '',
//       mobile: json['mobile'] ?? '',
//       category: json['category'] ?? '',
//       totalArea: json['totalArea'] ?? '',
//       unit: json['unit'] ?? '',
//       authorizationStatus: json['authorizationStatus'] ?? '',
//     );
//   }

//   Bill copyWith({
//     String? id,
//     String? title,
//     String? description,
//     double? amount,
//     DateTime? date,
//     String? customerName,
//     String? propertyDetails,
//     String? municipality,
//     String? integratedPid,
//     String? integratedOwner,
//     String? areaOfAuthority,
//     String? colony,
//     String? address,
//     String? mobile,
//     String? category,
//     String? totalArea,
//     String? unit,
//     String? authorizationStatus,
//   }) {
//     return Bill(
//       id: id ?? this.id,
//       date: date ?? this.date,
//       customerName: customerName ?? this.customerName,
//       propertyDetails: propertyDetails ?? this.propertyDetails,
//       municipality: municipality ?? this.municipality,
//       integratedPid: integratedPid ?? this.integratedPid,
//       integratedOwner: integratedOwner ?? this.integratedOwner,
//       areaOfAuthority: areaOfAuthority ?? this.areaOfAuthority,
//       colony: colony ?? this.colony,
//       address: address ?? this.address,
//       mobile: mobile ?? this.mobile,
//       category: category ?? this.category,
//       totalArea: totalArea ?? this.totalArea,
//       unit: unit ?? this.unit,
//       authorizationStatus: authorizationStatus ?? this.authorizationStatus,
//     );
//   }
// }
import 'dart:convert';

class Bill {
  final int id;
  final String name;
  final String? municipalityName;
  final String? propertyDetailsPropertyId;
  final String? integratedPidPropertyId;
  final String? integratedPidOwnerOccupierName;
  final String? areaOfAuthority;
  final String? colonyName;
  final String? addressOfProperty;
  final String? mobileNo;
  final String? category;
  final String? totalArea;
  final String? unit;
  final String? authorizationStatus;
  final String? propertyImageUrl;
  final String sourceType;
  final int createdBy;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;

  Bill({
    required this.id,
    required this.name,
    this.municipalityName,
    this.propertyDetailsPropertyId,
    this.integratedPidPropertyId,
    this.integratedPidOwnerOccupierName,
    this.areaOfAuthority,
    this.colonyName,
    this.addressOfProperty,
    this.mobileNo,
    this.category,
    this.totalArea,
    this.unit,
    this.authorizationStatus,
    this.propertyImageUrl,
    required this.sourceType,
    required this.createdBy,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
  });

  factory Bill.fromJson(Map<String, dynamic> json) {
    return Bill(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      municipalityName: json['municipality_name'],
      propertyDetailsPropertyId: json['property_details_property_id'],
      integratedPidPropertyId: json['integrated_pid_property_id'],
      integratedPidOwnerOccupierName:
          json['integrated_pid_owner_occupier_name'],
      areaOfAuthority: json['area_of_authority'],
      colonyName: json['colony_name'],
      addressOfProperty: json['address_of_property'],
      mobileNo: json['mobile_no'],
      category: json['category'],
      totalArea: json['total_area'],
      unit: json['unit'],
      authorizationStatus: json['authorization_status'],
      propertyImageUrl: json['property_image_url'],
      sourceType: json['source_type'] ?? '',
      createdBy: json['created_by'] ?? 0,
      isActive: json['is_active'] ?? false,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      deletedAt: json['deleted_at'] != null
          ? DateTime.parse(json['deleted_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'municipality_name': municipalityName,
      'property_details_property_id': propertyDetailsPropertyId,
      'integrated_pid_property_id': integratedPidPropertyId,
      'integrated_pid_owner_occupier_name': integratedPidOwnerOccupierName,
      'area_of_authority': areaOfAuthority,
      'colony_name': colonyName,
      'address_of_property': addressOfProperty,
      'mobile_no': mobileNo,
      'category': category,
      'total_area': totalArea,
      'unit': unit,
      'authorization_status': authorizationStatus,
      'property_image_url': propertyImageUrl,
      'source_type': sourceType,
      'created_by': createdBy,
      'is_active': isActive,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'deleted_at': deletedAt?.toIso8601String(),
    };
  }

  // Helper getters for UI compatibility
  String get customerName => name;
  String get municipality => municipalityName ?? '-';
  String get propertyDetails => propertyDetailsPropertyId ?? '-';
  String get integratedPid => integratedPidPropertyId ?? '-';
  String get integratedOwner => integratedPidOwnerOccupierName ?? '-';
  String get colony => colonyName ?? '-';
  String get address => addressOfProperty ?? '-';
  String get mobile => mobileNo ?? '-';

  // For display in table
  String get displayId => id.toString();
  String get displayStatus {
    if (authorizationStatus != null) {
      return authorizationStatus!.toLowerCase() == 'approved'
          ? 'Approved'
          : 'Inactive';
    }
    return isActive ? 'Active' : 'Inactive';
  }
}

class BillResponse {
  final List<Bill> data;
  final Pagination pagination;

  BillResponse({
    required this.data,
    required this.pagination,
  });

  factory BillResponse.fromJson(Map<String, dynamic> json) {
    return BillResponse(
      data: (json['data'] as List).map((item) => Bill.fromJson(item)).toList(),
      pagination: Pagination.fromJson(json['pagination']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': data.map((item) => item.toJson()).toList(),
      'pagination': pagination.toJson(),
    };
  }
}

class Pagination {
  final int currentPage;
  final int lastPage;
  final int perPage;
  final int total;

  Pagination({
    required this.currentPage,
    required this.lastPage,
    required this.perPage,
    required this.total,
  });

  factory Pagination.fromJson(Map<String, dynamic> json) {
    return Pagination(
      currentPage: json['current_page'] ?? 1,
      lastPage: json['last_page'] ?? 1,
      perPage: json['per_page'] ?? 10,
      total: json['total'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'current_page': currentPage,
      'last_page': lastPage,
      'per_page': perPage,
      'total': total,
    };
  }

  bool get hasNextPage => currentPage < lastPage;
}
