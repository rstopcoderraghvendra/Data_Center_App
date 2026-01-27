class Survey {
  final String id;
  final String name;
  final String propertyId;
  final String municipality;
  final String integratedPid;
  final String integratedOwner;
  final String areaOfAuthority;
  final String colony;
  final String address;
  final String mobile;
  final String category;
  final String totalArea;
  final String unit;
  final String authorizationStatus;

  Survey({
    required this.id,
    required this.name,
    required this.propertyId,
    required this.municipality,
    required this.integratedPid,
    required this.integratedOwner,
    required this.areaOfAuthority,
    required this.colony,
    required this.address,
    required this.mobile,
    required this.category,
    required this.totalArea,
    required this.unit,
    required this.authorizationStatus,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'propertyId': propertyId,
      'municipality': municipality,
      'integratedPid': integratedPid,
      'integratedOwner': integratedOwner,
      'areaOfAuthority': areaOfAuthority,
      'colony': colony,
      'address': address,
      'mobile': mobile,
      'category': category,
      'totalArea': totalArea,
      'unit': unit,
      'authorizationStatus': authorizationStatus,
    };
  }

  factory Survey.fromJson(Map<String, dynamic> json) {
    return Survey(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      propertyId: json['propertyId'] ?? '',
      municipality: json['municipality'] ?? '',
      integratedPid: json['integratedPid'] ?? '',
      integratedOwner: json['integratedOwner'] ?? '',
      areaOfAuthority: json['areaOfAuthority'] ?? '',
      colony: json['colony'] ?? '',
      address: json['address'] ?? '',
      mobile: json['mobile'] ?? '',
      category: json['category'] ?? '',
      totalArea: json['totalArea'] ?? '',
      unit: json['unit'] ?? '',
      authorizationStatus: json['authorizationStatus'] ?? '',
    );
  }

  Survey copyWith({
    String? id,
    String? name,
    String? propertyId,
    String? municipality,
    String? integratedPid,
    String? integratedOwner,
    String? areaOfAuthority,
    String? colony,
    String? address,
    String? mobile,
    String? category,
    String? totalArea,
    String? unit,
    String? authorizationStatus,
  }) {
    return Survey(
      id: id ?? this.id,
      name: name ?? this.name,
      propertyId: propertyId ?? this.propertyId,
      municipality: municipality ?? this.municipality,
      integratedPid: integratedPid ?? this.integratedPid,
      integratedOwner: integratedOwner ?? this.integratedOwner,
      areaOfAuthority: areaOfAuthority ?? this.areaOfAuthority,
      colony: colony ?? this.colony,
      address: address ?? this.address,
      mobile: mobile ?? this.mobile,
      category: category ?? this.category,
      totalArea: totalArea ?? this.totalArea,
      unit: unit ?? this.unit,
      authorizationStatus: authorizationStatus ?? this.authorizationStatus,
    );
  }
}
