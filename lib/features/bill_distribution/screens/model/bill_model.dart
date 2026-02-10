class Bill {
  final int? id;
  final int? projectId;
  final String name; // API uses 'name' not 'customer_name'

  final String municipality;
  final String? propertyDetailsPropertyId;
  final String? integratedPidPropertyId;
  final String? integratedPidOwnerOccupierName;
  final String? areaOfAuthority;
  final String colony;
  final String address;
  final String mobile;
  final String? category;
  final String? totalArea;
  final String? unit;
  final String? authorizationStatus;
  final PropertyImages? propertyImages; // Updated for property_images object
  final String? propertyImageUrl;
  final String sourceType;
  final int? createdBy;
  final bool? isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? deletedAt;

  Bill({
    this.id,
    this.projectId,
    required this.name,
    required this.municipality,
    this.propertyDetailsPropertyId,
    this.integratedPidPropertyId,
    this.integratedPidOwnerOccupierName,
    this.areaOfAuthority,
    required this.colony,
    required this.address,
    required this.mobile,
    this.category,
    this.totalArea,
    this.unit,
    this.authorizationStatus,
    this.propertyImages,
    this.propertyImageUrl,
    required this.sourceType,
    this.createdBy,
    this.isActive,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  // Getters for compatibility with existing code
  String get customerName => name;
  String get propertyDetails => propertyDetailsPropertyId ?? '';
  String get integratedPid => integratedPidPropertyId ?? '';
  String get integratedOwner => integratedPidOwnerOccupierName ?? '';

  factory Bill.fromJson(Map<String, dynamic> json) {
    try {
      // Parse property_images object
      PropertyImages? propertyImages;
      if (json['property_images'] != null) {
        if (json['property_images'] is Map) {
          propertyImages = PropertyImages.fromJson(
              Map<String, dynamic>.from(json['property_images']));
        } else if (json['property_images'] is List) {
          // Handle empty array case
          if ((json['property_images'] as List).isEmpty) {
            propertyImages = null;
          }
        }
      }

      return Bill(
        id: _parseInt(json['id']),
        projectId: _parseInt(json['project_id']),
        name: json['name']?.toString() ?? '',
        municipality: json['municipality_name']?.toString() ?? '',
        propertyDetailsPropertyId:
            json['property_details_property_id']?.toString(),
        integratedPidPropertyId: json['integrated_pid_property_id']?.toString(),
        integratedPidOwnerOccupierName:
            json['integrated_pid_owner_occupier_name']?.toString(),
        areaOfAuthority: json['area_of_authority']?.toString(),
        colony: json['colony_name']?.toString() ?? '-',
        address: json['address_of_property']?.toString() ?? '-',
        mobile: json['mobile_no']?.toString() ?? '-',
        category: json['category']?.toString() ?? '-',
        totalArea: json['total_area']?.toString() ?? '',
        unit: json['unit']?.toString() ?? '-',
        authorizationStatus:
            json['authorization_status']?.toString()?.toLowerCase() ??
                'pending',
        propertyImages: propertyImages,
        propertyImageUrl: json['property_image_url']?.toString(),
        sourceType: json['source_type']?.toString() ?? 'bill_distribution',
        createdBy: _parseInt(json['created_by']),
        isActive: json['is_active'] as bool? ?? true,
        createdAt: json['created_at'] != null
            ? DateTime.tryParse(json['created_at'].toString())
            : null,
        updatedAt: json['updated_at'] != null
            ? DateTime.tryParse(json['updated_at'].toString())
            : null,
        deletedAt: json['deleted_at'] != null
            ? DateTime.tryParse(json['deleted_at'].toString())
            : null,
      );
    } catch (e, stackTrace) {
      print('Error parsing Bill from JSON: $e');
      print('JSON: $json');
      print('Stack trace: $stackTrace');
      rethrow;
    }
  }

  static int? _parseInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is String) {
      return int.tryParse(value);
    }
    if (value is num) {
      return value.toInt();
    }
    return null;
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      if (projectId != null) 'project_id': projectId,
      'name': name,
      'municipality_name': municipality,
      if (propertyDetailsPropertyId != null)
        'property_details_property_id': propertyDetailsPropertyId,
      if (integratedPidPropertyId != null)
        'integrated_pid_property_id': integratedPidPropertyId,
      if (integratedPidOwnerOccupierName != null)
        'integrated_pid_owner_occupier_name': integratedPidOwnerOccupierName,
      if (areaOfAuthority != null) 'area_of_authority': areaOfAuthority,
      'colony_name': colony,
      'address_of_property': address,
      'mobile_no': mobile,
      if (category != null) 'category': category,
      if (totalArea != null) 'total_area': totalArea,
      if (unit != null) 'unit': unit,
      if (authorizationStatus != null)
        'authorization_status': authorizationStatus,
      if (propertyImages != null) 'property_images': propertyImages!.toJson(),
      if (propertyImageUrl != null) 'property_image_url': propertyImageUrl,
      'source_type': sourceType,
      if (createdBy != null) 'created_by': createdBy,
      if (isActive != null) 'is_active': isActive,
      if (createdAt != null) 'created_at': createdAt!.toIso8601String(),
      if (updatedAt != null) 'updated_at': updatedAt!.toIso8601String(),
      if (deletedAt != null) 'deleted_at': deletedAt!.toIso8601String(),
    };
  }
}

// PropertyImages model class
class PropertyImages {
  final String? frontView;
  final String? sideView;
  final String? additional;
  final String? location;

  PropertyImages({
    this.frontView,
    this.sideView,
    this.additional,
    this.location,
  });

  factory PropertyImages.fromJson(Map<String, dynamic> json) {
    return PropertyImages(
      frontView: json['front_view']?.toString(),
      sideView: json['side_view']?.toString(),
      additional: json['additional']?.toString(),
      location: json['location']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (frontView != null) 'front_view': frontView,
      if (sideView != null) 'side_view': sideView,
      if (additional != null) 'additional': additional,
      if (location != null) 'location': location,
    };
  }

  bool get isEmpty =>
      (frontView == null || frontView!.isEmpty) &&
      (sideView == null || sideView!.isEmpty) &&
      (additional == null || additional!.isEmpty) &&
      (location == null || location!.isEmpty);

  bool get isNotEmpty => !isEmpty;

  List<String> get allImages {
    final List<String> images = [];
    if (frontView != null && frontView!.isNotEmpty) images.add(frontView!);
    if (sideView != null && sideView!.isNotEmpty) images.add(sideView!);
    if (additional != null && additional!.isNotEmpty) images.add(additional!);
    if (location != null && location!.isNotEmpty) images.add(location!);
    return images;
  }

  // Helper method to get image by type
  String? getImage(String type) {
    switch (type) {
      case 'front_view':
        return frontView;
      case 'side_view':
        return sideView;
      case 'additional':
        return additional;
      case 'location':
        return location;
      default:
        return null;
    }
  }
}

// BillListResponse model for paginated response
class BillListResponse {
  final List<Bill> data;
  final Pagination pagination;

  BillListResponse({
    required this.data,
    required this.pagination,
  });

  factory BillListResponse.fromJson(Map<String, dynamic> json) {
    final List<dynamic> dataList = json['data'] ?? [];
    final List<Bill> bills = dataList.map((item) {
      return Bill.fromJson(Map<String, dynamic>.from(item));
    }).toList();

    return BillListResponse(
      data: bills,
      pagination: Pagination.fromJson(
          Map<String, dynamic>.from(json['pagination'] ?? {})),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': data.map((bill) => bill.toJson()).toList(),
      'pagination': pagination.toJson(),
    };
  }
}

// Pagination model
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
      currentPage: json['current_page'] as int? ?? 1,
      lastPage: json['last_page'] as int? ?? 1,
      perPage: json['per_page'] as int? ?? 50,
      total: json['total'] as int? ?? 0,
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

  bool get hasMore => currentPage < lastPage;
}
