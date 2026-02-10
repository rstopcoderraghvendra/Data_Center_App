// // class Survey {
// //   final int id;
// //   final int projectId;
// //   final String name;
// //   final String? municipalityName;
// //   final String? propertyDetailsPropertyId;
// //   final String? integratedPidPropertyId;
// //   final String? integratedPidOwnerOccupierName;
// //   final String? areaOfAuthority;
// //   final String? colonyName;
// //   final String? addressOfProperty;
// //   final String? mobileNo;
// //   final String? category;
// //   final String? totalArea;
// //   final String? unit;
// //   final String? authorizationStatus;
// //   final String? propertyImageUrl;
// //   final PropertyImages? propertyImages;
// //   final String sourceType;
// //   final bool isActive;
// //   final DateTime createdAt;
// //   final DateTime updatedAt;

// //   const Survey({
// //     required this.id,
// //     required this.projectId,
// //     required this.name,
// //     this.municipalityName,
// //     this.propertyDetailsPropertyId,
// //     this.integratedPidPropertyId,
// //     this.integratedPidOwnerOccupierName,
// //     this.areaOfAuthority,
// //     this.colonyName,
// //     this.addressOfProperty,
// //     this.mobileNo,
// //     this.category,
// //     this.totalArea,
// //     this.unit,
// //     this.authorizationStatus,
// //     this.propertyImageUrl,
// //     this.propertyImages,
// //     required this.sourceType,
// //     required this.isActive,
// //     required this.createdAt,
// //     required this.updatedAt,
// //   });

// //   factory Survey.fromJson(Map<String, dynamic> json) {
// //     // Helper function to safely parse integers
// //     int safeParseInt(dynamic value) {
// //       if (value == null) return 0;
// //       if (value is int) return value;
// //       if (value is String) {
// //         return int.tryParse(value) ?? 0;
// //       }
// //       if (value is double) {
// //         return value.toInt();
// //       }
// //       return 0;
// //     }

// //     // Helper function to safely parse strings
// //     String safeParseString(dynamic value) {
// //       if (value == null) return '';
// //       if (value is String) return value;
// //       return value.toString();
// //     }

// //     // Helper function to safely parse booleans
// //     bool safeParseBool(dynamic value) {
// //       if (value == null) return true;
// //       if (value is bool) return value;
// //       if (value is String) {
// //         return value.toLowerCase() == 'true' || value == '1';
// //       }
// //       if (value is int) {
// //         return value == 1;
// //       }
// //       return true;
// //     }

// //     // Helper function to safely parse DateTime
// //     DateTime safeParseDateTime(dynamic value) {
// //       try {
// //         if (value == null) return DateTime.now();
// //         if (value is DateTime) return value;
// //         return DateTime.parse(value.toString());
// //       } catch (e) {
// //         return DateTime.now();
// //       }
// //     }

// //     // Handle property_images which can be List or Map
// //     PropertyImages? propertyImages;
// //     final propertyImagesData = json['property_images'];

// //     if (propertyImagesData != null) {
// //       if (propertyImagesData is Map<String, dynamic>) {
// //         // It's a map with image URLs
// //         propertyImages = PropertyImages.fromJson(propertyImagesData);
// //       } else if (propertyImagesData is List) {
// //         // It's an empty array
// //         if (propertyImagesData.isEmpty) {
// //           propertyImages = PropertyImages.empty();
// //         }
// //       }
// //     }

// //     return Survey(
// //       id: safeParseInt(json['id']),
// //       projectId: safeParseInt(json['project_id']),
// //       name: safeParseString(json['name']),
// //       municipalityName: json['municipality_name'] as String?,
// //       propertyDetailsPropertyId:
// //           json['property_details_property_id'] as String?,
// //       integratedPidPropertyId: json['integrated_pid_property_id'] as String?,
// //       integratedPidOwnerOccupierName:
// //           json['integrated_pid_owner_occupier_name'] as String?,
// //       areaOfAuthority: json['area_of_authority'] as String?,
// //       colonyName: json['colony_name'] as String?,
// //       addressOfProperty: json['address_of_property'] as String?,
// //       mobileNo: json['mobile_no'] as String?,
// //       category: json['category'] as String?,
// //       totalArea: json['total_area'] as String?,
// //       unit: json['unit'] as String?,
// //       authorizationStatus: json['authorization_status'] as String?,
// //       propertyImageUrl: json['property_image_url'] as String?,
// //       propertyImages: propertyImages,
// //       sourceType: safeParseString(json['source_type']),
// //       isActive: safeParseBool(json['is_active']),
// //       createdAt: safeParseDateTime(json['created_at']),
// //       updatedAt: safeParseDateTime(json['updated_at']),
// //     );
// //   }

// //   Map<String, dynamic> toJson() {
// //     return {
// //       'id': id,
// //       'project_id': projectId,
// //       'name': name,
// //       'municipality_name': municipalityName,
// //       'property_details_property_id': propertyDetailsPropertyId,
// //       'integrated_pid_property_id': integratedPidPropertyId,
// //       'integrated_pid_owner_occupier_name': integratedPidOwnerOccupierName,
// //       'area_of_authority': areaOfAuthority,
// //       'colony_name': colonyName,
// //       'address_of_property': addressOfProperty,
// //       'mobile_no': mobileNo,
// //       'category': category,
// //       'total_area': totalArea,
// //       'unit': unit,
// //       'authorization_status': authorizationStatus,
// //       'property_image_url': propertyImageUrl,
// //       'property_images': propertyImages?.toJson(),
// //       'source_type': sourceType,
// //       'is_active': isActive,
// //       'created_at': createdAt.toIso8601String(),
// //       'updated_at': updatedAt.toIso8601String(),
// //     };
// //   }

// //   Survey copyWith({
// //     int? id,
// //     int? projectId,
// //     String? name,
// //     String? municipalityName,
// //     String? propertyDetailsPropertyId,
// //     String? integratedPidPropertyId,
// //     String? integratedPidOwnerOccupierName,
// //     String? areaOfAuthority,
// //     String? colonyName,
// //     String? addressOfProperty,
// //     String? mobileNo,
// //     String? category,
// //     String? totalArea,
// //     String? unit,
// //     String? authorizationStatus,
// //     String? propertyImageUrl,
// //     PropertyImages? propertyImages,
// //     String? sourceType,
// //     bool? isActive,
// //     DateTime? createdAt,
// //     DateTime? updatedAt,
// //   }) {
// //     return Survey(
// //       id: id ?? this.id,
// //       projectId: projectId ?? this.projectId,
// //       name: name ?? this.name,
// //       municipalityName: municipalityName ?? this.municipalityName,
// //       propertyDetailsPropertyId:
// //           propertyDetailsPropertyId ?? this.propertyDetailsPropertyId,
// //       integratedPidPropertyId:
// //           integratedPidPropertyId ?? this.integratedPidPropertyId,
// //       integratedPidOwnerOccupierName:
// //           integratedPidOwnerOccupierName ?? this.integratedPidOwnerOccupierName,
// //       areaOfAuthority: areaOfAuthority ?? this.areaOfAuthority,
// //       colonyName: colonyName ?? this.colonyName,
// //       addressOfProperty: addressOfProperty ?? this.addressOfProperty,
// //       mobileNo: mobileNo ?? this.mobileNo,
// //       category: category ?? this.category,
// //       totalArea: totalArea ?? this.totalArea,
// //       unit: unit ?? this.unit,
// //       authorizationStatus: authorizationStatus ?? this.authorizationStatus,
// //       propertyImageUrl: propertyImageUrl ?? this.propertyImageUrl,
// //       propertyImages: propertyImages ?? this.propertyImages,
// //       sourceType: sourceType ?? this.sourceType,
// //       isActive: isActive ?? this.isActive,
// //       createdAt: createdAt ?? this.createdAt,
// //       updatedAt: updatedAt ?? this.updatedAt,
// //     );
// //   }
// // }

// // class PropertyImages {
// //   final String? frontView;
// //   final String? sideView;
// //   final String? additional;
// //   final String? location;

// //   const PropertyImages({
// //     this.frontView,
// //     this.sideView,
// //     this.additional,
// //     this.location,
// //   });

// //   factory PropertyImages.fromJson(Map<String, dynamic> json) {
// //     return PropertyImages(
// //       frontView: json['front_view'] as String?,
// //       sideView: json['side_view'] as String?,
// //       additional: json['additional'] as String?,
// //       location: json['location'] as String?,
// //     );
// //   }

// //   factory PropertyImages.empty() {
// //     return const PropertyImages();
// //   }

// //   bool get isEmpty {
// //     return frontView == null &&
// //         sideView == null &&
// //         additional == null &&
// //         location == null;
// //   }

// //   bool get isNotEmpty {
// //     return !isEmpty;
// //   }

// //   Map<String, dynamic> toJson() {
// //     final Map<String, dynamic> data = <String, dynamic>{};
// //     if (frontView != null) data['front_view'] = frontView;
// //     if (sideView != null) data['side_view'] = sideView;
// //     if (additional != null) data['additional'] = additional;
// //     if (location != null) data['location'] = location;
// //     return data;
// //   }

// //   PropertyImages copyWith({
// //     String? frontView,
// //     String? sideView,
// //     String? additional,
// //     String? location,
// //   }) {
// //     return PropertyImages(
// //       frontView: frontView ?? this.frontView,
// //       sideView: sideView ?? this.sideView,
// //       additional: additional ?? this.additional,
// //       location: location ?? this.location,
// //     );
// //   }
// // }

// class SurveyListResponse {
//   final List<Survey> data;
//   final Pagination pagination;

//   SurveyListResponse({
//     required this.data,
//     required this.pagination,
//   });

//   factory SurveyListResponse.fromJson(Map<String, dynamic> json) {
//     final dataList =
//         (json['data'] as List).map((item) => Survey.fromJson(item)).toList();

//     return SurveyListResponse(
//       data: dataList,
//       pagination: Pagination.fromJson(json['pagination']),
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'data': data.map((survey) => survey.toJson()).toList(),
//       'pagination': pagination.toJson(),
//     };
//   }
// }

// class Survey {
//   final int id;
//   final int projectId;
//   final String? name;
//   final String? municipalityName;
//   final String? propertyDetailsPropertyId;
//   final String? integratedPidPropertyId;
//   final String? integratedPidOwnerOccupierName;
//   final String? areaOfAuthority;
//   final String? colonyName;
//   final String? addressOfProperty;
//   final String? mobileNo;
//   final String? category;
//   final String? totalArea;
//   final String? unit;
//   final String? authorizationStatus;
//   final String? propertyImageUrl;
//   final String sourceType;
//   final int? createdBy;
//   final bool isActive;
//   final DateTime createdAt;
//   final DateTime updatedAt;
//   final DateTime? deletedAt;
//   final String? frontView;
//   final String? sideView;
//   final String? additional;
//   final String? location;
//   final String? frontViewUrl;
//   final String? sideViewUrl;
//   final String? additionalUrl;
//   final String? locationUrl;

//   Survey({
//     required this.id,
//     required this.projectId,
//     required this.name,
//     this.municipalityName,
//     this.propertyDetailsPropertyId,
//     this.integratedPidPropertyId,
//     this.integratedPidOwnerOccupierName,
//     this.areaOfAuthority,
//     this.colonyName,
//     this.addressOfProperty,
//     this.mobileNo,
//     this.category,
//     this.totalArea,
//     this.unit,
//     this.authorizationStatus,
//     this.propertyImageUrl,
//     required this.sourceType,
//     this.createdBy,
//     required this.isActive,
//     required this.createdAt,
//     required this.updatedAt,
//     this.deletedAt,
//     this.frontView,
//     this.sideView,
//     this.additional,
//     this.location,
//     this.frontViewUrl,
//     this.sideViewUrl,
//     this.additionalUrl,
//     this.locationUrl,
//   });

//   factory Survey.fromJson(Map<String, dynamic> json) {
//     // Helper function to safely parse integers
//     int safeParseInt(dynamic value) {
//       if (value == null) return 0;
//       if (value is int) return value;
//       if (value is String) {
//         return int.tryParse(value) ?? 0;
//       }
//       if (value is double) {
//         return value.toInt();
//       }
//       return 0;
//     }

//     // Helper function to safely parse strings
//     String? safeParseString(dynamic value) {
//       if (value == null) return null;
//       if (value is String) return value.isEmpty ? null : value;
//       final str = value.toString();
//       return str.isEmpty ? null : str;
//     }

//     // Helper function to safely parse booleans
//     bool safeParseBool(dynamic value) {
//       if (value == null) return true;
//       if (value is bool) return value;
//       if (value is String) {
//         return value.toLowerCase() == 'true' || value == '1';
//       }
//       if (value is int) {
//         return value == 1;
//       }
//       return true;
//     }

//     // Helper function to safely parse DateTime
//     DateTime safeParseDateTime(dynamic value) {
//       try {
//         if (value == null) return DateTime.now();
//         if (value is DateTime) return value;
//         return DateTime.parse(value.toString());
//       } catch (e) {
//         return DateTime.now();
//       }
//     }

//     return Survey(
//       id: safeParseInt(json['id']),
//       projectId: safeParseInt(json['project_id']),
//       name: safeParseString(json['name']),
//       municipalityName: safeParseString(json['municipality_name']),
//       propertyDetailsPropertyId:
//           safeParseString(json['property_details_property_id']),
//       integratedPidPropertyId:
//           safeParseString(json['integrated_pid_property_id']),
//       integratedPidOwnerOccupierName:
//           safeParseString(json['integrated_pid_owner_occupier_name']),
//       areaOfAuthority: safeParseString(json['area_of_authority']),
//       colonyName: safeParseString(json['colony_name']),
//       addressOfProperty: safeParseString(json['address_of_property']),
//       mobileNo: safeParseString(json['mobile_no']),
//       category: safeParseString(json['category']),
//       totalArea: safeParseString(json['total_area']),
//       unit: safeParseString(json['unit']),
//       authorizationStatus: safeParseString(json['authorization_status']),
//       propertyImageUrl: safeParseString(json['property_image_url']),
//       sourceType: safeParseString(json['source_type']) ?? 'survey',
//       createdBy: safeParseInt(json['created_by']),
//       isActive: safeParseBool(json['is_active']),
//       createdAt: safeParseDateTime(json['created_at']),
//       updatedAt: safeParseDateTime(json['updated_at']),
//       deletedAt: json['deleted_at'] != null
//           ? safeParseDateTime(json['deleted_at'])
//           : null,
//       frontView: safeParseString(json['front_view']),
//       sideView: safeParseString(json['side_view']),
//       additional: safeParseString(json['additional']),
//       location: safeParseString(json['location']),
//       frontViewUrl: safeParseString(json['front_view_url']),
//       sideViewUrl: safeParseString(json['side_view_url']),
//       additionalUrl: safeParseString(json['additional_url']),
//       locationUrl: safeParseString(json['location_url']),
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'project_id': projectId,
//       'name': name,
//       'municipality_name': municipalityName,
//       'property_details_property_id': propertyDetailsPropertyId,
//       'integrated_pid_property_id': integratedPidPropertyId,
//       'integrated_pid_owner_occupier_name': integratedPidOwnerOccupierName,
//       'area_of_authority': areaOfAuthority,
//       'colony_name': colonyName,
//       'address_of_property': addressOfProperty,
//       'mobile_no': mobileNo,
//       'category': category,
//       'total_area': totalArea,
//       'unit': unit,
//       'authorization_status': authorizationStatus,
//       'property_image_url': propertyImageUrl,
//       'source_type': sourceType,
//       'created_by': createdBy,
//       'is_active': isActive,
//       'created_at': createdAt.toIso8601String(),
//       'updated_at': updatedAt.toIso8601String(),
//       'deleted_at': deletedAt?.toIso8601String(),
//       'front_view': frontView,
//       'side_view': sideView,
//       'additional': additional,
//       'location': location,
//       'front_view_url': frontViewUrl,
//       'side_view_url': sideViewUrl,
//       'additional_url': additionalUrl,
//       'location_url': locationUrl,
//     };
//   }

//   Survey copyWith({
//     int? id,
//     int? projectId,
//     String? name,
//     String? municipalityName,
//     String? propertyDetailsPropertyId,
//     String? integratedPidPropertyId,
//     String? integratedPidOwnerOccupierName,
//     String? areaOfAuthority,
//     String? colonyName,
//     String? addressOfProperty,
//     String? mobileNo,
//     String? category,
//     String? totalArea,
//     String? unit,
//     String? authorizationStatus,
//     String? propertyImageUrl,
//     String? sourceType,
//     int? createdBy,
//     bool? isActive,
//     DateTime? createdAt,
//     DateTime? updatedAt,
//     DateTime? deletedAt,
//     String? frontView,
//     String? sideView,
//     String? additional,
//     String? location,
//     String? frontViewUrl,
//     String? sideViewUrl,
//     String? additionalUrl,
//     String? locationUrl,
//   }) {
//     return Survey(
//       id: id ?? this.id,
//       projectId: projectId ?? this.projectId,
//       name: name ?? this.name,
//       municipalityName: municipalityName ?? this.municipalityName,
//       propertyDetailsPropertyId:
//           propertyDetailsPropertyId ?? this.propertyDetailsPropertyId,
//       integratedPidPropertyId:
//           integratedPidPropertyId ?? this.integratedPidPropertyId,
//       integratedPidOwnerOccupierName:
//           integratedPidOwnerOccupierName ?? this.integratedPidOwnerOccupierName,
//       areaOfAuthority: areaOfAuthority ?? this.areaOfAuthority,
//       colonyName: colonyName ?? this.colonyName,
//       addressOfProperty: addressOfProperty ?? this.addressOfProperty,
//       mobileNo: mobileNo ?? this.mobileNo,
//       category: category ?? this.category,
//       totalArea: totalArea ?? this.totalArea,
//       unit: unit ?? this.unit,
//       authorizationStatus: authorizationStatus ?? this.authorizationStatus,
//       propertyImageUrl: propertyImageUrl ?? this.propertyImageUrl,
//       sourceType: sourceType ?? this.sourceType,
//       createdBy: createdBy ?? this.createdBy,
//       isActive: isActive ?? this.isActive,
//       createdAt: createdAt ?? this.createdAt,
//       updatedAt: updatedAt ?? this.updatedAt,
//       deletedAt: deletedAt ?? this.deletedAt,
//       frontView: frontView ?? this.frontView,
//       sideView: sideView ?? this.sideView,
//       additional: additional ?? this.additional,
//       location: location ?? this.location,
//       frontViewUrl: frontViewUrl ?? this.frontViewUrl,
//       sideViewUrl: sideViewUrl ?? this.sideViewUrl,
//       additionalUrl: additionalUrl ?? this.additionalUrl,
//       locationUrl: locationUrl ?? this.locationUrl,
//     );
//   }

//   // Convenience getters for image display
//   String? get displayFrontView => frontViewUrl ?? frontView;
//   String? get displaySideView => sideViewUrl ?? sideView;
//   String? get displayAdditional => additionalUrl ?? additional;
//   String? get displayLocation => locationUrl ?? location;
// }

// class Pagination {
//   final int currentPage;
//   final int lastPage;
//   final int perPage;
//   final int total;

//   Pagination({
//     required this.currentPage,
//     required this.lastPage,
//     required this.perPage,
//     required this.total,
//   });

//   factory Pagination.fromJson(Map<String, dynamic> json) {
//     return Pagination(
//       currentPage: json['current_page'] as int? ?? 1,
//       lastPage: json['last_page'] as int? ?? 1,
//       perPage: json['per_page'] as int? ?? 50,
//       total: json['total'] as int? ?? 0,
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'current_page': currentPage,
//       'last_page': lastPage,
//       'per_page': perPage,
//       'total': total,
//     };
//   }
// }

class SurveyListResponse {
  final List<Survey> data;
  final Pagination pagination;

  SurveyListResponse({
    required this.data,
    required this.pagination,
  });

  factory SurveyListResponse.fromJson(Map<String, dynamic> json) {
    final dataList =
        (json['data'] as List).map((item) => Survey.fromJson(item)).toList();

    return SurveyListResponse(
      data: dataList,
      pagination: Pagination.fromJson(json['pagination']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': data.map((survey) => survey.toJson()).toList(),
      'pagination': pagination.toJson(),
    };
  }
}

class Survey {
  final int id;
  final int projectId;
  final String? name;
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
  final int? createdBy;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  final String? frontView;
  final String? sideView;
  final String? additional;
  final String? location;
  final String? frontViewUrl;
  final String? sideViewUrl;
  final String? additionalUrl;
  final String? locationUrl;

  Survey({
    required this.id,
    required this.projectId,
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
    this.createdBy,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    this.frontView,
    this.sideView,
    this.additional,
    this.location,
    this.frontViewUrl,
    this.sideViewUrl,
    this.additionalUrl,
    this.locationUrl,
  });

  factory Survey.fromJson(Map<String, dynamic> json) {
    // Helper function to safely parse integers
    int safeParseInt(dynamic value) {
      if (value == null) return 0;
      if (value is int) return value;
      if (value is String) {
        return int.tryParse(value) ?? 0;
      }
      if (value is double) {
        return value.toInt();
      }
      return 0;
    }

    // Helper function to safely parse strings
    String? safeParseString(dynamic value) {
      if (value == null) return null;
      if (value is String) return value.isEmpty ? null : value;
      final str = value.toString();
      return str.isEmpty ? null : str;
    }

    // Helper function to safely parse booleans
    bool safeParseBool(dynamic value) {
      if (value == null) return true;
      if (value is bool) return value;
      if (value is String) {
        return value.toLowerCase() == 'true' || value == '1';
      }
      if (value is int) {
        return value == 1;
      }
      return true;
    }

    // Helper function to safely parse DateTime
    DateTime safeParseDateTime(dynamic value) {
      try {
        if (value == null) return DateTime.now();
        if (value is DateTime) return value;
        return DateTime.parse(value.toString());
      } catch (e) {
        return DateTime.now();
      }
    }

    return Survey(
      id: safeParseInt(json['id']),
      projectId: safeParseInt(json['project_id']),
      name: safeParseString(json['name']),
      municipalityName: safeParseString(json['municipality_name']),
      propertyDetailsPropertyId:
          safeParseString(json['property_details_property_id']),
      integratedPidPropertyId:
          safeParseString(json['integrated_pid_property_id']),
      integratedPidOwnerOccupierName:
          safeParseString(json['integrated_pid_owner_occupier_name']),
      areaOfAuthority: safeParseString(json['area_of_authority']),
      colonyName: safeParseString(json['colony_name']),
      addressOfProperty: safeParseString(json['address_of_property']),
      mobileNo: safeParseString(json['mobile_no']),
      category: safeParseString(json['category']),
      totalArea: safeParseString(json['total_area']),
      unit: safeParseString(json['unit']),
      authorizationStatus: safeParseString(json['authorization_status']),
      propertyImageUrl: safeParseString(json['property_image_url']),
      sourceType: safeParseString(json['source_type']) ?? 'survey',
      createdBy: safeParseInt(json['created_by']),
      isActive: safeParseBool(json['is_active']),
      createdAt: safeParseDateTime(json['created_at']),
      updatedAt: safeParseDateTime(json['updated_at']),
      deletedAt: json['deleted_at'] != null
          ? safeParseDateTime(json['deleted_at'])
          : null,
      frontView: safeParseString(json['front_view']),
      sideView: safeParseString(json['side_view']),
      additional: safeParseString(json['additional']),
      location: safeParseString(json['location']),
      frontViewUrl: safeParseString(json['front_view_url']),
      sideViewUrl: safeParseString(json['side_view_url']),
      additionalUrl: safeParseString(json['additional_url']),
      locationUrl: safeParseString(json['location_url']),
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
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'deleted_at': deletedAt?.toIso8601String(),
      'front_view': frontView,
      'side_view': sideView,
      'additional': additional,
      'location': location,
      'front_view_url': frontViewUrl,
      'side_view_url': sideViewUrl,
      'additional_url': additionalUrl,
      'location_url': locationUrl,
    };
  }

  Survey copyWith({
    int? id,
    int? projectId,
    String? name,
    String? municipalityName,
    String? propertyDetailsPropertyId,
    String? integratedPidPropertyId,
    String? integratedPidOwnerOccupierName,
    String? areaOfAuthority,
    String? colonyName,
    String? addressOfProperty,
    String? mobileNo,
    String? category,
    String? totalArea,
    String? unit,
    String? authorizationStatus,
    String? propertyImageUrl,
    String? sourceType,
    int? createdBy,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? deletedAt,
    String? frontView,
    String? sideView,
    String? additional,
    String? location,
    String? frontViewUrl,
    String? sideViewUrl,
    String? additionalUrl,
    String? locationUrl,
  }) {
    return Survey(
      id: id ?? this.id,
      projectId: projectId ?? this.projectId,
      name: name ?? this.name,
      municipalityName: municipalityName ?? this.municipalityName,
      propertyDetailsPropertyId:
          propertyDetailsPropertyId ?? this.propertyDetailsPropertyId,
      integratedPidPropertyId:
          integratedPidPropertyId ?? this.integratedPidPropertyId,
      integratedPidOwnerOccupierName:
          integratedPidOwnerOccupierName ?? this.integratedPidOwnerOccupierName,
      areaOfAuthority: areaOfAuthority ?? this.areaOfAuthority,
      colonyName: colonyName ?? this.colonyName,
      addressOfProperty: addressOfProperty ?? this.addressOfProperty,
      mobileNo: mobileNo ?? this.mobileNo,
      category: category ?? this.category,
      totalArea: totalArea ?? this.totalArea,
      unit: unit ?? this.unit,
      authorizationStatus: authorizationStatus ?? this.authorizationStatus,
      propertyImageUrl: propertyImageUrl ?? this.propertyImageUrl,
      sourceType: sourceType ?? this.sourceType,
      createdBy: createdBy ?? this.createdBy,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      frontView: frontView ?? this.frontView,
      sideView: sideView ?? this.sideView,
      additional: additional ?? this.additional,
      location: location ?? this.location,
      frontViewUrl: frontViewUrl ?? this.frontViewUrl,
      sideViewUrl: sideViewUrl ?? this.sideViewUrl,
      additionalUrl: additionalUrl ?? this.additionalUrl,
      locationUrl: locationUrl ?? this.locationUrl,
    );
  }

  // Convenience getters for image display
  String? get displayFrontView => frontViewUrl ?? frontView;
  String? get displaySideView => sideViewUrl ?? sideView;
  String? get displayAdditional => additionalUrl ?? additional;
  String? get displayLocation => locationUrl ?? location;
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
}
