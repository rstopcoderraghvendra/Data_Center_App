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
