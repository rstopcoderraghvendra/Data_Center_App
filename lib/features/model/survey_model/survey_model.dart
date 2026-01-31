// class Survey {
//   final String id;
//   final String name;
//   final String propertyId;
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

//   Survey({
//     required this.id,
//     required this.name,
//     required this.propertyId,
//     required this.municipality,
//     required this.integratedPid,
//     required this.integratedOwner,
//     required this.areaOfAuthority,
//     required this.colony,
//     required this.address,
//     required this.mobile,
//     required this.category,
//     required this.totalArea,
//     required this.unit,
//     required this.authorizationStatus,
//   });

//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'name': name,
//       'propertyId': propertyId,
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

//   factory Survey.fromJson(Map<String, dynamic> json) {
//     return Survey(
//       id: json['id'] ?? '',
//       name: json['name'] ?? '',
//       propertyId: json['propertyId'] ?? '',
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

//   Survey copyWith({
//     String? id,
//     String? name,
//     String? propertyId,
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
//     return Survey(
//       id: id ?? this.id,
//       name: name ?? this.name,
//       propertyId: propertyId ?? this.propertyId,
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

// lib/features/survey_distribution/models/survey_model.dart

class Survey {
  final int id;
  final String displayId;
  final int projectId;
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
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Survey({
    required this.id,
    required this.displayId,
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
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Survey.fromJson(Map<String, dynamic> json) {
    return Survey(
      id: json['id'] as int,
      displayId: 'SRV${json['id']}',
      projectId: json['project_id'] as int,
      name: json['name'] as String,
      municipalityName: json['municipality_name'] as String?,
      propertyDetailsPropertyId:
          json['property_details_property_id'] as String?,
      integratedPidPropertyId: json['integrated_pid_property_id'] as String?,
      integratedPidOwnerOccupierName:
          json['integrated_pid_owner_occupier_name'] as String?,
      areaOfAuthority: json['area_of_authority'] as String?,
      colonyName: json['colony_name'] as String?,
      addressOfProperty: json['address_of_property'] as String?,
      mobileNo: json['mobile_no'] as String?,
      category: json['category'] as String?,
      totalArea: json['total_area'] as String?,
      unit: json['unit'] as String?,
      authorizationStatus: json['authorization_status'] as String?,
      propertyImageUrl: json['property_image_url'] as String?,
      sourceType: json['source_type'] as String,
      isActive: json['is_active'] as bool,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
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
      'is_active': isActive,
    };
  }

  // For form operations
  Survey copyWith({
    int? id,
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
  }) {
    return Survey(
      id: id ?? this.id,
      displayId: displayId,
      projectId: projectId,
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
      propertyImageUrl: propertyImageUrl,
      sourceType: sourceType,
      isActive: isActive,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
