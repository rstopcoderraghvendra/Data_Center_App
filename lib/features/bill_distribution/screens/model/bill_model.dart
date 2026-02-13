class Bill {
  int? id;
  int? projectId;
  String? name;
  String? municipalityName;
  String? propertyDetailsPropertyId;
  String? integratedPidPropertyId;
  String? integratedPidOwnerOccupierName;
  String? areaOfAuthority;
  String? colonyName;
  String? addressOfProperty;
  String? mobileNo;
  String? category;
  String? totalArea;
  String? unit;
  String? authorizationStatus;
  String? propertyImageUrl;
  String? sourceType;
  int? createdBy;
  bool? isActive;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;
  String? frontView;
  String? sideView;
  String? additional;
  String? location;
  String? frontViewUrl;
  String? sideViewUrl;
  String? additionalUrl;
  String? locationUrl;
  String? verifyBy;
  String? latitude;
  String? longitude; // New field for longitude

  Bill({
    this.id,
    this.projectId,
    this.name,
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
    this.sourceType,
    this.createdBy,
    this.isActive,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.frontView,
    this.sideView,
    this.additional,
    this.location,
    this.frontViewUrl,
    this.sideViewUrl,
    this.additionalUrl,
    this.locationUrl,
    this.verifyBy,
    this.latitude,
    this.longitude, // Initialize the new field
  });

  factory Bill.fromJson(Map<String, dynamic> json) {
    return Bill(
      id: json['id'],
      projectId: json['project_id'],
      name: json['name'],
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
      sourceType: json['source_type'],
      createdBy: json['created_by'],
      isActive: json['is_active'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      deletedAt: json['deleted_at'],
      frontView: json['front_view'],
      sideView: json['side_view'],
      additional: json['additional'],
      location: json['location'],
      frontViewUrl: json['front_view_url'],
      sideViewUrl: json['side_view_url'],
      additionalUrl: json['additional_url'],
      locationUrl: json['location_url'],
      verifyBy: json['verify_by'],
      latitude: json['latitude'],
      longitude: json['longitude'], // Parse the new field from JSON
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'project_id': projectId,
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
      'created_at': createdAt,
      'updated_at': updatedAt,
      'deleted_at': deletedAt,
      'front_view': frontView,
      'side_view': sideView,
      'additional': additional,
      'location': location,
      'front_view_url': frontViewUrl,
      'side_view_url': sideViewUrl,
      'additional_url': additionalUrl,
      'location_url': locationUrl,
      'verify_by': verifyBy,
      'latitude': latitude,
      'longitude': longitude, // Include the new field in JSON serialization
    };
  }

  // Helper getters for backward compatibility with your existing code
  String get customerName => name ?? '';
  String get municipality => municipalityName ?? '';
  String get propertyDetails => propertyDetailsPropertyId ?? '';
  String get integratedPid => integratedPidPropertyId ?? '';
  String get integratedOwner => integratedPidOwnerOccupierName ?? '';
  String get colony => colonyName ?? '';
  String get address => addressOfProperty ?? '';
  String get mobile => mobileNo ?? '';

  // Getter for property images
  PropertyImages? get propertyImages {
    if (frontViewUrl == null &&
        sideViewUrl == null &&
        additionalUrl == null &&
        locationUrl == null) {
      return null;
    }
    return PropertyImages(
      frontView: frontViewUrl,
      sideView: sideViewUrl,
      additional: additionalUrl,
      location: locationUrl,
    );
  }
}

// PropertyImages model for image URLs
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

  bool get isEmpty =>
      (frontView == null || frontView!.isEmpty) &&
      (sideView == null || sideView!.isEmpty) &&
      (additional == null || additional!.isEmpty) &&
      (location == null || location!.isEmpty);

  bool get isNotEmpty => !isEmpty;
}

// Response model for paginated API response
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
      currentPage: json['current_page'] ?? 1,
      lastPage: json['last_page'] ?? 1,
      perPage: json['per_page'] ?? 50,
      total: json['total'] ?? 0,
    );
  }
}
